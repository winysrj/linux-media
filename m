Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58332 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab3KOG3y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Nov 2013 01:29:54 -0500
Date: Fri, 15 Nov 2013 15:29:39 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: Fw: staging: media: Use dev_err() instead of pr_err()
Message-ID: <20131115062939.GC28137@kroah.com>
References: <20131114110814.6b13f62b@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131114110814.6b13f62b@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 14, 2013 at 11:08:14AM -0200, Mauro Carvalho Chehab wrote:
> Hi,
> 
> I'm not sure how this patch got applied upstream:
> 
> 	commit b6ea5ef80aa7fd6f4b18ff2e4174930e8772e812
> 	Author: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>
> 	Date:   Sun Oct 20 22:58:28 2013 +0530
> 	
> 	    staging:media: Use dev_dbg() instead of pr_debug()
> 	    
> 	    Use dev_dbg() instead of pr_debug() in go7007-usb.c.
>     
> 	    Signed-off-by: Dulshani Gunawardhana <dulshani.gunawardhana89@gmail.com>
> 	    Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 	    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> But, from the custody chain, it seems it was not C/C to linux-media ML,
> doesn't have the driver maintainer's ack[1] and didn't went via my tree.

It came in through my tree as part of the OPW intern application
process.

And yes, sorry, it's broken, I have some follow-on patches to fix this,
but you are right, it should just be reverted for now, very sorry about
that.

Do you want to do that, or should I?

thanks,

greg k-h
