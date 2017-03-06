Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34593 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753120AbdCFOOP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 09:14:15 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2.3] v4l: Clearly document interactions between formats, controls and buffers
Date: Mon,  6 Mar 2017 16:14:41 +0200
Message-Id: <20170306141441.13497-1-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20170305213610.3893-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20170305213610.3893-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

V4L2 exposes parameters that influence buffers sizes through the format
ioctls (VIDIOC_G_FMT, VIDIOC_TRY_FMT, VIDIOC_S_FMT, and possibly
VIDIOC_G_SELECTION and VIDIOC_S_SELECTION). Other parameters not part of
the format structure may also influence buffer sizes or buffer layout in
general. One existing such parameter is rotation, which is implemented
by the V4L2_CID_ROTATE control and thus exposed through the V4L2 control
ioctls.

The interaction between those parameters and buffers is currently only
partially specified by the V4L2 API. In particular interactions between
controls and buffers isn't specified at all. The behaviour of the
VIDIOC_S_FMT and VIDIOC_S_SELECTION ioctls when buffers are allocated is
also not fully specified.

This patch clearly defines and documents the interactions between
formats, selections, controls and buffers.

The preparatory discussions for the documentation change considered
completely disallowing controls that change the buffer size or layout,
in favour of extending the format API with a new ioctl that would bundle
those controls with format information. The idea has been rejected, as
this would essentially be a restricted version of the upcoming request
API that wouldn't bring any additional value.

Another option we have considered was to mandate the use of the request
API to modify controls that influence buffer size or layout. This has
also been rejected on the grounds that requiring the request API to
change rotation even when streaming is stopped would significantly
complicate implementation of drivers and usage of the V4L2 API for
applications.

Applications will however be required to use the upcoming request API to
change at runtime formats or controls that influence the buffer size or
layout, because of the need to synchronize buffers with the formats and
controls. Otherwise there would be no way to interpret the content of a
buffer correctly.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
Changes since v2.2:

- Describe the simple option first
- Fix error codes

Changes since v2.1:

- Fixed small issues in commit message
- Simplified wording of one sentence in the documentation

Changes since v2:

- Document the interaction with ioctls that can affect formats
  (VIDIOC_S_SELECTION, VIDIOC_S_INPUT, VIDIOC_S_OUTPUT, VIDIOC_S_STD and
  VIDIOC_S_DV_TIMINGS)
- Clarify the format/control change order
---
 Documentation/media/uapi/v4l/buffer.rst | 110 ++++++++++++++++++++++++++++++++
 1 file changed, 110 insertions(+)

diff --git a/Documentation/media/uapi/v4l/buffer.rst b/Documentation/media/uapi/v4l/buffer.rst
index ac58966ccb9b..d1e0d55dc219 100644
--- a/Documentation/media/uapi/v4l/buffer.rst
+++ b/Documentation/media/uapi/v4l/buffer.rst
@@ -34,6 +34,116 @@ flags are copied from the OUTPUT video buffer to the CAPTURE video
 buffer.
 
 
