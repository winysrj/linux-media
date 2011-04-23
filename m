Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:39582 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757165Ab1DWQbn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2011 12:31:43 -0400
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] ngene: Fix CI data transfer regression
Date: Sat, 23 Apr 2011 18:31:04 +0200
References: <201103292235.25151@orion.escape-edv.de>
In-Reply-To: <201103292235.25151@orion.escape-edv.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201104231831.06846@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 29 March 2011 22:35:24 Oliver Endriss wrote:
> Fix CI data transfer regression introduced by previous cleanup.
> 
> Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
> ---
>  drivers/media/dvb/ngene/ngene-core.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/dvb/ngene/ngene-core.c b/drivers/media/dvb/ngene/ngene-core.c
> index 175a0f6..9630705 100644
> --- a/drivers/media/dvb/ngene/ngene-core.c
> +++ b/drivers/media/dvb/ngene/ngene-core.c
> @@ -1520,6 +1520,7 @@ static int init_channel(struct ngene_channel *chan)
>  	if (dev->ci.en && (io & NGENE_IO_TSOUT)) {
>  		dvb_ca_en50221_init(adapter, dev->ci.en, 0, 1);
>  		set_transfer(chan, 1);
> +		chan->dev->channel[2].DataFormatFlags = DF_SWAP32;
>  		set_transfer(&chan->dev->channel[2], 1);
>  		dvb_register_device(adapter, &chan->ci_dev,
>  				    &ngene_dvbdev_ci, (void *) chan,
> -- 
> 1.6.5.3
> 

What happened to this patch? I am sure that it was in patchwork, but
patchwork apparently lost all patches between February 26th and
April 16th.

Please note that this patch must go to 2.6.39!

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
