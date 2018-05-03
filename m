Return-path: <linux-media-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:59947 "EHLO
        homiemail-a58.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751268AbeECQYT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 3 May 2018 12:24:19 -0400
Subject: Re: [PATCH 2/9] cx231xx: Use board profile values for addresses
To: Brad Love <brad@nextdimension.cc>,
        Matthias Schwarzott <zzam@gentoo.org>,
        linux-media@vger.kernel.org, mchehab@s-opensource.com
References: <1523983195-28691-1-git-send-email-brad@nextdimension.cc>
 <1523983195-28691-3-git-send-email-brad@nextdimension.cc>
 <00cb50ca-b467-2f0f-fbdc-92b8b9faad3b@gentoo.org>
 <a70a711a-8d9f-ccd9-aadb-fc31dd74bfa4@nextdimension.cc>
From: Brad Love <brad@nextdimension.cc>
Message-ID: <313bb7b0-cf16-20a2-1cc7-7df18860c37c@nextdimension.cc>
Date: Thu, 3 May 2018 11:24:18 -0500
MIME-Version: 1.0
In-Reply-To: <a70a711a-8d9f-ccd9-aadb-fc31dd74bfa4@nextdimension.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matthias,


On 2018-04-23 12:50, Brad Love wrote:
> Hi Matthias,
>
>
>
> On 2018-04-19 12:10, Matthias Schwarzott wrote:
>> Am 17.04.2018 um 18:39 schrieb Brad Love:
>>> Replace all usage of hard coded values with
>>> the proper field from the board profile.
>>>
>> Hi Brad,
>>
>> will there be any interference with the usage to configure the analog
>> tuner via the fields tuner_addr and tuner_type?
>>
>> Regards
>> Matthias
>
> I expanded the patch and reviewed each change.
>
> - CX231XX_BOARD_CNXT_RDE_253S : constant equals tuner_addr
> - CX231XX_BOARD_CNXT_RDU_253S : constant equals tuner_addr
> - CX231XX_BOARD_KWORLD_UB445_USB_HYBRID : constant equals tuner_addr
> - CX231XX_BOARD_HAUPPAUGE_EXETER : constant equals tuner_addr
> - CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx : constant equals tuner_addr
> - CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx : constant equals tuner_addr
> - CX231XX_BOARD_HAUPPAUGE_955Q : constant equals tuner_addr
> - CX231XX_BOARD_PV_PLAYTV_USB_HYBRID : constant equals tuner_addr
> - CX231XX_BOARD_KWORLD_UB430_USB_HYBRID : constant equals tuner_addr
>
>
> In all cases above I believe there should be no change in value used or
> behaviour, since the values are equal.
>
> I have tested the 955Q (no tuner_type analog though) well with this set.
> I will ask if someone in the main office can test one of these two:
> - CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx
> - CX231XX_BOARD_HAUPPAUGE_930C_HD_1114xx
>
> to verify everything is still fine with the analog tuner_type setup on
> them after these changes.
>
> Cheers,
>
> Brad


A CX231XX_BOARD_HAUPPAUGE_930C_HD_1113xx was found and anlaog ch3/4 PAL
was tested. The TDA18271 still worked correctly and had no problem
finding the signal. I think this patch is quite benign and just removes
constants. I'm pushing up a v2 in a bit with this patch left as is, and
the i2c helper set updated.

Cheers,

Brad



