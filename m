Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:42111 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727527AbeHPNXC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 16 Aug 2018 09:23:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFC] Request API questions
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Message-ID: <93ca4ddc-e803-ee5a-f345-7b72ded1f757@xs4all.nl>
Date: Thu, 16 Aug 2018 12:25:25 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent raised a few API issues/questions in his review of the documentation.

I've consolidated those in this RFC. I would like to know what others think
and if I should make changes.

1) Should you be allowed to set controls directly if they are also used in
   requests? Right now this is allowed, although we warn in the spec that
   this can lead to undefined behavior.

   In my experience being able to do this is very useful while testing,
   and restricting this is not all that easy to implement. I also think it is
   not our job. It is not as if something will break when you do this.

   If there really is a good reason why you can't mix this for a specific
   control, then the driver can check this and return -EBUSY.

2) If request_fd in QBUF or the control ioctls is not a request fd, then we
   now return ENOENT. Laurent suggests using EBADR ('Invalid request descriptor')
   instead. This seems like a good idea to me. Should I change this?

3) Calling VIDIOC_G_EXT_CTRLS for a request that has not been queued yet will
   return either the value of the control you set earlier in the request, or
   the current HW control value if it was never set in the request.

   I believe it makes sense to return what was set in the request previously
   (if you set it, you should be able to get it), but it is an idea to return
   ENOENT when calling this for controls that are NOT in the request.

   I'm inclined to implement that. Opinions?

4) When queueing a buffer to a request with VIDIOC_QBUF you set V4L2_BUF_FLAG_REQUEST_FD
   to indicate a valid request_fd. For other queue ioctls that take a struct v4l2_buffer
   this flag and the request_fd field are just ignored. Should we return EINVAL
   instead if the flag is set for those ioctls?

   The argument for just ignoring it is that older kernels that do not know about
   this flag will ignore it as well. There is no check against unknown flags.

Regards,

	Hans