+Interactions between formats, controls and buffers
+==================================================
+
+V4L2 exposes parameters that influence the buffer size, or the way data is
+laid out in the buffer. Those parameters are exposed through both formats and
+controls. One example of such a control is the ``V4L2_CID_ROTATE`` control
+that modifies the direction in which pixels are stored in the buffer, as well
+as the buffer size when the selected format includes padding at the end of
+lines.
+
+The set of information needed to interpret the content of a buffer (e.g. the
+pixel format, the line stride, the tiling orientation or the rotation) is
+collectively referred to in the rest of this section as the buffer layout.
+
+Modifying formats or controls that influence the buffer size or layout require
+the stream to be stopped. Any attempt at such a modification while the stream
+is active shall cause the ioctl setting the format or the control to return
+the ``EBUSY`` error code.
+
+.. note::
+
+   The :c:func:`VIDIOC_S_SELECTION` ioctl can, depending on the hardware (for
+   instance if the device doesn't include a scaler), modify the format in
+   addition to the selection rectangle. Similarly, the
+   :c:func:`VIDIOC_S_INPUT`, :c:func:`VIDIOC_S_OUTPUT`, :c:func:`VIDIOC_S_STD`
+   and :c:func:`VIDIOC_S_DV_TIMINGS` ioctls can also modify the format and
+   selection rectangles. When those ioctls result in a buffer size or layout
+   change, drivers shall handle that condition as they would handle it in the
+   :c:func:`VIDIOC_S_FMT` ioctl in all cases described in this section.
+
+Controls that only influence the buffer layout can be modified at any time
+when the stream is stopped. As they don't influence the buffer size, no
+special handling is needed to synchronize those controls with buffer
+allocation.
+
+Formats and controls that influence the buffer size interact with buffer
+allocation. The simplest way to handle this is for drivers to always require
+buffers to be reallocated in order to change those formats or controls. In
+that case, to perform such changes, userspace applications shall first stop
+the video stream with the :c:func:`VIDIOC_STREAMOFF` ioctl if it is running
+and free all buffers with the :c:func:`VIDIOC_REQBUFS` ioctl if they are
+allocated. The format or controls can then be modified, and buffers shall then
+be reallocated and the stream restarted. A typical ioctl sequence is
+
+ #. VIDIOC_STREAMOFF
+ #. VIDIOC_REQBUFS(0)
+ #. VIDIOC_S_EXT_CTRLS
+ #. VIDIOC_S_FMT
+ #. VIDIOC_REQBUFS(n)
+ #. VIDIOC_QBUF
+ #. VIDIOC_STREAMON
+
+The second :c:func:`VIDIOC_REQBUFS` call will take the new format and control
+value into account to compute the buffer size to allocate. Applications can
+also retrieve the size by calling the :c:func:`VIDIOC_G_FMT` ioctl if needed.
+
+.. note::
+
+   The API doesn't mandate the above order for control (3.) and format (4.)
+   changes. Format and controls can be set in a different order, or even
+   interleaved, depending on the device and use case. For instance some
+   controls might behave differently for different pixel formats, in which
+   case the format might need to be set first.
+
+When reallocation is required, any attempt to modify format or controls that
+influences the buffer size while buffers are allocated shall cause the format
+or control set ioctl to return the ``EBUSY`` error. Any attempt to queue a
+buffer too small for the current format or controls shall cause the
+:c:func:`VIDIOC_QBUF` ioctl to return a ``EINVAL`` error.
+
+Buffer reallocation is an expensive operation. To avoid that cost, drivers can
+(and are encouraged to) allow format or controls that influence the buffer
+size to be changed with buffers allocated. In that case, a typical ioctl
+sequence to modify format and controls is
+
+ #. VIDIOC_STREAMOFF
+ #. VIDIOC_S_EXT_CTRLS
+ #. VIDIOC_S_FMT
+ #. VIDIOC_QBUF
+ #. VIDIOC_STREAMON
+
+For this sequence to operate correctly, queued buffers need to be large enough
+for the new format or controls. Drivers shall return a ``ENOSPC`` error in
+response to format change (:c:func:`VIDIOC_S_FMT`) or control changes
+(:c:func:`VIDIOC_S_CTRL` or :c:func:`VIDIOC_S_EXT_CTRLS`) if buffers too small
+for the new format are currently queued. As a simplification, drivers are
+allowed to return a ``EBUSY`` error from these ioctls if any buffer is
+currently queued, without checking the queued buffers sizes.
+
+Additionally, drivers shall return a ``EINVAL`` error from the
+:c:func:`VIDIOC_QBUF` ioctl if the buffer being queued is too small for the
+current format or controls. Together, these requirements ensure that queued
+buffers will always be large enough for the configured format and controls.
+
+Userspace applications can query the buffer size required for a given format
+and controls by first setting the desired control values and then trying the
+desired format. The :c:func:`VIDIOC_TRY_FMT` ioctl will return the required
+buffer size.
+
+ #. VIDIOC_S_EXT_CTRLS(x)
+ #. VIDIOC_TRY_FMT()
+ #. VIDIOC_S_EXT_CTRLS(y)
+ #. VIDIOC_TRY_FMT()
+
+The :c:func:`VIDIOC_CREATE_BUFS` ioctl can then be used to allocate buffers
+based on the queried sizes (for instance by allocating a set of buffers large
+enough for all the desired formats and controls, or by allocating separate set
+of appropriately sized buffers for each use case).
+
+
 .. c:type:: v4l2_buffer
 
 struct v4l2_buffer
-- 
Regards,

Laurent Pinchart
