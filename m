Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34589 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932452AbbBBRvA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2015 12:51:00 -0500
Message-ID: <54CFB901.3080306@iki.fi>
Date: Mon, 02 Feb 2015 19:50:57 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 05/66] rtl2830: convert driver to kernel I2C model
References: <1419367799-14263-1-git-send-email-crope@iki.fi>	<1419367799-14263-5-git-send-email-crope@iki.fi> <20150127111004.795c40ca@recife.lan>
In-Reply-To: <20150127111004.795c40ca@recife.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/27/2015 03:10 PM, Mauro Carvalho Chehab wrote:
> Em Tue, 23 Dec 2014 22:48:58 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> Convert driver to kernel I2C model. Old DVB proprietary model is
>> still left there also.
>>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>

>> +struct rtl2830_platform_data {
>> +	/*
>> +	 * Clock frequency.
>> +	 * Hz
>> +	 * 4000000, 16000000, 25000000, 28800000
>> +	 */
>> +	u32 clk;
>> +
>> +	/*
>> +	 * Spectrum inversion.
>> +	 */
>> +	bool spec_inv;
>> +
>> +	/*
>> +	 */
>> +	u8 vtop;
>> +
>> +	/*
>> +	 */
>> +	u8 krf;
>> +
>> +	/*
>> +	 */
>> +	u8 agc_targ_val;
>> +
>> +	/*
>> +	 */
>> +	struct dvb_frontend* (*get_dvb_frontend)(struct i2c_client *);
>> +	struct i2c_adapter* (*get_i2c_adapter)(struct i2c_client *);
>> +};
>
> Please fix this to follow the Kernel CodingStyle for struct/function/...
> documentation:
> 	Documentation/kernel-doc-nano-HOWTO.txt
>
> Sometimes, I just leave things like that to pass, but the above one is too
> ugly, with empty multiple line comments, uncommented arguments, etc.

I added kernel-doc comments for rtl2830, rtl2832 and rtl2832_sdr driver 
platform data. PULL request is already updated.

And next time please start keep noise earlier - I have written tens of 
these drivers and that was first time you ask kernel-doc format comments 
for driver configurations structures. I see those should be as 
kernel-doc-nano-HOWTO.txt says, but it was first time I hear about that 
rule.

regards
Antti

-- 
http://palosaari.fi/
