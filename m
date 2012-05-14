Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62645 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461Ab2ENWLZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 18:11:25 -0400
Received: by mail-qc0-f174.google.com with SMTP id o28so3753022qcr.19
        for <linux-media@vger.kernel.org>; Mon, 14 May 2012 15:11:25 -0700 (PDT)
From: Michael Krufky <mkrufky@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 04/11] mxl111sf-tuner: tune SYS_ATSCMH just like SYS_ATSC
Date: Mon, 14 May 2012 18:10:46 -0400
Message-Id: <1337033453-22119-4-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1337033453-22119-1-git-send-email-mkrufky@linuxtv.org>
References: <1337033453-22119-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MxL111SF tuner is programmed the same way for ATSC-MH
as it is programmed for ATSC.

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/dvb/dvb-usb/mxl111sf-tuner.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb/dvb-usb/mxl111sf-tuner.c b/drivers/media/dvb/dvb-usb/mxl111sf-tuner.c
index 72db6ee..74da5bb1 100644
--- a/drivers/media/dvb/dvb-usb/mxl111sf-tuner.c
+++ b/drivers/media/dvb/dvb-usb/mxl111sf-tuner.c
@@ -284,6 +284,7 @@ static int mxl111sf_tuner_set_params(struct dvb_frontend *fe)
 
 	switch (delsys) {
 	case SYS_ATSC:
+	case SYS_ATSCMH:
 		bw = 0; /* ATSC */
 		break;
 	case SYS_DVBC_ANNEX_B:
-- 
1.7.9.5

