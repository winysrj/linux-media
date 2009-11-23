Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:52499 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbZKWJBi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 04:01:38 -0500
Date: Mon, 23 Nov 2009 10:01:36 +0100 (CET)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: grafgrimm77@gmx.de
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: dibusb-common.c FE_HAS_LOCK problem
In-Reply-To: <20091121182514.61b39d23@x2.grafnetz>
Message-ID: <alpine.LRH.2.00.0911230947540.14263@pub1.ifh.de>
References: <20091107105614.7a51f2f5@x2.grafnetz> <alpine.LRH.2.00.0911191630250.12734@pub2.ifh.de> <20091121182514.61b39d23@x2.grafnetz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mario,

On Sat, 21 Nov 2009, grafgrimm77@gmx.de wrote:

> Am Thu, 19 Nov 2009 16:37:18 +0100 (CET)
> schrieb Patrick Boettcher <pboettcher@kernellabs.com>:
>
>> On Sat, 7 Nov 2009, Mario Bachmann wrote:
>>
>>> Hi there,
>>>
>>> I tried linux-2.6.31.5 and tuning still does not work:
>>> tuning to 738000000 Hz
>>> video pid 0x0131, audio pid 0x0132
>>> status 00 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff |
>>> status 00 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff |
>>> status 00 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff |
>>> status 04 | signal 0000 | snr 0000 | ber 001fffff | unc 0000ffff |
>>>
>>> With some changes for the following file it works again:
>>> /usr/src/linux/drivers/media/dvb/dvb-usb/dibusb-common.c
>>>
>>> diff -Naur dibusb-common.c-ORIGINAL dibusb-common.c
>>>
>>> --- dibusb-common.c-ORIGINAL	2009-11-07 10:30:43.705344308 +0100
>>> +++ dibusb-common.c	2009-11-07 10:33:49.969345253 +0100
>>> @@ -133,17 +133,14 @@
>>>
>>> 	for (i = 0; i < num; i++) {
>>> 		/* write/read request */
>>> -		if (i+1 < num && (msg[i].flags & I2C_M_RD) == 0
>>> -					  && (msg[i+1].flags & I2C_M_RD)) {
>>> +		if (i+1 < num && (msg[i+1].flags & I2C_M_RD)) {
>>> 			if (dibusb_i2c_msg(d, msg[i].addr, msg[i].buf,msg[i].len,
>>> 						msg[i+1].buf,msg[i+1].len) < 0)
>>> 				break;
>>> 			i++;
>>> -		} else if ((msg[i].flags & I2C_M_RD) == 0) {
>>> +		} else
>>> 			if (dibusb_i2c_msg(d, msg[i].addr, msg[i].buf,msg[i].len,NULL,0) < 0)
>>> 				break;
>>> -		} else
>>> -			break;
>>> 	}
>>
>> Doing it is reverting a fix which avoids that uncontrolled i2c-access from
>> userspace is destroying the USB-eeprom.
>>
>> I understand that this is breaking the tuning for your board. I'm just not
>> understanding why.
>>
>> If you have some time to debug this issue, could you please try the
>> following:
>>
>> One of the devices for your board is trying to do an I2c access which is
>> falling into the last 'else'-branch - can you add a printk to find out
>> which one it is? The access must be wrongly constructed and must be fixed
>> in that driver.
>>
>> thanks,
>>
>> PS: if you don't have time to do it, please tell so.
>>
>> --
>>
>> Patrick
>> http://www.kernellabs.com/
>
> I do not understand exactly. printk what? Could you please give me a
> complete piece of code with the printk command? Would be great!
>
> My printk-tries ends up in an "Oops".

There is a
 	} else
 		break;

sequence in dibusb_i2c_xfer

instead of break, please add something like

printk(KERN_ERR "----- hello stupid I2C access ----\n");

recompile and load the new module, then check whether the line is 
appearing in /var/log/messages or /var/log/syslog when you tune the board.

If this is the case, try to identify which device is issuing the access by 
printing the i2c-address of struct i2c_msg.

HTH,
--

Patrick
http://www.kernellabs.com/
