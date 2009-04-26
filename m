Return-path: <linux-media-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:34377 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548AbZDZPct (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Apr 2009 11:32:49 -0400
Date: Sun, 26 Apr 2009 11:31:51 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: linux-media@vger.kernel.org
cc: mchehab@infradead.org
Subject: [PATCH] DVB: Re C99, move storage class to beginning.
Message-ID: <alpine.LFD.2.00.0904261130590.3357@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

diff --git a/drivers/media/dvb/firewire/firedtv-rc.c b/drivers/media/dvb/firewire/firedtv-rc.c
index 46a6324..27bca2e 100644
--- a/drivers/media/dvb/firewire/firedtv-rc.c
+++ b/drivers/media/dvb/firewire/firedtv-rc.c
@@ -18,7 +18,7 @@
 #include "firedtv.h"

 /* fixed table with older keycodes, geared towards MythTV */
-const static u16 oldtable[] = {
+static const u16 oldtable[] = {

 	/* code from device: 0x4501...0x451f */

@@ -62,7 +62,7 @@ const static u16 oldtable[] = {
 };

 /* user-modifiable table for a remote as sold in 2008 */
-const static u16 keytable[] = {
+static const u16 keytable[] = {

 	/* code from device: 0x0300...0x031f */


========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
