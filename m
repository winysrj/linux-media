Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:51973 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304Ab2IQN03 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 09:26:29 -0400
Message-ID: <505724F0.20502@schinagl.nl>
Date: Mon, 17 Sep 2012 15:26:08 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Support for Asus MyCinema U3100Mini Plus
References: <1347223647-645-1-git-send-email-oliver+list@schinagl.nl> <504D00BC.4040109@schinagl.nl> <504D0F44.6030706@iki.fi> <504D17AA.8020807@schinagl.nl> <504D1859.5050201@iki.fi> <504DB9D4.6020502@schinagl.nl> <504DD311.7060408@iki.fi> <504DF950.8060006@schinagl.nl> <504E2345.5090800@schinagl.nl> <5055DD27.7080501@schinagl.nl> <505601B6.2010103@iki.fi> <5055EA30.8000200@schinagl.nl> <50560B82.7000205@iki.fi> <50564E58.20004@schinagl.nl> <50566260.1090108@iki.fi> <5056DE5C.70003@schinagl.nl> <50571F83.10708@schinagl.nl> <50572290.8090308@iki.fi>
In-Reply-To: <50572290.8090308@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17-09-12 15:16, Antti Palosaari wrote:
> On 09/17/2012 04:02 PM, Oliver Schinagl wrote:
>> On 17-09-12 10:25, Oliver Schinagl wrote:
>>> On 17-09-12 01:36, Antti Palosaari wrote:
>>>> On 09/17/2012 01:10 AM, Oliver Schinagl wrote:
>>>>> On 09/16/12 19:25, Antti Palosaari wrote:
>>>>>> On 09/16/2012 06:03 PM, Oliver Schinagl wrote:
>>>>>>> I don't have windows, so capturing using windows is near 
>>>>>>> impossible.
>>>>>>> Also since the vendor driver used to work, I guess I will have 
>>>>>>> to dig
>>>>>>> into that more.
>>>>>>
>>>>>> You could capture data from Linux too (eg. Wireshark).
>>>>> Ah of course. I'll dig up the old vendor driver and see if I can 
>>>>> get it
>>>>> running on 3.2 or better yet, on 3.5/your-3.6. I know there's patches
>>>>> for 3.2 but I've never tested those. Otherwise the older 2.6.2* 
>>>>> series
>>>>> should still work.
>>>>>
>>>>>>
>>>>>> But with a little experience you could see those GPIOs reading
>>>>>> existing
>>>>>> Linux driver and then do some tests to see what happens. For example
>>>>>> some GPIO powers tuner off, you will see I2C error. Changing it back
>>>>>> error disappears.
>>>>> I have zero experience so I'll try to figure things out. I guess you
>>>>> currently turn on/off GPIO's etc in the current driver? Any line 
>>>>> which
>>>>> does this so I can examine how it's done? As for the I2C errors, I
>>>>> suppose the current driver will spew those out?
>>>>
>>>> Those GPIOs are set in file af9035.c, functiuons:
>>>> af9035_tuner_attach() and af9035_fc0011_tuner_callback(). For
>>>> TDA18218 tuner there is no any GPIOs set, which could be wrong and it
>>>> just works with good luck OR it is wired/connected directly so that
>>>> GPIOs are not used at all.
>>> Ahah! Then I know what to look for. Since af9035 also has fc0011
>>> support, there should be some similarities I can find.
>> Which I did. I found that the af9033 sets the "gpiot2" o, en and on
>> values high to enable the tuner. Luckly, the fc2580 is routed to the
>> exact same gpio and thus the same tuner enable/disable routine can be
>> used as the FC0011. Appearantly the FC0011 tuner also has a led that
>> needs to be enabled/disabled, at gpioh8, which the fc2580 lacks. So I
>> found the tuner enable and should be able to incorporate that without
>> issue.
>>
>> The other callback the fc2580 has, is a 'reset'. The fc2580 appears to
>> be lacking such feature, or is not used in the vendor driver.
>>>>
>>>>> Speaking off, in my previous message, I wrote about the driver 
>>>>> spitting
>>>>> out the following error:
>>>>> [dvb_usb_af9035]af9035_read_config =_ "%s: [%d]tuner=%02x\012"
>>>>
>>>> It is the tuner ID value got from eeprom. You should take that number
>>>> and add it to af9033.h file:
>>>> #define AF9033_TUNER_FC2580    0xXXXX <= insert number here
>>> Yes, but I think %s, %d and %02x\012 should actually list values?
>>> (\012 I belive is \newline)
>> I need to learn dynamic_debug; and I think I may have set it up wrong
>> last time (af9035 and fc2580, but not af9033). I found some good
>> documentation and will try this tonight.
>>>>
>>>>> None of the values where set however. Did I miss-configure 
>>>>> anything for
>>>>> it to cause to 'forget' substituting?
>>>>
>>>> What you mean? Could you enable debugs, plug stick in and copy paste
>>>> what debugs says?
>>> I have dynamic debugging enabled and have gotten the above snipped
>>> from the proc/sysfs interface. Also dmesg from replugging I've
>>> attached a few messages back.
>>>
>>> [  188.051502] af9033: firmware version: LINK=12.13.15.0 OFDM=6.20.15.0
>>> [  188.051520] usb 1-3: DVB: registering adapter 0 frontend 0 (Afatech
>>> AF9033 (DVB-T))...
>>> [  188.054019] i2c i2c-1: fc2580_attach: chip_id=5a
>>> [  188.054030] i2c i2c-1: fc2580_attach: failed=0
>>> [  188.054471] i2c i2c-1: fc2580_release:
>>> [  188.054485] usb 1-3: dvb_usbv2: 'Asus U3100Mini Plus' error while
>>> loading driver (-19)
>>>
>>> is the dmesg output from then, which doesn't list the values from the
>>> debugging bit either. I suppose I need more debugging options enabled
>>> to have those flag characters actually filled in?
>
> It should print af9035 debugs too.
>
> usb 2-2: af9035_read_config: [0]tuner=27
>
> modprobe dvb_usb_af9035; echo -n 'module dvb_usb_af9035 +p' > 
> /sys/kernel/debug/dynamic_debug/control
>
> modprobe dvb_usb_v2; echo -n 'module dvb_usb_v2 +p' > 
> /sys/kernel/debug/dynamic_debug/control
>
> If tuner communication is really working and it says chip id is 0x5a 
> then it is different than driver knows. It could be new revision of 
> tuner. Change chip_id to match 0x5a
>
Ah, so it's called chip_id on one end, but tuner_id on the other end. 
If/when I got this link working properly, I'll write a patch to fix some 
naming consistencies.

