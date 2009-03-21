Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:55456 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbZCUF4V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Mar 2009 01:56:21 -0400
Date: Fri, 20 Mar 2009 22:56:18 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [REVIEWv2] bttv v4l2_subdev conversion
In-Reply-To: <200903192124.52524.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.58.0903202236080.28292@shell2.speakeasy.net>
References: <200903192124.52524.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 19 Mar 2009, Hans Verkuil wrote:
> Please note that the somewhat awkward i2c address lists are temporary.

This should be mentioned in the patch description.  No one in the future
wondering why these address lists are here is going to find this email
message.  I know they're supposed to go away.  There's still stuff in the
bttv driver that Gerd declared obsolete and going away a half dozen years
ago.

> Without autoprobing the autoload module option has become obsolete. A warning
> is generated if it is set, but it is otherwise ignored.

It seems like one could still disable loading modules for that bttv might
think it needs.  When you're testing modules that have not been installed,
any calls to request_module() will load the wrong version and cause all
sorts of breakage.  It should still be possible to disable any attempts by
the driver to do that.

> diff -r 7191463177cd -r 68050e782acb linux/drivers/media/video/bt8xx/bttv-cards.c
> --- a/linux/drivers/media/video/bt8xx/bttv-cards.c	Thu Mar 19 20:53:32 2009 +0100
> +++ b/linux/drivers/media/video/bt8xx/bttv-cards.c	Thu Mar 19 21:15:53 2009 +0100
> @@ -97,12 +97,12 @@
>  static unsigned int tuner[BTTV_MAX]  = { [ 0 ... (BTTV_MAX-1) ] = UNSET };
>  static unsigned int svhs[BTTV_MAX]   = { [ 0 ... (BTTV_MAX-1) ] = UNSET };
>  static unsigned int remote[BTTV_MAX] = { [ 0 ... (BTTV_MAX-1) ] = UNSET };
> +static unsigned int msp3400[BTTV_MAX];
> +static unsigned int tda7432[BTTV_MAX];
> +static unsigned int tvaudio[BTTV_MAX];
> +static unsigned int saa6588[BTTV_MAX];

Are any of these audio chips mutually exclusive?  Does the driver even
support having more than one of them for the same card?  It looks like it
doesn't.  In that case you could replace some/all of these options with a
"audio chip type" option where 0 is none, 1 is tvaudio, 2 is msp3400, etc.
I think that's nicer than adding lots of new options and if you can't have
multiple audio chips, why allow one to specify that?

> +			0x22 >> 1,
> +			I2C_CLIENT_END
> +		};
> +
> +		btv->sd_saa6588 = v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap,
> +				"saa6588", "saa6588", addrs);

Why do you save the the subdev returned here?  AFAICS it's not ever used
anywhere.  You said that v4l2 subdevs automatically go away when the device
they are attacked to is removed, right?  So we don't need the pointer to
free it.

> --- a/linux/drivers/media/video/bt8xx/bttv.h	Thu Mar 19 20:53:32 2009 +0100
> +++ b/linux/drivers/media/video/bt8xx/bttv.h	Thu Mar 19 21:15:53 2009 +0100
> @@ -242,6 +242,7 @@
>  	unsigned int msp34xx_alt:1;
>
>  	unsigned int no_video:1; /* video pci function is unused */
> +	unsigned int has_saa6588:1;

How about not adding this?  It's unused and I just removed a bunch of
unused fields from here.  Add it when someone can actually make use of it.

>  	unsigned int tuner_type;  /* tuner chip type */
>  	unsigned int tda9887_conf;
>  	unsigned int svhs, dig;
> +	unsigned int has_saa6588:1;

You're better off not using a bitfield here.  Because of padding, it still
takes 32 bits (or more, depending on the alignment of bttv_pll_info) in the
struct but takes more code to use.
