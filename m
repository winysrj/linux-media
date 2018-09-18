Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:54484 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbeIRPyZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Sep 2018 11:54:25 -0400
Reply-To: kieran.bingham@ideasonboard.com
Subject: Re: [PATCH 3/3] i2c: adv748x: fix typo in comment for TXB CSI-2
 transmitter power down
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
References: <20180918014509.6394-1-niklas.soderlund+renesas@ragnatech.se>
 <20180918014509.6394-4-niklas.soderlund+renesas@ragnatech.se>
 <cad3ca03-7741-bbc1-b276-115c4b58fe3f@ideasonboard.com>
Message-ID: <853bf2a6-ffe8-83c3-f581-6de8072fbda8@ideasonboard.com>
Date: Tue, 18 Sep 2018 11:22:24 +0100
MIME-Version: 1.0
In-Reply-To: <cad3ca03-7741-bbc1-b276-115c4b58fe3f@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

On 18/09/18 10:54, Kieran Bingham wrote:
> Hi Niklas,
> 
> Thank you for the patch,
> 
> I don't think this conflicts with Jacopo's series at all does it ?
> 
> Perhaps with the amount of adv748x churn currently I should create an
> integration/for-next branch :-)
> 
> On 18/09/18 02:45, Niklas Söderlund wrote:
>> Fix copy-and-past error in comment for TXB CSI-2 transmitter power down
>> sequence.
>>
>> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> 
> This looks good and useful to me.
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
>> ---
>>  drivers/media/i2c/adv748x/adv748x-core.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/i2c/adv748x/adv748x-core.c b/drivers/media/i2c/adv748x/adv748x-core.c
>> index 9a82cdf301bccb41..86cb38f4d7cc11c6 100644
>> --- a/drivers/media/i2c/adv748x/adv748x-core.c
>> +++ b/drivers/media/i2c/adv748x/adv748x-core.c
>> @@ -299,7 +299,7 @@ static const struct adv748x_reg_value adv748x_power_down_txb_1lane[] = {
>>  
>>  	{ADV748X_PAGE_TXB, 0x31, 0x82},	/* ADI Required Write */
>>  	{ADV748X_PAGE_TXB, 0x1e, 0x00},	/* ADI Required Write */
>> -	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 4-lane MIPI */
>> +	{ADV748X_PAGE_TXB, 0x00, 0x81},	/* Enable 1-lane MIPI */

I should just go look at the rest of the code - but it stands out in
this hunk that we are enabling the lane in our power-down sequence?.

Perhaps we power it down further in the table which isn't provided by
the diff.

>>  	{ADV748X_PAGE_TXB, 0xda, 0x01},	/* i2c_mipi_pll_en - 1'b1 */
>>  	{ADV748X_PAGE_TXB, 0xc1, 0x3b},	/* ADI Required Write */
> 
> 
> 

-- 
Regards
--
Kieran
