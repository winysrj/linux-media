Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab2HLPha (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Aug 2012 11:37:30 -0400
Message-ID: <5027CDB0.6000903@redhat.com>
Date: Sun, 12 Aug 2012 12:37:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH RFC 1/3] dvb_frontend: use Kernel dev_* logging
References: <1344551101-16700-1-git-send-email-crope@iki.fi> <1344551101-16700-2-git-send-email-crope@iki.fi>
In-Reply-To: <1344551101-16700-2-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 09-08-2012 19:24, Antti Palosaari escreveu:
> Signed-off-by: Antti Palosaari <crope@iki.fi>

That looks ok for me.

> ---
>  drivers/media/dvb/dvb-core/dvb_frontend.c | 226 +++++++++++++++---------------
>  1 file changed, 116 insertions(+), 110 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index 13cf4d2..4548fc9 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -66,8 +66,6 @@ MODULE_PARM_DESC(dvb_powerdown_on_sleep, "0: do not power down, 1: turn LNB volt
>  module_param(dvb_mfe_wait_time, int, 0644);
>  MODULE_PARM_DESC(dvb_mfe_wait_time, "Wait up to <mfe_wait_time> seconds on open() for multi-frontend to become available (default:5 seconds)");
>  
> -#define dprintk if (dvb_frontend_debug) printk
> -
>  #define FESTATE_IDLE 1
>  #define FESTATE_RETUNE 2
>  #define FESTATE_TUNING_FAST 4
> @@ -207,7 +205,7 @@ static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
>  	struct dvb_frontend_event *e;
>  	int wp;
>  
> -	dprintk ("%s\n", __func__);
> +	dev_dbg(fe->dvb->device, "%s:\n", __func__);

Just one small issue that it might have... some of those core printk facilities
add a \n at the end. Can't remember if dev_*() are the ones that do it. If so,
you'll need to remove the \n from each line.

Regards,
Mauro
