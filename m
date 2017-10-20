Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:56115 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752096AbdJTHZN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 03:25:13 -0400
Subject: Re: [PATCH 1/3] drm: bridge: synopsys/dw-hdmi: Enable cec clock
To: Pierre-Hugues Husson <phh@phh.me>,
        linux-rockchip@lists.infradead.org
References: <20171013225337.5196-1-phh@phh.me>
 <20171013225337.5196-2-phh@phh.me>
 <35b9fbe3-9859-03e2-173e-8cff5a90efdd@xs4all.nl>
Cc: heiko@sntech.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <01c4773b-ec8b-5bdc-11ea-c4816b9c673a@xs4all.nl>
Date: Fri, 20 Oct 2017 09:25:09 +0200
MIME-Version: 1.0
In-Reply-To: <35b9fbe3-9859-03e2-173e-8cff5a90efdd@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14/10/17 10:16, Hans Verkuil wrote:
> On 10/14/2017 12:53 AM, Pierre-Hugues Husson wrote:
>> The documentation already mentions "cec" optional clock, but
>> currently the driver doesn't enable it.
>>
>> Signed-off-by: Pierre-Hugues Husson <phh@phh.me>
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Tested-by: Hans Verkuil <hans.verkuil@cisco.com>

> 
> Thanks!
> 
> 	Hans
> 
>> ---
>>  drivers/gpu/drm/bridge/synopsys/dw-hdmi.c | 17 +++++++++++++++++
>>  1 file changed, 17 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
>> index bf14214fa464..5007cdf43131 100644
>> --- a/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
>> +++ b/drivers/gpu/drm/bridge/synopsys/dw-hdmi.c
>> @@ -138,6 +138,7 @@ struct dw_hdmi {
>>  	struct device *dev;
>>  	struct clk *isfr_clk;
>>  	struct clk *iahb_clk;
>> +	struct clk *cec_clk;
>>  	struct dw_hdmi_i2c *i2c;
>>  
>>  	struct hdmi_data_info hdmi_data;
>> @@ -2382,6 +2383,18 @@ __dw_hdmi_probe(struct platform_device *pdev,
>>  		goto err_isfr;
>>  	}
>>  
>> +	hdmi->cec_clk = devm_clk_get(hdmi->dev, "cec");
>> +	if (IS_ERR(hdmi->cec_clk)) {
>> +		hdmi->cec_clk = NULL;
>> +	} else {
>> +		ret = clk_prepare_enable(hdmi->cec_clk);
>> +		if (ret) {
>> +			dev_err(hdmi->dev, "Cannot enable HDMI cec clock: %d\n",
>> +					ret);
>> +			goto err_res;
>> +		}
>> +	}
>> +
>>  	/* Product and revision IDs */
>>  	hdmi->version = (hdmi_readb(hdmi, HDMI_DESIGN_ID) << 8)
>>  		      | (hdmi_readb(hdmi, HDMI_REVISION_ID) << 0);
>> @@ -2518,6 +2531,8 @@ __dw_hdmi_probe(struct platform_device *pdev,
>>  		cec_notifier_put(hdmi->cec_notifier);
>>  
>>  	clk_disable_unprepare(hdmi->iahb_clk);
>> +	if (hdmi->cec_clk)
>> +		clk_disable_unprepare(hdmi->cec_clk);
>>  err_isfr:
>>  	clk_disable_unprepare(hdmi->isfr_clk);
>>  err_res:
>> @@ -2541,6 +2556,8 @@ static void __dw_hdmi_remove(struct dw_hdmi *hdmi)
>>  
>>  	clk_disable_unprepare(hdmi->iahb_clk);
>>  	clk_disable_unprepare(hdmi->isfr_clk);
>> +	if (hdmi->cec_clk)
>> +		clk_disable_unprepare(hdmi->cec_clk);
>>  
>>  	if (hdmi->i2c)
>>  		i2c_del_adapter(&hdmi->i2c->adap);
>>
> 
