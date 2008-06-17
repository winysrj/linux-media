Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bcjenkins@tvwhere.com>) id 1K8gen-0005sA-6N
	for linux-dvb@linuxtv.org; Tue, 17 Jun 2008 21:15:58 +0200
Received: by yw-out-2324.google.com with SMTP id 3so3112734ywj.41
	for <linux-dvb@linuxtv.org>; Tue, 17 Jun 2008 12:15:49 -0700 (PDT)
Message-Id: <9BD27DD1-A79E-43CE-AD3F-324F35DC1971@tvwhere.com>
From: Brandon Jenkins <bcjenkins@tvwhere.com>
To: mkrufky@linuxtv.org
In-Reply-To: <485805AC.5050601@linuxtv.org>
Mime-Version: 1.0 (Apple Message framework v924)
Date: Tue, 17 Jun 2008 15:15:13 -0400
References: <485805AC.5050601@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cx18 or tveeprom - Missing dependency? [SOLVED?]
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


On Jun 17, 2008, at 2:42 PM, mkrufky@linuxtv.org wrote:

> Brandon Jenkins wrote:
>>
>> On Jun 17, 2008, at 1:39 PM, mkrufky@linuxtv.org wrote:
>>
>>> Brandon Jenkins wrote:
>>>>
>>>> On Jun 17, 2008, at 12:17 PM, mkrufky@linuxtv.org wrote:
>>>>
>>>>> Brandon Jenkins wrote:
>>>>>>
>>>>>> On Jun 17, 2008, at 11:24 AM, mkrufky@linuxtv.org wrote:
>>>>>>
>>>>>>> Brandon Jenkins wrote:
>>>>>>>>
>>>>>>>> On Jun 17, 2008, at 10:52 AM, mkrufky@linuxtv.org wrote:
>>>>>>>>
>>>>>>>>> Brandon Jenkins wrote:
>>>>>>>>> Brandon,
>>>>>>>>>
>>>>>>>>> VIDEO_CX18 selects VIDEO_TUNER , but you chose the option,
>>>>>>>>> "MEDIA_TUNER_CUSTOMIZE" , which turns off the automatic tuner
>>>>>>>>> dependency
>>>>>>>>> selections.  Please note the description of this option:
>>>>>>>>>
>>>>>>>>> menuconfig MEDIA_TUNER_CUSTOMIZE
>>>>>>>>>    bool "Customize analog and hybrid tuner modules to build"
>>>>>>>>>    depends on MEDIA_TUNER
>>>>>>>>>    help
>>>>>>>>>      This allows the user to deselect tuner drivers  
>>>>>>>>> unnecessary
>>>>>>>>>      for their hardware from the build. Use this option with  
>>>>>>>>> care
>>>>>>>>>      as deselecting tuner drivers which are in fact necessary
>>>>>>>>> will
>>>>>>>>>      result in V4L/DVB devices which cannot be tuned due to
>>>>>>>>> lack of
>>>>>>>>>      driver support
>>>>>>>>>
>>>>>>>>>      If unsure say N.
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> We allow users to disable certain modules if they think they  
>>>>>>>>> know
>>>>>>>>> better, and choose to compile out drivers that they don't
>>>>>>>>> need.  You
>>>>>>>>> should not have disabled tuner-simple -- to play it safe,  
>>>>>>>>> don't
>>>>>>>>> enable
>>>>>>>>> MEDIA_TUNER_CUSTOMIZE
>>>>>>>>>
>>>>>>>>> Regards,
>>>>>>>>>
>>>>>>>>> Mike
>>>>>>>>>
>>>>>>>>>
>>>>>>>> Mike,
>>>>>>>>
>>>>>>>> Thank you. I understand the impact my choice makes in that  
>>>>>>>> matter.
>>>>>>>> However, all of the other modules required for cx18 to  
>>>>>>>> function are
>>>>>>>> marked in the lists as -M- indicating it is a required
>>>>>>>> module/module
>>>>>>>> dependency. I apologize for my ignorance of terminology, etc.,
>>>>>>>> but it
>>>>>>>> would seem to me that "Simple tuner support" should  
>>>>>>>> automatically
>>>>>>>> have
>>>>>>>> the -M- as a required resource for the tuner to function  
>>>>>>>> correctly.
>>>>>>>>
>>>>>>>> Thank you for your time in responding.
>>>>>>>>
>>>>>>>> Brandon
>>>>>>> No -- You are misunderstanding -- The selection of the  
>>>>>>> tuner.ko i2c
>>>>>>> client module is forced as -M- , since it is selected as a
>>>>>>> dependency.
>>>>>>> You then proceeded into a deeper layer of customization, and  
>>>>>>> enabled
>>>>>>> "MEDIA_TUNER_CUSTOMIZE" -- this option allows you to disable  
>>>>>>> tuner
>>>>>>> modules that should have otherwise been autoselected for your
>>>>>>> hardware.
>>>>>>> I repeat -- this is an advanced customization option, and you  
>>>>>>> have
>>>>>>> been
>>>>>>> so warned by its Kconfig description.
>>>>>>>
>>>>>>> I am pushing up a patch now that disables  
>>>>>>> MEDIA_TUNER_CUSTOMIZE by
>>>>>>> default.
>>>>>>>
>>>>>>> -Mike
>>>>>> Mike,
>>>>>>
>>>>>> That doesn't solve the problem. I believe the patch below, will.
>>>>>>
>>>>>> Brandon
>>>>>>
>>>>>> diff -r 50be11af3fdb linux/drivers/media/video/cx18/Kconfig
>>>>>> --- a/linux/drivers/media/video/cx18/Kconfig    Mon Jun 16  
>>>>>> 18:04:06
>>>>>> 2008 -0300
>>>>>> +++ b/linux/drivers/media/video/cx18/Kconfig    Tue Jun 17  
>>>>>> 12:02:03
>>>>>> 2008 -0400
>>>>>> @@ -12,6 +12,7 @@ config VIDEO_CX18
>>>>>>   select VIDEO_CS5345
>>>>>>   select DVB_S5H1409
>>>>>>   select MEDIA_TUNER_MXL5005S
>>>>>> +    select MEDIA_TUNER_SIMPLE
>>>>>>   ---help---
>>>>>>     This is a video4linux driver for Conexant cx23418 based
>>>>>>     PCI combo video recorder devices.
>>>>>>
>>>>> Brandon,
>>>>>
>>>>> Thank you for this, but this patch will not be merged.  I  
>>>>> explained in
>>>>> the quoted email, above, that you have invoked a deeper layer of
>>>>> customization that allows us to disable tuner modules,  
>>>>> regardless of
>>>>> your actual hardware.
>>>>>
>>>>> This option was designed for the sake of larger drivers, such as
>>>>> cx88 or
>>>>> saa7134, who may use many different tuners depending on the actual
>>>>> board
>>>>> present.  In the future, there may eventually be a cx18 board that
>>>>> does
>>>>> not use tuner-simple.  This option allows users to disable
>>>>> tuner-simple
>>>>> from building.  The default behavior is to automatically select  
>>>>> the
>>>>> tuner driver needed for your hardware, but when you enable
>>>>> MEDIA_TUNER_CUSTOMIZE, this autoselection is turned off.  This  
>>>>> is the
>>>>> correct behavior.
>>>>>
>>>>> I repeat again that this Kconfig option provides a warning to  
>>>>> the user
>>>>> that this should be enabled at your own risk, only.
>>>>>
>>>>> "Use this option with care as deselecting tuner drivers which  
>>>>> are in
>>>>> fact necessary will result in V4L/DVB devices which cannot be  
>>>>> tuned
>>>>> due
>>>>> to lack of driver support."
>>>>>
>>>>> Do not enable MEDIA_TUNER_CUSTOMIZE unless you know what you're  
>>>>> doing.
>>>>>
>>>>> End of story.
>>>>>
>>>>> -Mike
>>>>>
>>>>>
>>>> Mike,
>>>>
>>>> I don't mean to continue this debate, but if you say this is  
>>>> working
>>>> as designed I will leave it alone and move on. All other tuner  
>>>> modules
>>>> (the max linear) which are required by the cx18 to function are  
>>>> still
>>>> indeed -M- in the menuconfig view. Once I added the patch above  
>>>> Simple
>>>> tuner also became -M- indicating it was required by a selected  
>>>> board.
>>>> If Simple tuner is required for the card to function, it should be
>>>> automatically selected as are all the other tuner modules the card
>>>> requires.
>>>>
>>>> AFAIK - The only way to deselect a required tuner module is to
>>>> deselect the card it supports.
>>>>
>>>> Your message seems more about the principle of customizing which
>>>> modules are built, while I am trying to save further  
>>>> troubleshooting
>>>> by requiring the modules for my particular card to be automatically
>>>> selected if someone selects the card. I see the two as separate  
>>>> items.
>>>> If it is not appropriate to use the select TUNER in the Kconfig,  
>>>> whay
>>>> is the MaxlLinear in there?
>>>>
>>>> Brandon
>>>>
>>> That is a bug -- thanks for pointing it out.
>>>
>>> Clone this tree and try again:
>>>
>>> http://linuxtv.org/hg/~mkrufky/fix
>>>
>>> -Mike
>> Mike,
>>
>> This is effectively the same as when we first started this  
>> discussion.
>> But I can confirm that your last change works as designed and the
>> change to disallow customization by default does not.
>>
>> A change to the perl script ./v4l/scripts/make_kconfig.pl needs to be
>> done to set the default to no on that entry. I don't know perl, so I
>> can't help there.
>>
>> All of this though brings us back to the same point I started out
>> with. If Simple tuner is required, and if !DVB_FE_CUSTOMISE, then
>> there really ought to be a "select MEDIA_TUNER_SIMPLE if
>> !DVB_FE_CUSTOMISE" in the file. I know what needs to be done for the
>> card to function, my purpose in bringing this up was to help others.
> Brandon,
>
> There is no call to simple_tuner_attach() inside cx18-dvb.c
>
> There is a call to mxl5005s_attach() inside cx18-dvb.c -- mxl5005s  
> is an
> actual dependency that can be enabled or disabled.
>
> tuner_simple is an implied dependency, no code from within the cx18  
> ever
> calls simple_tuner_attach() -- Instead, cx18 attaches to the tuner.ko
> i2c_client module, which in turn calls simple_tuner_attach() as needed
> if available.
>
> No other driver selects TUNER_SIMPLE unless it explicitly calls
> simple_tuner_attach() directly.
>
> If there is a bug in make_kconfig.pl, then there is a bug -- don't try
> to fix that bug by altering the Kconfig menus.
>
> I understand that your intention is to help others.  Meanwhile, the
> default behavior is for MEDIA_TUNER_CUSTOMIZE to be disabled.  Even if
> MEDIA_TUNER_CUSTOMIZE is enabled, the default behavior of TUNER_SIMPLE
> is to be selected by default when MEDIA_TUNER_CUSTOMIZE is selected.
>
> The only way to disable TUNER_SIMPLE in this case is to manually  
> disable
> it on purpose.
>
> If you leave MEDIA_TUNER_CUSTOMIZE disabled, then you will not run  
> into
> this problem.
>
> Please accept this answer -- there isn't much more to be said on the  
> topic.
>
> -Mike
Mike,

First, I appreciate your time and responses, truly.

To a kernel developer your logic makes sense.

Your change to make MEDIA_TUNER_CUSTOMIZE disabled by default is  
ineffective because the perl script creating the config the first time  
you run make menuconfig enables the option. If that is of no concern,  
then so be it. I am not certain why you asked me to test changes which  
had zero difference in behavior, if you weren't interested in the  
results.

To sum this up as I understand:

1) The cx18 driver somehow requires the presence of simple tuner, but  
since it does not explicitly make a call to it; it is not auto selected.
2) Setting any default to no in Kconfig is negated by the perl script  
run during the first instance of make menuconfig which builds a  
default .config file with everything set to yes.
3) If I'd just blindly make all of the tuners and modules, we'd not be  
having this discussion. :)

Take care,

Brandon

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
