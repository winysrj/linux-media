Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:33710 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753670AbeDZHE2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 03:04:28 -0400
Received: by mail-wr0-f169.google.com with SMTP id o4-v6so5297856wrm.0
        for <linux-media@vger.kernel.org>; Thu, 26 Apr 2018 00:04:27 -0700 (PDT)
Subject: Re: [PATCH v4 2/2] media: Add a driver for the ov7251 camera sensor
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: mchehab@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1524673246-14175-1-git-send-email-todor.tomov@linaro.org>
 <1524673246-14175-3-git-send-email-todor.tomov@linaro.org>
 <20180426065010.a67iqsaicpgu7m5b@valkosipuli.retiisi.org.uk>
From: Todor Tomov <todor.tomov@linaro.org>
Message-ID: <c065854a-084d-8bc8-a76e-2988be8c3788@linaro.org>
Date: Thu, 26 Apr 2018 10:04:25 +0300
MIME-Version: 1.0
In-Reply-To: <20180426065010.a67iqsaicpgu7m5b@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 26.04.2018 09:50, Sakari Ailus wrote:
> Hi Todor,
> 
> On Wed, Apr 25, 2018 at 07:20:46PM +0300, Todor Tomov wrote:
> ...
>> +static int ov7251_write_reg(struct ov7251 *ov7251, u16 reg, u8 val)
>> +{
>> +	u8 regbuf[3];
>> +	int ret;
>> +
>> +	regbuf[0] = reg >> 8;
>> +	regbuf[1] = reg & 0xff;
>> +	regbuf[2] = val;
>> +
>> +	ret = i2c_master_send(ov7251->i2c_client, regbuf, 3);
>> +	if (ret < 0) {
>> +		dev_err(ov7251->dev, "%s: write reg error %d: reg=%x, val=%x\n",
>> +			__func__, ret, reg, val);
>> +		return ret;
>> +	}
>> +
>> +	return 0;
> 
> How about:
> 
> 	return ov7251_write_seq_regs(ov7251, reg, &val, 1);
> 
> And put the function below ov2751_write_seq_regs().

I'm not sure... It will calculate message length each time and then check
that it is not greater than 5, which it is. Seems redundant.

> 
>> +}
>> +
>> +static int ov7251_write_seq_regs(struct ov7251 *ov7251, u16 reg, u8 *val,
>> +				 u8 num)
>> +{
>> +	const u8 maxregbuf = 5;
>> +	u8 regbuf[maxregbuf];
>> +	u8 nregbuf = sizeof(reg) + num * sizeof(*val);
>> +	int ret = 0;
>> +
>> +	if (nregbuf > maxregbuf)
>> +		return -EINVAL;
>> +
>> +	regbuf[0] = reg >> 8;
>> +	regbuf[1] = reg & 0xff;
>> +
>> +	memcpy(regbuf + 2, val, num);
>> +
>> +	ret = i2c_master_send(ov7251->i2c_client, regbuf, nregbuf);
>> +	if (ret < 0) {
>> +		dev_err(ov7251->dev, "%s: write seq regs error %d: first reg=%x\n",
> 
> This line is over 80... 

Yes indeed. Somehow checkpatch does not report this line, I don't know why.

> 
> If you're happy with these, I can make the changes, too; they're trivial.

Only the second one? Thanks :)

> 
>> +			__func__, ret, reg);
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
> 

-- 
Best regards,
Todor Tomov
