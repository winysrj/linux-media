Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.15]:37041 "EHLO imap.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815Ab2HNFnE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 01:43:04 -0400
Message-ID: <5029E3B0.3000304@netup.ru>
Date: Tue, 14 Aug 2012 09:35:44 +0400
From: Anton Nurkin <ptqa@netup.ru>
MIME-Version: 1.0
To: mchehab@redhat.com, linux-media@vger.kernel.org
CC: =?UTF-8?B?0JDQu9C10LrRgdC10Lkg0JHRg9GC0LrQtdC10LI=?=
	<abutkeev@netup.ru>, Abylay Ospan <aospan@netup.ru>
Subject: [PATCH] cx23885-cards: fix netup card revision
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello, Mauro. Can you check our patch? Netup cards revision 1 are not 
manufactured anymore, rev. 4 should be default.

Signed-off-by: Anton Nurkin <ptqa@netup.ru>

---

  drivers/media/video/cx23885/cx23885-cards.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-cards.c 
b/drivers/media/video/cx23885/cx23885-cards.c
index d365e9a..d889bd2 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -36,7 +36,7 @@
  #include "xc5000.h"
  #include "cx23888-ir.h"

-static unsigned int netup_card_rev = 1;
+static unsigned int netup_card_rev = 4;
  module_param(netup_card_rev, int, 0644);
  MODULE_PARM_DESC(netup_card_rev,
                 "NetUP Dual DVB-T/C CI card revision");


-- 
http://www.netup.ru
+7 (495) 510-1025 доб.1
IP: 77.72.80.1
Moscow, GMT+4
-- Anton Nurkin --

