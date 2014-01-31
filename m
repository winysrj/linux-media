Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailsafe.webbplatsen.se ([94.247.172.109]:20725 "EHLO
	mailsafe.webbplatsen.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203AbaAaKPz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 05:15:55 -0500
Date: Fri, 31 Jan 2014 11:15:48 +0100
From: Joakim Hernberg <jbh@alchemy.lu>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH] [media] cx23885: Fix tuning regression for TeVii S471
Message-ID: <20140131111548.4974eb77@tor.valhalla.alchemy.lu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


When tuning to 10818V on Astra 28E2, the system tunes to 11343V
instead. This is a regression in the S471 driver introduced with the
changeset: b43ea8068d2090cb1e44632c8a938ab40d2c7419 [media] cx23885:
Fix TeVii S471 regression since introduction of ts2020.

Signed-off-by: Joakim Hernberg <jhernberg@alchemy.lu>
Suggested-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Tested-by: Mark Clarkstone <hello@markclarkstone.co.uk>

diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c
b/drivers/media/pci/cx23885/cx23885-dvb.c index 0549205..4be01b3 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -473,6 +473,7 @@ static struct ds3000_config tevii_ds3000_config = {
 static struct ts2020_config tevii_ts2020_config  = {
        .tuner_address = 0x60,
        .clk_out_div = 1,
+       .frequency_div = 1146000,
 };
 
 static struct cx24116_config dvbworld_cx24116_config = {


-- 

   Joakim
