Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110810.mail.gq1.yahoo.com ([67.195.13.233]:27306 "HELO
	web110810.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753649AbZESQke (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 12:40:34 -0400
Message-ID: <897518.36694.qm@web110810.mail.gq1.yahoo.com>
Date: Tue, 19 May 2009 09:40:35 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: [PATCH] [09051_56] Siano: cards - merge load_module to event switch
To: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


# HG changeset patch

# User Uri Shkolnik <uris@siano-ms.com>
# Date 1242751505 -10800
# Node ID f78cbc153c82ebe58a1bbe82271b91f5a4a90642
# Parent  d92f2dfcb226c5f8b8c3216f7cf96126f7571702
[09051_56] Siano: cards - merge load_module to event switch

From: Uri Shkolnik <uris@siano-ms.com>

Merge the load_module into the board_event, remove redundant
function.

Priority: normal

Signed-off-by: Uri Shkolnik <uris@siano-ms.com>

diff -r d92f2dfcb226 -r f78cbc153c82 linux/drivers/media/dvb/siano/sms-cards.c
--- a/linux/drivers/media/dvb/siano/sms-cards.c	Tue May 19 19:29:16 2009 +0300
+++ b/linux/drivers/media/dvb/siano/sms-cards.c	Tue May 19 19:45:05 2009 +0300
@@ -194,13 +194,7 @@ int sms_board_event(struct smscore_devic
 
 	case BOARD_EVENT_BIND:



      
