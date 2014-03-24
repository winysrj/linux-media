Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19696 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbaCXXPU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 19:15:20 -0400
Date: Tue, 25 Mar 2014 07:15:17 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	kbuild-all@01.org
Subject: [linuxtv-media:master 453/499] WARNING: Comparing jiffies is
 almost always wrong; prefer time_after, time_before and friends
Message-ID: <5330bc85.WjS9lWyITuNDeI8X%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tree:   git://linuxtv.org/media_tree.git master
head:   8432164ddf7bfe40748ac49995356ab4dfda43b7
commit: 3d0c8fa3c5a0f9ffc4c3e8b4625ddeb875aee50b [453/499] [media] msi3101: convert to SDR API

scripts/checkpatch.pl 0001-media-msi3101-convert-to-SDR-API.patch
# many are suggestions rather than must-fix

WARNING: line over 80 characters
#369: drivers/staging/media/msi3101/sdr-msi3101.c:55:
+#define V4L2_PIX_FMT_SDR_S8     v4l2_fourcc('D', 'S', '0', '8') /* signed 8-bit */

WARNING: line over 80 characters
#370: drivers/staging/media/msi3101/sdr-msi3101.c:56:
+#define V4L2_PIX_FMT_SDR_S12    v4l2_fourcc('D', 'S', '1', '2') /* signed 12-bit */

WARNING: line over 80 characters
#371: drivers/staging/media/msi3101/sdr-msi3101.c:57:
+#define V4L2_PIX_FMT_SDR_S14    v4l2_fourcc('D', 'S', '1', '4') /* signed 14-bit */

WARNING: line over 80 characters
#372: drivers/staging/media/msi3101/sdr-msi3101.c:58:
+#define V4L2_PIX_FMT_SDR_MSI2500_384 v4l2_fourcc('M', '3', '8', '4') /* Mirics MSi2500 format 384 */

WARNING: Unnecessary space before function pointer arguments
#450: drivers/staging/media/msi3101/sdr-msi3101.c:151:
+	int (*convert_stream) (struct msi3101_state *s, u8 *dst, u8 *src,

WARNING: line over 80 characters
#553: drivers/staging/media/msi3101/sdr-msi3101.c:212:
+		sample_num[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 | src[0] << 0;

WARNING: Comparing jiffies is almost always wrong; prefer time_after, time_before and friends
#588: drivers/staging/media/msi3101/sdr-msi3101.c:235:
+	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {

WARNING: line over 80 characters
#590: drivers/staging/media/msi3101/sdr-msi3101.c:237:
+		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);

WARNING: Missing a blank line after declarations
#592: drivers/staging/media/msi3101/sdr-msi3101.c:239:
+		unsigned int samples = sample_num[i_max - 1] - s->sample;
+		s->jiffies_next = jiffies_now;

WARNING: Comparing jiffies is almost always wrong; prefer time_after, time_before and friends
#798: drivers/staging/media/msi3101/sdr-msi3101.c:387:
+	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {

WARNING: line over 80 characters
#801: drivers/staging/media/msi3101/sdr-msi3101.c:389:
+		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);

WARNING: Comparing jiffies is almost always wrong; prefer time_after, time_before and friends
#884: drivers/staging/media/msi3101/sdr-msi3101.c:452:
+	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {

WARNING: line over 80 characters
#887: drivers/staging/media/msi3101/sdr-msi3101.c:454:
+		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);

WARNING: line over 80 characters
#933: drivers/staging/media/msi3101/sdr-msi3101.c:492:
+		sample_num[i] = src[3] << 24 | src[2] << 16 | src[1] << 8 | src[0] << 0;

WARNING: Comparing jiffies is almost always wrong; prefer time_after, time_before and friends
#958: drivers/staging/media/msi3101/sdr-msi3101.c:515:
+	if ((s->jiffies_next + msecs_to_jiffies(10000)) <= jiffies) {

WARNING: line over 80 characters
#960: drivers/staging/media/msi3101/sdr-msi3101.c:517:
+		unsigned long msecs = jiffies_to_msecs(jiffies_now) - jiffies_to_msecs(s->jiffies_next);

WARNING: Missing a blank line after declarations
#962: drivers/staging/media/msi3101/sdr-msi3101.c:519:
+		unsigned int samples = sample_num[i_max - 1] - s->sample;
+		s->jiffies_next = jiffies_now;

ERROR: space required after that ';' (ctx:VxV)
#987: drivers/staging/media/msi3101/sdr-msi3101.c:539:
+	struct {signed int x:14;} se;
 	                       ^

WARNING: Missing a blank line after declarations
#1245: drivers/staging/media/msi3101/sdr-msi3101.c:1073:
+	u32 reg;
+	dev_dbg(&s->udev->dev, "%s: lna=%d mixer=%d if=%d\n", __func__,

WARNING: Missing a blank line after declarations
#1447: drivers/staging/media/msi3101/sdr-msi3101.c:1380:
+	int i;
+	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,

WARNING: Missing a blank line after declarations
#1473: drivers/staging/media/msi3101/sdr-msi3101.c:1404:
+	int i;
+	dev_dbg(&s->udev->dev, "%s: pixelformat fourcc %4.4s\n", __func__,

WARNING: Missing a blank line after declarations
#1528: drivers/staging/media/msi3101/sdr-msi3101.c:1455:
+	int ret  = 0;
+	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d\n",

WARNING: Missing a blank line after declarations
#1548: drivers/staging/media/msi3101/sdr-msi3101.c:1473:
+	int ret, band;
+	dev_dbg(&s->udev->dev, "%s: tuner=%d type=%d frequency=%u\n",

WARNING: line over 80 characters
#1559: drivers/staging/media/msi3101/sdr-msi3101.c:1484:
+		#define BAND_RF_0 ((bands_rf[0].rangehigh + bands_rf[1].rangelow) / 2)

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
