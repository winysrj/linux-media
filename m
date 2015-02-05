Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:45481 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbbBEIDn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Feb 2015 03:03:43 -0500
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Wolfram Sang <wsa@the-dreams.de>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] media: radio: assign wait_for_completion_timeout to appropriately typed var
Date: Thu,  5 Feb 2015 02:58:48 -0500
Message-Id: <1423123128-3464-1-git-send-email-hofrat@osadl.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

wait_for_completion_timeout() returns unsigned long not int. This assigns
the return value to an appropriately typed variable (also helps keep 
static code checkers happy).

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Patch was only compile tested with x86_64_defconfig + CONFIG_MEDIA_SUPPORT=m
CONFIG_MEDIA_CAMERA_SUPPORT=y, CONFIG_V4L_PLATFORM_DRIVERS=y,
CONFIG_MEDIA_RADIO_SUPPORT=y, RADIO_ADAPTER=y, CONFIG_RADIO_WL1273=m

Patch is against 3.19.0-rc7 (localversion-next is -next-20150204)

 drivers/media/radio/radio-wl1273.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index b8f3644..571c7f6 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -347,6 +347,7 @@ static int wl1273_fm_set_tx_freq(struct wl1273_device *radio, unsigned int freq)
 {
 	struct wl1273_core *core = radio->core;
 	int r = 0;
+	unsigned long t;
 
 	if (freq < WL1273_BAND_TX_LOW) {
 		dev_err(radio->dev,
@@ -378,11 +379,11 @@ static int wl1273_fm_set_tx_freq(struct wl1273_device *radio, unsigned int freq)
 	reinit_completion(&radio->busy);
 
 	/* wait for the FR IRQ */
-	r = wait_for_completion_timeout(&radio->busy, msecs_to_jiffies(2000));
-	if (!r)
+	t = wait_for_completion_timeout(&radio->busy, msecs_to_jiffies(2000));
+	if (!t)
 		return -ETIMEDOUT;
 
-	dev_dbg(radio->dev, "WL1273_CHANL_SET: %d\n", r);
+	dev_dbg(radio->dev, "WL1273_CHANL_SET: %lu\n", t);
 
 	/* Enable the output power */
 	r = core->write(core, WL1273_POWER_ENB_SET, 1);
@@ -392,12 +393,12 @@ static int wl1273_fm_set_tx_freq(struct wl1273_device *radio, unsigned int freq)
 	reinit_completion(&radio->busy);
 
 	/* wait for the POWER_ENB IRQ */
-	r = wait_for_completion_timeout(&radio->busy, msecs_to_jiffies(1000));
-	if (!r)
+	t = wait_for_completion_timeout(&radio->busy, msecs_to_jiffies(1000));
+	if (!t)
 		return -ETIMEDOUT;
 
 	radio->tx_frequency = freq;
-	dev_dbg(radio->dev, "WL1273_POWER_ENB_SET: %d\n", r);
+	dev_dbg(radio->dev, "WL1273_POWER_ENB_SET: %lu\n", t);
 
 	return	0;
 }
@@ -406,6 +407,7 @@ static int wl1273_fm_set_rx_freq(struct wl1273_device *radio, unsigned int freq)
 {
 	struct wl1273_core *core = radio->core;
 	int r, f;
+	unsigned long t;
 
 	if (freq < radio->rangelow) {
 		dev_err(radio->dev,
@@ -446,8 +448,8 @@ static int wl1273_fm_set_rx_freq(struct wl1273_device *radio, unsigned int freq)
 
 	reinit_completion(&radio->busy);
 
-	r = wait_for_completion_timeout(&radio->busy, msecs_to_jiffies(2000));
-	if (!r) {
+	t = wait_for_completion_timeout(&radio->busy, msecs_to_jiffies(2000));
+	if (!t) {
 		dev_err(radio->dev, "%s: TIMEOUT\n", __func__);
 		return -ETIMEDOUT;
 	}
-- 
1.7.10.4

