Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58094 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab0AMLGQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 06:06:16 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: David Vrabel <dvrabel@arcom.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Magnus Damm <damm@igel.co.jp>,
	Kuninori Morimoto <morimoto.kuninori@renesas.com>,
	Paul Mundt <lethal@linux-sh.org>, linux-media@vger.kernel.org
Subject: [RESEND PATCH 3/5] V4L/DVB sh_mobile_ceu: don't check platform_get_irq's return value against zero
Date: Wed, 13 Jan 2010 12:05:44 +0100
Message-Id: <1263380746-27803-3-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1260979809-24811-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1260979809-24811-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

platform_get_irq returns -ENXIO on failure, so !irq was probably
always true.  Better use (int)irq <= 0.  Note that a return value of
zero is still handled as error even though this could mean irq0.

This is a followup to 305b3228f9ff4d59f49e6d34a7034d44ee8ce2f0 that
changed the return value of platform_get_irq from 0 to -ENXIO on error.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: David Vrabel <dvrabel@arcom.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Magnus Damm <damm@igel.co.jp>
Cc: Kuninori Morimoto <morimoto.kuninori@renesas.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-media@vger.kernel.org
---
 drivers/media/video/sh_mobile_ceu_camera.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index d69363f..f09c714 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -1827,7 +1827,7 @@ static int __devinit sh_mobile_ceu_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irq = platform_get_irq(pdev, 0);
-	if (!res || !irq) {
+	if (!res || (int)irq <= 0) {
 		dev_err(&pdev->dev, "Not enough CEU platform resources.\n");
 		err = -ENODEV;
 		goto exit;
-- 
1.6.6

