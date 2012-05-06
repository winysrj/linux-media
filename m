Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54402 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab2EFRkR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 13:40:17 -0400
Received: by bkcji2 with SMTP id ji2so3172142bkc.19
        for <linux-media@vger.kernel.org>; Sun, 06 May 2012 10:40:16 -0700 (PDT)
Message-ID: <4FA6B77D.3080107@googlemail.com>
Date: Sun, 06 May 2012 19:40:13 +0200
From: Thomas Mair <thomas.mair86@googlemail.com>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC] tuner callback name in RTL28xxu driver
References: <CAKZ=SG9U48d=eE3avccR-Auao5UMo0OANw8KKb=MP1XPtkHwmg@mail.gmail.com> <201205061737.18561.hfvogt@gmx.net> <4FA6A67B.5080508@googlemail.com> <201205061929.30682.hfvogt@gmx.net>
In-Reply-To: <201205061929.30682.hfvogt@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06.05.2012 19:29, Hans-Frieder Vogt wrote:
> Thomas,
> 
> in your patch for the RTL28xxu you introduce a tuner callback (see below). You 
> called the command FC0012_FE_CALLBACK_UHF_ENABLE.
> Since the argument is currently defined to be true if the frequency is below 
> 300MHz, i.e. the argument is true if the frequency is a VHF frequency.
> Therefore I would rather recommend to call the command 
> ..._FE_CALLBACK_VHF_ENABLE.
> What do you think?
Yes. I changed that 5 times. That is why it ended up wrong. 
I am currently resolving your issues and will rename it too in other patches.

> I am just about to send out a patch for the fc0013 tuner, and since this tuner 
> has a lot in common with the fc0012, I intend to put the callback definition 
> into a separate fc001x-common.h header. I just like to know if you have any 
> objections me renaming the callback command.
> 
> Cheers,
> Hans-Frieder
> 
>> +
>> +
>> +static int rtl2832u_fc0012_tuner_callback(struct dvb_usb_device *d,
>> +		int cmd, int arg)
>> +{
>> +	int ret;
>> +	u8 val;
>> +
>> +	deb_info("%s cmd=%d arg=%d", __func__, cmd, arg);
>> +	switch (cmd) {
>> +	case FC0012_FE_CALLBACK_UHF_ENABLE:
>> +		/* set output values */
>> +
>> +		ret = rtl28xx_rd_reg(d, SYS_GPIO_DIR, &val);
>> +		if (ret)
>> +			goto err;
>> +
>> +		val &= 0xbf;
>> +
>> +		ret = rtl28xx_wr_reg(d, SYS_GPIO_DIR, val);
>> +		if (ret)
>> +			goto err;
>> +
>> +
>> +		ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_EN, &val);
>> +		if (ret)
>> +			goto err;
>> +
>> +		val |= 0x40;
>> +
>> +		ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_EN, val);
>> +		if (ret)
>> +			goto err;
>> +
>> +
>> +		ret = rtl28xx_rd_reg(d, SYS_GPIO_OUT_VAL, &val);
>> +		if (ret)
>> +			goto err;
>> +
>> +		if (arg)
>> +			val &= 0xbf; /* set GPIO6 low */
>> +		else
>> +			val |= 0x40; /* set GPIO6 high */
>> +
>> +
>> +		ret = rtl28xx_wr_reg(d, SYS_GPIO_OUT_VAL, val);
>> +		if (ret)
>> +			goto err;
>> +		break;
>> +	default:
>> +		ret = -EINVAL;
>> +		goto err;
>> +	}
>> +	return 0;
>> +
>> +err:
>> +	err("%s: failed=%d", __func__, ret);
>> +
>>  	return ret;
>>  }
>>
> 
> Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net

