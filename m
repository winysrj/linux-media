Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4339 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758393AbZCWVEA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2009 17:04:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Janne Grunau <j@jannau.net>
Subject: Re: linux-next: Tree for March 23 (media/video/hdpvr)
Date: Mon, 23 Mar 2009 22:04:15 +0100
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org
References: <20090323205454.d0cbf721.sfr@canb.auug.org.au> <49C7D965.5080202@oracle.com> <20090323204940.GA5079@aniel>
In-Reply-To: <20090323204940.GA5079@aniel>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903232204.15457.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 23 March 2009 21:49:40 Janne Grunau wrote:
> Hi,
> 
> On Mon, Mar 23, 2009 at 11:48:05AM -0700, Randy Dunlap wrote:
> > Stephen Rothwell wrote:
> > > 
> > > Changes since 20090320:
> > 
> > > The v4l-dvb tree gained a build failure for which I have reverted 3 commits.
> > 
> > drivers/built-in.o: In function `hdpvr_disconnect':
> > hdpvr-core.c:(.text+0xf3894): undefined reference to `i2c_del_adapter'
> > drivers/built-in.o: In function `hdpvr_register_i2c_adapter':
> > (.text+0xf4145): undefined reference to `i2c_add_adapter'
> > 
> > 
> > CONFIG_I2C is not enabled.
> 
> following patch should fix that.
> 
> Janne
> 
> ps: Mauro, I'll send a pull request shortly
> 


> diff --git a/drivers/media/video/hdpvr/hdpvr-core.c
> b/drivers/media/video/hdpvr/hdpvr-core.c index e7300b5..dadb2e7 100644
> --- a/drivers/media/video/hdpvr/hdpvr-core.c
> +++ b/drivers/media/video/hdpvr/hdpvr-core.c
> @@ -21,6 +21,7 @@
>  #include <linux/usb.h>
>  #include <linux/mutex.h>
>  #include <linux/i2c.h>
> +#include <linux/autoconf.h>
>
>  #include <linux/videodev2.h>
>  #include <media/v4l2-dev.h>

Hi Janne,

Don't include autoconf.h! It's preloaded for you already and shouldn't be
included manually. Esp. since the v4l-dvb tree creates and preloads a custom
version. Loading it manually will overwrite that.

Other than that it's fine.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
