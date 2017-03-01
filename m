Return-path: <linux-media-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:49945 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753226AbdCAQ0P (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Mar 2017 11:26:15 -0500
Date: Wed, 1 Mar 2017 18:26:11 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org, Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH] [media] coda: restore original firmware locations
Message-ID: <20170301162611.wkwjrondluidkkui@tarshish>
References: <20170301153625.16249-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170301153625.16249-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Wed, Mar 01, 2017 at 04:36:25PM +0100, Philipp Zabel wrote:
> Recently, an unfinished patch was merged that added a third entry to the
> beginning of the array of firmware locations without changing the code
> to also look at the third element, thus pushing an old firmware location
> off the list.
> 
> Fixes: 8af7779f3cbc ("[media] coda: add Freescale firmware compatibility location")
> Cc: Baruch Siach <baruch@tkos.co.il>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Thanks for cleaning up after me.

Acked-by: Baruch Siach <baruch@tkos.co.il>

[snip]

> -	if (dev->firmware == 1) {
> +	if (dev->firmware > 0) {
>  		/*
>  		 * Since we can't suppress warnings for failed asynchronous
>  		 * firmware requests, report that the fallback firmware was

I still think this is ugly, though.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
