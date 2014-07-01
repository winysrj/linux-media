Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34418 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbaGARxL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jul 2014 13:53:11 -0400
Message-ID: <1404237187.19382.78.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v2 06/29] [media] coda: Add encoder/decoder support for
 CODA960
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de
Date: Tue, 01 Jul 2014 19:53:07 +0200
In-Reply-To: <1403626611.10756.11.camel@mpb-nicolas>
References: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
	 <1403621771-11636-7-git-send-email-p.zabel@pengutronix.de>
	 <1403626611.10756.11.camel@mpb-nicolas>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

Am Dienstag, den 24.06.2014, 12:16 -0400 schrieb Nicolas Dufresne:
[...]
> > @@ -2908,6 +3183,7 @@ static void coda_timeout(struct work_struct *work)
> >  static u32 coda_supported_firmwares[] = {
> >  	CODA_FIRMWARE_VERNUM(CODA_DX6, 2, 2, 5),
> >  	CODA_FIRMWARE_VERNUM(CODA_7541, 1, 4, 50),
> > +	CODA_FIRMWARE_VERNUM(CODA_960, 2, 1, 5),
> 
> Where can we find these firmwares ?

The firmware images are distributed with an EULA in Freescale's BSPs
that can be downloaded from their website. The file you are looking for
is vpu_fw_imx6q.bin (for i.MX6Q/D) or vpu_fw_imx6d.bin (for i.MX6DL/S).
This has to be stripped of the 16-byte header and must be reordered to
fit the CODA memory access pattern by reversing the order of each set of
four 16-bit values (imagine little-endian 64-bit values made of four
16-bit wide bytes).

regards
Philipp

