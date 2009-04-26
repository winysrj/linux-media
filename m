Return-path: <linux-media-owner@vger.kernel.org>
Received: from symlink.to.noone.org ([85.10.207.172]:54971 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbZDZNDm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Apr 2009 09:03:42 -0400
From: Tobias Klauser <tklauser@distanz.ch>
To: mchehab@infradead.org, linux-media@vger.kernel.org
Cc: stefanr@s5r6.in-berlin.de, Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH] firedtv: Storage class should be before const qualifier
Date: Sun, 26 Apr 2009 15:03:29 +0200
Message-Id: <1240751009-10023-1-git-send-email-tklauser@distanz.ch>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The C99 specification states in section 6.11.5:

The placement of a storage-class specifier other than at the beginning
of the declaration specifiers in a declaration is an obsolescent
feature.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/media/dvb/firewire/firedtv-rc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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
 
-- 
1.6.2.4

