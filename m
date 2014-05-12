Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4749 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbaELMmH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 May 2014 08:42:07 -0400
Message-ID: <5370C18C.7040006@xs4all.nl>
Date: Mon, 12 May 2014 14:41:48 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Ryley Angus <ryleyjangus@gmail.com>,
	"'Keith Pyle'" <kpyle@austin.rr.com>
Subject: [PATCH] hdpvr: fix interrupted recording
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ryley, Keith, can you test this one more time and if it works reply with
a 'Tested-by' tag that I can add to the patch?

Thanks!

	Hans


This issue was reported by Ryley Angus:

<quote>
I record from my satellite set top box using component video and optical
audio input. I basically use "cat /dev/video0 > ~/video.ts” or use dd. The
box is set to output audio as AC-3 over optical, but most channels are
actually output as stereo PCM. When the channel is changed between a PCM
channel and (typically to a movie channel) to a channel utilising AC-3,
the HD-PVR stops the recording as the set top box momentarily outputs no
audio. Changing between PCM channels doesn't cause any issues.

My main problem was that when this happens, cat/dd doesn't actually exit.
When going through the hdpvr driver source and the dmesg output, I found
the hdpvr driver wasn't actually shutting down the device properly until
I manually killed cat/dd.

I've seen references to this issue being a hardware issue from as far back
as 2010: http://forums.gbpvr.com/showthread.php?46429-HD-PVR-drops-recording-on-channel-change-Hauppauge-says-too-bad .

I tracked my issue to the file hdpvr-video.c. Specifically:
"if (wait_event_interruptible(dev->wait_data, buf->status = BUFSTAT_READY)) {"
(line ~450). The device seems to get stuck waiting for the buffer to become
ready. But as far as I can tell, when the channel is changed between a PCM
and AC-3 broadcast the buffer status will never actually become ready.
</quote>

Angus provided a hack to fix this, which I've rewritten.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Ryley Angus <ryleyjangus@gmail.com>
---
 drivers/media/usb/hdpvr/hdpvr-video.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 0500c417..44227da 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -454,6 +454,8 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
 
 		if (buf->status != BUFSTAT_READY &&
 		    dev->status != STATUS_DISCONNECTED) {
+			int err;
+
 			/* return nonblocking */
 			if (file->f_flags & O_NONBLOCK) {
 				if (!ret)
@@ -461,11 +463,23 @@ static ssize_t hdpvr_read(struct file *file, char __user *buffer, size_t count,
 				goto err;
 			}
 
-			if (wait_event_interruptible(dev->wait_data,
-					      buf->status == BUFSTAT_READY)) {
-				ret = -ERESTARTSYS;
+			err = wait_event_interruptible_timeout(dev->wait_data,
+					      buf->status == BUFSTAT_READY,
+					      msecs_to_jiffies(3000));
+			if (err < 0) {
+				ret = err;
 				goto err;
 			}
+			if (!err) {
+				v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
+					"timeout: restart streaming\n");
+				hdpvr_stop_streaming(dev);
+				err = hdpvr_start_streaming(dev);
+				if (err) {
+					ret = err;
+					goto err;
+				}
+			}
 		}
 
 		if (buf->status != BUFSTAT_READY)
-- 
2.0.0.rc0

