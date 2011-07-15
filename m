Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:43050 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754094Ab1GOHql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 03:46:41 -0400
Received: from tele (unknown [IPv6:2a01:e35:2f5c:9de0:212:bfff:fe1e:8db5])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 23F909400CB
	for <linux-media@vger.kernel.org>; Fri, 15 Jul 2011 09:46:34 +0200 (CEST)
Date: Fri, 15 Jul 2011 09:48:27 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] Fix wrong register mask in gspca/sonixj.c
Message-ID: <20110715094827.1a2211f5@tele>
In-Reply-To: <1310695719.58713.YahooMailClassic@web121818.mail.ne1.yahoo.com>
References: <1310695719.58713.YahooMailClassic@web121818.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 14 Jul 2011 19:08:39 -0700 (PDT)
Luiz Ramos <luizzramos@yahoo.com.br> wrote:

> Signed-off-by: Luiz Carlos Ramos <lramos.prof <at> yahoo.com.br>
> 
> 
> --- a/drivers/media/video/gspca/sonixj.c        2011-07-14
> 13:14:41.000000000 -0300 +++
> b/drivers/media/video/gspca/sonixj.c        2011-07-14
> 13:22:26.000000000 -0300 @@ -2386,7 +2386,7 @@ static int
> sd_start(struct gspca_dev *gs reg_w1(gspca_dev, 0x01, 0x22);
> msleep(100); reg01 = SCL_SEL_OD | S_PDN_INV;
> -               reg17 &= MCK_SIZE_MASK;
> +               reg17 &= ~MCK_SIZE_MASK; /* that is, reset bits 4..0 */
>  		  reg17 |= 0x04;          /* clock / 4 */
>                 break;
>         }

Acked-by: Jean-François Moine <moinejf@free.fr>

Luiz, may you get and try the last gspca tarball from my web site? (you
will have to redo your patch, because I have not yet uploaded it)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
