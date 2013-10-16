Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:39460 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab3JPHVa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Oct 2013 03:21:30 -0400
Received: from localhost (pD9E8127E.dip0.t-ipconnect.de [217.232.18.126])
	by smtp.strato.de (RZmta 32.8 DYNA|AUTH)
	with (TLSv1.2:DHE-RSA-AES128-GCM-SHA256 encrypted) ESMTPSA id z05aecp9G6OHrr
	for <linux-media@vger.kernel.org>;
	Wed, 16 Oct 2013 09:21:28 +0200 (CEST)
Date: Wed, 16 Oct 2013 09:21:28 +0200
From: Johannes Koch <johannes@ortsraum.de>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] cx23885-dvb: fix ds3000 ts2020 split for TEVII S471
Message-ID: <20131016072128.GA13505@Loki.fritz.box>
References: <1376513927-6217-1-git-send-email-cv@cv-sv.de>
 <20130926135157.2a26f245@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130926135157.2a26f245@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi  Mauro,

On Thu, Sep 26, 2013 at 01:51:57PM -0300, Mauro Carvalho Chehab wrote:
> The difference between your patch and the applied one is:
> 
> diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
> index 971e4ff..8ed7b94 100644
> --- a/drivers/media/pci/cx23885/cx23885-dvb.c
> +++ b/drivers/media/pci/cx23885/cx23885-dvb.c
> @@ -1055,7 +1055,6 @@ static int dvb_register(struct cx23885_tsport *port)
>  				&tevii_ts2020_config, &i2c_bus->i2c_adap);
>  			fe0->dvb.frontend->ops.set_voltage = f300_set_voltage;
>  		}
> -
>  		break;
>  	case CX23885_BOARD_DVBWORLD_2005:
>  		i2c_bus = &dev->i2c_bus[1];
> @@ -1285,6 +1284,7 @@ static int dvb_register(struct cx23885_tsport *port)
>  		if (fe0->dvb.frontend != NULL) {
>  			dvb_attach(ts2020_attach, fe0->dvb.frontend,
>  				&tevii_ts2020_config, &i2c_bus->i2c_adap);
> +			fe0->dvb.frontend->ops.set_voltage = f300_set_voltage;
>  		}
>  		break;
>  	case CX23885_BOARD_PROF_8000:
> 
> 
> So, basically, on our patch, you're also filling ops.set_voltage. 
> 
> As I don't know the board details, I can't tell if this is required or
> not.
> 
> Christian/Johannes,
> 
> Could you please double-check it? If this is needed, please send me a new
> patch, rebased on the top of linux-media git tree.

no, setting the voltage via dvb.frontend->ops.set_voltage is not needed for
the TeVii S471. See also the patch that introduced S471 support:
https://linuxtv.org/patch/11189/.

Best regards
 Johannes

