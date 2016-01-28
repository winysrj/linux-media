Return-path: <linux-media-owner@vger.kernel.org>
Received: from outmx-004.london.gridhost.co.uk ([95.142.156.54]:46937 "EHLO
	outmx-004.london.gridhost.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161307AbcA1R0d convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2016 12:26:33 -0500
Received: from mail-qg0-f43.google.com (unknown [209.85.192.43])
	(Authenticated sender: sendmail@nucblog.net)
	by outmx-004.london.gridhost.co.uk (Postfix) with ESMTPA id 80C7D200F54A5
	for <linux-media@vger.kernel.org>; Thu, 28 Jan 2016 17:26:31 +0000 (GMT)
Received: by mail-qg0-f43.google.com with SMTP id b35so44598219qge.0
        for <linux-media@vger.kernel.org>; Thu, 28 Jan 2016 09:26:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1442041326.2442.2.camel@xs4all.nl>
References: <1436697509.2446.14.camel@xs4all.nl>
	<1440352250.13381.3.camel@xs4all.nl>
	<55F332FE.7040201@mbox200.swipnet.se>
	<1442041326.2442.2.camel@xs4all.nl>
Date: Thu, 28 Jan 2016 19:26:30 +0200
Message-ID: <CAAZRmGxvrXjanCTcd0Ybk-qzHhqO5e6JhrpSWxNXSa+zzPsdUg@mail.gmail.com>
Subject: Re: DVBSky T980C CI issues (kernel 4.0.x)
From: Olli Salonen <olli.salonen@iki.fi>
To: Jurgen Kramer <gtmkramer@xs4all.nl>
Cc: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jürgen,

Did you get anywhere with this?

I have a clone of your card and was just starting to look at this
issue. Kernel 3.19 seems to work ok, but 4.3 not. Did you have any
time to try to pinpoint this more?

Cheers,
-olli

On 12 September 2015 at 10:02, Jurgen Kramer <gtmkramer@xs4all.nl> wrote:
> On Fri, 2015-09-11 at 22:01 +0200, Torbjorn Jansson wrote:
>> On 2015-08-23 19:50, Jurgen Kramer wrote:
>> >
>> > On Sun, 2015-07-12 at 12:38 +0200, Jurgen Kramer wrote:
>> >> I have been running a couple of DVBSky T980C's with CIs with success
>> >> using an older kernel (3.17.8) with media-build and some added patches
>> >> from the mailing list.
>> >>
>> >> I thought lets try a current 4.0 kernel to see if I no longer need to be
>> >> running a custom kernel. Everything works just fine except the CAM
>> >> module. I am seeing these:
>> >>
>> >> [  456.574969] dvb_ca adapter 0: Invalid PC card inserted :(
>> >> [  456.626943] dvb_ca adapter 1: Invalid PC card inserted :(
>> >> [  456.666932] dvb_ca adapter 2: Invalid PC card inserted :(
>> >>
>> >> The normal 'CAM detected and initialised' messages to do show up with
>> >> 4.0.8
>> >>
>> >> I am not sure what changed in the recent kernels, what is needed to
>> >> debug this?
>> >>
>> >> Jurgen
>> > Retest. I've isolated one T980C on another PC with kernel 4.1.5, still the same 'Invalid PC card inserted :(' message.
>> > Even after installed today's media_build from git no improvement.
>> >
>> > Any hints where to start looking would be appreciated!
>> >
>> > cimax2.c|h do not seem to have changed. There are changes to
>> > dvb_ca_en50221.c
>> >
>> > Jurgen
>> >
>>
>> did you get it to work?
>
> No, it needs a thorough debug session. So far no one seems able to
> help...
>
>> i got a dvbsky T980C too for dvb-t2 reception and so far the only
>> drivers that have worked at all is the ones from dvbsky directly.
>>
>> i was very happy when i noticed that recent kernels have support for it
>> built in but unfortunately only the modules and firmware loads but then
>> nothing actually works.
>> i use mythtv and it complains a lot about the signal, running femon also
>> produces lots of errors.
>>
>> so i had to switch back to kernel 4.0.4 with mediabuild from dvbsky.
>>
>> if there were any other dvb-t2 card with ci support that had better
>> drivers i would change right away.
>>
>> one problem i have with the mediabuilt from dvbsky is that at boot the
>> cam never works and i have to first tune a channel, then remove and
>> reinstert the cam to get it to work.
>> without that nothing works.
>>
>> and finally a problem i ran into when i tried mediabuilt from linuxtv.org.
>> fedora uses kernel modules with .ko.xz extension so when you install the
>> mediabuilt modulels you get one modulename.ko and one modulename.ko.xz
>>
>> before a make install from mediabuild overwrote the needed modules.
>> any advice on how to handle this now?
>>
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
