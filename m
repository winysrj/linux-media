Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:33898 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbZCEJn6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 04:43:58 -0500
Date: Thu, 5 Mar 2009 01:43:55 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Jean Delvare <khali@linux-fr.org>
cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] cx88: Prevent general protection fault on rmmod
In-Reply-To: <20090305103824.351d0110@hyperion.delvare>
Message-ID: <Pine.LNX.4.58.0903050141050.24268@shell2.speakeasy.net>
References: <20090305103824.351d0110@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Mar 2009, Jean Delvare wrote:
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
>  	struct work_struct work;
>  	struct timer_list timer;
> +#else
> +	struct delayed_work work;
> +#endif

You don't need this compat stuff.  compat.h will take are of it for you.
Just code it like you would for the latest kernel.  The only thing you need
to worry about is the way the third argument of the work function went
away, but the ifdef that's already there takes care of it.
