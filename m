Return-path: <linux-media-owner@vger.kernel.org>
Received: from outmx-006.london.gridhost.co.uk ([95.142.156.174]:40226 "EHLO
	outmx-006.london.gridhost.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755252AbcBPUUS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2016 15:20:18 -0500
Received: from mail-qk0-f174.google.com (unknown [209.85.220.174])
	(Authenticated sender: sendmail@nucblog.net)
	by outmx-006.london.gridhost.co.uk (Postfix) with ESMTPA id 12E0287A552
	for <linux-media@vger.kernel.org>; Tue, 16 Feb 2016 20:20:15 +0000 (GMT)
Received: by mail-qk0-f174.google.com with SMTP id s5so71602700qkd.0
        for <linux-media@vger.kernel.org>; Tue, 16 Feb 2016 12:20:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56ADCBE4.6050609@mbox200.swipnet.se>
References: <1436697509.2446.14.camel@xs4all.nl>
	<1440352250.13381.3.camel@xs4all.nl>
	<55F332FE.7040201@mbox200.swipnet.se>
	<1442041326.2442.2.camel@xs4all.nl>
	<CAAZRmGxvrXjanCTcd0Ybk-qzHhqO5e6JhrpSWxNXSa+zzPsdUg@mail.gmail.com>
	<1454007436.13371.4.camel@xs4all.nl>
	<CAAZRmGwuinufZpCpTs8t+BRyTcfio-4z34PCKH7Ha3J+dxXNqw@mail.gmail.com>
	<56ADCBE4.6050609@mbox200.swipnet.se>
Date: Tue, 16 Feb 2016 22:20:15 +0200
Message-ID: <CAAZRmGy21S+qkrC9d0hz02J98woUc9p+LtnhK8Det=yWmb_myg@mail.gmail.com>
Subject: Re: DVBSky T980C CI issues (kernel 4.0.x)
From: Olli Salonen <olli.salonen@iki.fi>
To: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Cc: Jurgen Kramer <gtmkramer@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Found the issue and submitted a patch.

The I2C buses for T980C/T2-4500CI were crossed when CI registration
was moved to its own function.

Cheers,
-olli

On 31 January 2016 at 10:55, Torbjorn Jansson
<torbjorn.jansson@mbox200.swipnet.se> wrote:
> this ci problem is the reason i decided to buy the CT2-4650 usb based device
> instead.
> but the 4650 was a slightly newer revision needing a patch i submitted
> earlier.
> and also this 4650 device does not have auto switching between dvb-t and t2
> like the dvbsky card have, so i also need an updated version of mythtv.
>
> my long term wish is to not have to patch things or build custom kernels or
> modules.
> so anything done to improve the dvbsky card or the 4650 is much appreciated.
>
>
> On 2016-01-28 20:42, Olli Salonen wrote:
>>
>> Hi Jürgen & Mauro,
>>
>> I did bisect this and it seems this rather big patch broke it:
>>
>> 2b0aac3011bc7a9db27791bed4978554263ef079 is the first bad commit
>> commit 2b0aac3011bc7a9db27791bed4978554263ef079
>> Author: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>> Date:   Tue Dec 23 13:48:07 2014 -0200
>>
>>      [media] cx23885: move CI/MAC registration to a separate function
>>
>>      As reported by smatch:
>>          drivers/media/pci/cx23885/cx23885-dvb.c:2080 dvb_register()
>> Function too hairy.  Giving up.
>>
>>      This is indeed a too complex function, with lots of stuff inside.
>>      Breaking this into two functions makes it a little bit less hairy.
>>
>>      Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>
>> It's getting a bit late, so I'll call it a day now and have a look at
>> the patch to see what goes wrong there.
>>
>> Cheers,
>> -olli
>>
>> On 28 January 2016 at 20:57, Jurgen Kramer <gtmkramer@xs4all.nl> wrote:
>>>
>>> Hi Olli,
>>>
>>> On Thu, 2016-01-28 at 19:26 +0200, Olli Salonen wrote:
>>>>
>>>> Hi Jürgen,
>>>>
>>>> Did you get anywhere with this?
>>>>
>>>> I have a clone of your card and was just starting to look at this
>>>> issue. Kernel 3.19 seems to work ok, but 4.3 not. Did you have any
>>>> time to try to pinpoint this more?
>>>
>>> No, unfortunately not. I have spend a few hours adding printk's but it
>>> did not get me any closer what causes the issue. This really needs
>>> investigation from someone who is more familiar with linux media.
>>>
>>> Last thing I tried was the latest (semi open) drivers from dvbsky on a
>>> 4.3 kernel. Here the CI and CAM registered successfully.
>>>
>>> Greetings,
>>> Jurgen
>>>
>>>> Cheers,
>>>> -olli
>>>>
>>>> On 12 September 2015 at 10:02, Jurgen Kramer <gtmkramer@xs4all.nl>
>>>> wrote:
>>>>>
>>>>> On Fri, 2015-09-11 at 22:01 +0200, Torbjorn Jansson wrote:
>>>>>>
>>>>>> On 2015-08-23 19:50, Jurgen Kramer wrote:
>>>>>>>
>>>>>>>
>>>>>>> On Sun, 2015-07-12 at 12:38 +0200, Jurgen Kramer wrote:
>>>>>>>>
>>>>>>>> I have been running a couple of DVBSky T980C's with CIs with
>>>>>>>> success
>>>>>>>> using an older kernel (3.17.8) with media-build and some
>>>>>>>> added patches
>>>>>>>> from the mailing list.
>>>>>>>>
>>>>>>>> I thought lets try a current 4.0 kernel to see if I no longer
>>>>>>>> need to be
>>>>>>>> running a custom kernel. Everything works just fine except
>>>>>>>> the CAM
>>>>>>>> module. I am seeing these:
>>>>>>>>
>>>>>>>> [  456.574969] dvb_ca adapter 0: Invalid PC card inserted :(
>>>>>>>> [  456.626943] dvb_ca adapter 1: Invalid PC card inserted :(
>>>>>>>> [  456.666932] dvb_ca adapter 2: Invalid PC card inserted :(
>>>>>>>>
>>>>>>>> The normal 'CAM detected and initialised' messages to do show
>>>>>>>> up with
>>>>>>>> 4.0.8
>>>>>>>>
>>>>>>>> I am not sure what changed in the recent kernels, what is
>>>>>>>> needed to
>>>>>>>> debug this?
>>>>>>>>
>>>>>>>> Jurgen
>>>>>>>
>>>>>>> Retest. I've isolated one T980C on another PC with kernel
>>>>>>> 4.1.5, still the same 'Invalid PC card inserted :(' message.
>>>>>>> Even after installed today's media_build from git no
>>>>>>> improvement.
>>>>>>>
>>>>>>> Any hints where to start looking would be appreciated!
>>>>>>>
>>>>>>> cimax2.c|h do not seem to have changed. There are changes to
>>>>>>> dvb_ca_en50221.c
>>>>>>>
>>>>>>> Jurgen
>>>>>>>
>>>>>>
>>>>>> did you get it to work?
>>>>>
>>>>>
>>>>> No, it needs a thorough debug session. So far no one seems able to
>>>>> help...
>>>>>
>>>>>> i got a dvbsky T980C too for dvb-t2 reception and so far the only
>>>>>> drivers that have worked at all is the ones from dvbsky directly.
>>>>>>
>>>>>> i was very happy when i noticed that recent kernels have support
>>>>>> for it
>>>>>> built in but unfortunately only the modules and firmware loads
>>>>>> but then
>>>>>> nothing actually works.
>>>>>> i use mythtv and it complains a lot about the signal, running
>>>>>> femon also
>>>>>> produces lots of errors.
>>>>>>
>>>>>> so i had to switch back to kernel 4.0.4 with mediabuild from
>>>>>> dvbsky.
>>>>>>
>>>>>> if there were any other dvb-t2 card with ci support that had
>>>>>> better
>>>>>> drivers i would change right away.
>>>>>>
>>>>>> one problem i have with the mediabuilt from dvbsky is that at
>>>>>> boot the
>>>>>> cam never works and i have to first tune a channel, then remove
>>>>>> and
>>>>>> reinstert the cam to get it to work.
>>>>>> without that nothing works.
>>>>>>
>>>>>> and finally a problem i ran into when i tried mediabuilt from
>>>>>> linuxtv.org.
>>>>>> fedora uses kernel modules with .ko.xz extension so when you
>>>>>> install the
>>>>>> mediabuilt modulels you get one modulename.ko and one
>>>>>> modulename.ko.xz
>>>>>>
>>>>>> before a make install from mediabuild overwrote the needed
>>>>>> modules.
>>>>>> any advice on how to handle this now?
>>>>>>
>>>>>>
>>>>>
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-
>>>>> media" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
