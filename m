Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.200.34]:54997 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751606AbdIUOw6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 10:52:58 -0400
Reply-To: shuah@kernel.org
Subject: Re: [PATCH 18/25] media: dvb_frontend: get rid of
 dtv_get_property_dump()
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Satendra Singh Thakur <satendra.t@samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Shuah Khan <shuah@kernel.org>
References: <cover.1505933919.git.mchehab@s-opensource.com>
 <770f2fb8fba1930ca728ae6e713de86e2c6b95c8.1505933919.git.mchehab@s-opensource.com>
From: Shuah Khan <shuah@kernel.org>
Message-ID: <56186eeb-252d-ce8d-5a82-6fbc30981a3d@kernel.org>
Date: Thu, 21 Sep 2017 08:52:45 -0600
MIME-Version: 1.0
In-Reply-To: <770f2fb8fba1930ca728ae6e713de86e2c6b95c8.1505933919.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/20/2017 01:11 PM, Mauro Carvalho Chehab wrote:
> Simplify the get property handling and move it to the existing
> code at dtv_property_process_get() directly.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/dvb-core/dvb_frontend.c | 43 ++++++++++-------------------------
>  1 file changed, 12 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index b7094c7a405f..607eaf3db052 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -1107,36 +1107,6 @@ static struct dtv_cmds_h dtv_cmds[DTV_MAX_COMMAND + 1] = {
>  	_DTV_CMD(DTV_STAT_TOTAL_BLOCK_COUNT, 0, 0),
>  };
>  
> -static void dtv_get_property_dump(struct dvb_frontend *fe,
> -			      struct dtv_property *tvp)
> -{
> -	int i;
> -
> -	if (tvp->cmd <= 0 || tvp->cmd > DTV_MAX_COMMAND) {
> -		dev_warn(fe->dvb->device, "%s: GET tvp.cmd = 0x%08x undefined\n"
> -				, __func__,
> -				tvp->cmd);
> -		return;
> -	}
> -
> -	dev_dbg(fe->dvb->device, "%s: GET tvp.cmd    = 0x%08x (%s)\n", __func__,
> -		tvp->cmd,
> -		dtv_cmds[tvp->cmd].name);
> -
> -	if (dtv_cmds[tvp->cmd].buffer) {
> -		dev_dbg(fe->dvb->device, "%s: tvp.u.buffer.len = 0x%02x\n",
> -			__func__, tvp->u.buffer.len);
> -
> -		for(i = 0; i < tvp->u.buffer.len; i++)
> -			dev_dbg(fe->dvb->device,
> -					"%s: tvp.u.buffer.data[0x%02x] = 0x%02x\n",
> -					__func__, i, tvp->u.buffer.data[i]);
> -	} else {
> -		dev_dbg(fe->dvb->device, "%s: tvp.u.data = 0x%08x\n", __func__,
> -				tvp->u.data);
> -	}
> -}
> -
>  /* Synchronise the legacy tuning parameters into the cache, so that demodulator
>   * drivers can use a single set_frontend tuning function, regardless of whether
>   * it's being used for the legacy or new API, reducing code and complexity.
> @@ -1529,7 +1499,18 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
>  		return -EINVAL;
>  	}
>  
> -	dtv_get_property_dump(fe, tvp);
> +	if (!dtv_cmds[tvp->cmd].buffer)
> +		dev_dbg(fe->dvb->device,
> +			"%s: GET cmd 0x%08x (%s) = 0x%08x\n",
> +			__func__, tvp->cmd, dtv_cmds[tvp->cmd].name,
> +			tvp->u.data);
> +	else
> +		dev_dbg(fe->dvb->device,
> +			"%s: GET cmd 0x%08x (%s) len %d: %*ph\n",
> +			__func__,
> +			tvp->cmd, dtv_cmds[tvp->cmd].name,
> +			tvp->u.buffer.len,
> +			tvp->u.buffer.len, tvp->u.buffer.data);
>  
>  	return 0;
>  }
> 

Why not keep common dtv_property_dum(0 and make these enhancements to add
more information to the dump in a common routine so both get and set are
covered.

I think this change coupled with the change in 17/25 is moving away from
common simpler code to embedded debug code. I am not clear on the value
it adds.

thanks,
-- Shuah 
