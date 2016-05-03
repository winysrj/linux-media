Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35712 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756AbcECS1Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2016 14:27:16 -0400
Received: by mail-wm0-f67.google.com with SMTP id e201so5275426wme.2
        for <linux-media@vger.kernel.org>; Tue, 03 May 2016 11:27:15 -0700 (PDT)
Subject: Re: [RFC PATCH 04/24] smiapp-pll: Take existing divisor into account
 in minimum divisor check
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1461532104-24032-5-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160501104524.GD26360@valkosipuli.retiisi.org.uk>
Cc: sre@kernel.org, pali.rohar@gmail.com, pavel@ucw.cz,
	linux-media@vger.kernel.org
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <5728ED34.3060402@gmail.com>
Date: Tue, 3 May 2016 21:25:56 +0300
MIME-Version: 1.0
In-Reply-To: <20160501104524.GD26360@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On  1.05.2016 13:45, Sakari Ailus wrote:
> Hi Ivaylo,
>
> On Mon, Apr 25, 2016 at 12:08:04AM +0300, Ivaylo Dimitrov wrote:
>> From: Sakari Ailus <sakari.ailus@iki.fi>
>>
>> Required added multiplier (and divisor) calculation did not take into
>> account the existing divisor when checking the values against the minimum
>> divisor. Do just that.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
>> ---
>>   drivers/media/i2c/smiapp-pll.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
>> index e3348db..5ad1edb 100644
>> --- a/drivers/media/i2c/smiapp-pll.c
>> +++ b/drivers/media/i2c/smiapp-pll.c
>> @@ -227,7 +227,8 @@ static int __smiapp_pll_calculate(
>>
>>   	more_mul_factor = lcm(div, pll->pre_pll_clk_div) / div;
>>   	dev_dbg(dev, "more_mul_factor: %u\n", more_mul_factor);
>> -	more_mul_factor = lcm(more_mul_factor, op_limits->min_sys_clk_div);
>> +	more_mul_factor = lcm(more_mul_factor,
>> +			      DIV_ROUND_UP(op_limits->min_sys_clk_div, div));
>>   	dev_dbg(dev, "more_mul_factor: min_op_sys_clk_div: %d\n",
>>   		more_mul_factor);
>>   	i = roundup(more_mul_min, more_mul_factor);
>
> I remember writing the patch, but I don't remember what for, or whether it
> was really needed. Does the secondary sensor work without this one?
>

[  107.285919] smiapp 2-0010: lanes 1
[  107.286010] smiapp 2-0010: reset -2, nvm 0, clk 9600000, mode 0
[  107.286041] smiapp 2-0010: freq 0: 60000000
[  107.289306] twl4030reg_is_enabled VAUX4 0
[  107.303680] twl4030reg_enable VAUX4 0
[  107.352233] smiapp 2-0010: module 0x01-0x022b
[  107.352325] smiapp 2-0010: module revision 0x04-0x00 date 00-00-00
[  107.352355] smiapp 2-0010: sensor 0x00-0x0000
[  107.352386] smiapp 2-0010: sensor revision 0x00 firmware version 0x00
[  107.352416] smiapp 2-0010: smia version 10 smiapp version 00
[  107.352447] smiapp 2-0010: the sensor is called vs6555, ident 01022b04

.
.
.

[  107.595672] smiapp 2-0010: unable to compute pre_pll divisor
[  107.611816] smiapp 2-0010: link freq 60000000 Hz, bpp 10 not ok
[  107.611816] smiapp 2-0010: no valid link frequencies for 10 bpp
[  107.618072] smiapp 2-0010: no supported mbus code found

Or, in short, it does not work without this patch.

Thanks,
Ivo
