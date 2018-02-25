Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:53760 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751670AbeBYRHB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Feb 2018 12:07:01 -0500
Received: by mail-wm0-f68.google.com with SMTP id t74so13277005wme.3
        for <linux-media@vger.kernel.org>; Sun, 25 Feb 2018 09:07:00 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: [PATCH] [media] ngene: add proper polling to the dvbdev_ci file ops
Date: Sun, 25 Feb 2018 18:06:56 +0100
Message-Id: <20180225170656.10358-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Implement the poll callback for the dvbdev_ci file ops. The ts_poll()
function queries the DVB ring buffers for available data and space, and
reports this as appropriate. Also, set the dvb_device readers, writers
and users to proper values (one reader, one writer, two users).

This fixes the raw CI TS transport in conjunction with TVheadend's
DDCI functionality.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
This patch was committed ontop of the ngene hardware/tsfix series, so it
might conflict if that series isn't applied beforehand (I honestly didn't
test that).

 drivers/media/pci/ngene/ngene-dvb.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/ngene/ngene-dvb.c b/drivers/media/pci/ngene/ngene-dvb.c
index 0f9759a4d124..2df641e05fca 100644
--- a/drivers/media/pci/ngene/ngene-dvb.c
+++ b/drivers/media/pci/ngene/ngene-dvb.c
@@ -87,18 +87,41 @@ static ssize_t ts_read(struct file *file, char __user *buf,
 	return count;
 }
 
+static __poll_t ts_poll(struct file *file, poll_table *wait)
+{
+	struct dvb_device *dvbdev = file->private_data;
+	struct ngene_channel *chan = dvbdev->priv;
+	struct ngene *dev = chan->dev;
+	struct dvb_ringbuffer *rbuf = &dev->tsin_rbuf;
+	struct dvb_ringbuffer *wbuf = &dev->tsout_rbuf;
+	__poll_t mask = 0;
+
+	poll_wait(file, &rbuf->queue, wait);
+	poll_wait(file, &wbuf->queue, wait);
+
+	if (!dvb_ringbuffer_empty(rbuf))
+		mask |= EPOLLIN | EPOLLRDNORM;
+	if (dvb_ringbuffer_free(wbuf) >= 188)
+		mask |= EPOLLOUT | EPOLLWRNORM;
+
+	return mask;
+}
+
 static const struct file_operations ci_fops = {
 	.owner   = THIS_MODULE,
 	.read    = ts_read,
 	.write   = ts_write,
 	.open    = dvb_generic_open,
 	.release = dvb_generic_release,
+	.poll    = ts_poll,
+	.mmap    = NULL,
 };
 
 struct dvb_device ngene_dvbdev_ci = {
-	.readers = -1,
-	.writers = -1,
-	.users   = -1,
+	.priv    = NULL,
+	.readers = 1,
+	.writers = 1,
+	.users   = 2,
 	.fops    = &ci_fops,
 };
 
-- 
2.16.1
