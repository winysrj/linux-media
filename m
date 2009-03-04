Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:50672 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbZCDQ43 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2009 11:56:29 -0500
Message-ID: <49AEB2E0.1030503@oracle.com>
Date: Wed, 04 Mar 2009 08:57:04 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH -next] media/dm1105: uses ir_* functions, select VIDEO_IR
References: <20090304180630.047dac29.sfr@canb.auug.org.au>
In-Reply-To: <20090304180630.047dac29.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

dm1105 uses the ir_*() functions, so it needs to select VIDEO_IR
to avoid build errors:

dm1105.c:(.text+0x26b7ac): undefined reference to `ir_input_keydown'
dm1105.c:(.text+0x26b7bc): undefined reference to `ir_input_nokey'
(.devinit.text+0x29982): undefined reference to `ir_codes_dm1105_nec'
(.devinit.text+0x2998a): undefined reference to `ir_input_init'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/dvb/dm1105/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20090304.orig/drivers/media/dvb/dm1105/Kconfig
+++ linux-next-20090304/drivers/media/dvb/dm1105/Kconfig
@@ -8,6 +8,7 @@ config DVB_DM1105
 	select DVB_STB6000 if !DVB_FE_CUSTOMISE
 	select DVB_CX24116 if !DVB_FE_CUSTOMISE
 	select DVB_SI21XX if !DVB_FE_CUSTOMISE
+	select VIDEO_IR
 	help
 	  Support for cards based on the SDMC DM1105 PCI chip like
 	  DvbWorld 2002
