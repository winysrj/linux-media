Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:58982 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729447AbeIRVj6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 17:39:58 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH 3/3] i2c: adv748x: fix typo in comment for TXB CSI-2
 transmitter power down
To: jacopo mondi <jacopo@jmondi.org>
Cc: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20180918014509.6394-1-niklas.soderlund+renesas@ragnatech.se>
 <20180918014509.6394-4-niklas.soderlund+renesas@ragnatech.se>
 <cad3ca03-7741-bbc1-b276-115c4b58fe3f@ideasonboard.com>
 <20180918123457.GR16851@w540>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <365aadbb-7090-e60a-25e2-0549baf48215@ideasonboard.com>
Date: Tue, 18 Sep 2018 17:06:40 +0100
MIME-Version: 1.0
In-Reply-To: <20180918123457.GR16851@w540>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On 18/09/18 13:34, jacopo mondi wrote:
> Hi Kieran,
> 
> On Tue, Sep 18, 2018 at 10:54:44AM +0100, Kieran Bingham wrote:
>> Hi Niklas,
>>
>> Thank you for the patch,
>>
>> I don't think this conflicts with Jacopo's series at all does it ?
> 
> It does, and I think this series should have been (re)based, or the
> other way around, but all these changes should probably go together,
> don't they?

I think when I wrote that comment, I actually meant *just this patch* :-)

I think your series is more mature and closer to integration, so it
might be that this series should be on top.


>>
>> Perhaps with the amount of adv748x churn currently I should create an
>> integration/for-next branch :-)
>>
> 
> Also, but we may be able to handle this a single series, once we have
> Ebisu working.
> 
> Thanks
>    j
> 
>> On 18/09/18 02:45, Niklas Söderlund wrote:
>>> Fix copy-and-past error in comment for TXB CSI-2 transmitter power down
>>> sequence.
>>>
>>> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>>
>> This looks good and useful to me.
>>
>> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>>> ---
>>>  drivers/media/i2c/adv748x/adv748x-core.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
>>> index 9a82cdf301bccb41..86cb38f4d7cc11c6 100644
>>> --- a/drivers/media/i2c/adv748x/adv748x-core.c
>>> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
>>> @@ -299,7 +299,7 @@ static const struct adv748x_reg_value adv748x_power_down_txb_1lane[] = {
>>>
>>>  	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
>>>  	{ADV748X_PAGE_TXB, 0x1e, 0x00},	/* ADI Required Write */
>>> -	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 4-lane MIPI */
>>> +	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */
>>>  	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
>>>  	{ADV748X_PAGE_TXB, 0xc1, 0x3b},	/* ADI Required Write */
>>
>>
>>
>> --
>> Regards
>> --
>> Kieran

-- 
Regards
--
Kieran