The vendor source also slightly more accurately describes 
fc2580_init_reg_vals. When writing to 0x45 and 0x4c, it can have 
different meanings, it controls the AGC. While the vendor driver always 
uses the same bytes the init table uses, there always exists these 
differences and its documentation. Is it desired to document this, and 
if so where? A comment in the source? A wikipage somewhere? Or does it 
simply not matter? See 
http://git.schinagl.nl/AF903x_SRC.git/tree/api/fc2580.c#n135 for what I 
mean exactly.

I guess which address goes with which GPIO is far less interesting, as 
the gpio name could in theory be different from the actual pin due to 
pin multiplexing, right?
>
>>>>>>
>>>>>>> Since all the pieces should be there, fc2580 driver, af9033/5 
>>>>>>> driver,
>>>>>>> it's just a matter of glueing things together, right? I'll dig
>>>>>>> further
>>>>>>> into it and see what I can find/do.
>>>>>>
>>>>>> Correct. Tuner init (demod settings fc2580) for is needed for 
>>>>>> af9033.
>>>>>> And GPIOs for AF9035. In very bad luck some changes for fc2580 is
>>>>>> needed
>>>>>> too, but it is not very, very, unlikely.
>>>>>>
>>>>>> This patch is very similar you will need to do (tda18218 tuner 
>>>>>> support
>>>>>> for af9035):
>>>>>> http://patchwork.linuxtv.org/patch/10547/
>>>>> I re-did my patch using that as a template (before I used your 
>>>>> work on
>>>>> the rtl) and got the exact result.
>>>>>
>>>>> Your rtl|fc2580 combo btw (from bare memory) didn't have the
>>>>> fc2580_init
>>>>> stream in af9033_priv.h. What exactly gets init-ed there? The 
>>>>> af9033 to
>>>>> work with the fc2580?
>>>>
>>>> You have to add fc2580 init table to file af9033_priv.h. It
>>>> configures all the settings needed for AF9033 demod in order to
>>>> operate with FC2580 tuner. There is some values like "tuner ID" which
>>>> is passed for AF9033 firmware, dunno what kind of tweaks it done.
>>>> Maybe calculates some values like signal strengths and AGC values. It
>>>> could work without, but at least performance is reduced.
>>> I did add it. I found the init tables in the vendor driver, compared
>>> them to the existing init tables, found that the others where
>>> identical, but offset by 0x8000. I thus copied the table for the
>>> fc2580 and added the address offset.
>>> You can glance over it in the driver patch I submitted last week,
>>> should be there :)
>>>
>>> But since it modified the AF9033, I understand why your rtl driver
>>> didn't have the init table for the fc2580.
>
> If you look comment from the rtl28xxu.c around line 635 you will see it.
> /* FIXME: do not abuse fc0012 settings */
I take it, if my patch works, it can be also useful to the rtl28xxu driver?

>
> Antti

