Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:38404 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754805AbdHYMHJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 Aug 2017 08:07:09 -0400
From: Bhumika Goyal <bhumirks@gmail.com>
To: julia.lawall@lip6.fr, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH] [media] omap3isp: make omap3isp_prev_csc and omap3isp_prev_rgbtorgb const
Date: Fri, 25 Aug 2017 17:36:37 +0530
Message-Id: <1503662797-7633-1-git-send-email-bhumirks@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make these const as they are only used as a copy operation.

Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
---
 drivers/media/platform/omap3isp/isppreview.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index ac30a0f..2e7e961 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -25,7 +25,7 @@
 #include "isppreview.h"
 
 /* Default values in Office Fluorescent Light for RGBtoRGB Blending */
-static struct omap3isp_prev_rgbtorgb flr_rgb2rgb = {
+static const struct omap3isp_prev_rgbtorgb flr_rgb2rgb = {
 	{	/* RGB-RGB Matrix */
 		{0x01E2, 0x0F30, 0x0FEE},
 		{0x0F9B, 0x01AC, 0x0FB9},
@@ -35,7 +35,7 @@
 };
 
 /* Default values in Office Fluorescent Light for RGB to YUV Conversion*/
-static struct omap3isp_prev_csc flr_prev_csc = {
+static const struct omap3isp_prev_csc flr_prev_csc = {
 	{	/* CSC Coef Matrix */
 		{66, 129, 25},
 		{-38, -75, 112},
-- 
1.9.1
