Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp23.services.sfr.fr ([93.17.128.20]:3213 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2LOXL0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 18:11:26 -0500
Message-ID: <50CD038F.2020501@sfr.fr>
Date: Sun, 16 Dec 2012 00:11:11 +0100
From: Patrice Chotard <patrice.chotard@sfr.fr>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Antti Palosaari <crope@iki.fi>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
CC: =?iso-8859-1?b?RnLpZOlyaWM=?= <frederic.mantegazza@gbiloba.org>
Subject: [PATCH 0/2] fix dvb_pll_attach failure for ngene
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Patrice Chotard (2):
  [media] drxd: allow functional gate control after attach
  [media] ngene: separate demodulator and tuner attach

 drivers/media/dvb-frontends/drxd_hard.c |    4 ++++
 drivers/media/pci/ngene/ngene-cards.c   |   10 ++++++++++
 2 files changed, 14 insertions(+)

-- 
1.7.10.4
