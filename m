Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:35805 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab2EXJ6n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 05:58:43 -0400
Message-ID: <4FBE0650.20407@adsb.co.uk>
Date: Thu, 24 May 2012 10:58:40 +0100
From: Andrew Benham <adsb@adsb.co.uk>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: hverkuil@xs4all.nl,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] bttv: Use btv->has_radio rather then the card info when
 registering the tuner
References: <1337513292-3321-1-git-send-email-hdegoede@redhat.com> <1337513292-3321-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1337513292-3321-2-git-send-email-hdegoede@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20/05/12 12:28, Hans de Goede wrote:

> After bttv_init_card2(), bttv_init_tuner(), and it should clearly use
> the updated, dynamic has_radio value from btv->has_radio, rather then
> the const value in the tvcards array.
> 
> This fixes the radio not working on my Hauppauge WinTV.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---

Thanks for this.  The radio on my Hauppauge WinTV last worked with the
2.6.38 kernel.
Since April 2012 there's been no analogue TV in the London area, and as
the radio part of the card didn't work I was about to throw it away :-(
But a quick rebuild of the module and I have radio again.  Many thanks.

> diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
> index ff2933a..1c030fe 100644
> --- a/drivers/media/video/bt8xx/bttv-cards.c
> +++ b/drivers/media/video/bt8xx/bttv-cards.c
> @@ -3649,7 +3649,7 @@ void __devinit bttv_init_tuner(struct bttv *btv)
>  		struct tuner_setup tun_setup;
>  
>  		/* Load tuner module before issuing tuner config call! */
> -		if (bttv_tvcards[btv->c.type].has_radio)
> +		if (btv->has_radio)
>  			v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
>  				&btv->c.i2c_adap, "tuner",
>  				0, v4l2_i2c_tuner_addrs(ADDRS_RADIO));
> @@ -3664,7 +3664,7 @@ void __devinit bttv_init_tuner(struct bttv *btv)
>  		tun_setup.type = btv->tuner_type;
>  		tun_setup.addr = addr;
>  
> -		if (bttv_tvcards[btv->c.type].has_radio)
> +		if (btv->has_radio)
>  			tun_setup.mode_mask |= T_RADIO;
>  
>  		bttv_call_all(btv, tuner, s_type_addr, &tun_setup);

-- 
Andrew Benham     Southgate, London N14, United Kingdom

The gates in my computer are AND OR and NOT, not "Bill"
