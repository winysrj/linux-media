Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:57077 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab3LGJ4B (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Dec 2013 04:56:01 -0500
Date: Sat, 7 Dec 2013 10:55:59 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Gerhard Sittig <gsi@denx.de>
Cc: linuxppc-dev@lists.ozlabs.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v6 13/17] [media] fsl-viu: adjust for OF based clock
 lookup
Message-ID: <20131207105559.68183008@crub>
In-Reply-To: <1385851897-23475-14-git-send-email-gsi@denx.de>
References: <1385851897-23475-1-git-send-email-gsi@denx.de>
	<1385851897-23475-14-git-send-email-gsi@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 30 Nov 2013 23:51:33 +0100
Gerhard Sittig <gsi@denx.de> wrote:

> after device tree based clock lookup became available, the VIU driver
> need no longer use the previous global "viu_clk" name, but should use
> the "ipg" clock name specific to the OF node
> 
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Gerhard Sittig <gsi@denx.de>
> ---
>  drivers/media/platform/fsl-viu.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

applied to next. Thanks!

Anatolij
