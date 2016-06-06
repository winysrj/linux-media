Return-path: <linux-media-owner@vger.kernel.org>
Received: from v-smtpgw1.han.skanova.net ([81.236.60.204]:57782 "EHLO
	v-smtpgw1.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbcFFLgU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2016 07:36:20 -0400
Subject: Re: DVBSky T980C CI issues (kernel 4.0.x)
To: Olli Salonen <olli.salonen@iki.fi>,
	Jurgen Kramer <gtmkramer@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <1436697509.2446.14.camel@xs4all.nl>
 <1440352250.13381.3.camel@xs4all.nl> <55F332FE.7040201@mbox200.swipnet.se>
 <1442041326.2442.2.camel@xs4all.nl>
 <CAAZRmGxvrXjanCTcd0Ybk-qzHhqO5e6JhrpSWxNXSa+zzPsdUg@mail.gmail.com>
 <1454007436.13371.4.camel@xs4all.nl>
 <CAAZRmGwuinufZpCpTs8t+BRyTcfio-4z34PCKH7Ha3J+dxXNqw@mail.gmail.com>
 <56ADCBE4.6050609@mbox200.swipnet.se>
 <CAAZRmGy21S+qkrC9d0hz02J98woUc9p+LtnhK8Det=yWmb_myg@mail.gmail.com>
 <56C88CEB.3080907@mbox200.swipnet.se> <1455988859.21645.6.camel@xs4all.nl>
 <CAAZRmGwME6Mb+HAtd5nwPxc9RJi-XdTbS_Cfn1P1LOi0Y2UYZg@mail.gmail.com>
 <56D880E7.4070306@mbox200.swipnet.se> <56D8B3A1.9030001@mbox200.swipnet.se>
 <56D8B4A2.2090402@mbox200.swipnet.se>
From: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Message-ID: <3ff89b0f-ad6e-0b3f-9f92-fd4274dcaa5c@mbox200.swipnet.se>
Date: Mon, 6 Jun 2016 13:30:30 +0200
MIME-Version: 1.0
In-Reply-To: <56D8B4A2.2090402@mbox200.swipnet.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

FYI i still get "Exec format error" while modprobing cx23885 with 
media_build from today.

any chance of having this fixed so i can test the mediabuild code with 
my dvbsky card?



On 2016-03-03 23:03, Torbjorn Jansson wrote:
> found something, modprobe results in the following dmesg message:
>
> frame_vector: exports duplicate symbol frame_vector_create (owned by
> kernel)
>
> every time i do a modprobe of cx23885
> what does this mean?
>
> On 2016-03-03 22:58, Torbjorn Jansson wrote:
>> i'm having a bit of a problem testing the changed firmware on my t980c
>> card.
>>
>> complied the code from media_tree and i get the usb card to work with
>> those modules but for some reason modprobe of cx23885 results in:
>> # modprobe cx23885
>> modprobe: ERROR: could not insert 'cx23885': Exec format error
>>
>> all the other modules work just fine, i'm not sure what i'm doing wrong.
>>
>>
>> On 2016-03-03 19:22, Torbjorn Jansson wrote:
>>> i was about to ask how to easiest see what firmware i was running
>>> without rebooting when i realized i already have it in this mail
>>> thread ;)
>>>
>>> all of the firmware i'm running is the ones that came from dvbsky
>>> directly in this file:
>>> http://www.dvbsky.net/download/linux/dvbsky-firmware.tar.gz
>>>
>>> i suspect i should go thru all of the firmware files i use since if one
>>> is bad the other ones is probably also bad.
>>>
>>> i assume i also should also check: dvb-tuner-si2158-a20-01.fw
>>> what version is a good one? i have found 2 different files:
>>>
>>> the one i current usefrom dvbsky, also same as OpenELEC fw repo uses
>>> with md5sum:
>>> 8e98d25d6219e235b519a3c47dbfa856  dvb-tuner-si2158-a20-01.fw
>>>
>>> and then i found another one at
>>> http://palosaari.fi/linux/v4l-dvb/firmware/Si2158/Si2158-A20/
>>> 0cba7ce61c1411cbe7f22c0746e24e33  dvb-tuner-si2158-a20-01.fw
>>> this file is a bit smaller.
>>>
>>> i will retest with the new firmware you suggested and see what happens.
>>>
>>>
>>> On 2016-03-03 12:02, Olli Salonen wrote:
>>>> Hi Jurgen, Torbjörn,
>>>>
>>>> I've noticed that there is currently a small confusion about the
>>>> firmware versions for the Si2168-A20 demodulator. This is used in the
>>>> older versions of DVBSky T680C (TechnoTrend CT2-4650 CI) and DVBSky
>>>> T980C (TechnoTrend CT2-4500 CI).
>>>>
>>>> The version 2.0.5 does not support PLP handling and seems to work very
>>>> badly with the Linux driver - at least for me. Version 2.0.35 on the
>>>> other hand seems to find all DVB-T/T2 channels for me just fine with
>>>> both dvbv5-scan and w_scan (devices used for this test: TechnoTrend
>>>> CT2-4650 CI and TechnoTrend CT2-4500 CI new version).
>>>>
>>>> Versions used:
>>>> dvbv5-scan version 1.7.0
>>>> w_scan version 20150111 (compiled for DVB API 5.10)
>>>>
>>>> So if you are running these Si2168-A20 based devices, make sure you've
>>>> got the firmware 2.0.35 that can be downloaded for example here:
>>>> http://palosaari.fi/linux/v4l-dvb/firmware/Si2168/Si2168-A20/32e06713b33915f674bfb2c209beaea5/
>>>>
>>>>
>>>>
>>>>
>>>> Cheers,
>>>> -olli
>>>>
>>>> On 20 February 2016 at 19:20, Jurgen Kramer <gtmkramer@xs4all.nl>
>>>> wrote:
>>>>> Hi,
>>>>>
>>>>> On Sat, 2016-02-20 at 16:57 +0100, Torbjorn Jansson wrote:
>>>>>> i have tested your patch with my dvbsky dvb-t2 card.
>>>>>> testing was done by compiling a custom kernel with your patch
>>>>>> included.
>>>>>> test was done against fedora 22 4.3.4-200 kernel
>>>>>>
>>>>>> with the patch included the CI slot is found.
>>>>>> so there is some progress for sure
>>>>>> -----
>>>>>> [   10.189408] cx25840 11-0044: loaded v4l-cx23885-avcore-01.fw
>>>>>> firmware
>>>>>> (16382 bytes)
>>>>>> [   10.206683] cx23885_dvb_register() allocating 1 frontend(s)
>>>>>> [   10.207968] cx23885[0]: cx23885 based dvb card
>>>>>> [   10.224306] i2c i2c-10: Added multiplexed i2c bus 12
>>>>>> [   10.225633] si2168 10-0064: Silicon Labs Si2168 successfully
>>>>>> attached
>>>>>> [   10.243310] si2157 12-0060: Silicon Labs Si2147/2148/2157/2158
>>>>>> successfully attached
>>>>>> [   10.244560] DVB: registering new adapter (cx23885[0])
>>>>>> [   10.245807] cx23885 0000:07:00.0: DVB: registering adapter 0
>>>>>> frontend
>>>>>> 0 (Silicon Labs Si2168)...
>>>>>> [   10.417402] sp2 9-0040: CIMaX SP2 successfully attached
>>>>>> [   10.447120] DVBSky T980C MAC address: 00:17:42:54:09:85
>>>>>> [   10.448844] cx23885_dev_checkrevision() Hardware revision = 0xa5
>>>>>> [   10.450550] cx23885[0]/0: found at 0000:07:00.0, rev: 4, irq: 19,
>>>>>> latency: 0, mmio: 0xf6e00000
>>>>>>
>>>>>> later when tuning:
>>>>>>
>>>>>> [   67.728109] si2168 10-0064: found a 'Silicon Labs Si2168-A20'
>>>>>> [   67.802203] si2168 10-0064: downloading firmware from file
>>>>>> 'dvb-demod-si2168-a20-01.fw'
>>>>>> [   68.968336] si2168 10-0064: firmware version: 2.0.5
>>>>>> [   68.977071] si2157 12-0060: found a 'Silicon Labs Si2158-A20'
>>>>>> [   69.961057] si2157 12-0060: downloading firmware from file
>>>>>> 'dvb-tuner-si2158-a20-01.fw'
>>>>>> [   70.969094] si2157 12-0060: firmware version: 2.1.9
>>>>>> ----
>>>>>>
>>>>>> but using dvbv5-scan to scan it doesn't find any channel.
>>>>>> all i get is this:
>>>>>> ----
>>>>>> Scanning frequency #1 770000000
>>>>>>          (0x00) Signal= -114.00dBm
>>>>>> Scanning frequency #2 754000000
>>>>>>          (0x00) Signal= -27.00dBm C/N= 32.50dB
>>>>>> Scanning frequency #3 546000000
>>>>>>          (0x00) Signal= -25.00dBm C/N= 33.75dB
>>>>>> Scanning frequency #4 650000000
>>>>>>          (0x00) Signal= -18.00dBm C/N= 36.00dB
>>>>>> Scanning frequency #5 522000000
>>>>>>          (0x00) Signal= -28.00dBm C/N= 33.00dB
>>>>>> ----
>>>>>>
>>>>>> so something else is broken too.
>>>>>>
>>>>> I have been using the patches for a few days. So far everything works
>>>>> great (using MythTV). Scanning with dvbv5_scan does indeed not work
>>>>> (never did for me). w_scan works though.
>>>>>
>>>>> Can these patches please be included in the stable kernels ?
>>>>>
>>>>> Jurgen
>>>>>
>>>>>
>>>>>> On 2016-02-16 21:20, Olli Salonen wrote:
>>>>>>> Hi all,
>>>>>>>
>>>>>>> Found the issue and submitted a patch.
>>>>>>>
>>>>>>> The I2C buses for T980C/T2-4500CI were crossed when CI registration
>>>>>>> was moved to its own function.
>>>>>>>
>>>>>>> Cheers,
>>>>>>> -olli
>>>>>>>
>>>>>>> On 31 January 2016 at 10:55, Torbjorn Jansson
>>>>>>> <torbjorn.jansson@mbox200.swipnet.se> wrote:
>>>>>>>> this ci problem is the reason i decided to buy the CT2-4650 usb
>>>>>>>> based device
>>>>>>>> instead.
>>>>>>>> but the 4650 was a slightly newer revision needing a patch i
>>>>>>>> submitted
>>>>>>>> earlier.
>>>>>>>> and also this 4650 device does not have auto switching between
>>>>>>>> dvb-t and t2
>>>>>>>> like the dvbsky card have, so i also need an updated version of
>>>>>>>> mythtv.
>>>>>>>>
>>>>>>>> my long term wish is to not have to patch things or build custom
>>>>>>>> kernels or
>>>>>>>> modules.
>>>>>>>> so anything done to improve the dvbsky card or the 4650 is much
>>>>>>>> appreciated.
>>>>>>>>
>>>>>>>>
>>>>>>>> On 2016-01-28 20:42, Olli Salonen wrote:
>>>>>>>>>
>>>>>>>>> Hi Jürgen & Mauro,
>>>>>>>>>
>>>>>>>>> I did bisect this and it seems this rather big patch broke it:
>>>>>>>>>
>>>>>>>>> 2b0aac3011bc7a9db27791bed4978554263ef079 is the first bad
>>>>>>>>> commit
>>>>>>>>> commit 2b0aac3011bc7a9db27791bed4978554263ef079
>>>>>>>>> Author: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>>>>>>> Date:   Tue Dec 23 13:48:07 2014 -0200
>>>>>>>>>
>>>>>>>>>        [media] cx23885: move CI/MAC registration to a separate
>>>>>>>>> function
>>>>>>>>>
>>>>>>>>>        As reported by smatch:
>>>>>>>>>            drivers/media/pci/cx23885/cx23885-dvb.c:2080
>>>>>>>>> dvb_register()
>>>>>>>>> Function too hairy.  Giving up.
>>>>>>>>>
>>>>>>>>>        This is indeed a too complex function, with lots of stuff
>>>>>>>>> inside.
>>>>>>>>>        Breaking this into two functions makes it a little bit
>>>>>>>>> less hairy.
>>>>>>>>>
>>>>>>>>>        Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung
>>>>>>>>> .com>
>>>>>>>>>
>>>>>>>>> It's getting a bit late, so I'll call it a day now and have a
>>>>>>>>> look at
>>>>>>>>> the patch to see what goes wrong there.
>>>>>>>>>
>>>>>>>>> Cheers,
>>>>>>>>> -olli
>>>>>>>>>
>>>>>>>>> On 28 January 2016 at 20:57, Jurgen Kramer <gtmkramer@xs4all.nl
>>>>>>>>>> wrote:
>>>>>>>>>>
>>>>>>>>>> Hi Olli,
>>>>>>>>>>
>>>>>>>>>> On Thu, 2016-01-28 at 19:26 +0200, Olli Salonen wrote:
>>>>>>>>>>>
>>>>>>>>>>> Hi Jürgen,
>>>>>>>>>>>
>>>>>>>>>>> Did you get anywhere with this?
>>>>>>>>>>>
>>>>>>>>>>> I have a clone of your card and was just starting to look
>>>>>>>>>>> at this
>>>>>>>>>>> issue. Kernel 3.19 seems to work ok, but 4.3 not. Did you
>>>>>>>>>>> have any
>>>>>>>>>>> time to try to pinpoint this more?
>>>>>>>>>>
>>>>>>>>>> No, unfortunately not. I have spend a few hours adding
>>>>>>>>>> printk's but it
>>>>>>>>>> did not get me any closer what causes the issue. This really
>>>>>>>>>> needs
>>>>>>>>>> investigation from someone who is more familiar with linux
>>>>>>>>>> media.
>>>>>>>>>>
>>>>>>>>>> Last thing I tried was the latest (semi open) drivers from
>>>>>>>>>> dvbsky on a
>>>>>>>>>> 4.3 kernel. Here the CI and CAM registered successfully.
>>>>>>>>>>
>>>>>>>>>> Greetings,
>>>>>>>>>> Jurgen
>>>>>>>>>>
>>>>>>>>>>> Cheers,
>>>>>>>>>>> -olli
>>>>>>>>>>>
>>>>>>>>>>> On 12 September 2015 at 10:02, Jurgen Kramer <gtmkramer@xs4
>>>>>>>>>>> all.nl>
>>>>>>>>>>> wrote:
>>>>>>>>>>>>
>>>>>>>>>>>> On Fri, 2015-09-11 at 22:01 +0200, Torbjorn Jansson
>>>>>>>>>>>> wrote:
>>>>>>>>>>>>>
>>>>>>>>>>>>> On 2015-08-23 19:50, Jurgen Kramer wrote:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> On Sun, 2015-07-12 at 12:38 +0200, Jurgen Kramer
>>>>>>>>>>>>>> wrote:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> I have been running a couple of DVBSky T980C's with
>>>>>>>>>>>>>>> CIs with
>>>>>>>>>>>>>>> success
>>>>>>>>>>>>>>> using an older kernel (3.17.8) with media-build and
>>>>>>>>>>>>>>> some
>>>>>>>>>>>>>>> added patches
>>>>>>>>>>>>>>> from the mailing list.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> I thought lets try a current 4.0 kernel to see if I
>>>>>>>>>>>>>>> no longer
>>>>>>>>>>>>>>> need to be
>>>>>>>>>>>>>>> running a custom kernel. Everything works just fine
>>>>>>>>>>>>>>> except
>>>>>>>>>>>>>>> the CAM
>>>>>>>>>>>>>>> module. I am seeing these:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> [  456.574969] dvb_ca adapter 0: Invalid PC card
>>>>>>>>>>>>>>> inserted :(
>>>>>>>>>>>>>>> [  456.626943] dvb_ca adapter 1: Invalid PC card
>>>>>>>>>>>>>>> inserted :(
>>>>>>>>>>>>>>> [  456.666932] dvb_ca adapter 2: Invalid PC card
>>>>>>>>>>>>>>> inserted :(
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> The normal 'CAM detected and initialised' messages
>>>>>>>>>>>>>>> to do show
>>>>>>>>>>>>>>> up with
>>>>>>>>>>>>>>> 4.0.8
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> I am not sure what changed in the recent kernels,
>>>>>>>>>>>>>>> what is
>>>>>>>>>>>>>>> needed to
>>>>>>>>>>>>>>> debug this?
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> Jurgen
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Retest. I've isolated one T980C on another PC with
>>>>>>>>>>>>>> kernel
>>>>>>>>>>>>>> 4.1.5, still the same 'Invalid PC card inserted :('
>>>>>>>>>>>>>> message.
>>>>>>>>>>>>>> Even after installed today's media_build from git no
>>>>>>>>>>>>>> improvement.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Any hints where to start looking would be
>>>>>>>>>>>>>> appreciated!
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> cimax2.c|h do not seem to have changed. There are
>>>>>>>>>>>>>> changes to
>>>>>>>>>>>>>> dvb_ca_en50221.c
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Jurgen
>>>>>>>>>>>>>>
>>>>>>>>>>>>>
>>>>>>>>>>>>> did you get it to work?
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> No, it needs a thorough debug session. So far no one
>>>>>>>>>>>> seems able to
>>>>>>>>>>>> help...
>>>>>>>>>>>>
>>>>>>>>>>>>> i got a dvbsky T980C too for dvb-t2 reception and so
>>>>>>>>>>>>> far the only
>>>>>>>>>>>>> drivers that have worked at all is the ones from dvbsky
>>>>>>>>>>>>> directly.
>>>>>>>>>>>>>
>>>>>>>>>>>>> i was very happy when i noticed that recent kernels
>>>>>>>>>>>>> have support
>>>>>>>>>>>>> for it
>>>>>>>>>>>>> built in but unfortunately only the modules and
>>>>>>>>>>>>> firmware loads
>>>>>>>>>>>>> but then
>>>>>>>>>>>>> nothing actually works.
>>>>>>>>>>>>> i use mythtv and it complains a lot about the signal,
>>>>>>>>>>>>> running
>>>>>>>>>>>>> femon also
>>>>>>>>>>>>> produces lots of errors.
>>>>>>>>>>>>>
>>>>>>>>>>>>> so i had to switch back to kernel 4.0.4 with mediabuild
>>>>>>>>>>>>> from
>>>>>>>>>>>>> dvbsky.
>>>>>>>>>>>>>
>>>>>>>>>>>>> if there were any other dvb-t2 card with ci support
>>>>>>>>>>>>> that had
>>>>>>>>>>>>> better
>>>>>>>>>>>>> drivers i would change right away.
>>>>>>>>>>>>>
>>>>>>>>>>>>> one problem i have with the mediabuilt from dvbsky is
>>>>>>>>>>>>> that at
>>>>>>>>>>>>> boot the
>>>>>>>>>>>>> cam never works and i have to first tune a channel,
>>>>>>>>>>>>> then remove
>>>>>>>>>>>>> and
>>>>>>>>>>>>> reinstert the cam to get it to work.
>>>>>>>>>>>>> without that nothing works.
>>>>>>>>>>>>>
>>>>>>>>>>>>> and finally a problem i ran into when i tried
>>>>>>>>>>>>> mediabuilt from
>>>>>>>>>>>>> linuxtv.org.
>>>>>>>>>>>>> fedora uses kernel modules with .ko.xz extension so
>>>>>>>>>>>>> when you
>>>>>>>>>>>>> install the
>>>>>>>>>>>>> mediabuilt modulels you get one modulename.ko and one
>>>>>>>>>>>>> modulename.ko.xz
>>>>>>>>>>>>>
>>>>>>>>>>>>> before a make install from mediabuild overwrote the
>>>>>>>>>>>>> needed
>>>>>>>>>>>>> modules.
>>>>>>>>>>>>> any advice on how to handle this now?
>>>>>>>>>>>>>

