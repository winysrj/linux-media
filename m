Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:31804 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaKXLJC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 06:09:02 -0500
Message-ID: <5473119D.6080205@cisco.com>
Date: Mon, 24 Nov 2014 12:08:13 +0100
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Valentin Rothberg <valentinrothberg@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] omap24xx/tcm825x: remove pointless Makefile entry
References: <1416826438.10073.11.camel@x220>
In-Reply-To: <1416826438.10073.11.camel@x220>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I found the same thing and it is already part of my pull request
to Mauro.

I'm setting this patch as Obsoleted in patchwork.

It's unclear what happened. My original patch definitely removed both
Makefile lines.

Regards,

	Hans

On 11/24/14 11:53, Paul Bolle wrote:
> The deprecated omap2 camera drivers were recently removed. Both the
> Kconfig symbol VIDEO_TCM825X and the drivers/staging/media/omap24xx
> directory are gone. So the Makefile entry that references both is now
> pointless. Remove it too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Tested by grepping the tree.
> 
> Triggered by commit db85a0403be4 ("[media] omap24xx/tcm825x: remove
> deprecated omap2 camera drivers."), which is included in next-20141124.
> What happened is that it removed only one of the two Makefile entries
> for omap24xx.
> 
>  drivers/staging/media/Makefile | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
> index 97bfef97f838..30fb352fc4a9 100644
> --- a/drivers/staging/media/Makefile
> +++ b/drivers/staging/media/Makefile
> @@ -4,7 +4,6 @@ obj-$(CONFIG_LIRC_STAGING)	+= lirc/
>  obj-$(CONFIG_VIDEO_DT3155)	+= dt3155v4l/
>  obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
>  obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
> -obj-$(CONFIG_VIDEO_TCM825X)     += omap24xx/
>  obj-$(CONFIG_DVB_MN88472)       += mn88472/
>  obj-$(CONFIG_DVB_MN88473)       += mn88473/
>  
> 
