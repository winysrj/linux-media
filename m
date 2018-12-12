Return-Path: <SRS0=2Dg0=OV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E46FC67839
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 10:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0273E2086D
	for <linux-media@archiver.kernel.org>; Wed, 12 Dec 2018 10:13:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="wKI17rQ/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0273E2086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ideasonboard.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbeLLKNw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 12 Dec 2018 05:13:52 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:33300 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726727AbeLLKNw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Dec 2018 05:13:52 -0500
Received: from [192.168.43.26] (unknown [149.254.234.213])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id BBDE055A;
        Wed, 12 Dec 2018 11:13:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1544609629;
        bh=zE/IyzhL5ePCVONwzAXNhebA2JLT6y+lO/L3DOTBaK4=;
        h=Reply-To:Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=wKI17rQ/Hfd4kuEvskncTQrUD5inIoGhrDUjacOPF22HjOw5p3RZxtj1qpHldqe6K
         0/E9LS8ldeVORccAnGe0Y0P8wD4DcBfb/t8ehE4Wj74dp9bDg95xqVx00sFfX789JE
         qLnccE2CMAiOf+SnTwEwFWTGoypdahWyq7XeM9Q8=
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH 1/5] media: adv748x: Rework reset procedure
To:     jacopo mondi <jacopo@jmondi.org>
Cc:     Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <1544541373-30044-1-git-send-email-jacopo+renesas@jmondi.org>
 <1544541373-30044-2-git-send-email-jacopo+renesas@jmondi.org>
 <32aa95b8-1ae8-9f05-6d57-cf370ff58edf@ideasonboard.com>
 <20181212081626.GJ5597@w540>
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
Openpgp: preference=signencrypt
Autocrypt: addr=kieran.bingham@ideasonboard.com; keydata=
 xsFNBFYE/WYBEACs1PwjMD9rgCu1hlIiUA1AXR4rv2v+BCLUq//vrX5S5bjzxKAryRf0uHat
 V/zwz6hiDrZuHUACDB7X8OaQcwhLaVlq6byfoBr25+hbZG7G3+5EUl9cQ7dQEdvNj6V6y/SC
 rRanWfelwQThCHckbobWiQJfK9n7rYNcPMq9B8e9F020LFH7Kj6YmO95ewJGgLm+idg1Kb3C
 potzWkXc1xmPzcQ1fvQMOfMwdS+4SNw4rY9f07Xb2K99rjMwZVDgESKIzhsDB5GY465sCsiQ
 cSAZRxqE49RTBq2+EQsbrQpIc8XiffAB8qexh5/QPzCmR4kJgCGeHIXBtgRj+nIkCJPZvZtf
 Kr2EAbc6tgg6DkAEHJb+1okosV09+0+TXywYvtEop/WUOWQ+zo+Y/OBd+8Ptgt1pDRyOBzL8
 RXa8ZqRf0Mwg75D+dKntZeJHzPRJyrlfQokngAAs4PaFt6UfS+ypMAF37T6CeDArQC41V3ko
 lPn1yMsVD0p+6i3DPvA/GPIksDC4owjnzVX9kM8Zc5Cx+XoAN0w5Eqo4t6qEVbuettxx55gq
 8K8FieAjgjMSxngo/HST8TpFeqI5nVeq0/lqtBRQKumuIqDg+Bkr4L1V/PSB6XgQcOdhtd36
 Oe9X9dXB8YSNt7VjOcO7BTmFn/Z8r92mSAfHXpb07YJWJosQOQARAQABzTBLaWVyYW4gQmlu
 Z2hhbSA8a2llcmFuLmJpbmdoYW1AaWRlYXNvbmJvYXJkLmNvbT7CwYAEEwEKACoCGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4ACGQEFAlnDk/gFCQeA/YsACgkQoR5GchCkYf3X5w/9EaZ7
 cnUcT6dxjxrcmmMnfFPoQA1iQXr/MXQJBjFWfxRUWYzjvUJb2D/FpA8FY7y+vksoJP7pWDL7
 QTbksdwzagUEk7CU45iLWL/CZ/knYhj1I/+5LSLFmvZ/5Gf5xn2ZCsmg7C0MdW/GbJ8IjWA8
 /LKJSEYH8tefoiG6+9xSNp1p0Gesu3vhje/GdGX4wDsfAxx1rIYDYVoX4bDM+uBUQh7sQox/
 R1bS0AaVJzPNcjeC14MS226mQRUaUPc9250aj44WmDfcg44/kMsoLFEmQo2II9aOlxUDJ+x1
 xohGbh9mgBoVawMO3RMBihcEjo/8ytW6v7xSF+xP4Oc+HOn7qebAkxhSWcRxQVaQYw3S9iZz
 2iA09AXAkbvPKuMSXi4uau5daXStfBnmOfalG0j+9Y6hOFjz5j0XzaoF6Pln0jisDtWltYhP
 X9LjFVhhLkTzPZB/xOeWGmsG4gv2V2ExbU3uAmb7t1VSD9+IO3Km4FtnYOKBWlxwEd8qOFpS
 jEqMXURKOiJvnw3OXe9MqG19XdeENA1KyhK5rqjpwdvPGfSn2V+SlsdJA0DFsobUScD9qXQw
 OvhapHe3XboK2+Rd7L+g/9Ud7ZKLQHAsMBXOVJbufA1AT+IaOt0ugMcFkAR5UbBg5+dZUYJj
 1QbPQcGmM3wfvuaWV5+SlJ+WeKIb8tbOwU0EVgT9ZgEQAM4o5G/kmruIQJ3K9SYzmPishRHV
 DcUcvoakyXSX2mIoccmo9BHtD9MxIt+QmxOpYFNFM7YofX4lG0ld8H7FqoNVLd/+a0yru5Cx
 adeZBe3qr1eLns10Q90LuMo7/6zJhCW2w+HE7xgmCHejAwuNe3+7yt4QmwlSGUqdxl8cgtS1
 PlEK93xXDsgsJj/bw1EfSVdAUqhx8UQ3aVFxNug5OpoX9FdWJLKROUrfNeBE16RLrNrq2ROc
 iSFETpVjyC/oZtzRFnwD9Or7EFMi76/xrWzk+/b15RJ9WrpXGMrttHUUcYZEOoiC2lEXMSAF
 SSSj4vHbKDJ0vKQdEFtdgB1roqzxdIOg4rlHz5qwOTynueiBpaZI3PHDudZSMR5Fk6QjFooE
 XTw3sSl/km/lvUFiv9CYyHOLdygWohvDuMkV/Jpdkfq8XwFSjOle+vT/4VqERnYFDIGBxaRx
 koBLfNDiiuR3lD8tnJ4A1F88K6ojOUs+jndKsOaQpDZV6iNFv8IaNIklTPvPkZsmNDhJMRHH
 Iu60S7BpzNeQeT4yyY4dX9lC2JL/LOEpw8DGf5BNOP1KgjCvyp1/KcFxDAo89IeqljaRsCdP
 7WCIECWYem6pLwaw6IAL7oX+tEqIMPph/G/jwZcdS6Hkyt/esHPuHNwX4guqTbVEuRqbDzDI
 2DJO5FbxABEBAAHCwWUEGAEKAA8CGwwFAlnDlGsFCQeA/gIACgkQoR5GchCkYf1yYRAAq+Yo
 nbf9DGdK1kTAm2RTFg+w9oOp2Xjqfhds2PAhFFvrHQg1XfQR/UF/SjeUmaOmLSczM0s6XMeO
 VcE77UFtJ/+hLo4PRFKm5X1Pcar6g5m4xGqa+Xfzi9tRkwC29KMCoQOag1BhHChgqYaUH3yo
 UzaPwT/fY75iVI+yD0ih/e6j8qYvP8pvGwMQfrmN9YB0zB39YzCSdaUaNrWGD3iCBxg6lwSO
 LKeRhxxfiXCIYEf3vwOsP3YMx2JkD5doseXmWBGW1U0T/oJF+DVfKB6mv5UfsTzpVhJRgee7
 4jkjqFq4qsUGxcvF2xtRkfHFpZDbRgRlVmiWkqDkT4qMA+4q1y/dWwshSKi/uwVZNycuLsz+
 +OD8xPNCsMTqeUkAKfbD8xW4LCay3r/dD2ckoxRxtMD9eOAyu5wYzo/ydIPTh1QEj9SYyvp8
 O0g6CpxEwyHUQtF5oh15O018z3ZLztFJKR3RD42VKVsrnNDKnoY0f4U0z7eJv2NeF8xHMuiU
 RCIzqxX1GVYaNkKTnb/Qja8hnYnkUzY1Lc+OtwiGmXTwYsPZjjAaDX35J/RSKAoy5wGo/YFA
 JxB1gWThL4kOTbsqqXj9GLcyOImkW0lJGGR3o/fV91Zh63S5TKnf2YGGGzxki+ADdxVQAm+Q
 sbsRB8KNNvVXBOVNwko86rQqF9drZuw=
