Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:42311 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbZCESOT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 13:14:19 -0500
Date: Thu, 5 Mar 2009 19:13:43 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firedtv: fix printk format mismatch
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <tkrat.89b6c7e0ebef51fe@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Eliminate
drivers/media/dvb/firewire/firedtv-avc.c: In function 'debug_fcp':
drivers/media/dvb/firewire/firedtv-avc.c:156: warning: format '%d' expects type 'int', but argument 5 has type 'size_t'

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Mauro, if you don't mind I queue it up in linux1394-2.6.git for after
2.6.29, before 2.6.30-rc1.  There may be firewire subsystem related
changes of firedtv coming together until then.

 drivers/media/dvb/firewire/firedtv-avc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/media/dvb/firewire/firedtv-avc.c
===================================================================
--- linux.orig/drivers/media/dvb/firewire/firedtv-avc.c
+++ linux/drivers/media/dvb/firewire/firedtv-avc.c
@@ -115,7 +115,7 @@ static const char *debug_fcp_ctype(unsig
 }
 
 static const char *debug_fcp_opcode(unsigned int opcode,
-				    const u8 *data, size_t length)
+				    const u8 *data, int length)
 {
 	switch (opcode) {
 	case AVC_OPCODE_VENDOR:			break;
@@ -141,7 +141,7 @@ static const char *debug_fcp_opcode(unsi
 	return "Vendor";
 }
 
-static void debug_fcp(const u8 *data, size_t length)
+static void debug_fcp(const u8 *data, int length)
 {
 	unsigned int subunit_type, subunit_id, op;
 	const char *prefix = data[0] > 7 ? "FCP <- " : "FCP -> ";

-- 
Stefan Richter
-=====-==--= --== --=-=
http://arcgraph.de/sr/

