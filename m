Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <4857F6D0.5040905@linuxtv.org>
From: mkrufky@linuxtv.org
To: bcjenkins@tvwhere.com
Date: Tue, 17 Jun 2008 13:39:28 -0400
MIME-Version: 1.0
in-reply-to: <87404417-9637-4DA2-A6CD-4B2469C52D72@tvwhere.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cx18 or tveeprom - Missing dependency? [PATCH]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Brandon Jenkins wrote:
>
> On Jun 17, 2008, at 12:17 PM, mkrufky@linuxtv.org wrote:
>
>> Brandon Jenkins wrote:
>>>
>>> On Jun 17, 2008, at 11:24 AM, mkrufky@linuxtv.org wrote:
>>>
>>>> Brandon Jenkins wrote:
>>>>>
>>>>> On Jun 17, 2008, at 10:52 AM, mkrufky@linuxtv.org wrote:
>>>>>
>>>>>> Brandon Jenkins wrote:
>>>>>> Brandon,
>>>>>>
>>>>>> VIDEO_CX18 selects VIDEO_TUNER , but you chose the option,
>>>>>> "MEDIA_TUNER_CUSTOMIZE" , which turns off the automatic tuner
>>>>>> dependency
>>>>>> selections.  Please note the description of this option:
>>>>>>
>>>>>> menuconfig MEDIA_TUNER_CUSTOMIZE
>>>>>>      bool "Customize analog and hybrid tuner modules to build"
>>>>>>      depends on MEDIA_TUNER
>>>>>>      help
>>>>>>        This allows the user to deselect tuner drivers unnecessary
>>>>>>        for their hardware from the build. Use this option with care
>>>>>>        as deselecting tuner drivers which are in fact necessary will
>>>>>>        result in V4L/DVB devices which cannot be tuned due to 
>>>>>> lack of
>>>>>>        driver support
>>>>>>
>>>>>>        If unsure say N.
>>>>>>
>>>>>>
>>>>>> We allow users to disable certain modules if they think they know
>>>>>> better, and choose to compile out drivers that they don't need.  You
>>>>>> should not have disabled tuner-simple -- to play it safe, don't 
>>>>>> enable
>>>>>> MEDIA_TUNER_CUSTOMIZE
>>>>>>
>>>>>> Regards,
>>>>>>
>>>>>> Mike
>>>>>>
>>>>>>
>>>>> Mike,
>>>>>
>>>>> Thank you. I understand the impact my choice makes in that matter.
>>>>> However, all of the other modules required for cx18 to function are
>>>>> marked in the lists as -M- indicating it is a required module/module
>>>>> dependency. I apologize for my ignorance of terminology, etc., but it
>>>>> would seem to me that "Simple tuner support" should automatically 
>>>>> have
>>>>> the -M- as a required resource for the tuner to function correctly.
>>>>>
>>>>> Thank you for your time in responding.
>>>>>
>>>>> Brandon
>>>> No -- You are misunderstanding -- The selection of the tuner.ko i2c
>>>> client module is forced as -M- , since it is selected as a dependency.
>>>> You then proceeded into a deeper layer of customization, and enabled
>>>> "MEDIA_TUNER_CUSTOMIZE" -- this option allows you to disable tuner
>>>> modules that should have otherwise been autoselected for your 
>>>> hardware.
>>>> I repeat -- this is an advanced customization option, and you have 
>>>> been
>>>> so warned by its Kconfig description.
>>>>
>>>> I am pushing up a patch now that disables MEDIA_TUNER_CUSTOMIZE by
>>>> default.
>>>>
>>>> -Mike
>>> Mike,
>>>
>>> That doesn't solve the problem. I believe the patch below, will.
>>>
>>> Brandon
>>>
>>> diff -r 50be11af3fdb linux/drivers/media/video/cx18/Kconfig
>>> --- a/linux/drivers/media/video/cx18/Kconfig    Mon Jun 16 18:04:06
>>> 2008 -0300
>>> +++ b/linux/drivers/media/video/cx18/Kconfig    Tue Jun 17 12:02:03
>>> 2008 -0400
>>> @@ -12,6 +12,7 @@ config VIDEO_CX18
>>>     select VIDEO_CS5345
>>>     select DVB_S5H1409
>>>     select MEDIA_TUNER_MXL5005S
>>> +    select MEDIA_TUNER_SIMPLE
>>>     ---help---
>>>       This is a video4linux driver for Conexant cx23418 based
>>>       PCI combo video recorder devices.
>>>
>> Brandon,
>>
>> Thank you for this, but this patch will not be merged.  I explained in
>> the quoted email, above, that you have invoked a deeper layer of
>> customization that allows us to disable tuner modules, regardless of
>> your actual hardware.
>>
>> This option was designed for the sake of larger drivers, such as cx88 or
>> saa7134, who may use many different tuners depending on the actual board
>> present.  In the future, there may eventually be a cx18 board that does
>> not use tuner-simple.  This option allows users to disable tuner-simple
>> from building.  The default behavior is to automatically select the
>> tuner driver needed for your hardware, but when you enable
>> MEDIA_TUNER_CUSTOMIZE, this autoselection is turned off.  This is the
>> correct behavior.
>>
>> I repeat again that this Kconfig option provides a warning to the user
>> that this should be enabled at your own risk, only.
>>
>> "Use this option with care as deselecting tuner drivers which are in
>> fact necessary will result in V4L/DVB devices which cannot be tuned due
>> to lack of driver support."
>>
>> Do not enable MEDIA_TUNER_CUSTOMIZE unless you know what you're doing.
>>
>> End of story.
>>
>> -Mike
>>
>>
> Mike,
>
> I don't mean to continue this debate, but if you say this is working 
> as designed I will leave it alone and move on. All other tuner modules 
> (the max linear) which are required by the cx18 to function are still 
> indeed -M- in the menuconfig view. Once I added the patch above Simple 
> tuner also became -M- indicating it was required by a selected board. 
> If Simple tuner is required for the card to function, it should be 
> automatically selected as are all the other tuner modules the card 
> requires.
>
> AFAIK - The only way to deselect a required tuner module is to 
> deselect the card it supports.
>
> Your message seems more about the principle of customizing which 
> modules are built, while I am trying to save further troubleshooting 
> by requiring the modules for my particular card to be automatically 
> selected if someone selects the card. I see the two as separate items. 
> If it is not appropriate to use the select TUNER in the Kconfig, whay 
> is the MaxlLinear in there?
>
> Brandon
>
That is a bug -- thanks for pointing it out.

Clone this tree and try again:

http://linuxtv.org/hg/~mkrufky/fix

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
