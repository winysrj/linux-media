Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:18318 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZCENs3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 08:48:29 -0500
Date: Thu, 5 Mar 2009 14:48:14 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] cx88: Prevent general protection fault on rmmod
Message-ID: <20090305144814.6168dcd8@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.58.0903050141050.24268@shell2.speakeasy.net>
References: <20090305103824.351d0110@hyperion.delvare>
	<Pine.LNX.4.58.0903050141050.24268@shell2.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Mar 2009 01:43:55 -0800 (PST), Trent Piepho wrote:
> On Thu, 5 Mar 2009, Jean Delvare wrote:
> > +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
> >  	struct work_struct work;
> >  	struct timer_list timer;
> > +#else
> > +	struct delayed_work work;
> > +#endif
> 
> You don't need this compat stuff.  compat.h will take are of it for you.
> Just code it like you would for the latest kernel.  The only thing you need
> to worry about is the way the third argument of the work function went
> away, but the ifdef that's already there takes care of it.

OK, thanks. I'll resend updated patches soon.

-- 
Jean Delvare
