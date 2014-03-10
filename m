Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50438 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbaCJL7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 07:59:52 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 09/15] drx-j: get rid of some unused vars
Date: Mon, 10 Mar 2014 08:59:01 -0300
Message-Id: <1394452747-5426-10-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
References: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported when compiled with W=1:

drivers/media/dvb-frontends/drx39xyj/drxj.c: In function ‘ctrl_set_channel’:
drivers/media/dvb-frontends/drx39xyj/drxj.c:10340:26: warning: variable ‘common_attr’ set but not used [-Wunused-but-set-variable]
  struct drx_common_attr *common_attr = NULL;
                          ^
drivers/media/dvb-frontends/drx39xyj/drxj.c:10336:6: warning: variable ‘intermediate_freq’ set but not used [-Wunused-but-set-variable]
  s32 intermediate_freq = 0;

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index a26ddc9fa2bc..a36cfa684153 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -10333,11 +10333,9 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 {
 	int rc;
 	s32 tuner_freq_offset = 0;
-	s32 intermediate_freq = 0;
 	struct drxj_data *ext_attr = NULL;
 	struct i2c_device_addr *dev_addr = NULL;
 	enum drx_standard standard = DRX_STANDARD_UNKNOWN;
-	struct drx_common_attr *common_attr = NULL;
 #ifndef DRXJ_VSB_ONLY
 	u32 min_symbol_rate = 0;
 	u32 max_symbol_rate = 0;
@@ -10348,7 +10346,6 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 	if ((demod == NULL) || (channel == NULL))
 		return -EINVAL;
 
-	common_attr = (struct drx_common_attr *) demod->my_common_attr;
 	dev_addr = demod->my_i2c_dev_addr;
 	ext_attr = (struct drxj_data *) demod->my_ext_attr;
 	standard = ext_attr->standard;
@@ -10506,7 +10503,6 @@ ctrl_set_channel(struct drx_demod_instance *demod, struct drx_channel *channel)
 	}
 
 	tuner_freq_offset = 0;
-	intermediate_freq = demod->my_common_attr->intermediate_freq;
 
    /*== Setup demod for specific standard ====================================*/
 	switch (standard) {
-- 
1.8.5.3

