Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm27-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.157]:46922 "HELO
	nm27-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751721Ab1HNBnL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2011 21:43:11 -0400
Message-ID: <1313286189.94904.YahooMailClassic@web121720.mail.ne1.yahoo.com>
Date: Sat, 13 Aug 2011 18:43:09 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: PCTV 290e nanostick and remote control support
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
In-Reply-To: <4E46FB3C.7060402@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

The rc-pinnacle-pctv-hd keymap is missing the definition of the OK key:

--- linux-3.0/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c.orig	2011-08-14 02:42:01.000000000 +0100
+++ linux-3.0/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c	2011-08-14 02:12:45.000000000 +0100
@@ -20,6 +20,7 @@
 	{ 0x0701, KEY_MENU }, /* Pinnacle logo */
 	{ 0x0739, KEY_POWER },
 	{ 0x0703, KEY_VOLUMEUP },
+	{ 0x0705, KEY_OK },
 	{ 0x0709, KEY_VOLUMEDOWN },
 	{ 0x0706, KEY_CHANNELUP },
 	{ 0x070c, KEY_CHANNELDOWN },

Cheers,
Chris

