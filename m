Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:49931 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbZL1RtG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2009 12:49:06 -0500
Received: by fxm25 with SMTP id 25so4728295fxm.21
        for <linux-media@vger.kernel.org>; Mon, 28 Dec 2009 09:49:05 -0800 (PST)
Date: Mon, 28 Dec 2009 19:48:49 +0200
From: Dan Carpenter <error27@gmail.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: linux-media@vger.kernel.org, Matthias Schwarzott <zzam@gentoo.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [patch] fix weird array index in zl10036.c
Message-ID: <20091228174849.GG17645@bicker>
References: <20091227131529.GJ6075@bicker> <200912271802.46083.zzam@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912271802.46083.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I was initially concerned about the weird array index (the 2 bumps
into the next row of the array).  Matthias Schwarzott look at the
datasheet and it turns out it should be zl10036_init_tab[1][0] |= 0x01;

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/media/dvb/frontends/zl10036.c	2009-12-28 19:04:51.000000000 +0200
+++ devel/drivers/media/dvb/frontends/zl10036.c	2009-12-28 19:07:18.000000000 +0200
@@ -411,7 +411,7 @@ static int zl10036_init_regs(struct zl10
 	state->bf = 0xff;
 
 	if (!state->config->rf_loop_enable)
-		zl10036_init_tab[1][2] |= 0x01;
+		zl10036_init_tab[1][0] |= 0x01;
 
 	deb_info("%s\n", __func__);
 
