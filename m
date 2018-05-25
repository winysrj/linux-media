Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-1b.atlantis.sk ([80.94.52.26]:37029 "EHLO
        smtp-1b.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964971AbeEYJIr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 05:08:47 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3 v2] gspca_zc3xx: Fix power line frequency settings for OV7648
Date: Fri, 25 May 2018 11:08:42 +0200
Message-Id: <20180525090843.31735-2-linux@rainbow-software.org>
In-Reply-To: <20180525090843.31735-1-linux@rainbow-software.org>
References: <20180525090843.31735-1-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Power line frequency settings for OV7648 sensor contain autogain
and exposure commands, affecting unrelated controls. Remove them.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/usb/gspca/zc3xx.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/usb/gspca/zc3xx.c b/drivers/media/usb/gspca/zc3xx.c
index 992918b3ad0c..c72f2d9167d9 100644
--- a/drivers/media/usb/gspca/zc3xx.c
+++ b/drivers/media/usb/gspca/zc3xx.c
@@ -3184,7 +3184,6 @@ static const struct usb_action ov7620_InitialScale[] = {	/* 320x240 */
 	{}
 };
 static const struct usb_action ov7620_50HZ[] = {
-	{0xaa, 0x13, 0x00a3},	/* 00,13,a3,aa */
 	{0xdd, 0x00, 0x0100},	/* 00,01,00,dd */
 	{0xaa, 0x2b, 0x0096},	/* 00,2b,96,aa */
 	{0xaa, 0x75, 0x008a},	/* 00,75,8a,aa */
@@ -3195,15 +3194,12 @@ static const struct usb_action ov7620_50HZ[] = {
 	{0xa0, 0x00, ZC3XX_R195_ANTIFLICKERHIGH},	/* 01,95,00,cc */
 	{0xa0, 0x00, ZC3XX_R196_ANTIFLICKERMID},	/* 01,96,00,cc */
 	{0xa0, 0x83, ZC3XX_R197_ANTIFLICKERLOW},	/* 01,97,83,cc */
-	{0xaa, 0x10, 0x0082},				/* 00,10,82,aa */
 	{0xaa, 0x76, 0x0003},				/* 00,76,03,aa */
 /*	{0xa0, 0x40, ZC3XX_R002_CLOCKSELECT},		 * 00,02,40,cc
 							 * if mode0 (640x480) */
 	{}
 };
 static const struct usb_action ov7620_60HZ[] = {
-	{0xaa, 0x13, 0x00a3},			/* 00,13,a3,aa */
-						/* (bug in zs211.inf) */
 	{0xdd, 0x00, 0x0100},			/* 00,01,00,dd */
 	{0xaa, 0x2b, 0x0000},			/* 00,2b,00,aa */
 	{0xaa, 0x75, 0x008a},			/* 00,75,8a,aa */
@@ -3214,7 +3210,6 @@ static const struct usb_action ov7620_60HZ[] = {
 	{0xa0, 0x00, ZC3XX_R195_ANTIFLICKERHIGH}, /* 01,95,00,cc */
 	{0xa0, 0x00, ZC3XX_R196_ANTIFLICKERMID}, /* 01,96,00,cc */
 	{0xa0, 0x83, ZC3XX_R197_ANTIFLICKERLOW}, /* 01,97,83,cc */
-	{0xaa, 0x10, 0x0020},			/* 00,10,20,aa */
 	{0xaa, 0x76, 0x0003},			/* 00,76,03,aa */
 /*	{0xa0, 0x40, ZC3XX_R002_CLOCKSELECT},	 * 00,02,40,cc
 						 * if mode0 (640x480) */
@@ -3224,8 +3219,6 @@ static const struct usb_action ov7620_60HZ[] = {
 	{}
 };
 static const struct usb_action ov7620_NoFliker[] = {
-	{0xaa, 0x13, 0x00a3},			/* 00,13,a3,aa */
-						/* (bug in zs211.inf) */
 	{0xdd, 0x00, 0x0100},			/* 00,01,00,dd */
 	{0xaa, 0x2b, 0x0000},			/* 00,2b,00,aa */
 	{0xaa, 0x75, 0x008e},			/* 00,75,8e,aa */
-- 
Ondrej Zary
