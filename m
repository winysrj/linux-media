Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <4857D73D.8080709@linuxtv.org>
From: mkrufky@linuxtv.org
To: bcjenkins@tvwhere.com
Date: Tue, 17 Jun 2008 11:24:45 -0400
MIME-Version: 1.0
in-reply-to: <D4F69DB0-447A-42C5-A26F-19DCB73D0339@tvwhere.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cx18 or tveeprom - Missing dependency?
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
> On Jun 17, 2008, at 10:52 AM, mkrufky@linuxtv.org wrote:
>
>> Brandon Jenkins wrote:
>> Brandon,
>>
>> VIDEO_CX18 selects VIDEO_TUNER , but you chose the option,
>> "MEDIA_TUNER_CUSTOMIZE" , which turns off the automatic tuner dependency
>> selections.  Please note the description of this option:
>>
>> menuconfig MEDIA_TUNER_CUSTOMIZE
>>        bool "Customize analog and hybrid tuner modules to build"
>>        depends on MEDIA_TUNER
>>        help
>>          This allows the user to deselect tuner drivers unnecessary
>>          for their hardware from the build. Use this option with care
>>          as deselecting tuner drivers which are in fact necessary will
>>          result in V4L/DVB devices which cannot be tuned due to lack of
>>          driver support
>>
>>          If unsure say N.
>>
>>
>> We allow users to disable certain modules if they think they know
>> better, and choose to compile out drivers that they don't need.  You
>> should not have disabled tuner-simple -- to play it safe, don't enable
>> MEDIA_TUNER_CUSTOMIZE
>>
>> Regards,
>>
>> Mike
>>
>>
> Mike,
>
> Thank you. I understand the impact my choice makes in that matter. 
> However, all of the other modules required for cx18 to function are 
> marked in the lists as -M- indicating it is a required module/module 
> dependency. I apologize for my ignorance of terminology, etc., but it 
> would seem to me that "Simple tuner support" should automatically have 
> the -M- as a required resource for the tuner to function correctly.
>
> Thank you for your time in responding.
>
> Brandon
No -- You are misunderstanding -- The selection of the tuner.ko i2c 
client module is forced as -M- , since it is selected as a dependency.  
You then proceeded into a deeper layer of customization, and enabled 
"MEDIA_TUNER_CUSTOMIZE" -- this option allows you to disable tuner 
modules that should have otherwise been autoselected for your hardware.  
I repeat -- this is an advanced customization option, and you have been 
so warned by its Kconfig description.

I am pushing up a patch now that disables MEDIA_TUNER_CUSTOMIZE by default.

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
