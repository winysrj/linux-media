Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp23.services.sfr.fr ([93.17.128.22]:48437 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756604Ab2LNR2P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Dec 2012 12:28:15 -0500
Message-ID: <50CB61A6.7060308@sfr.fr>
Date: Fri, 14 Dec 2012 18:28:06 +0100
From: Patrice Chotard <patrice.chotard@sfr.fr>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
CC: =?iso-8859-1?b?RnLpZOlyaWM=?= <frederic.mantegazza@gbiloba.org>,
	Patrice Chotard <patrice.chotard@sfr.fr>
Subject: [PATCH] [media] ngene: fix dvb_pll_attach failure
References: <50B51F7E.2030008@sfr.fr>
In-Reply-To: <50B51F7E.2030008@sfr.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Before dvb_pll_attch call, be sure that drxd demodulator was
initialized, otherwise, dvb_pll_attach() will always failed.

In dvb_pll_attach(), first thing done is to enable the I2C gate
control in order to probe the pll by performing a read access.
As demodulator was not initialized, every i2c access failed.

Reported-by: frederic.mantegazza@gbiloba.org
Signed-off-by: Patrice Chotard <patricechotard@free.fr>
---
 drivers/media/pci/ngene/ngene-cards.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/pci/ngene/ngene-cards.c
b/drivers/media/pci/ngene/ngene-cards.c
index 96a13ed..e2192db 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -328,6 +328,8 @@ static int demod_attach_drxd(struct ngene_channel *chan)
 		return -ENODEV;
 	}

+	/* initialized the DRXD demodulator */
+	chan->fe->ops.init(chan->fe);
 	if (!dvb_attach(dvb_pll_attach, chan->fe, feconf->pll_address,
 			&chan->i2c_adapter,
 			feconf->pll_type)) {
-- 
1.7.10.4
