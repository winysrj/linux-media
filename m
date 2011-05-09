Return-path: <mchehab@gaivota>
Received: from mail.kapsi.fi ([217.30.184.167]:41852 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716Ab1EIVpn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2011 17:45:43 -0400
Message-ID: <4DC86081.80400@iki.fi>
Date: Tue, 10 May 2011 00:45:37 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Steve Kerrison <steve@stevekerrison.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Andreas Oberritter <obi@linuxtv.org>
Subject: Re: [PATCH v2 4/5] cxd2820r: Update frontend capabilities to advertise
 QAM-256
References: <4DC6BF28.8070006@redhat.com> <1304882240-23044-5-git-send-email-steve@stevekerrison.com>
In-Reply-To: <1304882240-23044-5-git-send-email-steve@stevekerrison.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello Steve,
All your DVB-T2 / CXD2820R are fine for me, thanks. I'll ack only this 
one since it is almost only having very small, but direct, effect to 
CXD2820R driver.


On 05/08/2011 10:17 PM, Steve Kerrison wrote:
> This is supported in DVB-T2 mode, so added to the T/T2 frontend.
>
> Signed-off-by: Steve Kerrison<steve@stevekerrison.com>

Acked-by: Antti Palosaari <crope@iki.fi>



> ---
>   drivers/media/dvb/frontends/cxd2820r_core.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/dvb/frontends/cxd2820r_core.c b/drivers/media/dvb/frontends/cxd2820r_core.c
> index e900c4c..0779f69 100644
> --- a/drivers/media/dvb/frontends/cxd2820r_core.c
> +++ b/drivers/media/dvb/frontends/cxd2820r_core.c
> @@ -855,7 +855,8 @@ static struct dvb_frontend_ops cxd2820r_ops[2] = {
>   				FE_CAN_FEC_3_4 | FE_CAN_FEC_5_6 |
>   				FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
>   				FE_CAN_QPSK | FE_CAN_QAM_16 |
> -				FE_CAN_QAM_64 | FE_CAN_QAM_AUTO |
> +				FE_CAN_QAM_64 | FE_CAN_QAM_256 |
> +				FE_CAN_QAM_AUTO |
>   				FE_CAN_TRANSMISSION_MODE_AUTO |
>   				FE_CAN_GUARD_INTERVAL_AUTO |
>   				FE_CAN_HIERARCHY_AUTO |

regards
Antti

-- 
http://palosaari.fi/
