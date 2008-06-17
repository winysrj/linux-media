Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <4857CF9F.7050901@linuxtv.org>
From: mkrufky@linuxtv.org
To: bcjenkins@tvwhere.com
Date: Tue, 17 Jun 2008 10:52:15 -0400
MIME-Version: 1.0
in-reply-to: <42CF7D26-E68F-48A0-BECF-9CDA71AE7966@tvwhere.com>
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
> On Jun 17, 2008, at 9:38 AM, Michael Krufky wrote:
>
>> Brandon Jenkins wrote:
>>> Greetings,
>>>
>>> I choose to compile only the modules which are required for the
>>> hardware in my system as a way to speed up compilation times. When
>>> compiling for the v4l-dvb I run make menuconfig and deselect the
>>> modules for the adapters  not in my system. If I don't compile in
>>> Simple tuner support the cx18 load process throws and error in 
>>> tveeprom.
>>
>>
>> The analog tuner on the hvr1600 is supported by tuner-simple -- you 
>> need that module compiled.
>>
>> -Mike Krufky
>
> Mike,
>
> Thanks for the reply. I am sorry my intention was to highlight the 
> fact that it is not auto-selected as part of the process and that I 
> have to manually select it. If it is a dependency, should it not be 
> auto-selected? Would it be a dependency of cx18 or tveeprom?
>
> Thanks again,
>
> Brandon
Brandon,

VIDEO_CX18 selects VIDEO_TUNER , but you chose the option, 
"MEDIA_TUNER_CUSTOMIZE" , which turns off the automatic tuner dependency 
selections.  Please note the description of this option:

menuconfig MEDIA_TUNER_CUSTOMIZE
        bool "Customize analog and hybrid tuner modules to build"
        depends on MEDIA_TUNER
        help
          This allows the user to deselect tuner drivers unnecessary
          for their hardware from the build. Use this option with care
          as deselecting tuner drivers which are in fact necessary will
          result in V4L/DVB devices which cannot be tuned due to lack of
          driver support

          If unsure say N.


We allow users to disable certain modules if they think they know 
better, and choose to compile out drivers that they don't need.  You 
should not have disabled tuner-simple -- to play it safe, don't enable 
MEDIA_TUNER_CUSTOMIZE

Regards,

Mike



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
