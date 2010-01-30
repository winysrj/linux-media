Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:50885 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab0A3Q1A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jan 2010 11:27:00 -0500
Received: by ewy28 with SMTP id 28so583665ewy.28
        for <linux-media@vger.kernel.org>; Sat, 30 Jan 2010 08:26:58 -0800 (PST)
From: Martin Fuzzey <mfuzzey@gmail.com>
Subject: [PATCH] Video : pwc : Fix regression in pwc_set_shutter_speed caused
	by bad constant => sizeof conversion.
To: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: Greg KH <greg@kroah.com>, treecej@comcast.net
Date: Sat, 30 Jan 2010 17:26:51 +0100
Message-ID: <20100130162650.18132.97369.stgit@srv002.fuzzey.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Regression was caused by my commit 6b35ca0d3d586b8ecb8396821af21186e20afaf0
which determined message size using sizeof rather than hardcoded constants.

Unfortunately pwc_set_shutter_speed reuses a 2 byte buffer for a one byte
message too so the sizeof was bogus in this case.

All other uses of sizeof checked and are ok.

Signed-off-by: Martin Fuzzey <mfuzzey@gmail.com>

---

 drivers/media/video/pwc/pwc-ctrl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/pwc/pwc-ctrl.c b/drivers/media/video/pwc/pwc-ctrl.c
index 50b415e..f7f7e04 100644
--- a/drivers/media/video/pwc/pwc-ctrl.c
+++ b/drivers/media/video/pwc/pwc-ctrl.c
@@ -753,7 +753,7 @@ int pwc_set_shutter_speed(struct pwc_device *pdev, int mode, int value)
 		buf[0] = 0xff; /* fixed */
 
 	ret = send_control_msg(pdev,
-		SET_LUM_CTL, SHUTTER_MODE_FORMATTER, &buf, sizeof(buf));
+		SET_LUM_CTL, SHUTTER_MODE_FORMATTER, &buf, 1);
 
 	if (!mode && ret >= 0) {
 		if (value < 0)

