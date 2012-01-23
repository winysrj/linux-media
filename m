Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36403 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066Ab2AWURE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 15:17:04 -0500
Message-ID: <4F1DC03D.4080204@iki.fi>
Date: Mon, 23 Jan 2012 22:17:01 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [git:v4l-dvb/for_v3.4] [media] cxd2820r: fix dvb_frontend_ops
References: <E1RpQFN-0000uK-Bc@www.linuxtv.org>
In-Reply-To: <E1RpQFN-0000uK-Bc@www.linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Are going to push these Kernel 3.4 as topic hints?
These are fixes for 3.3, for example that patch in question...

Antti

On 01/23/2012 10:10 PM, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the
> http://git.linuxtv.org/media_tree.git tree:
>
> Subject: [media] cxd2820r: fix dvb_frontend_ops
> Author:  Antti Palosaari<crope@iki.fi>
> Date:    Wed Jan 18 13:57:33 2012 -0300
>
> Fix bug introduced by multi-frontend to single-frontend change.
>
> * Add missing DVB-C caps
> * Change frontend name as single frontend does all the standards
>
> Signed-off-by: Antti Palosaari<crope@iki.fi>
> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>
>   drivers/media/dvb/frontends/cxd2820r_core.c |    4 +++-
>   1 files changed, 3 insertions(+), 1 deletions(-)
>
> ---
>
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=9bf31efa84c898a0cf294bacdfe8edcac24e6318
>
> diff --git a/drivers/media/dvb/frontends/cxd2820r_core.c b/drivers/media/dvb/frontends/cxd2820r_core.c
> index caae7f7..5fe591d 100644
> --- a/drivers/media/dvb/frontends/cxd2820r_core.c
> +++ b/drivers/media/dvb/frontends/cxd2820r_core.c
> @@ -562,7 +562,7 @@ static const struct dvb_frontend_ops cxd2820r_ops = {
>   	.delsys = { SYS_DVBT, SYS_DVBT2, SYS_DVBC_ANNEX_A },
>   	/* default: DVB-T/T2 */
>   	.info = {
> -		.name = "Sony CXD2820R (DVB-T/T2)",
> +		.name = "Sony CXD2820R",
>
>   		.caps =	FE_CAN_FEC_1_2			|
>   			FE_CAN_FEC_2_3			|
> @@ -572,7 +572,9 @@ static const struct dvb_frontend_ops cxd2820r_ops = {
>   			FE_CAN_FEC_AUTO			|
>   			FE_CAN_QPSK			|
>   			FE_CAN_QAM_16			|
> +			FE_CAN_QAM_32			|
>   			FE_CAN_QAM_64			|
> +			FE_CAN_QAM_128			|
>   			FE_CAN_QAM_256			|
>   			FE_CAN_QAM_AUTO			|
>   			FE_CAN_TRANSMISSION_MODE_AUTO	|


-- 
http://palosaari.fi/
