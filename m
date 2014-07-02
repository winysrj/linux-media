Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51073 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbaGBTQs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jul 2014 15:16:48 -0400
Date: Wed, 2 Jul 2014 21:16:42 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: 'Nicolas Dufresne' <nicolas.dufresne@collabora.com>,
	linux-media@vger.kernel.org,
	'Mauro Carvalho Chehab' <m.chehab@samsung.com>,
	'Fabio Estevam' <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Guo Shawn-R65073 <r65073@freescale.com>,
	Estevam Fabio-R49496 <r49496@freescale.com>
Subject: Re: [PATCH v2 06/29] [media] coda: Add encoder/decoder support for
 CODA960
Message-ID: <20140702191642.GM22620@pengutronix.de>
References: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
 <1403621771-11636-7-git-send-email-p.zabel@pengutronix.de>
 <1403626611.10756.11.camel@mpb-nicolas>
 <1404237187.19382.78.camel@paszta.hi.pengutronix.de>
 <0b3a01cf95fa$b7df2190$279d64b0$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b3a01cf95fa$b7df2190$279d64b0$%debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wed, Jul 02, 2014 at 03:37:06PM +0200, Kamil Debski wrote:
> > From: Philipp Zabel [mailto:p.zabel@pengutronix.de]
> > Sent: Tuesday, July 01, 2014 7:53 PM
> > To: Nicolas Dufresne
> > Cc: linux-media@vger.kernel.org; Mauro Carvalho Chehab; Kamil Debski;
> > Fabio Estevam; kernel@pengutronix.de
> > Subject: Re: [PATCH v2 06/29] [media] coda: Add encoder/decoder support
> > for CODA960
> > 
> > Hi Nicolas,
> > 
> > Am Dienstag, den 24.06.2014, 12:16 -0400 schrieb Nicolas Dufresne:
> > [...]
> > > > @@ -2908,6 +3183,7 @@ static void coda_timeout(struct work_struct
> > > > *work)  static u32 coda_supported_firmwares[] = {
> > > >  	CODA_FIRMWARE_VERNUM(CODA_DX6, 2, 2, 5),
> > > >  	CODA_FIRMWARE_VERNUM(CODA_7541, 1, 4, 50),
> > > > +	CODA_FIRMWARE_VERNUM(CODA_960, 2, 1, 5),
> > >
> > > Where can we find these firmwares ?
> > 
> > The firmware images are distributed with an EULA in Freescale's BSPs
> > that can be downloaded from their website. The file you are looking for
> > is vpu_fw_imx6q.bin (for i.MX6Q/D) or vpu_fw_imx6d.bin (for i.MX6DL/S).
> > This has to be stripped of the 16-byte header and must be reordered to
> > fit the CODA memory access pattern by reversing the order of each set
> > of four 16-bit values (imagine little-endian 64-bit values made of four
> > 16-bit wide bytes).
> 
> It would be really nice if the firmware was available in the linux-firmware
> repository. Do you think this would be possible?
>  
> Best wishes,
> -- 
> Kamil Debski
> Samsung R&D Institute Poland

I tried to convince Freescale to put the firmware into linux-firmware
for 15 months now, but recently got no reply any more.

Fabio, Shawn, could you try to discuss this with the responsible folks
inside FSL again? Maybe responsibilities have changed in the meantime
and I might have tried to talk to the wrong people.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
