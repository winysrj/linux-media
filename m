Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49939 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab2FTVbc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 17:31:32 -0400
Received: by pbbrp8 with SMTP id rp8so1143616pbb.19
        for <linux-media@vger.kernel.org>; Wed, 20 Jun 2012 14:31:32 -0700 (PDT)
Message-ID: <4FE24132.4090705@gmail.com>
Date: Wed, 20 Jun 2012 14:31:30 -0700
From: Mack Stanley <mcs1937@gmail.com>
MIME-Version: 1.0
To: c.pascoe@itee.uq.edu.au
CC: linux-media@vger.kernel.org
Subject: Chipset change for CX88_BOARD_PINNACLE_PCTV_HD_800i
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Mr. Pascoe,

I'm writing to you as the maintainer of the cx88-dvb kernel module.

I recently bought a pci tv card that the kernel identifies as supported:

05:00.0 Multimedia video controller [0400]: Conexant Systems, Inc.
CX23880/1/2/3 PCI Video and Audio Decoder [14f1:8800] (rev 05)
Subsystem: Pinnacle Systems Inc. Device [11bd:0051]

My card appears to be the same card as this Pinnacle card
(http://www.linuxtv.org/wiki/index.php/Pinnacle_PCTV_HD_Card_%28800i%29)
except that it has a Samsung S5H1411 chip in place of the S5H1409 on the
original Pinnacle card identified by the kernel. 

My card is branded "PCTV HD PCI Card 800i"
(http://www.pctvsystems.com/Products/ProductsNorthAmerica/HybridproductsUSA/PCTVHDCard/tabid/171/language/en-US/Default.aspx),
though I bought it as a Hauppauge card
(http://www.newegg.com/Product/Product.aspx?Item=15-116-043&SortField=0&SummaryType=0&Pagesize=10&PurchaseMark=&SelectedRating=-1&VideoOnlyMark=False&VendorMark=&IsFeedbackTab=true&Keywords=linux&Page=1#scrollFullInfo).

Because of the changed chip, "dvb_attach" returns NULL, so the cx88-dvb
module fails to insert, and no /dev/dvb nodes are created. 

I was able to get around this by copying s5h1411_config
dvico_fusionhdtv7_config to a new
"s5h1411_config pinnacle_pctv_hd_800i_config", then replacing
s5h1409_attach with s5h1411_attach in
case CX88_BOARD_PINNACLE_PCTV_HD_800i in the definition of dvb_register.

I built against headers for Fedora 16 kernel 3.3.8-1.fc16.x86_64.  The
result loads normally and creates /dev/dvb/adaper0 containing demux0, 
dvr0,  frontend0,  and net0. 

"w_scan -fa -A2 -c US -x " produces a long list of frequencies, all but
two of which are in us-Cable-IRC-center-frequencies-QAM256. However,
w_scan finds no "services" and I haven't been able to coax either
scandvb or scte65scan into finding any channels. I don't know whether
this is because my shot-in-the-dark modification to cx88-dvb doesn't
work, or because Comcast has some screwy way of sending signals to its
DTA's.

I'm of course more than happy to help in any way.

Thanks for your time,
Mack


