Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:50837 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756129Ab2ISKlv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 06:41:51 -0400
Message-ID: <5059A155.3000502@schinagl.nl>
Date: Wed, 19 Sep 2012 12:41:25 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Support for Asus MyCinema U3100Mini Plus
References: <1347223647-645-1-git-send-email-oliver+list@schinagl.nl> <504D00BC.4040109@schinagl.nl> <504D0F44.6030706@iki.fi> <504D17AA.8020807@schinagl.nl> <504D1859.5050201@iki.fi> <504DB9D4.6020502@schinagl.nl> <504DD311.7060408@iki.fi> <504DF950.8060006@schinagl.nl> <504E2345.5090800@schinagl.nl> <5055DD27.7080501@schinagl.nl> <505601B6.2010103@iki.fi> <5055EA30.8000200@schinagl.nl> <50560B82.7000205@iki.fi> <50564E58.20004@schinagl.nl> <50566260.1090108@iki.fi> <5056DE5C.70003@schinagl.nl> <50571F83.10708@schinagl.nl> <50572290.8090308@iki.fi> <505724F0.20502@schinagl.nl> <50572B1D.3080807@iki.fi> <50573FC5.40307@schinagl.nl> <50578B61.1040700@schinagl.nl> <5057910C.10408@iki.fi> <50579CC3.5040703@schinagl.nl> <5058ACE4.6070408@schinagl.nl> <5058FAD9.4090204@iki.fi>
In-Reply-To: <5058FAD9.4090204@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19-09-12 00:51, Antti Palosaari wrote:
> On 09/18/2012 08:18 PM, Oliver Schinagl wrote:
>> On 09/17/12 23:57, Oliver Schinagl wrote:
>>> On 09/17/12 23:07, Antti Palosaari wrote:
>>>> On 09/17/2012 11:43 PM, Oliver Schinagl wrote:
>>>>> On 09/17/12 17:20, Oliver Schinagl wrote:
>>>>>
>>>>>>>>> If tuner communication is really working and it says chip id is
>>>>>>>>> 0x5a
>>>>>>>>> then it is different than driver knows. It could be new 
>>>>>>>>> revision of
>>>>>>>>> tuner. Change chip_id to match 0x5a
>>>>>>>>>
>>>>>>>> Ah, so it's called chip_id on one end, but tuner_id on the other
>>>>>>>> end.
>>>>>>>> If/when I got this link working properly, I'll write a patch to 
>>>>>>>> fix
>>>>>>>> some
>>>>>>>> naming consistencies.
>>>>>>>
>>>>>>> No, you are totally wrong now. Chip ID is value inside chip 
>>>>>>> register.
>>>>>>> Almost every chip has some chip id value which driver could 
>>>>>>> detect it
>>>>>>> is speaking with correct chip. In that case value is stored inside
>>>>>>> fc2580.
>>>>>>>
>>>>>>> Tuner ID is value stored inside AF9035 chip / eeprom. It is
>>>>>>> configuration value for AF9035 hardware design. It says "that 
>>>>>>> AF9035
>>>>>>> device uses FC2580 RF-tuner". AF9035 (FC2580) tuner ID and FC2580
>>>>>>> chip
>>>>>>> ID are different values having different meaning.
>>>>>> Ok, I understand the difference between Chip ID and Tuner ID I 
>>>>>> guess,
>>>>>> and with my new knowledge about dynamic debug I know also
>>>>>> understand my
>>>>>> findings and where it goes wrong. I also know understand the 
>>>>>> chipID is
>>>>>> stored in fc2580.c under the fc2580_attach, where it checks for 
>>>>>> 0x56.
>>>>>> Appearantly my chipID is 0x5a. I wasn't triggered by this as none of
>>>>>> the
>>>>>> other fc2580 or af9035 devices had such a change so it wasn't 
>>>>>> obvious.
>>>>>> Tuner ID is actively being chechked/set in the source, so that 
>>>>>> seemed
>>>>>> more obvious.
>>>>> It can't be 0x5a as chipid. I actually found that the vendor driver
>>>>> also
>>>>> reads from 0x01 once to test the chip.
>>>>>
>>>>> This function is a generic function which tests I2C interface's
>>>>> availability by reading out it's I2C id data from reg. address 
>>>>> '0x01'.
>>>>>
>>>>> int fc2580_i2c_test( void ) {
>>>>>      return ( fc2580_i2c_read( 0x01 ) == 0x56 )? 0x01 : 0x00;
>>>>> }
>>>>>
>>>>> So something else is going weird. chipid being 0x56 is good though;
>>>>> same
>>>>> chip revision. However I now got my system to hang, got some 
>>>>> soft-hang
>>>>> errors and the driver only reported failure on loading. No other 
>>>>> debug
>>>>> that I saw from dmesg before the crash. Will investigate more.
>>>>
>>>> huoh.
>>>>
>>>> usb 2-2: rtl28xxu_ctrl_msg: c0 00 ac 01 00 03 01 00 <<< 56
>>>> usb 2-2: rtl28xxu_ctrl_msg: 40 00 ac 01 10 03 01 00 >>> ff
>>>> usb 2-2: rtl28xxu_ctrl_msg: c0 00 ac 01 00 03 01 00 <<< 56
>>>> usb 2-2: rtl28xxu_ctrl_msg: 40 00 ac 01 10 03 01 00 >>> 00
>>>> usb 2-2: rtl28xxu_ctrl_msg: c0 00 ac 01 00 03 01 00 <<< 56
>>>> i2c i2c-5: fc2580: FCI FC2580 successfully identified
>>>>
>>>> Why do you think its value is static - it cannot be changed...
>>> I'm not saying it can be at all :p
>>>
>>> according to debug output, I had
>>>
>>> [  188.054019] i2c i2c-1: fc2580_attach: chip_id=5a
>>>
>>> so to your suggestion, I made it accept chip_id 0x5a as well.
>>>      if ((chip_id != 0x56) || (chip_id != 0x5a))
>>>          goto err;
>>>
>>> But theoretically, it can't be 0x5a, as even the vendor driver would
>>> only check for 0x56 (the function actually never gets called, so any
>>> revision according the those sources could work).
>>>
>>> So I will investigate why it would return 0x5a for the chip id :)
>>>
>>>
>> Turns out, the chip REALLY REALLY is 0x5a. I took some snapshots of both
>> the tuner and bridge/demodulator and uploaded them to the linuxtv wiki
>> [1]. If you could compare that one to your Chips? The markings are:
>>
>> FCI 2580 01BD
>>
>> AF9035B-N2
>> 1012 QJFSQ
>
> I haven't opened my device at all...
>
>> On a more serious note, right now, the driver soft-locks-up. Either with
>> or without accepting the 0x5a chip_id.
>>
>> What I do is, manually load all modules, enable debugging and plug in
>> the device.
>>
>> Everything appears to work normally for a while, I can do the dmesg dump
>> etc, but after about 22 seconds, I get this warning:
>> BUG: soft lockup - CPU#2 stuck for 22s! [udev-acl:2320]
>> (With the CPU# number being arbitrary). 22s later, another CPU fails. I
>> haven't waited for the other core's to fail.
>>
>> Also, removing the module is impossible. Rebooting also fails. I have to
>> sys-req reboot it.
>>
>> I don't know how much my patch is responsible for this of course, but
>> since attaching of the tuner fails due to the wrong chip_id in one case,
>> the only code affected is the USB id that loads the driver/firmware. I
>> did see this with the older firmware too btw, so appears to be firmware
>> unrelated.
>>
>> In the meantime, I continue finding out why after accepting chip_id
>> 0x5a, it still fails on tuner attach. I suppose somehow the tuner_id
>> isn't matching, which is weird, but will find out about it in the next
>> few days.
>
> Tuner attach does nothing more that could fail than check that one 
> register. It is almost impossible to get it failing if tuner ID match. 
> Maybe I2C communication is not working, error returned and it bails 
> out? Anyhow, such situation should be visible when debugs are enabled.
When it hangs the PC, nothing is visible. All functions bail out with 
error code -19. The fc2580 module is then used -1 times and can't be 
unloaded, as can't the others. As with my other post, when the tuner IS 
detected and is working, no hangs or stalls appear to be happening.
>
>> [1] http://www.linuxtv.org/wiki/index.php/Asus_U3100_Mini_plus_DVB-T
>
> regards
> Antti
>

