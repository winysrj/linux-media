Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:44188 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932340AbeCVOTF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Mar 2018 10:19:05 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC] Request API
Message-ID: <aa5f4986-7cb3-ec85-203d-e1afa644d769@xs4all.nl>
Date: Thu, 22 Mar 2018 15:18:59 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

RFC Request API
---------------

This document proposes the public API for handling requests.

There has been some confusion about how to do this, so this summarizes the
current approach based on conversations with the various stakeholders today
(Sakari, Alexandre Courbot, Tomasz Figa and myself).

The goal is to finalize this so the Request API patch series work can
continue.

1) Additions to the media API

   Allocate an empty request object:

   #define MEDIA_IOC_REQUEST_ALLOC _IOW('|', 0x05, __s32 *)

   This will return a file descriptor representing the request or an error
   if it can't allocate the request.

   If the pointer argument is NULL, then this will just return 0 (if this ioctl
   is implemented) or -ENOTTY otherwise. This can be used to test whether this
   ioctl is supported or not without actually having to allocate a request.

2) Operations on the request fd

   You can queue (aka submit) or reinit a request by calling these ioctls on the request fd:

   #define MEDIA_REQUEST_IOC_QUEUE   _IO('|',  128)
   #define MEDIA_REQUEST_IOC_REINIT  _IO('|',  129)

   Note: the original proposal from Alexandre used IOC_SUBMIT instead of
   IOC_QUEUE. I have a slight preference for QUEUE since that implies that the
   request end up in a queue of requests. That's less obvious with SUBMIT. I
   have no strong opinion on this, though.

   With REINIT you reset the state of the request as if you had just allocated
   it. You cannot REINIT a request if the request is queued but not yet completed.
   It will return -EBUSY in that case.

   Calling QUEUE if the request is already queued or completed will return -EBUSY
   as well. Or would -EPERM be better? I'm open to suggestions. Either error code
   will work, I think.

   You can poll the request fd to wait for it to complete. A request is complete
   if all the associated buffers are available for dequeuing and all the associated
   controls (such as controls containing e.g. statistics) are updated with their
   final values.

   To free a request you close the request fd. Note that it may still be in
   use internally, so this has to be refcounted.

   Requests only contain the changes since the previously queued request or
   since the current hardware state if no other requests are queued.

3) To associate a v4l2 buffer with a request the 'reserved' field in struct
   v4l2_buffer is used to store the request fd. Buffers won't be 'prepared'
   until the request is queued since the request may contain information that
   is needed to prepare the buffer.

   Queuing a buffer without a request after a buffer with a request is equivalent
   to queuing a request containing just that buffer and nothing else. I.e. it will
   just use whatever values the hardware has at the time of processing.

4) To associate v4l2 controls with a request we take the first of the
   'reserved[2]' array elements in struct v4l2_ext_controls and use it to store
   the request fd.

   When querying a control value from a request it will return the newest
   value in the list of pending requests, or the current hardware value if
   is not set in any of the pending requests.

   Setting controls without specifying a request fd will just act like it does
   today: the hardware is immediately updated. This can cause race conditions
   if the same control is also specified in a queued request: it is not defined
   which will be set first. It is therefor not a good idea to set the same
   control directly as well as set it as part of a request.

Notes:

- Earlier versions of this API had a TRY command as well to validate the
  request. I'm not sure that is useful so I dropped it, but it can easily
  be added if there is a good use-case for it. Traditionally within V4L the
  TRY ioctl will also update wrong values to something that works, but that
  is not the intention here as far as I understand it. So the validation
  step can also be done when the request is queued and, if it fails, it will
  just return an error.

- If due to performance reasons we will have to allocate/queue/reinit multiple
  requests with a single ioctl, then we will have to add new ioctls to the
  media device. At this moment in time it is not clear that this is really
  needed and it certainly isn't needed for the stateless codec support that
  we are looking at now.

Regards,

	Hans
