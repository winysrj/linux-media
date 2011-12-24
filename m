Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755711Ab1LXPvO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:14 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFpEbL030882
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:14 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 13/47] [media] tda18271: add support for QAM 7 MHz map
Date: Sat, 24 Dec 2011 13:50:18 -0200
Message-Id: <1324741852-26138-14-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-13-git-send-email-mchehab@redhat.com>
References: <1324741852-26138-1-git-send-email-mchehab@redhat.com>
 <1324741852-26138-2-git-send-email-mchehab@redhat.com>
 <1324741852-26138-3-git-send-email-mchehab@redhat.com>
 <1324741852-26138-4-git-send-email-mchehab@redhat.com>
 <1324741852-26138-5-git-send-email-mchehab@redhat.com>
 <1324741852-26138-6-git-send-email-mchehab@redhat.com>
 <1324741852-26138-7-git-send-email-mchehab@redhat.com>
 <1324741852-26138-8-git-send-email-mchehab@redhat.com>
 <1324741852-26138-9-git-send-email-mchehab@redhat.com>
 <1324741852-26138-10-git-send-email-mchehab@redhat.com>
 <1324741852-26138-11-git-send-email-mchehab@redhat.com>
 <1324741852-26138-12-git-send-email-mchehab@redhat.com>
 <1324741852-26138-13-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This standard is not properly documented, but its settings are at
the tda18271dd driver, and are somewhat obvious, as they follow
the same logic as DVB-T 7MHz.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/tuners/tda18271-maps.c |    4 ++++
 drivers/media/common/tuners/tda18271.h      |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/media/common/tuners/tda18271-maps.c b/drivers/media/common/tuners/tda18271-maps.c
index 3d5b6ab..fb881c6 100644
--- a/drivers/media/common/tuners/tda18271-maps.c
+++ b/drivers/media/common/tuners/tda18271-maps.c
@@ -1213,6 +1213,8 @@ static struct tda18271_std_map tda18271c1_std_map = {
 		      .if_lvl = 1, .rfagc_top = 0x37, }, /* EP3[4:0] 0x1e */
 	.qam_6    = { .if_freq = 4000, .fm_rfn = 0, .agc_mode = 3, .std = 5,
 		      .if_lvl = 1, .rfagc_top = 0x37, }, /* EP3[4:0] 0x1d */
+	.qam_7    = { .if_freq = 4500, .fm_rfn = 0, .agc_mode = 3, .std = 6,
+		      .if_lvl = 1, .rfagc_top = 0x37, }, /* EP3[4:0] 0x1e */
 	.qam_8    = { .if_freq = 5000, .fm_rfn = 0, .agc_mode = 3, .std = 7,
 		      .if_lvl = 1, .rfagc_top = 0x37, }, /* EP3[4:0] 0x1f */
 };
@@ -1244,6 +1246,8 @@ static struct tda18271_std_map tda18271c2_std_map = {
 		      .if_lvl = 1, .rfagc_top = 0x37, }, /* EP3[4:0] 0x1d */
 	.qam_6    = { .if_freq = 4000, .fm_rfn = 0, .agc_mode = 3, .std = 5,
 		      .if_lvl = 1, .rfagc_top = 0x37, }, /* EP3[4:0] 0x1d */
+	.qam_7    = { .if_freq = 4500, .fm_rfn = 0, .agc_mode = 3, .std = 6,
+		      .if_lvl = 1, .rfagc_top = 0x37, }, /* EP3[4:0] 0x1e */
 	.qam_8    = { .if_freq = 5000, .fm_rfn = 0, .agc_mode = 3, .std = 7,
 		      .if_lvl = 1, .rfagc_top = 0x37, }, /* EP3[4:0] 0x1f */
 };
diff --git a/drivers/media/common/tuners/tda18271.h b/drivers/media/common/tuners/tda18271.h
index 50cfa8c..640bae4 100644
--- a/drivers/media/common/tuners/tda18271.h
+++ b/drivers/media/common/tuners/tda18271.h
@@ -53,6 +53,7 @@ struct tda18271_std_map {
 	struct tda18271_std_map_item dvbt_7;
 	struct tda18271_std_map_item dvbt_8;
 	struct tda18271_std_map_item qam_6;
+	struct tda18271_std_map_item qam_7;
 	struct tda18271_std_map_item qam_8;
 };
 
-- 
1.7.8.352.g876a6

