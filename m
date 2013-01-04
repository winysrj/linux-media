Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59281 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230Ab3ADVkL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jan 2013 16:40:11 -0500
Message-ID: <50E74C16.6010503@iki.fi>
Date: Fri, 04 Jan 2013 23:39:34 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Alexander Inyukhin <shurick@sectorb.msk.ru>,
	Renato Gallo <renatogallo@unixproducts.com>
Subject: [GIT PULL] Realtek RTL2832U USB IDs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 8cd7085ff460ead3aba6174052a408f4ad52ac36:

   [media] get_dvb_firmware: Fix the location of firmware for Terratec 
HTC (2013-01-01 11:18:26 -0200)

are available in the git repository at:

   git://linuxtv.org/anttip/media_tree.git rtl28xxu-usb-ids

for you to fetch changes up to fea1d5e4e8cfae6c60c2a97b0db714d8d57d871a:

   rtl28xxu: correct some device names (2013-01-04 23:35:00 +0200)

----------------------------------------------------------------
Alexander Inyukhin (1):
       rtl28xxu: add Gigabyte U7300 DVB-T Dongle

Antti Palosaari (2):
       rtl28xxu: [1b80:d3a8] ASUS My Cinema-U3100Mini Plus V2
       rtl28xxu: correct some device names

  drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 10 +++++++---
  1 file changed, 7 insertions(+), 3 deletions(-)

-- 
http://palosaari.fi/
