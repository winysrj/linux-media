Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:49782 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026AbbDDMFG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Apr 2015 08:05:06 -0400
Message-ID: <551FD350.7030409@xs4all.nl>
Date: Sat, 04 Apr 2015 14:04:32 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] m88ts2022: remove from Makefile
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove target from Makefile: this driver no longer exists.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/tuners/Makefile b/drivers/media/tuners/Makefile
index da4fe6e..06a9ab6 100644
--- a/drivers/media/tuners/Makefile
+++ b/drivers/media/tuners/Makefile
@@ -33,7 +33,6 @@ obj-$(CONFIG_MEDIA_TUNER_E4000) += e4000.o
 obj-$(CONFIG_MEDIA_TUNER_FC2580) += fc2580.o
 obj-$(CONFIG_MEDIA_TUNER_TUA9001) += tua9001.o
 obj-$(CONFIG_MEDIA_TUNER_SI2157) += si2157.o
-obj-$(CONFIG_MEDIA_TUNER_M88TS2022) += m88ts2022.o
 obj-$(CONFIG_MEDIA_TUNER_FC0011) += fc0011.o
 obj-$(CONFIG_MEDIA_TUNER_FC0012) += fc0012.o
 obj-$(CONFIG_MEDIA_TUNER_FC0013) += fc0013.o
