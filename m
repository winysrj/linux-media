Return-path: <linux-media-owner@vger.kernel.org>
Received: from as-10.de ([212.112.241.2]:59128 "EHLO mail.as-10.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbZFQUls (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 16:41:48 -0400
Date: Wed, 17 Jun 2009 22:41:49 +0200
From: Halim Sahin <halim.sahin@t-online.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Trent Piepho <xyzzy@speakeasy.org>, linux-media@vger.kernel.org
Subject: Re: bttv problem loading takes about several minutes
Message-ID: <20090617204149.GA12617@halim.local>
References: <20090617162400.GA11690@halim.local> <Pine.LNX.4.58.0906171001510.32713@shell2.speakeasy.net> <200906172206.27230.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906172206.27230.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
On Mi, Jun 17, 2009 at 10:06:26 +0200, Hans Verkuil wrote:
> The log is from bttv version 0.9.17. The new code is only present in version 
> 0.9.18. So this is definitely not related to any of my changes.
> 

Yes it's from a debian lenny kernel 2.6.26.
But I have tested latest v4l-dvb with the same result
under 2.6.28 (ubuntu 9.04).



> The code in bttv_probe (bttv-driver.c) does this:
> 
>         if (bttv_verbose)
>                 bttv_gpio_tracking(btv,"init");
> 
>         /* needs to be done before i2c is registered */
>         bttv_init_card1(btv);
> 
>         /* register i2c + gpio */
>         init_bttv_i2c(btv);
> 
>         /* some card-specific stuff (needs working i2c) */
>         bttv_init_card2(btv);
> 
> So it looks like it can be either bttv_init_card1 or init_bttv_i2c that is 
> causing the delay.
> 
> Halim, can you try to put some printk() statements in between the calls 
> above to see which call is taking so long? Actually, it would be nice if 
> you are able to 'drill-down' as well in whatever function is causing the 
> delay, since I truly don't see what might be delaying things for you.

Yes I will test  this tomorrow.

Thanks a lot!
Halim

