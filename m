Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248Ab2AFTMK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Jan 2012 14:12:10 -0500
Message-ID: <4F07477C.50900@redhat.com>
Date: Fri, 06 Jan 2012 17:11:56 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Oliver Endriss <o.endriss@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] drxk: Fix regression introduced by commit '[media] Remove
 Annex A/C selection via roll-off factor'
References: <201201041945.58852@orion.escape-edv.de>
In-Reply-To: <201201041945.58852@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04-01-2012 16:45, Oliver Endriss wrote:
> Fix regression introduced by commit '[media] Remove Annex A/C selection via roll-off factor'
> As a result of this commit, DVB-T tuning did not work anymore.
> 
> Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
> 
> diff --git a/drivers/media/dvb/frontends/drxk_hard.c b/drivers/media/dvb/frontends/drxk_hard.c
> index 36e1c82..13f22a1 100644
> --- a/drivers/media/dvb/frontends/drxk_hard.c
> +++ b/drivers/media/dvb/frontends/drxk_hard.c
> @@ -6235,6 +6235,8 @@ static int drxk_set_parameters(struct dvb_frontend *fe)
>  	case SYS_DVBC_ANNEX_C:
>  		state->m_itut_annex_c = true;
>  		break;
> +	case SYS_DVBT:
> +		break;
>  	default:
>  		return -EINVAL;
>  	}
> 
Hi Oliver,

Thanks for the patch! 

It become obsoleted by the patch that converted the driver
to create just one frontend:
	http://git.linuxtv.org/media_tree.git/commitdiff/fa4b2a171d42ffc512b3a86922ad68e1355eb17a

While I don't have DVB-T signal here, the logs were showing that the driver is
switching properly between DVB-T and DVB-C.

Yet, I'd appreciate if you could test it with a real signal,
for us to be 100% sure that everything is working as expected.

Thanks!
Mauro
