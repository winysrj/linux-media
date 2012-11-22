Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40074 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab2KVXbD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 18:31:03 -0500
Message-ID: <50AEB598.4090506@iki.fi>
Date: Fri, 23 Nov 2012 01:30:32 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR 3.8] rtl28xxu: new device IDs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 304a0807a22852fe3095a62c24b25c4d0e16d003:

   [media] drivers/media/usb/hdpvr/hdpvr-core.c: fix error return code 
(2012-11-22 14:22:31 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git for_v3.8-rtl28xxu

for you to fetch changes up to 37afa053cf6ac2c6dbd2bbe13f473916751c0621:

   rtl28xxu: add NOXON DAB/DAB+ USB dongle rev 2 (2012-11-23 01:24:36 +0200)

----------------------------------------------------------------
Andrew Karpow (1):
       rtl28xxu: 0ccd:00d7 TerraTec Cinergy T Stick+

Antti Palosaari (1):
       rtl28xxu: 1d19:1102 Dexatek DK mini DVB-T Dongle

Juergen Lock (1):
       rtl28xxu: add NOXON DAB/DAB+ USB dongle rev 2

  drivers/media/dvb-core/dvb-usb-ids.h    | 1 +
  drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 6 ++++++
  2 files changed, 7 insertions(+)


-- 
http://palosaari.fi/

