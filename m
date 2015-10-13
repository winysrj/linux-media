Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:35509 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360AbbJMOR7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Oct 2015 10:17:59 -0400
Received: by obbzf10 with SMTP id zf10so14584620obb.2
        for <linux-media@vger.kernel.org>; Tue, 13 Oct 2015 07:17:59 -0700 (PDT)
MIME-Version: 1.0
From: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Date: Tue, 13 Oct 2015 16:17:39 +0200
Message-ID: <CAH-u=82Uv_Z1fNM5w8d-g+JNpZPwhf=JpWMfUuY0tWTJwO-X8A@mail.gmail.com>
Subject: [PATCH] DocBook media: Fix a typo in encoder cmd
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A copy-paste from DECODER_CMD : replace decoded by encoded.

Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
---
 Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
b/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
index fc1d462..70a4a08 100644
--- a/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
@@ -130,7 +130,7 @@ encoding will continue until the end of the
current <wordasword>Group
 Of Pictures</wordasword>, otherwise encoding will stop immediately.
 When the encoder is already stopped, this command does
 nothing. mem2mem encoders will send a <constant>V4L2_EVENT_EOS</constant> event
-when the last frame has been decoded and all frames are ready to be
dequeued and
+when the last frame has been encoded and all frames are ready to be
dequeued and
 will set the <constant>V4L2_BUF_FLAG_LAST</constant> buffer flag on the last
 buffer of the capture queue to indicate there will be no new buffers
produced to
 dequeue. This buffer may be empty, indicated by the driver setting the
-- 
2.6.0