Organization: Ideas on Board
Message-ID: <d54c10d8-0096-2846-bc3d-402b1ded973b@ideasonboard.com>
Date:   Wed, 12 Dec 2018 10:13:44 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181212081626.GJ5597@w540>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Heya

On 12/12/2018 08:16, jacopo mondi wrote:
> Hi Kieran,
>    thanks for review
> 
> On Tue, Dec 11, 2018 at 11:52:03PM +0000, Kieran Bingham wrote:
>> Hi Jacopo,
>>
>> On 11/12/2018 15:16, Jacopo Mondi wrote:
>>> Re-work the chip reset procedure to configure the CP (HDMI) and SD (AFE) cores
>>> before resetting the MIPI CSI-2 TXs.
>>>
>>> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
>>> ---
>>>  drivers/media/i2c/adv748x/adv748x-core.c | 24 ++++++++++--------------
>>>  1 file changed, 10 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
>>> index d94c63cb6a2e..5495dc7891e8 100644
>>> --- a/drivers/media/i2c/adv748x/adv748x-core.c
>>> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
>>> @@ -353,9 +353,8 @@ static const struct adv748x_reg_value adv748x_sw_reset[] = {
>>>  	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
>>>  };
>>>
>>> -/* Supported Formats For Script Below */
>>> -/* - 01-29 HDMI to MIPI TxA CSI 4-Lane - RGB888: */
>>
>> Is this information redundant ? (CSI-4Lane, RGB888 configuration?)
>>
> 
> The CSI-2 data lane configuration has been break out from this table
> by Niklas' patches. I've tried also moving the format configuration
> out of this, but I haven't sent that change. The HDMI video direction
> is now handled at link setup time, so I guess the only relevant
> information is about the RGB888 format configured on the CP backend.
> I'll keep that.
> 

