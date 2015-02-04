Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45391 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965805AbbBDNOw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Feb 2015 08:14:52 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Pawel Osciak <pawel@osciak.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 5/5] [media] DocBooc: mention mem2mem codecs for encoder/decoder commands
Date: Wed,  4 Feb 2015 14:14:37 +0100
Message-Id: <1423055677-13161-6-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1423055677-13161-1-git-send-email-p.zabel@pengutronix.de>
References: <1423055677-13161-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch mentions mem2mem codecs and the mem2mem draining flow signals in the
VIDIOC_DECODER_CMD V4L2_DEC_CMD_STOP and VIDIOC_ENCODER_CMD V4L2_ENC_CMD_STOP
documentation.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml | 6 +++++-
 Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml | 5 ++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml b/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
index 9215627..6a30493 100644
--- a/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
@@ -197,7 +197,11 @@ be muted when playing back at a non-standard speed.
 this command does nothing. This command has two flags:
 if <constant>V4L2_DEC_CMD_STOP_TO_BLACK</constant> is set, then the decoder will
 set the picture to black after it stopped decoding. Otherwise the last image will
-repeat. If <constant>V4L2_DEC_CMD_STOP_IMMEDIATELY</constant> is set, then the decoder
+repeat. mem2mem decoders will stop producing new frames altogether. They will send
+a <constant>V4L2_EVENT_EOS</constant> event after the last frame was decoded and
+will set the <constant>V4L2_BUF_FLAG_LAST</constant> buffer flag when there will
+be no new buffers produced to dequeue.
+If <constant>V4L2_DEC_CMD_STOP_IMMEDIATELY</constant> is set, then the decoder
 stops immediately (ignoring the <structfield>pts</structfield> value), otherwise it
 will keep decoding until timestamp >= pts or until the last of the pending data from
 its internal buffers was decoded.
diff --git a/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml b/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
index 0619ca5..e9cf601 100644
--- a/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
@@ -129,7 +129,10 @@ this command.</entry>
 encoding will continue until the end of the current <wordasword>Group
 Of Pictures</wordasword>, otherwise encoding will stop immediately.
 When the encoder is already stopped, this command does
-nothing.</entry>
+nothing. mem2mem encoders will send a <constant>V4L2_EVENT_EOS</constant> event
+after the last frame was encoded and will set the
+<constant>V4L2_BUF_FLAG_LAST</constant> buffer flag on the capture queue when
+there will be no new buffers produced to dequeue</entry>
 	  </row>
 	  <row>
 	    <entry><constant>V4L2_ENC_CMD_PAUSE</constant></entry>
-- 
2.1.4

