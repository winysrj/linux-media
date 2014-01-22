Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailsafe.webbplatsen.se ([94.247.172.109]:20610 "EHLO
	mailsafe.webbplatsen.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbaAVTVM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jan 2014 14:21:12 -0500
Received: from skinbark.wpsintrax.se (unknown [83.145.49.220])
	by mailsafe.webbplatsen.se (Halon Mail Gateway) with ESMTP
	for <linux-media@vger.kernel.org>; Wed, 22 Jan 2014 20:04:01 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by skinbark.wpsintrax.se (Postfix) with ESMTP id E340F77C0C6
	for <linux-media@vger.kernel.org>; Wed, 22 Jan 2014 20:04:09 +0100 (CET)
Received: from skinbark.wpsintrax.se ([127.0.0.1])
	by localhost (skinbark.wpsintrax.se [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hX06S-s9maMn for <linux-media@vger.kernel.org>;
	Wed, 22 Jan 2014 20:04:09 +0100 (CET)
Received: from tor.valhalla.alchemy.lu (vodsl-4669.vo.lu [80.90.56.61])
	by skinbark.wpsintrax.se (Postfix) with ESMTPA id 933AD77C0AD
	for <linux-media@vger.kernel.org>; Wed, 22 Jan 2014 20:04:09 +0100 (CET)
Date: Wed, 22 Jan 2014 20:04:08 +0100
From: Joakim Hernberg <jbh@alchemy.lu>
To: linux-media@vger.kernel.org
Subject: patch to fix a tuning regression for TeVii S471
Message-ID: <20140122200408.3d0fc1cf@tor.valhalla.alchemy.lu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/RTyNbk=oiW68NPSSGouXgee"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/RTyNbk=oiW68NPSSGouXgee
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

I recently discovered a regression in the S471 driver.  When trying to
tune to 10818V on Astra 28E2, the system would tune to 11343V instead.
After browsing the code it appears that a divider was changed when the
tuning code was moved from ds3000.c to ts2020.c.

The attached patch fixes this regression, but testing turns up
more anomalies.  For instance I don't seem to be able to tune to 11344H
on 28E2 either.  The diseqc switches and lnbs are most likely in
working order as my Vu+ STB has no problem to tune to this frequency.

Can someone with either a S471 or another card using the ts2020 tuner
please verify that it's not a local problem?

-- 

   Joakim

--MP_/RTyNbk=oiW68NPSSGouXgee
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-Fix-a-TeVii-S471-regression-introduced-when-the-tuni.patch

>From 2b546f8e961b3cc1d990eabd3e9ca955b14782b5 Mon Sep 17 00:00:00 2001
From: makepkg <makepkg@archlinux.com>
Date: Wed, 22 Jan 2014 19:44:49 +0100
Subject: [PATCH] Fix a TeVii S471 regression introduced when the tuning code
 was moved from ds3000,c to ts2020.c. Trying to tune to 10818V, tunes to
 11343V instead.

---
 drivers/media/pci/cx23885/cx23885-dvb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 0549205..4be01b3 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -473,6 +473,7 @@ static struct ds3000_config tevii_ds3000_config = {
 static struct ts2020_config tevii_ts2020_config  = {
 	.tuner_address = 0x60,
 	.clk_out_div = 1,
+	.frequency_div = 1146000,
 };
 
 static struct cx24116_config dvbworld_cx24116_config = {
-- 
1.8.5.3


--MP_/RTyNbk=oiW68NPSSGouXgee--
