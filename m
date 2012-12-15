Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp23.services.sfr.fr ([93.17.128.20]:4102 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2LOXL4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 18:11:56 -0500
Message-ID: <50CD03AF.3080602@sfr.fr>
Date: Sun, 16 Dec 2012 00:11:43 +0100
From: Patrice Chotard <patrice.chotard@sfr.fr>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
CC: =?iso-8859-1?b?RnLpZOlyaWM=?= <frederic.mantegazza@gbiloba.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH 2/2] [media] ngene: separate demodulator and tuner attach
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Previously, demodulator and tuner attach was done in the
demod_attach callback. Migrate the tuner part in the
tuner_attach callback in ngene_info to do thing in right place.

Signed-off-by: Patrice Chotard <patricechotard@free.fr>
---
 drivers/media/pci/ngene/ngene-cards.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/media/pci/ngene/ngene-cards.c
b/drivers/media/pci/ngene/ngene-cards.c
index 96a13ed..8db3fa1 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -328,6 +328,15 @@ static int demod_attach_drxd(struct ngene_channel
*chan)
 		return -ENODEV;
 	}

+	return 0;
+}
+
+static int tuner_attach_dtt7520x(struct ngene_channel *chan)
+{
+	struct drxd_config *feconf;
+
+	feconf = chan->dev->card_info->fe_config[chan->number];
+
 	if (!dvb_attach(dvb_pll_attach, chan->fe, feconf->pll_address,
 			&chan->i2c_adapter,
 			feconf->pll_type)) {
@@ -722,6 +731,7 @@ static struct ngene_info ngene_info_terratec = {
 	.name           = "Terratec Integra/Cinergy2400i Dual DVB-T",
 	.io_type        = {NGENE_IO_TSIN, NGENE_IO_TSIN},
 	.demod_attach   = {demod_attach_drxd, demod_attach_drxd},
+	.tuner_attach	= {tuner_attach_dtt7520x, tuner_attach_dtt7520x},
 	.fe_config      = {&fe_terratec_dvbt_0, &fe_terratec_dvbt_1},
 	.i2c_access     = 1,
 };
-- 
1.7.10.4
