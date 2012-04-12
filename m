Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57844 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932362Ab2DLNM3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Apr 2012 09:12:29 -0400
Message-ID: <4F86D4B8.8060005@iki.fi>
Date: Thu, 12 Apr 2012 16:12:24 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Thomas Mair <thomas.mair86@googlemail.com>
CC: Oliver Schinagl <oliver+list@schinagl.nl>,
	linux-media@vger.kernel.org
Subject: Re: RTL28XX driver
References: <CAKZ=SG-pmn2BtqB+ihY9H9bvYCZq-E3uBsSaioPF5SRceq9iDg@mail.gmail.com> <4F804CDC.3030306@gmail.com> <CAKZ=SG_=7U2QShzq+2HE8SVZvyRpG3rNTsDzwUaso=CG8tXOsg@mail.gmail.com> <4F85D787.2050403@iki.fi> <4F85F89A.80107@schinagl.nl> <4F85FE63.1030700@iki.fi> <4F86C66A.4010404@schinagl.nl> <CAKZ=SG8gHbnRGFrajp2=Op7x52UcMT_5CFM5wzgajKCXkggFtA@mail.gmail.com> <4F86CE09.3080601@schinagl.nl> <CAKZ=SG95OA3pOvxM6eypsNaBvzX1wfjPR4tucc8725bnhE3FEg@mail.gmail.com>
In-Reply-To: <CAKZ=SG95OA3pOvxM6eypsNaBvzX1wfjPR4tucc8725bnhE3FEg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12.04.2012 15:54, Thomas Mair wrote:
> It is not my driver ;) And at the beginning it looks quite scary but
> it may help together with the dump. You can find it
> here:https://github.com/tmair/DVB-Realtek-RTL2832U-2.2.2-10tuner-mod_kernel-3.0.0/blob/master/RTL2832-2.2.2_kernel-3.0.0/tuner_fc2580.c
>
> 2012/4/12 Oliver Schinagl<oliver+list@schinagl.nl>:
>> I accept the challenge :p but where is your fc2580 driver? And in that
>> thought, where is antti's stub driver :)
>>
>> That might help me get started :)
>>
>> On 12-04-12 14:18, Thomas Mair wrote:
>>>
>>> Hi Oliver,
>>>
>>> the Realtek driver sources I have also contain a fc2580 driver. Maybe
>>> the source code will help you together with the usb sniff.
>>>
>>> 2012/4/12 Oliver Schinagl<oliver+list@schinagl.nl>:
>>>>
>>>> Would love to,  even tried a bit, but don't really know how to start,
>>>> what
>>>> to use as a template. I think I can extract the i2c messages from the
>>>> dreaded ugly af903 driver however, using src or usbsniff.
>>>>
>>>> On 11-04-12 23:57, Antti Palosaari wrote:
>>>>>
>>>>> On 12.04.2012 00:33, Oliver Schinagl wrote:
>>>>>>
>>>>>> On 04/11/12 21:12, Antti Palosaari wrote:
>>>>>>>
>>>>>>> I have some old stubbed drivers that just works for one frequency
>>>>>>> using
>>>>>>> combination of RTL2832U + FC2580. Also I have rather well commented
>>>>>>> USB
>>>>>>> sniff from that device. I can sent those if you wish.
>>>>>>>
>>>>>> FC2580? Do you have anything for/from that driver? My USB stick as an
>>>>>> AFA9035 based one, using that specific tuner.
>>>>>
>>>>>
>>>>> Nothing but stubbed driver that contains static register values taken
>>>>> from
>>>>> the sniff and it just tunes to one channel (IIRC 634 MHz / 8 MHz BW).
>>>>>
>>>>> Feel free to contribute new tuner driver in order to add support for
>>>>> your
>>>>> AF9035 device.

Here are my sniffs and stubbed driver etc. what I found from the HD. 
Those well commented sniffs, both RTL2831U and RTL2832U, are surely most 
valuable material.

http://palosaari.fi/linux/v4l-dvb/rtl283xu/

FC2580 can be found from both AF9035 and RTL2832U codes.

Generally, as coding new demod driver for example, you want to use that 
kind of stubbed tuner "driver" for example:


	/* FC0011: 634 MHz / BW 8 MHz */
	struct {
		u8 r[8];
		int len;
	} regs[] = {
		{{ 0x07, 0x0f }, 2 },
		{{ 0x08, 0x3e }, 2 },
		{{ 0x0a, 0xb8 }, 2 },
		{{ 0x0b, 0x80 }, 2 },
		{{ 0x0d, 0x04 }, 2 },
		{{ 0x00, 0x00, 0x05, 0x11, 0xf1, 0xc7, 0x0a, 0x30 }, 8 },
		{{ 0x0e, 0x80 }, 2 },
		{{ 0x0e, 0x00 }, 2 },
		{{ 0x0e, 0x00 }, 2 },
		{{ 0x0e }, 1 },
		{{ 0x06, 0x30 }, 2 },
		{{ 0x0d }, 1 },
		{{ 0x0d, 0x14 }, 2 },
		{{ 0x10, 0x0b }, 2 },
	};

	for (i = 0; i < ARRAY_SIZE(regs); i++) {
		pr_debug("%s: i=%d len=%d data=%02x\n", __func__, i, regs[i].len, 
regs[i].r[0]);
		struct i2c_msg msg[1] = {
			{
				.addr = 0x60,
				.flags = 0,
				.len = regs[i].len,
				.buf = regs[i].r,
			}
		};
		ret = i2c_transfer(state->i2c, msg, 1);
		if (ret != 1)
			pr_debug("%s: I2C write failed i=%d len=%d data=%02x\n", __func__, i, 
regs[i].len, regs[i].r[0]);
	}


regards
Antti
-- 
http://palosaari.fi/
