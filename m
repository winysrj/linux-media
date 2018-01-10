Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.139]:50419 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751888AbeAJBIQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Jan 2018 20:08:16 -0500
Reply-To: zhengsq@rock-chips.com
Subject: Re: [PATCH v4 2/5] media: ov5695: add support for OV5695 sensor
To: Baruch Siach <baruch@tkos.co.il>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        ddl@rock-chips.com, tfiga@chromium.org
References: <1515509304-15941-1-git-send-email-zhengsq@rock-chips.com>
 <1515509304-15941-3-git-send-email-zhengsq@rock-chips.com>
 <20180109165440.droexlfysvtyt6kl@tarshish>
From: Shunqian Zheng <zhengsq@rock-chips.com>
Message-ID: <155c9971-f5a5-b79e-4c32-70d2bfccd098@rock-chips.com>
Date: Wed, 10 Jan 2018 09:08:04 +0800
MIME-Version: 1.0
In-Reply-To: <20180109165440.droexlfysvtyt6kl@tarshish>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Baruch,


On 2018年01月10日 00:54, Baruch Siach wrote:
> Hi Shunqian Zheng,
>
> On Tue, Jan 09, 2018 at 10:48:21PM +0800, Shunqian Zheng wrote:
>> +static int ov5695_write_array(struct i2c_client *client,
>> +			      const struct regval *regs)
>> +{
>> +	u32 i;
>> +	int ret = 0;
>> +
>> +	for (i = 0; ret == 0 && regs[i].addr != REG_NULL; i++)
>> +		ret = ov5695_write_reg(client, regs[i].addr,
>> +				       OV5695_REG_VALUE_08BIT, regs[i].val);
> This loop should stop on first failure, and return the error value. With
> current code a register write failure is masked by following writes.
This loop will stop once ret != 0 as in for loop condition

Thanks,
>
>> +
>> +	return ret;
>> +}
> baruch
>
