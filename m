Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:50092 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932127AbcIENCQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Sep 2016 09:02:16 -0400
Subject: Re: [PATCH 2/2] pulse8-cec: store logical address mask
To: Johan Fjeldtvedt <jaffe1@gmail.com>, linux-media@vger.kernel.org
References: <20160830123129.24306-1-jaffe1@gmail.com>
 <20160830123129.24306-2-jaffe1@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f1337508-d648-7cbe-cd0b-b39021913815@xs4all.nl>
Date: Mon, 5 Sep 2016 15:02:10 +0200
MIME-Version: 1.0
In-Reply-To: <20160830123129.24306-2-jaffe1@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2016 02:31 PM, Johan Fjeldtvedt wrote:
> In addition to setting the ACK mask, also set the logical address mask
> setting in the dongle. This is (and not the ACK mask) is persisted for
> use in autonomous mode.
> 
> The logical address mask to use is deduced from the primary device type
> in adap->log_addrs.
> 
> Signed-off-by: Johan Fjeldtvedt <jaffe1@gmail.com>
> ---
>  drivers/staging/media/pulse8-cec/pulse8-cec.c | 34 +++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/drivers/staging/media/pulse8-cec/pulse8-cec.c b/drivers/staging/media/pulse8-cec/pulse8-cec.c
> index 1158ba9..ede285a 100644
> --- a/drivers/staging/media/pulse8-cec/pulse8-cec.c
> +++ b/drivers/staging/media/pulse8-cec/pulse8-cec.c
> @@ -498,6 +498,40 @@ static int pulse8_cec_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
>  	if (err)
>  		goto unlock;
>  
> +	switch (adap->log_addrs.primary_device_type[0]) {
> +	case CEC_OP_PRIM_DEVTYPE_TV:
> +		mask = 0;

Is this right? Shouldn't it be 0x001?

> +		break;
> +	case CEC_OP_PRIM_DEVTYPE_RECORD:
> +		mask = 0x206;

Note that cec.h has CEC_LOG_ADDR_MASK_ defines. It's better to use those.

Regards,

	Hans

> +		break;
> +	case CEC_OP_PRIM_DEVTYPE_TUNER:
> +		mask = 0x4C8;
> +		break;
> +	case CEC_OP_PRIM_DEVTYPE_PLAYBACK:
> +		mask = 0x910;
> +		break;
> +	case CEC_OP_PRIM_DEVTYPE_AUDIOSYSTEM:
> +		mask = 0x20;
> +		break;
> +	case CEC_OP_PRIM_DEVTYPE_SWITCH:
> +		mask = 0x8000;
> +		break;
> +	case CEC_OP_PRIM_DEVTYPE_PROCESSOR:
> +		mask = 0x4000;
> +		break;
> +	default:
> +		mask = 0;
> +		break;
> +	}
> +	cmd[0] = MSGCODE_SET_LOGICAL_ADDRESS_MASK;
> +	cmd[1] = mask >> 8;
> +	cmd[2] = mask & 0xff;
> +	err = pulse8_send_and_wait(pulse8, cmd, 3,
> +				   MSGCODE_COMMAND_ACCEPTED, 0);
> +	if (err)
> +		goto unlock;
> +
>  	cmd[0] = MSGCODE_SET_DEFAULT_LOGICAL_ADDRESS;
>  	cmd[1] = log_addr;
>  	err = pulse8_send_and_wait(pulse8, cmd, 2,
> 