Thanks for the clarification.

>>> -static const struct adv748x_reg_value adv748x_init_txa_4lane[] = {
>>> +/* Initialize CP Core. */
>>> +static const struct adv748x_reg_value adv748x_init_hdmi[] = {
>>
>> While we're here - is there much scope - or value in changing these
>> tables to functions with parameters using Niklas' adv748x_write_check() ?
>>
>> The suggestion only has value if there are parameters that we would need
>> to configure. So it might be reasonable to leave these tables.
>>
> 
> Right now I don't see much value in that. I would prefer breaking out
> the format configuration from this static tables, but that's for
> later.

Perfect - I agree - doesn't need to happen in this patch.

If the format configuration can be broken out from the table later then
that's great news.



>> A general Ack on renaming to the function instead of the
>> TX/configuration though - as that makes the purpose clearer.
>>
>>
>>>  	/* Disable chip powerdown & Enable HDMI Rx block */
>>>  	{ADV748X_PAGE_IO, 0x00, 0x40},
>>>
>>> @@ -399,10 +398,8 @@ static const struct adv748x_reg_value adv748x_init_txa_4lane[] = {
>>>  	{ADV748X_PAGE_EOR, 0xff, 0xff}	/* End of register table */
>>>  };
>>>
>>> -/* 02-01 Analog CVBS to MIPI TX-B CSI 1-Lane - */
>>> -/* Autodetect CVBS Single Ended In Ain 1 - MIPI Out */
>>> -static const struct adv748x_reg_value adv748x_init_txb_1lane[] = {
>>> -
>>
>> Same comments as above really :)
>>
> 
> I'll see what I can keep.
> 
> Thanks
>   j
> 
>>> +/* Initialize AFE core. */
>>> +static const struct adv748x_reg_value adv748x_init_afe[] = {
>>>  	{ADV748X_PAGE_IO, 0x00, 0x30},	/* Disable chip powerdown Rx */
>>>  	{ADV748X_PAGE_IO, 0xf2, 0x01},	/* Enable I2C Read Auto-Increment */
>>>
>>> @@ -445,19 +442,18 @@ static int adv748x_reset(struct adv748x_state *state)
>>>  	if (ret < 0)
>>>  		return ret;
>>>
>>> -	/* Init and power down TXA */
>>> -	ret = adv748x_write_regs(state, adv748x_init_txa_4lane);
>>> +	/* Initialize CP and AFE cores. */
>>> +	ret = adv748x_write_regs(state, adv748x_init_hdmi);
>>>  	if (ret)
>>>  		return ret;
>>>
>>> -	adv748x_tx_power(&state->txa, 1);
>>> -	adv748x_tx_power(&state->txa, 0);
>>> -
>>> -	/* Init and power down TXB */
>>> -	ret = adv748x_write_regs(state, adv748x_init_txb_1lane);
>>> +	ret = adv748x_write_regs(state, adv748x_init_afe);
>>>  	if (ret)
>>>  		return ret;
>>>
>>> +	/* Reset TXA and TXB */
>>> +	adv748x_tx_power(&state->txa, 1);
>>> +	adv748x_tx_power(&state->txa, 0);
>>>  	adv748x_tx_power(&state->txb, 1);
>>>  	adv748x_tx_power(&state->txb, 0);
>>>
>>> --
>>> 2.7.4
>>>
>>
>> --
>> Regards
>> --
>> Kieran

-- 
Regards
--
Kieran
