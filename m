Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 690F4C04EB8
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 14:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F37202086D
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 14:31:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="tYhbOPKD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F37202086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbeLJObT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 10 Dec 2018 09:31:19 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:58360 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726791AbeLJObT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Dec 2018 09:31:19 -0500
Received: from [192.168.0.21] (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 05C48549;
        Mon, 10 Dec 2018 15:31:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544452277;
        bh=ATyJWp0w2G/QLL9GaymDzok2ggRWbbsPn06NeMIYwcI=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=tYhbOPKDfooGYCPisbZaFCvIyUO+aO1N1jST/e2JY05MN4nuYr0uJKc7iFZSm1rzz
         r7I0coJmvZgV7NBxN8c/Uj+nehiMa/TzO9n7bzjh6InBlQW/jWEr5CkpeuL4V+LDzs
         bIpqBh8y3LrEYk2ClyzGH8UlsCZjtXLiS/PUDQNg=
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH v2] media: i2c: adv748x: Fix video standard selection
 register setting
To:     =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
Cc:     Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Jacopo Mondi <jacopo@jmondi.org>,
        Koji Matsuoka <koji.matsuoka.xm@renesas.com>
References: <20181210122901.14600-1-kieran.bingham+renesas@ideasonboard.com>
 <20181210125533.GI17972@bigcity.dyn.berto.se>
From:   Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Organization: Ideas on Board
Message-ID: <262d2daf-eb5b-26ec-aba0-19f5101758a7@ideasonboard.com>
Date:   Mon, 10 Dec 2018 14:31:14 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181210125533.GI17972@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

On 10/12/2018 12:55, Niklas Söderlund wrote:
> Hi Koji-san, Kieran(-san),
> 
> Thanks for your work.
> 
> On 2018-12-10 12:29:01 +0000, Kieran Bingham wrote:
>> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
>>
>> The ADV7481 Register Control Manual states that bit 2 in the Video
>> Standard Selection register is reserved with the value of 1.
>>
>> The bit is otherwise undocumented, and currently cleared by the driver
>> when setting the video standard selection.
>>
>> Define the bit as reserved, and ensure that it is always set when
>> writing to the SDP_VID_SEL register.
>>
>> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
>> [Kieran: Updated commit message, utilised BIT macro]
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>> ---
>>  drivers/media/i2c/adv748x/adv748x-afe.c | 3 ++-
>>  drivers/media/i2c/adv748x/adv748x.h     | 1 +
>>  2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/i2c/adv748x/adv748x-afe.c b/drivers/media/i2c/adv748x/adv748x-afe.c
>> index 71714634efb0..c4d9ffc50702 100644
>> --- a/drivers/media/i2c/adv748x/adv748x-afe.c
>> +++ b/drivers/media/i2c/adv748x/adv748x-afe.c
>> @@ -151,7 +151,8 @@ static void adv748x_afe_set_video_standard(struct adv748x_state *state,
>>  					  int sdpstd)
>>  {
>>  	sdp_clrset(state, ADV748X_SDP_VID_SEL, ADV748X_SDP_VID_SEL_MASK,
>> -		   (sdpstd & 0xf) << ADV748X_SDP_VID_SEL_SHIFT);
>> +		   (sdpstd & 0xf) << ADV748X_SDP_VID_SEL_SHIFT |
>> +		   ADV748X_SDP_VID_RESERVED_BIT);
> 
> Is this really needed? In practice the adv748x driver never touches the 
> reserved bit and this special handling *should* not be needed :-)


Excellent observation. I somehow assumed we were doing a straight write
here.


>   #define sdp_clrset(s, r, m, v) sdp_write(s, r, (sdp_read(s, r) & ~m) | v)
> 
> The full 'user_map_rw_reg_02' register where the upper 4 bits are 
> vid_sel subregister is read and masked. Then the value is updated with 
> the new vid_sel value and written back.
> 
> However if this is needed or fixes a real bug I'm not against this 
> change but in such case I feel the mask should be updated to reflect 
> which bits are touched.

The mask is defined as:

#define ADV748X_SDP_VID_SEL_MASK        0xf0

Which indeed covers only the VID_SEL bits, and ensures that the reserved
bit is left alone.

If the hardware initialises this bit, then it will remain set. If not -
then the bit will remain unset. I think that's perfectly acceptable for
an undocumented bit, so lets drop this patch.

--
Regards

Kieran



> 
>>  }
>>  
>>  static int adv748x_afe_s_input(struct adv748x_afe *afe, unsigned int input)
>> diff --git a/drivers/media/i2c/adv748x/adv748x.h b/drivers/media/i2c/adv748x/adv748x.h
>> index b482c7fe6957..778aa55a741a 100644
>> --- a/drivers/media/i2c/adv748x/adv748x.h
>> +++ b/drivers/media/i2c/adv748x/adv748x.h
>> @@ -265,6 +265,7 @@ struct adv748x_state {
>>  #define ADV748X_SDP_INSEL		0x00	/* user_map_rw_reg_00 */
>>  
>>  #define ADV748X_SDP_VID_SEL		0x02	/* user_map_rw_reg_02 */
>> +#define ADV748X_SDP_VID_RESERVED_BIT	BIT(2)	/* undocumented reserved bit */
>>  #define ADV748X_SDP_VID_SEL_MASK	0xf0
>>  #define ADV748X_SDP_VID_SEL_SHIFT	4
>>  
>> -- 
>> 2.17.1
>>
> 

