Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:54424 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751531AbeCWIqF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 04:46:05 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Pawel Osciak <pawel@osciak.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFCv2] Request API
Message-ID: <7fd4debd-5537-a261-06f0-c2ab1ca3b33d@xs4all.nl>
Date: Fri, 23 Mar 2018 09:46:00 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

RFC Request API, version 2
--------------------------

This document proposes the public API for handling requests.

There has been some confusion about how to do this, so this summarizes the
current approach based on conversations with the various stakeholders today
(Sakari, Alexandre Courbot, Thomasz Figa and myself).

1) Additions to the media API

   Allocate an empty request object:

   #define MEDIA_IOC_REQUEST_ALLOC _IOW('|', 0x05, __s32 *)

   This will return a file descriptor representing the request or an error
   if it can't allocate the request.

   If the pointer argument is NULL, then this will just return 0 (if this ioctl
   is implemented) or -ENOTTY otherwise. This can be used to test whether this
   ioctl is supported or not without actually having to allocate a request.

2) Operations on the request fd

   You can queue or reinit a request by calling these ioctls on the request fd:

   #define MEDIA_REQUEST_IOC_QUEUE   _IO('|',  128)
   #define MEDIA_REQUEST_IOC_REINIT  _IO('|',  129)

   With REINIT you reset the state of the request as if you had just allocated
   it.

   You can poll the request fd to wait for it to complete.

   To free a request you close the request fd. Note that it may still be in
   use internally, so the internal datastructures have to be refcounted.

   For this initial implementation only buffers and controls are contained
   in a request. This is needed to implement stateless codecs. Supporting
   complex camera pipelines will require more work.

   Requests only contain the changes to the state at request queue time
   relative to the previously queued request(s) or the current hardware state
   if no other requests were queued.

   Once a request is completed it will retain the state at completion
   time.

3) To associate a v4l2 buffer with a request the 'reserved' field in struct
   v4l2_buffer is used to store the request fd. Buffers won't be 'prepared'
   until the request is queued since the request may contain information that
   is needed to prepare the buffer.

   To indicate that request_fd should be used this flag should be set by
   userspace at QBUF time:

#define V4L2_BUF_FLAG_REQUEST			0x00800000

   This flag will also be returned by the driver to indicate that the buffer
   is associated with a request.

   TBD: what should vb2 return as request_fd value if this flag is set?
   This should act the same as the fence patch series and this is still
   being tweaked so let's wait for that to be merged first, then we can
   finalize this.

4) To associate v4l2 controls with a request we take the first of the
   'reserved[2]' array elements in struct v4l2_ext_controls and use it to store
   the request fd.

   We also add a new WHICH value:

#define V4L2_CTRL_WHICH_REQUEST   0x0f010000

   This tells the control framework to get/set controls from the given
   request fd.

   When querying a control value from a request it will return the newest
   value in the list of pending requests, or the current hardware value if
   is not set in any of the pending requests.

   When a request is completed the controls will no longer change. A copy
   will be made of volatile controls at the time of completion (actually
   it will be up to the driver to decide when to do that).

   Volatile controls and requests:

   - If you set a volatile control in a request, then that will be ignored,
     unless the V4L2_CTRL_FLAG_EXECUTE_ON_WRITE flag is set as well.

   - If you get a volatile control from a request then:
     1) If the request is completed it will return the value of the volatile
        control at completion time.
     2) Otherwise: if the V4L2_CTRL_FLAG_EXECUTE_ON_WRITE is set and it was
        set in a request, then that value is returned.
     3) Otherwise: return the current value from the hardware (i.e. normal
        behavior).

   Read-only controls and requests:

   - If you get a read-only control from a request then:
     1) If the request is completed it will return the value of the read-only
        control at completion time.
     2) Otherwise it will get the current value from the driver (i.e. normal
        behavior).

   Open issue: should we receive control events if a control in a request is
   added/changed? Currently there are no plans to support control events for
   requests. I don't see a clear use-case and neither do I see an easy way
   of implementing this (which fd would receive those events?).

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

- The behavior of VIDIOC_G_EXT_CTRLS with which == V4L2_CTRL_WHICH_CUR_VAL
  and VIDIOC_G_CTRL remains the same (i.e. it returns the current driver/HW
  values). However, when combined with requests the documentation should make
  clear that this returns a snapshot only and is racy w.r.t. applying values
  from a request.

- There is a discussion whether there should be a VIDIOC_REQUEST_ALLOC ioctl
  for V4L2 in addition to the media ioctl. The reason is that stateless codecs
  do not need the media controller except for allocating requests. So a V4L2
  ioctl would avoid applications from having to deal with a media device.
  This would also add additional hassle w.r.t. SELinux as I understand it.

  Support for this can be added for now as a final patch in the Request API
  patch series and we'll postpone the decision on this.
