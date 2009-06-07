Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:53772 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbZFGSST (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jun 2009 14:18:19 -0400
Received: by ewy6 with SMTP id 6so3579469ewy.37
        for <linux-media@vger.kernel.org>; Sun, 07 Jun 2009 11:18:21 -0700 (PDT)
Message-ID: <4A2C0469.4080507@gmail.com>
Date: Sun, 07 Jun 2009 20:18:17 +0200
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: linux-media@vger.kernel.org
Subject: [PATCH] Coherent naming of the pac207 v4l2 ctrls
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Francois,

The following minor patch renames two pac207 ctrls in order to
create a coherent naming of the v4l2 ctrls.

Best regards,
Erik

# HG changeset patch
# User erik.andren@gmail.com
# Date 1244398262 -7200
# Node ID 33938b355bc65d57f03ddea53bc42c8186dfe2c2
# Parent  c4bd8403b04210035fb823317974831d911fa086
gspca - pac207: Unify v4l2 ctrl names

From: Erik Andrén <erik.andren@gmail.com>

Let all pac207 ctrls have a coherent naming

Priority: normal

Signed-off-by: Erik Andrén <erik.andren@gmail.com>

diff -r c4bd8403b042 -r 33938b355bc6
linux/drivers/media/video/gspca/pac207.c
--- a/linux/drivers/media/video/gspca/pac207.c  Sun Jun 07 16:58:04
2009 +0200
+++ b/linux/drivers/media/video/gspca/pac207.c  Sun Jun 07 20:11:02
2009 +0200
@@ -106,7 +106,7 @@
            {
                .id = V4L2_CID_EXPOSURE,
                .type = V4L2_CTRL_TYPE_INTEGER,
-               .name = "exposure",
+               .name = "Exposure",
                .minimum = PAC207_EXPOSURE_MIN,
                .maximum = PAC207_EXPOSURE_MAX,
                .step = 1,
@@ -137,7 +137,7 @@
            {
                .id = V4L2_CID_GAIN,
                .type = V4L2_CTRL_TYPE_INTEGER,
-               .name = "gain",
+               .name = "Gain",
                .minimum = PAC207_GAIN_MIN,
                .maximum = PAC207_GAIN_MAX,
                .step = 1,

