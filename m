Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:49631 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbZA2Uqn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 15:46:43 -0500
Message-ID: <498215A8.3020203@free.fr>
Date: Thu, 29 Jan 2009 21:46:32 +0100
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: Patrick Boettcher <patrick.boettcher@desy.de>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Support faulty USB IDs on DIBUSB_MC
References: <484A72D3.7070500@free.fr> <4974E4BE.2060107@free.fr> <20090129074735.76e07d47@caramujo.chehab.org> <alpine.LRH.1.10.0901291117110.15700@pub6.ifh.de> <49820C26.5090309@free.fr>
In-Reply-To: <49820C26.5090309@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

matthieu castet wrote:
> Hi Patrick,
> 
> Patrick Boettcher wrote:
>> Hi,
>>
>> sorry for not answering ealier, recently I became the master of 
>> postponing things. :(
>>
>> On Thu, 29 Jan 2009, Mauro Carvalho Chehab wrote:
>>
>>>> +/* 14 */    { USB_DEVICE(USB_VID_CYPRESS,        
>>>> USB_PID_ULTIMA_TVBOX_USB2_FX_COLD) },
>>>> +#endif
>>>
>>> It doesn't sound a very good approach the need of recompiling the 
>>> driver to
>>> allow it to work with a broken card. The better would be to have some 
>>> modprobe
>>> option to force it to accept a certain USB ID as a valid ID for the 
>>> card.
>>
>> The most correct way would be to reprogram the eeprom, by simply 
>> writing to 0xa0 (0x50 << 1) I2C address... There was a thread on the 
>> linux-dvb some time ago.
>>
BTW dibusb_i2c_xfer seems to do things very dangerous :
it assumes that it get only write/read request or write request.

That means that read can be understood as write. For example a program 
doing
file = open("/dev/i2c-x", O_RDWR);
ioctl(file, I2C_SLAVE, 0x50)
  read(file, data, 10)
will corrupt the eeprom as it will be understood as a write.

Now that I think of that, I run sensors-detect on this machine, may be 
this is what trash the eeprom ?


Matthieu
