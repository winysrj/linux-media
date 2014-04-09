Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933354AbaDIQT1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 12:19:27 -0400
Date: Wed, 9 Apr 2014 09:21:58 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vitaly Osipov <vitaly.osipov@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] staging: media: omap24xx: fix up some checkpatch.pl
 issues
Message-ID: <20140409162158.GA15832@kroah.com>
References: <20140409132511.GA7873@witts-MacBook-Pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409132511.GA7873@witts-MacBook-Pro.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Apr 09, 2014 at 11:25:18PM +1000, Vitaly Osipov wrote:
> Fixes the following issues:
> 
> tcm825x.c:
> 
> ERROR: Macros with complex values should be enclosed in parenthesis
> WARNING: Prefer [subsystem eg: netdev]_info([subsystem]dev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> 
> tcm825x.h:
> 
> ERROR: Macros with complex values should be enclosed in parenthesis


Please only do one type of thing per patch.  So this should be a series
of 2 patches, one for the macro "error", and one for the printk fixes.

Can you please redo these and resend them?

thanks,

greg k-h
