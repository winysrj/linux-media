Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44194 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229Ab1CAExz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 23:53:55 -0500
Received: by bwz15 with SMTP id 15so4293310bwz.19
        for <linux-media@vger.kernel.org>; Mon, 28 Feb 2011 20:53:54 -0800 (PST)
Date: Tue, 1 Mar 2011 13:55:11 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] tm6000: add audio conf for new cards
Message-ID: <20110301135511.6dc0ab2b@glory.local>
In-Reply-To: <4D5D8BFB.4070802@redhat.com>
References: <4CAD5A78.3070803@redhat.com>
 <4CB492D4.1000609@arcor.de>
 <20101129174412.08f2001c@glory.local>
 <4CF51C9E.6040600@arcor.de>
 <20101201144704.43b58f2c@glory.local>
 <4CF67AB9.6020006@arcor.de>
 <20101202134128.615bbfa0@glory.local>
 <4CF71CF6.7080603@redhat.com>
 <20101206010934.55d07569@glory.local>
 <4CFBF62D.7010301@arcor.de>
 <20101206190230.2259d7ab@glory.local>
 <4CFEA3D2.4050309@arcor.de>
 <20101208125539.739e2ed2@glory.local>
 <4CFFAD1E.7040004@arcor.de>
 <20101214122325.5cdea67e@glory.local>
 <4D079ADF.2000705@arcor.de>
 <20101215164634.44846128@glory.local>
 <4D08E43C.8080002@arcor.de>
 <20101216183844.6258734e@glory.local>
 <4D0A4883.20804@arcor.de>
 <20101217104633.7c9d10d7@glory.local>
 <4D0AF2A7.6080100@arcor.de>
 <20101217160854.16a1f754@glory.local>
 <4D0BFF4B.3060001@redhat.com>
 <20110120150508.53c9b55e@glory.local>
 <4D388C44.7040500@arcor.de>
 <20110217141257.6d1b578b@glory.local>
 <4D5D8BFB.4070802@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/Ybs11CK9Iqo=0X9DG0JxhiO"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

--MP_/Ybs11CK9Iqo=0X9DG0JxhiO
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi

Add configuration of an audio for our new TV cards.

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index a356ba7..88144a1 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -324,6 +324,8 @@ struct tm6000_board tm6000_boards[] = {
 		.tuner_addr   = 0xc2 >> 1,
 		.demod_addr   = 0x1e >> 1,
 		.type         = TM6010,
+		.avideo       = TM6000_AIP_SIF1,
+		.aradio       = TM6000_AIP_LINE1,
 		.caps = {
 			.has_tuner    = 1,
 			.has_dvb      = 1,
@@ -341,6 +343,8 @@ struct tm6000_board tm6000_boards[] = {
 		.tuner_type   = TUNER_XC5000,
 		.tuner_addr   = 0xc2 >> 1,
 		.type         = TM6010,
+		.avideo       = TM6000_AIP_SIF1,
+		.aradio       = TM6000_AIP_LINE1,
 		.caps = {
 			.has_tuner    = 1,
 			.has_dvb      = 0,

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

With my best regards, Dmitry.

--MP_/Ybs11CK9Iqo=0X9DG0JxhiO
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=tm6000_lite_audio.diff

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index a356ba7..88144a1 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -324,6 +324,8 @@ struct tm6000_board tm6000_boards[] = {
 		.tuner_addr   = 0xc2 >> 1,
 		.demod_addr   = 0x1e >> 1,
 		.type         = TM6010,
+		.avideo       = TM6000_AIP_SIF1,
+		.aradio       = TM6000_AIP_LINE1,
 		.caps = {
 			.has_tuner    = 1,
 			.has_dvb      = 1,
@@ -341,6 +343,8 @@ struct tm6000_board tm6000_boards[] = {
 		.tuner_type   = TUNER_XC5000,
 		.tuner_addr   = 0xc2 >> 1,
 		.type         = TM6010,
+		.avideo       = TM6000_AIP_SIF1,
+		.aradio       = TM6000_AIP_LINE1,
 		.caps = {
 			.has_tuner    = 1,
 			.has_dvb      = 0,

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/Ybs11CK9Iqo=0X9DG0JxhiO--
