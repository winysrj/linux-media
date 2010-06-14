Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52855 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab0FNU1F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jun 2010 16:27:05 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: reiserfs-devel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	clemens@ladisch.de, debora@linux.vnet.ibm.com,
	dri-devel@lists.freedesktop.org, linux-i2c@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net, linux-media@vger.kernel.org,
	"Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 8/8]tuners:tuner-simple Fix warning: variable 'tun' set but not used
Date: Mon, 14 Jun 2010 13:26:48 -0700
Message-Id: <1276547208-26569-9-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

not sure if this is correct or not for 
fixing this warning:
  CC [M]  drivers/media/common/tuners/tuner-simple.o
drivers/media/common/tuners/tuner-simple.c: In function 'simple_set_tv_freq':
drivers/media/common/tuners/tuner-simple.c:548:20: warning: variable 'tun' set but not used

 Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/media/common/tuners/tuner-simple.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/media/common/tuners/tuner-simple.c b/drivers/media/common/tuners/tuner-simple.c
index 8abbcc5..4465b99 100644
--- a/drivers/media/common/tuners/tuner-simple.c
+++ b/drivers/media/common/tuners/tuner-simple.c
@@ -545,14 +545,12 @@ static int simple_set_tv_freq(struct dvb_frontend *fe,
 	struct tuner_simple_priv *priv = fe->tuner_priv;
 	u8 config, cb;
 	u16 div;
-	struct tunertype *tun;
 	u8 buffer[4];
 	int rc, IFPCoff, i;
 	enum param_type desired_type;
 	struct tuner_params *t_params;
 
-	tun = priv->tun;
-
+	
 	/* IFPCoff = Video Intermediate Frequency - Vif:
 		940  =16*58.75  NTSC/J (Japan)
 		732  =16*45.75  M/N STD
-- 
1.7.1.rc1.21.gf3bd6

