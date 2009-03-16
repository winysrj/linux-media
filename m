Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:60226 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbZCPSje (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 14:39:34 -0400
Date: Mon, 16 Mar 2009 11:39:32 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: REVIEW: bttv conversion to v4l2_subdev
In-Reply-To: <24193.62.70.2.252.1237205766.squirrel@webmail.xs4all.nl>
Message-ID: <Pine.LNX.4.58.0903161137480.28292@shell2.speakeasy.net>
References: <24193.62.70.2.252.1237205766.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 16 Mar 2009, Hans Verkuil wrote:
> >> +++ b/linux/drivers/media/video/bt8xx/bttvp.h	Sun Mar 15 13:07:15 2009
> >> +0100
> >> @@ -331,6 +331,7 @@ struct bttv {
> >>  	unsigned int tuner_type;  /* tuner chip type */
> >>  	unsigned int tda9887_conf;
> >>  	unsigned int svhs, dig;
> >> +	int has_saa6588;
> >
> > Does it need to be a 32 or 64 bit integer?
>
> I'll replace it with a u8.
>
> >
> >>  	struct bttv_pll_info pll;
> >>  	int triton1;
> >>  	int gpioirq;

Due to field alignment in the structure it won't make any difference.
