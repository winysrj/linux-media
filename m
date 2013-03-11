Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54441 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab3CKWMS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 18:12:18 -0400
Message-ID: <513E569A.4030407@iki.fi>
Date: Tue, 12 Mar 2013 00:11:38 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: Gianluca Gennari <gennarone@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] block i2c tuner reads for Avermedia Twinstar in the af9035
 driver
References: <4261811.IXtDYhFBCx@jar7.dominio> <3480171.KOskcr6aWb@jar7.dominio> <513DD4C1.5070504@iki.fi> <5231183.rT6pVb4eC3@jar7.dominio>
In-Reply-To: <5231183.rT6pVb4eC3@jar7.dominio>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/11/2013 10:02 PM, Jose Alberto Reguero wrote:
> On Lunes, 11 de marzo de 2013 14:57:37 Antti Palosaari escribió:
>> On 03/11/2013 01:51 PM, Jose Alberto Reguero wrote:
>>> On Lunes, 11 de febrero de 2013 14:48:18 Jose Alberto Reguero escribió:
>>>> On Domingo, 10 de febrero de 2013 22:11:53 Antti Palosaari escribió:
>>>>> On 02/10/2013 09:43 PM, Jose Alberto Reguero wrote:
>>>>>> This patch block the i2c tuner reads for Avermedia Twinstar. If it's
>>>>>> needed other pids can be added.
>>>>>>
>>>>>> Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>
>>>>>>
>>>>>> diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.c
>>>>>> linux.new/drivers/media/usb/dvb-usb-v2/af9035.c ---
>>>>>> linux/drivers/media/usb/dvb-usb-v2/af9035.c	2013-01-07
>>>>>> 05:45:57.000000000 +0100 +++
>>>>>> linux.new/drivers/media/usb/dvb-usb-v2/af9035.c	2013-02-08
>>>>>> 22:55:08.304089054 +0100 @@ -232,7 +232,11 @@ static int
>>>>>> af9035_i2c_master_xfer(struct
>>>>>>
>>>>>>     			buf[3] = 0x00; /* reg addr MSB */
>>>>>>     			buf[4] = 0x00; /* reg addr LSB */
>>>>>>     			memcpy(&buf[5], msg[0].buf, msg[0].len);
>>>>>>
>>>>>> -			ret = af9035_ctrl_msg(d, &req);
>>>>>> +			if (state->block_read) {
>>>>>> +				msg[1].buf[0] = 0x3f;
>>>>>> +				ret = 0;
>>>>>> +			} else
>>>>>> +				ret = af9035_ctrl_msg(d, &req);
>>>>>>
>>>>>>     		}
>>>>>>     	
>>>>>>     	} else if (num == 1 && !(msg[0].flags & I2C_M_RD)) {
>>>>>>     	
>>>>>>     		if (msg[0].len > 40) {
>>>>>>
>>>>>> @@ -638,6 +642,17 @@ static int af9035_read_config(struct dvb
>>>>>>
>>>>>>     	for (i = 0; i < ARRAY_SIZE(state->af9033_config); i++)
>>>>>>     	
>>>>>>     		state->af9033_config[i].clock = clock_lut[tmp];
>>>>>>
>>>>>> +	state->block_read = false;
>>>>>> +
>>>>>> +	if (le16_to_cpu(d->udev->descriptor.idVendor) == USB_VID_AVERMEDIA &&
>>>>>> +		le16_to_cpu(d->udev->descriptor.idProduct) ==
>>>>>> +			USB_PID_AVERMEDIA_TWINSTAR) {
>>>>>> +		dev_dbg(&d->udev->dev,
>>>>>> +				"%s: AverMedia Twinstar: block i2c read from tuner\n",
>>>>>> +				__func__);
>>>>>> +		state->block_read = true;
>>>>>> +	}
>>>>>> +
>>>>>>
>>>>>>     	return 0;
>>>>>>
>>>>>>     err:
>>>>>> diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.h
>>>>>> linux.new/drivers/media/usb/dvb-usb-v2/af9035.h ---
>>>>>> linux/drivers/media/usb/dvb-usb-v2/af9035.h	2013-01-07
>>>>>> 05:45:57.000000000 +0100 +++
>>>>>> linux.new/drivers/media/usb/dvb-usb-v2/af9035.h	2013-02-08
>>>>>> 22:52:42.293842710 +0100 @@ -54,6 +54,7 @@ struct usb_req {
>>>>>>
>>>>>>     struct state {
>>>>>>
>>>>>>     	u8 seq; /* packet sequence number */
>>>>>>     	bool dual_mode;
>>>>>>
>>>>>> +	bool block_read;
>>>>>>
>>>>>>     	struct af9033_config af9033_config[2];
>>>>>>
>>>>>>     };
>>>>>
>>>>> Could you test if faking tuner ID during attach() is enough?
>>>>>
>>>>> Also, I would like to know what is returned error code from firmware
>>>>> when it fails. Enable debugs to see it. It should print something like
>>>>> that: af9035_ctrl_msg: command=03 failed fw error=2
>>>>>
>>>>>
>>>>> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c
>>>>> b/drivers/media/usb/dvb-usb-v2/af9035.c
>>>>> index a1e953a..5a4f28d 100644
>>>>> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
>>>>> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
>>>>> @@ -1082,9 +1082,22 @@ static int af9035_tuner_attach(struct
>>>>> dvb_usb_adapter *adap)
>>>>>
>>>>>                            tuner_addr = 0x60 | 0x80; /* I2C bus hack */
>>>>>
>>>>>                    }
>>>>>
>>>>> +               // fake used tuner for demod firmware / i2c adapter
>>>>> +               if (adap->id == 0)
>>>>> +                       ret = af9035_wr_reg(d, 0x00f641,
>>>>> AF9033_TUNER_FC0011);
>>>>> +               else
>>>>> +                       ret = af9035_wr_reg(d, 0x10f641,
>>>>> AF9033_TUNER_FC0011);
>>>>> +
>>>>>
>>>>>                    /* attach tuner */
>>>>>                    fe = dvb_attach(mxl5007t_attach, adap->fe[0],
>>>>>                    &d->i2c_adap,
>>>>>
>>>>>                                    tuner_addr,
>>>>>
>>>>> &af9035_mxl5007t_config[adap->id]);
>>>>> +
>>>>> +               // return correct tuner
>>>>> +               if (adap->id == 0)
>>>>> +                       ret = af9035_wr_reg(d, 0x00f641,
>>>>> AF9033_TUNER_MXL5007T);
>>>>> +               else
>>>>> +                       ret = af9035_wr_reg(d, 0x10f641,
>>>>> AF9033_TUNER_MXL5007T);
>>>>> +
>>>>>
>>>>>                    break;
>>>>>
>>>>>            case AF9033_TUNER_TDA18218:
>>>>>                    /* attach tuner */
>>>>>
>>>>> regards
>>>>> Antti
>>>>
>>>> I will try with fake tuner, but I can't test unil next weekend.
>>>> If I remember, the read operation is performed, and return good value,
>>>> but after that, all the i2c transfers fail. Seee:
>>>>
>>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg56346.html
>>>>
>>>> Jose Alberto
>>>
>>> I tried with fake tuner without success:
>>>
>>> [ 1346.707405] DVB: registering new adapter (AVerMedia Twinstar (A825))
>>> [ 1346.959043] i2c i2c-1: af9033: firmware version: LINK=11.5.9.0
>>> OFDM=5.17.9.1
>>> [ 1346.962920] usb 1-2: DVB: registering adapter 0 frontend 0 (Afatech
>>> AF9033 (DVB-T))...
>>> [ 1347.439354] mxl5007t 1-0060: creating new instance
>>> [ 1347.440644] mxl5007t_get_chip_id: unknown rev (3f)
>>> [ 1347.440652] mxl5007t_get_chip_id: MxL5007T detected @ 1-0060
>>> [ 1347.443023] mxl5007t_write_reg: 472: failed!
>>> [ 1347.443031] mxl5007t_attach: error -121 on line 903
>>> [ 1347.443790] usb 1-2: dvb_usb_v2: 'AVerMedia Twinstar (A825)' error
>>> while
>>> loading driver (-19)
>>> [ 1347.446624] usb 1-2: dvb_usb_v2: 'AVerMedia Twinstar (A825)'
>>> successfully deinitialized and disconnected
>>
>> I don't see how the hell it could even go to the mxl5007t_write_reg()
>> during attach. Any idea?
>>
>
> Now with the patches I sent for mxl5007 in the attach function
> mxl5007t_soft_reset is called, and also  loop_thru_enable is writed. The
> problem is that the read is performed and it return a good value, but the next
> writes fail.
>
>> I have some thoughts that mxl5007t do not use repeated condition. Driver
>> still does that. Could you test to perform register read without a
>> repeated I2C condition?
>>
>
> How I can do that? what it is a repeated i2c condition?

You should take a look for I2C specification.

Please test that:
http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/af9035_i2c_mxl5007t_test

It fixes similar issue of AF9015 driver :)

I am not able to test AF9035 as I have no hw. It is compile tested only. 
Try to do some tweaking for AF9035 implementation if it does not work!

regards
Antti

-- 
http://palosaari.fi/
