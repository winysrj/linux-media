Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43151 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab3IHAXC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Sep 2013 20:23:02 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Fengguang Wu <fengguang.wu@intel.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/3] msi3101: msi3101_ioctl_ops can be static
Date: Sun,  8 Sep 2013 03:21:50 +0300
Message-Id: <1378599711-26875-3-git-send-email-crope@iki.fi>
In-Reply-To: <1378599711-26875-1-git-send-email-crope@iki.fi>
References: <1378599711-26875-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fengguang Wu <fengguang.wu@intel.com>

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/staging/media/msi3101/sdr-msi3101.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/msi3101/sdr-msi3101.c b/drivers/staging/media/msi3101/sdr-msi3101.c
index 24c7b70..7715c85 100644
--- a/drivers/staging/media/msi3101/sdr-msi3101.c
+++ b/drivers/staging/media/msi3101/sdr-msi3101.c
@@ -1657,7 +1657,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 			f->frequency * 625UL / 10UL);
 }
 
-const struct v4l2_ioctl_ops msi3101_ioctl_ops = {
+static const struct v4l2_ioctl_ops msi3101_ioctl_ops = {
 	.vidioc_querycap          = msi3101_querycap,
 
 	.vidioc_enum_input        = msi3101_enum_input,
-- 
1.7.11.7

