Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:8974 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbaFEPbk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jun 2014 11:31:40 -0400
Received: from uscpsbgex3.samsung.com
 (u124.gpu85.samsung.co.kr [203.254.195.124]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N6P003W9CGRU940@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 05 Jun 2014 11:31:39 -0400 (EDT)
From: Thiago Santos <ts.santos@sisa.samsung.com>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Thiago Santos <ts.santos@sisa.samsung.com>
Subject: [PATCH/RFC 2/2] libv4l2: release the lock before doing a DQBUF
Date: Thu, 05 Jun 2014 12:31:24 -0300
Message-id: <1401982284-1983-3-git-send-email-ts.santos@sisa.samsung.com>
In-reply-to: <1401982284-1983-1-git-send-email-ts.santos@sisa.samsung.com>
References: <1401982284-1983-1-git-send-email-ts.santos@sisa.samsung.com>
MIME-version: 1.0
Content-type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In blocking mode, if there are no buffers available the DQBUF will block
waiting for a QBUF to be called but it will block holding the streaming
lock which will prevent any QBUF from happening, causing a deadlock.

Can be tested with: v4l2grab -t 1 -b 1 -s 2000

Signed-off-by: Thiago Santos <ts.santos@sisa.samsung.com>
---
 lib/libv4l2/libv4l2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/libv4l2/libv4l2.c b/lib/libv4l2/libv4l2.c
index c4d69f7..5589fe0 100644
--- a/lib/libv4l2/libv4l2.c
+++ b/lib/libv4l2/libv4l2.c
@@ -290,9 +290,11 @@ static int v4l2_dequeue_and_convert(int index, struct v4l2_buffer *buf,
 		return result;
 
 	do {
+		pthread_mutex_unlock(&devices[index].stream_lock);
 		result = devices[index].dev_ops->ioctl(
 				devices[index].dev_ops_priv,
 				devices[index].fd, VIDIOC_DQBUF, buf);
+		pthread_mutex_lock(&devices[index].stream_lock);
 		if (result) {
 			if (errno != EAGAIN) {
 				int saved_err = errno;
-- 
2.0.0

