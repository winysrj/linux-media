Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns2011.yellis.net ([79.170.233.11]:36623 "EHLO
	vds2011.yellis.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688Ab0FKQHz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jun 2010 12:07:55 -0400
Message-ID: <4C125DD5.6060604@anevia.com>
Date: Fri, 11 Jun 2010 18:01:25 +0200
From: Florent AUDEBERT <florent.audebert@anevia.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: abraham.manu@gmail.com, Florent Audebert <faudebert@anevia.com>
Subject: [PATCH] stb0899: Removed an extra byte sent at init on DiSEqC bus
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I noticed a stray 0x00 at init on DiSEqC bus (KNC1 DVB-S2) with a DiSEqC
tool analyzer.

I removed the register from initialization table and all seem to go well
(at least for my KNC board).


Regards,


Signed-off-by: Florent Audebert <florent.audebert@anevia.com>
---
 drivers/media/dvb/dvb-usb/az6027.c       |    1 -
 drivers/media/dvb/mantis/mantis_vp1041.c |    1 -
 drivers/media/dvb/ttpci/budget-av.c      |    1 -
 drivers/media/dvb/ttpci/budget-ci.c      |    1 -
 4 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6027.c b/drivers/media/dvb/dvb-usb/az6027.c
index 6681ac1..9710e7b 100644
--- a/drivers/media/dvb/dvb-usb/az6027.c
+++ b/drivers/media/dvb/dvb-usb/az6027.c
@@ -40,7 +40,6 @@ static const struct stb0899_s1_reg az6027_stb0899_s1_init_1[] = {
 	{ STB0899_DISRX_ST0     	, 0x04 },
 	{ STB0899_DISRX_ST1     	, 0x00 },
 	{ STB0899_DISPARITY     	, 0x00 },
-	{ STB0899_DISFIFO       	, 0x00 },
 	{ STB0899_DISSTATUS		, 0x20 },
 	{ STB0899_DISF22        	, 0x99 },
 	{ STB0899_DISF22RX      	, 0xa8 },
diff --git a/drivers/media/dvb/mantis/mantis_vp1041.c b/drivers/media/dvb/mantis/mantis_vp1041.c
index d1aa2bc..7bb1f28 100644
--- a/drivers/media/dvb/mantis/mantis_vp1041.c
+++ b/drivers/media/dvb/mantis/mantis_vp1041.c
@@ -51,7 +51,6 @@ static const struct stb0899_s1_reg vp1041_stb0899_s1_init_1[] = {
 	{ STB0899_DISRX_ST0     	, 0x04 },
 	{ STB0899_DISRX_ST1     	, 0x00 },
 	{ STB0899_DISPARITY     	, 0x00 },
-	{ STB0899_DISFIFO       	, 0x00 },
 	{ STB0899_DISSTATUS		, 0x20 },
 	{ STB0899_DISF22        	, 0x99 },
 	{ STB0899_DISF22RX      	, 0xa8 },
diff --git a/drivers/media/dvb/ttpci/budget-av.c b/drivers/media/dvb/ttpci/budget-av.c
index 983672a..b697af4 100644
--- a/drivers/media/dvb/ttpci/budget-av.c
+++ b/drivers/media/dvb/ttpci/budget-av.c
@@ -896,7 +896,6 @@ static const struct stb0899_s1_reg knc1_stb0899_s1_init_1[] = {
 	{ STB0899_DISRX_ST0		, 0x04 },
 	{ STB0899_DISRX_ST1		, 0x00 },
 	{ STB0899_DISPARITY		, 0x00 },
-	{ STB0899_DISFIFO		, 0x00 },
 	{ STB0899_DISSTATUS		, 0x20 },
 	{ STB0899_DISF22		, 0x8c },
 	{ STB0899_DISF22RX		, 0x9a },
diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index 13ac9e3..da5a72c 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -1046,7 +1046,6 @@ static const struct stb0899_s1_reg tt3200_stb0899_s1_init_1[] = {
 	{ STB0899_DISRX_ST0     	, 0x04 },
 	{ STB0899_DISRX_ST1     	, 0x00 },
 	{ STB0899_DISPARITY     	, 0x00 },
-	{ STB0899_DISFIFO       	, 0x00 },
 	{ STB0899_DISSTATUS		, 0x20 },
 	{ STB0899_DISF22        	, 0x8c },
 	{ STB0899_DISF22RX      	, 0x9a },
-- 
1.7.1

