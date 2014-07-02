Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56683 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaGBNhH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jul 2014 09:37:07 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N83002XC75SZ320@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 02 Jul 2014 14:37:04 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Philipp Zabel' <p.zabel@pengutronix.de>,
	'Nicolas Dufresne' <nicolas.dufresne@collabora.com>
Cc: linux-media@vger.kernel.org,
	'Mauro Carvalho Chehab' <m.chehab@samsung.com>,
	'Fabio Estevam' <fabio.estevam@freescale.com>,
	kernel@pengutronix.de
References: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
 <1403621771-11636-7-git-send-email-p.zabel@pengutronix.de>
 <1403626611.10756.11.camel@mpb-nicolas>
 <1404237187.19382.78.camel@paszta.hi.pengutronix.de>
In-reply-to: <1404237187.19382.78.camel@paszta.hi.pengutronix.de>
Subject: RE: [PATCH v2 06/29] [media] coda: Add encoder/decoder support for
 CODA960
Date: Wed, 02 Jul 2014 15:37:06 +0200
Message-id: <0b3a01cf95fa$b7df2190$279d64b0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Philipp Zabel [mailto:p.zabel@pengutronix.de]
> Sent: Tuesday, July 01, 2014 7:53 PM
> To: Nicolas Dufresne
> Cc: linux-media@vger.kernel.org; Mauro Carvalho Chehab; Kamil Debski;
> Fabio Estevam; kernel@pengutronix.de
> Subject: Re: [PATCH v2 06/29] [media] coda: Add encoder/decoder support
> for CODA960
> 
> Hi Nicolas,
> 
> Am Dienstag, den 24.06.2014, 12:16 -0400 schrieb Nicolas Dufresne:
> [...]
> > > @@ -2908,6 +3183,7 @@ static void coda_timeout(struct work_struct
> > > *work)  static u32 coda_supported_firmwares[] = {
> > >  	CODA_FIRMWARE_VERNUM(CODA_DX6, 2, 2, 5),
> > >  	CODA_FIRMWARE_VERNUM(CODA_7541, 1, 4, 50),
> > > +	CODA_FIRMWARE_VERNUM(CODA_960, 2, 1, 5),
> >
> > Where can we find these firmwares ?
> 
> The firmware images are distributed with an EULA in Freescale's BSPs
> that can be downloaded from their website. The file you are looking for
> is vpu_fw_imx6q.bin (for i.MX6Q/D) or vpu_fw_imx6d.bin (for i.MX6DL/S).
> This has to be stripped of the 16-byte header and must be reordered to
> fit the CODA memory access pattern by reversing the order of each set
> of four 16-bit values (imagine little-endian 64-bit values made of four
> 16-bit wide bytes).

It would be really nice if the firmware was available in the linux-firmware
repository. Do you think this would be possible?
 
Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

