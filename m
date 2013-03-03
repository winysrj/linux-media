Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529Ab3CCP67 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Mar 2013 10:58:59 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r23FwwEJ021689
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sun, 3 Mar 2013 10:58:58 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 10/11] [media] cx231xx: Improve signal reception for PV SBTVD
Date: Sun,  3 Mar 2013 12:58:50 -0300
Message-Id: <1362326331-17541-11-git-send-email-mchehab@redhat.com>
In-Reply-To: <1362326331-17541-1-git-send-email-mchehab@redhat.com>
References: <1362326331-17541-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using 3.3 MHz IF, use 4MHz. That's the standard
value for the demod, and, while it can be adjusted, 3.3 MHz
is out of the recommended range. So, let's stick with the
default.
With regards to the IF voltage level, instead of using
0.5 V(p-p) for IF, use 2V, giving a 12dB gain.
The rationale is that, on PixelView SBTVD Hybrid,
even 2V(p-p) would be in the nominal range for IF,
as the maximum range on this particular device is 3V.
A higher gain here should help to improve reception under
weak signals.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/cx231xx/cx231xx-dvb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 7c4e360..14e2610 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -89,8 +89,8 @@ static struct tda18271_std_map cnxt_rde253s_tda18271_std_map = {
 };
 
 static struct tda18271_std_map mb86a20s_tda18271_config = {
-	.dvbt_6   = { .if_freq = 3300, .agc_mode = 3, .std = 4,
-		      .if_lvl = 7, .rfagc_top = 0x37, },
+	.dvbt_6   = { .if_freq = 4000, .agc_mode = 3, .std = 4,
+		      .if_lvl = 0, .rfagc_top = 0x37, },
 };
 
 static struct tda18271_config cnxt_rde253s_tunerconfig = {
-- 
1.8.1.4