>
>
>>> Signed-off-by: Brad Love <brad@nextdimension.cc>
>>> ---
>>>  drivers/media/usb/cx231xx/cx231xx-dvb.c | 19 +++++++++----------
>>>  1 file changed, 9 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
>>> index 67ed667..99f1a77 100644
>>> --- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
>>> +++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
>>> @@ -728,7 +728,7 @@ static int dvb_init(struct cx231xx *dev)
>>>  		dvb->frontend[0]->callback = cx231xx_tuner_callback;
>>>  
>>>  		if (!dvb_attach(tda18271_attach, dev->dvb->frontend[0],
>>> -			       0x60, tuner_i2c,
>>> +			       dev->board.tuner_addr, tuner_i2c,
>>>  			       &cnxt_rde253s_tunerconfig)) {
>>>  			result = -EINVAL;
>>>  			goto out_free;
>>> @@ -752,7 +752,7 @@ static int dvb_init(struct cx231xx *dev)
>>>  		dvb->frontend[0]->callback = cx231xx_tuner_callback;
>>>  
>>>  		if (!dvb_attach(tda18271_attach, dev->dvb->frontend[0],
>>> -			       0x60, tuner_i2c,
>>> +			       dev->board.tuner_addr, tuner_i2c,
>>>  			       &cnxt_rde253s_tunerconfig)) {
>>>  			result = -EINVAL;
>>>  			goto out_free;
>>> @@ -779,7 +779,7 @@ static int dvb_init(struct cx231xx *dev)
>>>  		dvb->frontend[0]->callback = cx231xx_tuner_callback;
>>>  
>>>  		dvb_attach(tda18271_attach, dev->dvb->frontend[0],
>>> -			   0x60, tuner_i2c,
>>> +			   dev->board.tuner_addr, tuner_i2c,
>>>  			   &hcw_tda18271_config);
>>>  		break;
>>>  
>>> @@ -797,7 +797,7 @@ static int dvb_init(struct cx231xx *dev)
>>>  
>>>  		memset(&info, 0, sizeof(struct i2c_board_info));
>>>  		strlcpy(info.type, "si2165", I2C_NAME_SIZE);
>>> -		info.addr = 0x64;
>>> +		info.addr = dev->board.demod_addr;
>>>  		info.platform_data = &si2165_pdata;
>>>  		request_module(info.type);
>>>  		client = i2c_new_device(demod_i2c, &info);
>>> @@ -822,8 +822,7 @@ static int dvb_init(struct cx231xx *dev)
>>>  		dvb->frontend[0]->callback = cx231xx_tuner_callback;
>>>  
>>>  		dvb_attach(tda18271_attach, dev->dvb->frontend[0],
>>> -			0x60,
>>> -			tuner_i2c,
>>> +			dev->board.tuner_addr, tuner_i2c,
>>>  			&hcw_tda18271_config);
>>>  
>>>  		dev->cx231xx_reset_analog_tuner = NULL;
>>> @@ -844,7 +843,7 @@ static int dvb_init(struct cx231xx *dev)
>>>  
>>>  		memset(&info, 0, sizeof(struct i2c_board_info));
>>>  		strlcpy(info.type, "si2165", I2C_NAME_SIZE);
>>> -		info.addr = 0x64;
>>> +		info.addr = dev->board.demod_addr;
>>>  		info.platform_data = &si2165_pdata;
>>>  		request_module(info.type);
>>>  		client = i2c_new_device(demod_i2c, &info);
>>> @@ -879,7 +878,7 @@ static int dvb_init(struct cx231xx *dev)
>>>  		si2157_config.if_port = 1;
>>>  		si2157_config.inversion = true;
>>>  		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
>>> -		info.addr = 0x60;
>>> +		info.addr = dev->board.tuner_addr;
>>>  		info.platform_data = &si2157_config;
>>>  		request_module("si2157");
>>>  
>>> @@ -938,7 +937,7 @@ static int dvb_init(struct cx231xx *dev)
>>>  		si2157_config.if_port = 1;
>>>  		si2157_config.inversion = true;
>>>  		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
>>> -		info.addr = 0x60;
>>> +		info.addr = dev->board.tuner_addr;
>>>  		info.platform_data = &si2157_config;
>>>  		request_module("si2157");
>>>  
>>> @@ -985,7 +984,7 @@ static int dvb_init(struct cx231xx *dev)
>>>  		dvb->frontend[0]->callback = cx231xx_tuner_callback;
>>>  
>>>  		dvb_attach(tda18271_attach, dev->dvb->frontend[0],
>>> -			   0x60, tuner_i2c,
>>> +			   dev->board.tuner_addr, tuner_i2c,
>>>  			   &pv_tda18271_config);
>>>  		break;
>>>  
>>>
>
