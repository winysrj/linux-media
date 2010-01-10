Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.mujha-vel.cz ([81.30.225.246]:40327 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab0AJI4t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 03:56:49 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@redhat.com
Cc: hverkuil@xs4all.nl, awalls@radix.net, ivtv-devel@ivtvdriver.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	jirislaby@gmail.com
Subject: [PATCH 1/1] media: video/cx18, fix potential null dereference
Date: Sun, 10 Jan 2010 09:56:46 +0100
Message-Id: <1263113806-7532-1-git-send-email-jslaby@suse.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stanse found a potential null dereference in cx18_dvb_start_feed
and cx18_dvb_stop_feed. There is a check for stream being NULL,
but it is dereferenced earlier. Move the dereference after the
check.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/video/cx18/cx18-dvb.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/cx18/cx18-dvb.c b/drivers/media/video/cx18/cx18-dvb.c
index 71ad2d1..0ad5b63 100644
--- a/drivers/media/video/cx18/cx18-dvb.c
+++ b/drivers/media/video/cx18/cx18-dvb.c
@@ -213,10 +213,14 @@ static int cx18_dvb_start_feed(struct dvb_demux_feed *feed)
 {
 	struct dvb_demux *demux = feed->demux;
 	struct cx18_stream *stream = (struct cx18_stream *) demux->priv;
-	struct cx18 *cx = stream->cx;
+	struct cx18 *cx;
 	int ret;
 	u32 v;
 
+	if (!stream)
+		return -EINVAL;
+
+	cx = stream->cx;
 	CX18_DEBUG_INFO("Start feed: pid = 0x%x index = %d\n",
 			feed->pid, feed->index);
 
@@ -253,9 +257,6 @@ static int cx18_dvb_start_feed(struct dvb_demux_feed *feed)
 	if (!demux->dmx.frontend)
 		return -EINVAL;
 
-	if (!stream)
-		return -EINVAL;
-
 	mutex_lock(&stream->dvb.feedlock);
 	if (stream->dvb.feeding++ == 0) {
 		CX18_DEBUG_INFO("Starting Transport DMA\n");
@@ -279,13 +280,14 @@ static int cx18_dvb_stop_feed(struct dvb_demux_feed *feed)
 {
 	struct dvb_demux *demux = feed->demux;
 	struct cx18_stream *stream = (struct cx18_stream *)demux->priv;
-	struct cx18 *cx = stream->cx;
+	struct cx18 *cx;
 	int ret = -EINVAL;
 
-	CX18_DEBUG_INFO("Stop feed: pid = 0x%x index = %d\n",
-			feed->pid, feed->index);
-
 	if (stream) {
+		cx = stream->cx;
+		CX18_DEBUG_INFO("Stop feed: pid = 0x%x index = %d\n",
+				feed->pid, feed->index);
+
 		mutex_lock(&stream->dvb.feedlock);
 		if (--stream->dvb.feeding == 0) {
 			CX18_DEBUG_INFO("Stopping Transport DMA\n");
-- 
1.6.5.7

