Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51395 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab2KHAXQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Nov 2012 19:23:16 -0500
Message-ID: <509AFB58.2070808@iki.fi>
Date: Thu, 08 Nov 2012 02:22:48 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
CC: Andrew Karpow <andy@mailbox.tu-berlin.de>,
	Hubert Lin <hubertwslin@gmail.com>
Subject: [GIT PULL FOR v3.7] rtl28xxu new USB IDs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro, these are both simple USB ID additions and nothing more. I think 
it is allowed to push this kind of simple ID additions even after merge 
window is closed. So I hope to see these for 3.7.

Antti

The following changes since commit 1fdead8ad31d3aa833bc37739273fcde89ace93c:

   [media] m5mols: Add missing #include <linux/sizes.h> (2012-10-10 
08:17:16 -0300)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git for_v3.7-new-rtl28xxu-usb-ids

for you to fetch changes up to 904b87d6f202b1220585ed85b134510891b9b7e5:

   rtl28xxu: 0ccd:00d7 TerraTec Cinergy T Stick+ (2012-11-08 02:18:12 +0200)

----------------------------------------------------------------
Andrew Karpow (1):
       rtl28xxu: 0ccd:00d7 TerraTec Cinergy T Stick+

Antti Palosaari (1):
       rtl28xxu: 1d19:1102 Dexatek DK mini DVB-T Dongle

  drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 4 ++++
  1 file changed, 4 insertions(+)


-- 
http://palosaari.fi/

