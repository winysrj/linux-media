Return-path: <linux-media-owner@vger.kernel.org>
Received: from srv-hp10-72.netsons.net ([94.141.22.72]:51795 "EHLO
        srv-hp10-72.netsons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425880AbeCBJhb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 04:37:31 -0500
From: Luca Ceresoli <luca@lucaceresoli.net>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Luca Ceresoli <luca@lucaceresoli.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH] media: doc: poll: fix links to dual-ioctl sections
Date: Fri,  2 Mar 2018 10:37:20 +0100
Message-Id: <1519983440-9724-1-git-send-email-luca@lucaceresoli.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Links like :ref:`VIDIOC_STREAMON` expand to "ioctl VIDIOC_STREAMON,
VIDIOC_STREAMOFF". Thus our reader will think we are talking about
STREAMON _and_ STREAMOFF, but only one of the two actually applies
in some cases.

Fix by adding a link title, so the reader will read only the correct
ioctl name.

Signed-off-by: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
---
 Documentation/media/uapi/v4l/func-poll.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/media/uapi/v4l/func-poll.rst b/Documentation/media/uapi/v4l/func-poll.rst
index d0432dc09b05..360bc6523ae2 100644
--- a/Documentation/media/uapi/v4l/func-poll.rst
+++ b/Documentation/media/uapi/v4l/func-poll.rst
@@ -39,7 +39,7 @@ When streaming I/O has been negotiated this function waits until a
 buffer has been filled by the capture device and can be dequeued with
 the :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl. For output devices this
 function waits until the device is ready to accept a new buffer to be
-queued up with the :ref:`VIDIOC_QBUF` ioctl for
+queued up with the :ref:`VIDIOC_QBUF <VIDIOC_QBUF>` ioctl for
 display. When buffers are already in the outgoing queue of the driver
 (capture) or the incoming queue isn't full (display) the function
 returns immediately.
@@ -52,11 +52,11 @@ flags in the ``revents`` field, output devices the ``POLLOUT`` and
 ``POLLWRNORM`` flags. When the function timed out it returns a value of
 zero, on failure it returns -1 and the ``errno`` variable is set
 appropriately. When the application did not call
-:ref:`VIDIOC_STREAMON` the :ref:`poll() <func-poll>`
+:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` the :ref:`poll() <func-poll>`
 function succeeds, but sets the ``POLLERR`` flag in the ``revents``
 field. When the application has called
-:ref:`VIDIOC_STREAMON` for a capture device but
-hasn't yet called :ref:`VIDIOC_QBUF`, the
+:ref:`VIDIOC_STREAMON <VIDIOC_STREAMON>` for a capture device but
+hasn't yet called :ref:`VIDIOC_QBUF <VIDIOC_QBUF>`, the
 :ref:`poll() <func-poll>` function succeeds and sets the ``POLLERR`` flag in
 the ``revents`` field. For output devices this same situation will cause
 :ref:`poll() <func-poll>` to succeed as well, but it sets the ``POLLOUT`` and
-- 
2.7.4
