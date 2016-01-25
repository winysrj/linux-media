Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:46281 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253AbcAYRBm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 12:01:42 -0500
Date: Mon, 25 Jan 2016 15:01:36 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-media@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] [media] m88rs6000t: Better exception handling in
 five functions
Message-ID: <20160125150136.449f2593@recife.lan>
In-Reply-To: <5681497E.7030702@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
	<5680FDB3.7060305@users.sourceforge.net>
	<alpine.DEB.2.10.1512281019050.2702@hadrien>
	<56810F56.4080306@users.sourceforge.net>
	<alpine.DEB.2.10.1512281134590.2702@hadrien>
	<568148FD.7080209@users.sourceforge.net>
	<5681497E.7030702@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 28 Dec 2015 15:38:54 +0100
SF Markus Elfring <elfring@users.sourceforge.net> escreveu:

> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Mon, 28 Dec 2015 15:10:30 +0100
> 
> This issue was detected by using the Coccinelle software.
> 
> Move the jump label directly before the desired log statement
> so that the variable "ret" will not be checked once more
> after a function call.
> Use the identifier "report_failure" instead of "err".
> 
> Suggested-by: Julia Lawall <julia.lawall@lip6.fr>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/media/tuners/m88rs6000t.c | 154 +++++++++++++++++++-------------------
>  1 file changed, 78 insertions(+), 76 deletions(-)
> 
> diff --git a/drivers/media/tuners/m88rs6000t.c b/drivers/media/tuners/m88rs6000t.c
> index 504bfbc..7e59a9f 100644
> --- a/drivers/media/tuners/m88rs6000t.c
> +++ b/drivers/media/tuners/m88rs6000t.c
> @@ -44,7 +44,7 @@ static int m88rs6000t_set_demod_mclk(struct dvb_frontend *fe)
>  	/* select demod main mclk */
>  	ret = regmap_read(dev->regmap, 0x15, &utmp);
>  	if (ret)
> -		goto err;
> +		goto report_failure;

Why to be so verbose? Calling it as "err" is enough, and it means less
code to type if we need to add another goto.

Regards,
Mauro
