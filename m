Return-path: <linux-media-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56833 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754222Ab2KENUj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Nov 2012 08:20:39 -0500
Date: Mon, 5 Nov 2012 14:11:08 +0100
From: Greg Kroah-Hartman <greg@kroah.com>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/media: Use dev_ printks in go7007/s2250-loader.c
Message-ID: <20121105131108.GC27238@kroah.com>
References: <1352115282-8081-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352115282-8081-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 05, 2012 at 08:34:42PM +0900, YAMANE Toshiaki wrote:
> fixed below checkpatch warnings.
> - WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
> - WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...
> 
> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
> ---
>  drivers/staging/media/go7007/s2250-loader.c |   35 ++++++++++++++-------------
>  1 file changed, 18 insertions(+), 17 deletions(-)

Please note that I don't touch the drivers/staging/media/* files, so
copying me on these patches doesn't do anything :)

thanks,

greg k-h
