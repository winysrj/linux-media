Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:40005 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989Ab3ADFr3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jan 2013 00:47:29 -0500
From: Libin Yang <lbyang@marvell.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Albert Wang <twang13@marvell.com>
CC: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Thu, 3 Jan 2013 21:42:42 -0800
Subject: RE: [PATCH V3 03/15] [media] marvell-ccic: add clock tree support
 for marvell-ccic driver
Message-ID: <A63A0DC671D719488CD1A6CD8BDC16CF230AFE224B@SC-VEXCH4.marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
 <1355565484-15791-4-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1301011633530.31619@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1301011633530.31619@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for your review. Please see my comments below.

>-----Original Message-----
>From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
>Sent: Wednesday, January 02, 2013 12:06 AM
>To: Albert Wang
>Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
>Subject: Re: [PATCH V3 03/15] [media] marvell-ccic: add clock tree support for
>marvell-ccic driver
>
>On Sat, 15 Dec 2012, Albert Wang wrote:
>
>> From: Libin Yang <lbyang@marvell.com>
>>
>> This patch adds the clock tree support for marvell-ccic.
>>
>> Each board may require different clk enabling sequence.
>> Developer need add the clk_name in correct sequence in board driver
>> to use this feature.
>>
>> Signed-off-by: Libin Yang <lbyang@marvell.com>
>> Signed-off-by: Albert Wang <twang13@marvell.com>
>> ---
>>  drivers/media/platform/marvell-ccic/mcam-core.h  |    4 ++
>>  drivers/media/platform/marvell-ccic/mmp-driver.c |   57 +++++++++++++++++++++-
>>  include/media/mmp-camera.h                       |    5 ++
>>  3 files changed, 65 insertions(+), 1 deletion(-)
>>
[snip]

>> diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c
>b/drivers/media/platform/marvell-ccic/mmp-driver.c
>> index 603fa0a..2c4dce3 100755
>> --- a/drivers/media/platform/marvell-ccic/mmp-driver.c
>> +++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
[snip]

>> +
>> +	mcam_clk_set(mcam, 0);
>>  }
>>
>>  /*
>> @@ -202,7 +223,7 @@ void mmpcam_calc_dphy(struct mcam_camera *mcam)
>>  	 * pll1 will never be changed, it is a fixed value
>>  	 */
>>
>> -	if (IS_ERR(mcam->pll1))
>> +	if (IS_ERR_OR_NULL(mcam->pll1))
>
>Why are you changing this? If this really were needed, you should do this
>already in the previous patch, where you add these lines. But I don't
>think this is a good idea, don't think Russell would like this :-) NULL is
>a valid clock. Only a negative error is a failure. In fact, if you like,
>you could initialise .pll1 to ERR_PTR(-EINVAL) in your previous patch in
>mmpcam_probe().

In the below code, we will use platform related clk_get_rate() to get the rate. 
In the function we do not judge the clk is NULL or not. If we do not judge here, 
we need judge for NULL in the later, otherwise, error may happen. Or do you
think it is better that we should judge the pointer in the function clk_get_rate()?

>
>>  		return;
>>
>>  	tx_clk_esc = clk_get_rate(mcam->pll1) / 1000000 / 12;
>> @@ -229,6 +250,35 @@ static irqreturn_t mmpcam_irq(int irq, void *data)
>>  	return IRQ_RETVAL(handled);
>>  }
>>
>> +static void mcam_init_clk(struct mcam_camera *mcam,
>> +			struct mmp_camera_platform_data *pdata, int init)
>
>I don't think this "int init" makes sense. Please, remove the parameter
>and you actually don't need the de-initialisation, no reason to set
>num_clk = 0 before freeing memory.

Yes, the init parameter is not good here, which make confusion.
The driver de-initiatives the clks because
I want to make sure the driver will never enable the clks after de-initialization.
After second consideration based on your suggestion, I will remove
de-initialization, because this scenario will never happen.

>
>> +{
>> +	unsigned int i;
>> +
>> +	if (NR_MCAM_CLK < pdata->clk_num) {
>> +		dev_err(mcam->dev, "Too many mcam clocks defined\n");
>> +		mcam->clk_num = 0;
>> +		return;
>> +	}
>> +
>> +	if (init) {
>> +		for (i = 0; i < pdata->clk_num; i++) {
>> +			if (pdata->clk_name[i] != NULL) {
>> +				mcam->clk[i] = devm_clk_get(mcam->dev,
>> +						pdata->clk_name[i]);
>
>Sorry, no. Passing clock names in platform data doesn't look right to me.
>Clock names are a property of the consumer device, not of clock supplier.
>Also, your platform tells you to get clk_num clocks, you fail to get one
>of them, you don't continue trying the rest and just return with no error.
>This seems strange, usually a failure to get clocks, that the platform
>tells you to get, is fatal.

I agree that after failing to get the clk, we should return error
instead of just returning. 

For the clock names, the clock names are different on different platforms.
So we need platform data passing the clock names. Do you have any suggestions?

>
>> +				if (IS_ERR(mcam->clk[i])) {
>> +					dev_err(mcam->dev,
>> +						"Could not get clk: %s\n",
>> +						pdata->clk_name[i]);
>> +					mcam->clk_num = 0;
>> +					return;
>> +				}
>> +			}
>> +		}
>> +		mcam->clk_num = pdata->clk_num;
>> +	} else
>> +		mcam->clk_num = 0;
>> +}
>>
>>  static int mmpcam_probe(struct platform_device *pdev)
>>  {
>
>Thanks
>Guennadi
>---
>Guennadi Liakhovetski, Ph.D.
>Freelance Open-Source Software Developer
>http://www.open-technology.de/

Regards,
Libin
