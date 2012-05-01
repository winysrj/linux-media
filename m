Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:38849 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab2EAEMq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2012 00:12:46 -0400
Received: by mail-vx0-f174.google.com with SMTP id p1so2537594vcq.19
        for <linux-media@vger.kernel.org>; Mon, 30 Apr 2012 21:12:45 -0700 (PDT)
From: Michael Krufky <mkrufky@kernellabs.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: [PATCH 04/10] mxl111sf-tuner: tune SYS_ATSCMH just like SYS_ATSC
Date: Tue,  1 May 2012 00:12:19 -0400
Message-Id: <1335845545-20879-4-git-send-email-mkrufky@linuxtv.org>
In-Reply-To: <1335845545-20879-1-git-send-email-mkrufky@linuxtv.org>
References: <1335845545-20879-1-git-send-email-mkrufky@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
---
 drivers/media/dvb/dvb-usb/mxl111sf-tuner.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

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
1.7.5.4

