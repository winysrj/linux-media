Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36849 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858AbbKRN66 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2015 08:58:58 -0500
Received: by wmww144 with SMTP id w144so198277542wmw.1
        for <linux-media@vger.kernel.org>; Wed, 18 Nov 2015 05:58:57 -0800 (PST)
Message-ID: <564C841E.1050601@gmail.com>
Date: Wed, 18 Nov 2015 14:58:54 +0100
From: =?windows-1252?Q?Tycho_L=FCrsen?= <tycholursen@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: cx23885: use pci_set_dma_mask insted of pci_dma_supported
References: <20151112175329.6ccc66f3@recife.lan> <20151118092156.762dc600@recife.lan>
In-Reply-To: <20151118092156.762dc600@recife.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Christoph,
I own a couple of DVBSky T982 cards, and with your latest patch I can't 
use them anymore.
When the driver loads, it spits this:

[   16.851869] cx23885 driver version 0.0.4 loaded
[   16.852012] CORE cx23885[0]: subsystem: 4254:0982, board: DVBSky T982 
[card=51,autodetected]
[   17.080771] cx25840 11-0044: cx23885 A/V decoder found @ 0x88 
(cx23885[0])
[   17.713272] cx25840 11-0044: loaded v4l-cx23885-avcore-01.fw firmware 
(16382 bytes)
[   17.728982] cx23885_dvb_register() allocating 1 frontend(s)
[   17.728986] cx23885[0]: cx23885 based dvb card
[   17.730007] i2c i2c-10: Added multiplexed i2c bus 12
[   17.730009] si2168 10-0064: Silicon Labs Si2168 successfully attached
[   17.731970] si2157 12-0060: Silicon Labs Si2147/2148/2157/2158 
successfully attached
[   17.731976] DVB: registering new adapter (cx23885[0])
[   17.731979] cx23885 0000:02:00.0: DVB: registering adapter 1 frontend 
0 (Silicon Labs Si2168)...
[   17.760401] DVBSky T982 port 1 MAC address: 00:17:42:54:09:87
[   17.760404] cx23885_dvb_register() allocating 1 frontend(s)
[   17.760406] cx23885[0]: cx23885 based dvb card
[   17.761028] i2c i2c-9: Added multiplexed i2c bus 13
[   17.761030] si2168 9-0064: Silicon Labs Si2168 successfully attached
[   17.762782] si2157 13-0060: Silicon Labs Si2147/2148/2157/2158 
successfully attached
[   17.762791] DVB: registering new adapter (cx23885[0])
[   17.762794] cx23885 0000:02:00.0: DVB: registering adapter 2 frontend 
0 (Silicon Labs Si2168)...
[   17.791455] DVBSky T982 port 2 MAC address: 00:17:42:54:09:88
[   17.791461] cx23885_dev_checkrevision() Hardware revision = 0xa5
[   17.791465] cx23885[0]/0: found at 0000:02:00.0, rev: 4, irq: 19, 
latency: 0, mmio: 0xf7800000
[   17.791469] cx23885[0]/0: Oops: no 32bit PCI DMA ???
[   17.795970] cx23885: probe of 0000:02:00.0 failed with error -5

I guess your patch is ok, so what could be going on?
Kind regards,
Tycho Lürsen

