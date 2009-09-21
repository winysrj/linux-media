Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46739 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785AbZIUJ7B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 05:59:01 -0400
Date: Mon, 21 Sep 2009 06:58:24 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Richard =?ISO-8859-1?B?UvZqZm9ycw==?=
	<richard.rojfors@mocean-labs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	dougsland@redhat.com
Subject: Re: [hg:v4l-dvb] video: initial support for ADV7180
Message-ID: <20090921065824.4e18917a@pedra.chehab.org>
In-Reply-To: <4AB72B33.5070107@mocean-labs.com>
References: <E1MoqBB-0006BF-Qx@mail.linuxtv.org>
	<4AB72B33.5070107@mocean-labs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 21 Sep 2009 09:28:51 +0200
Richard Röjfors  <richard.rojfors@mocean-labs.com> escreveu:

> Patch from Richard Röjfors wrote:
> > The patch number 13019 was added via Douglas Schilling Landgraf <dougsland@redhat.com>
> > to http://linuxtv.org/hg/v4l-dvb master development tree.
> > 
> > Kernel patches in this development tree may be modified to be backward
> > compatible with older kernels. Compatibility modifications will be
> > removed before inclusion into the mainstream Kernel
> > 
> > If anyone has any objections, please let us know by sending a message to:
> > 	Linux Media Mailing List <linux-media@vger.kernel.org>
> > 
> > ------
> 
> Hi,
> 
> There is a newer version of the driver that has support for beeing
> interrupt driver and setting standard, and checking the signal status.
> 
> I would be very happy if that gets committed instead.

Hi Richard,

The previous version were already committed on our trees. So, please send us
diff patches, instead of a completely new version.

As stated on Kernel Documentation/SubmittingPatches:

"If your changes produce a lot of deltas, you may want to look into
splitting them into individual patches which modify things in
logical stages.  This will facilitate easier reviewing by other
kernel developers, very important if you want your patch accepted."

So, if you are adding 3 new functionalities (interrupt, standard setting,
signal status), the better is if you send us 3 patches.

Thanks,
Mauro.

> +static int v4l2_std_to_adv7180(v4l2_std_id std)
> +{
> +	/* pal is a combination of several variants */
> +	if (std & V4L2_STD_PAL)
> +		return ADV7180_INPUT_CONTROL_PAL_BG;
> +	if (std & V4L2_STD_NTSC)
> +		return ADV7180_INPUT_CONTROL_NTSC_M;
> +
> +	switch (std) {
> +	case V4L2_STD_PAL_60:
> +		return ADV7180_INPUT_CONTROL_PAL60;
> +	case V4L2_STD_NTSC_443:
> +		return ADV7180_INPUT_CONTROL_NTSC_443;
> +	case V4L2_STD_PAL_N:
> +		return ADV7180_INPUT_CONTROL_PAL_N;
> +	case V4L2_STD_PAL_M:
> +		return ADV7180_INPUT_CONTROL_PAL_M;
> +	case V4L2_STD_PAL_Nc:
> +		return ADV7180_INPUT_CONTROL_PAL_COMB_N;
> +	case V4L2_STD_SECAM:
> +		return ADV7180_INPUT_CONTROL_PAL_SECAM;
> +	default:
> +		return -EINVAL;
> +	}
> +}

Btw, this code is not right. 

All standards are bit masks. As such, it is valid that an userspace application
to send a request like, for example, V4L2_STD_SECAM_K. This standard
seems to be supported, but your driver will return -EINVAL.

What we generally do is to handle first the special cases where just one standard
that requires especial treatment is defined (like PAL/60, PAL/M, PAL/N, ...) and then
at the bottom, we handle the masks that covers more than one standard, like:

	if (std == V4L_STD_PAL_60)
		return ADV7180_INPUT_CONTROL_PAL60;
	...

	if (std & V4L2_STD_SECAM)
		return ADV7180_INPUT_CONTROL_PAL_SECAM;
	if (std & V4L2_STD_NTSC)
		return ADV7180_INPUT_CONTROL_NTSC_M;
	/* If it is none of the above, it is PAL */
	return ADV7180_INPUT_CONTROL_PAL_BG;



Cheers,
Mauro
