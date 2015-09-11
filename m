Return-path: <linux-media-owner@vger.kernel.org>
Received: from v-smtpgw2.han.skanova.net ([81.236.60.205]:40421 "EHLO
	v-smtpgw2.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbbIKUHJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 16:07:09 -0400
Subject: Re: DVBSky T980C CI issues (kernel 4.0.x)
To: Jurgen Kramer <gtmkramer@xs4all.nl>, linux-media@vger.kernel.org
References: <1436697509.2446.14.camel@xs4all.nl>
 <1440352250.13381.3.camel@xs4all.nl>
From: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Message-ID: <55F332FE.7040201@mbox200.swipnet.se>
Date: Fri, 11 Sep 2015 22:01:02 +0200
MIME-Version: 1.0
In-Reply-To: <1440352250.13381.3.camel@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2015-08-23 19:50, Jurgen Kramer wrote:
>
> On Sun, 2015-07-12 at 12:38 +0200, Jurgen Kramer wrote:
>> I have been running a couple of DVBSky T980C's with CIs with success
>> using an older kernel (3.17.8) with media-build and some added patches
>> from the mailing list.
>>
>> I thought lets try a current 4.0 kernel to see if I no longer need to be
>> running a custom kernel. Everything works just fine except the CAM
>> module. I am seeing these:
>>
>> [  456.574969] dvb_ca adapter 0: Invalid PC card inserted :(
>> [  456.626943] dvb_ca adapter 1: Invalid PC card inserted :(
>> [  456.666932] dvb_ca adapter 2: Invalid PC card inserted :(
>>
>> The normal 'CAM detected and initialised' messages to do show up with
>> 4.0.8
>>
>> I am not sure what changed in the recent kernels, what is needed to
>> debug this?
>>
>> Jurgen
> Retest. I've isolated one T980C on another PC with kernel 4.1.5, still the same 'Invalid PC card inserted :(' message.
> Even after installed today's media_build from git no improvement.
>
> Any hints where to start looking would be appreciated!
>
> cimax2.c|h do not seem to have changed. There are changes to
> dvb_ca_en50221.c
>
> Jurgen
>

did you get it to work?

i got a dvbsky T980C too for dvb-t2 reception and so far the only 
drivers that have worked at all is the ones from dvbsky directly.

i was very happy when i noticed that recent kernels have support for it 
built in but unfortunately only the modules and firmware loads but then 
nothing actually works.
i use mythtv and it complains a lot about the signal, running femon also 
produces lots of errors.

so i had to switch back to kernel 4.0.4 with mediabuild from dvbsky.

if there were any other dvb-t2 card with ci support that had better 
drivers i would change right away.

one problem i have with the mediabuilt from dvbsky is that at boot the 
cam never works and i have to first tune a channel, then remove and 
reinstert the cam to get it to work.
without that nothing works.

and finally a problem i ran into when i tried mediabuilt from linuxtv.org.
fedora uses kernel modules with .ko.xz extension so when you install the 
mediabuilt modulels you get one modulename.ko and one modulename.ko.xz

before a make install from mediabuild overwrote the needed modules.
any advice on how to handle this now?


