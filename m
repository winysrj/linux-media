Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm1.bt.bullet.mail.ukl.yahoo.com ([217.146.183.199]:32714 "HELO
	nm1.bt.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752971Ab1HNMYw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2011 08:24:52 -0400
Received: from volcano.underworld (volcano.underworld [192.168.0.3])
	by wellhouse.underworld (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id p7ECIkCg026694
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-media@vger.kernel.org>; Sun, 14 Aug 2011 13:18:48 +0100
Message-ID: <4E47BD26.70508@yahoo.com>
Date: Sun, 14 Aug 2011 13:18:46 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] Add missing OK key to PCTV IR keymap
Content-Type: multipart/mixed;
 boundary="------------060508040800030704060003"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060508040800030704060003
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

The following patch adds the IR code for the missing "OK" key to the Pinnacle 
PCTV HD map. This map is now used by the PCTV 290e DVB-T2 device, whose remote 
control has 26 buttons.

Cheers,
Chris

Signed-off-by: Chris Rankin <rankincj@yahoo.com>


--------------060508040800030704060003
Content-Type: text/x-patch;
 name="EM28xx-keymap.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-keymap.diff"

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

--------------060508040800030704060003--
