Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay.chp.ru ([213.170.120.254] helo=ns.chp.ru)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1KbJZR-0001gn-NP
	for linux-dvb@linuxtv.org; Thu, 04 Sep 2008 20:28:43 +0200
Received: from cherep2.ptl.ru (localhost.ptl.ru [127.0.0.1])
	by cherep.quantum.ru (Postfix) with SMTP id 579B019E6D5B
	for <linux-dvb@linuxtv.org>; Thu,  4 Sep 2008 22:28:07 +0400 (MSD)
Received: from localhost.localdomain (unknown [213.170.123.250])
	by ns.chp.ru (Postfix) with ESMTP id 0D0BF19E6543
	for <linux-dvb@linuxtv.org>; Thu,  4 Sep 2008 22:28:07 +0400 (MSD)
Date: Thu, 4 Sep 2008 22:38:27 +0400
From: Goga777 <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Message-ID: <20080904223827.1b92f2d7@bk.ru>
In-Reply-To: <48C01A99.402@gmail.com>
References: <48C00822.4030509@gmail.com> <48C01698.4060503@gmail.com>
	<48C01A99.402@gmail.com>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Multiproto API/Driver Update
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

Hi, Manu

is it possible to patch scan2 for dvb-s2 support ?

Goga

> Greetings.
> 
> First I would like to thank everyone for their patience.  Multiproto
> has been under development for some time and I know many of you have
> been anxious for its arrival.  I would also like to thank all the
> people who've helped code and test the new api.  Last but not least, a
> thanks to the app developers who've supported multiproto, and whose
> continued support is very much appreciated.
> 
> As you might already know, I've been out-of-town for the last few
> months and haven't been able to progress multiproto further.  I've now
> returned and am glad to announce I've been putting the finishing
> touches on the multiproto api, along with many fixes/updates to
> supported drivers.  Multiproto has reached a state where it is ready
> to be adopted into the kernel and already has a pull request to do so.
> 
> Here are some important pieces of information for you to know:
> 
> current supported modulations with supported hardware:
> DVB-S, DVB-S2, DVB-T, DVB-C, DVB-H
> 
> How big is multiproto?
> It's not.  It doesn't exceed the size of the legacy api and is infact
> smaller when used in non-legacy mode.
> 
> Does it support ISDB-T, ATSC-MH, CMMB, DBM-T/H?
> Intentionally, no!  Experience with the old api development has proven
> that making blind assumptions about delivery systems is a bad idea.
> It's better to add in support for these when the hardware actually arrives
> and can be properly tested. There is enough reserved space in the api to
> support future modulations.
> 
> current supported chipsets/devices:
> STB0899 based cards (AD SP400/VP-1041, TT S2 3200, KNC1 DVB-S2 etc.)
> 
> drivers currently in development:
> STB0900/STB0903 based (eg. SAA716x based cards: AD SE-200/VP-1028, etc.)
> 
> To clear up some misinformation and misconceptions:
> 
> Is multiproto backwards compatible with previously built binaries?
> YES!  You don't need to do anything to make it backward compatible.
> 
> Does multiproto have support for drivers found in v4l?
> YES!  Multiproto includes the v4l tree as well.  However, the software
> you use must support the multiproto api in order to use them.
> Fortunately many already do but in the event support for the api must
> be added, it can usually be done with minor changes.
> 
> Are new modulations possible?
> YES!  Multiproto has been designed so that adding new future
> modulations may be done with minimal effort.  This will help speed up
> the driver development process and allow us to use this api for some
> time to come.
> 
> If you would like to use any of these drivers now, you may pull the
> tree from http://jusst.de/hg/multiproto.  Drivers may be configured
> with 'make menuconfig' the same as you've done with v4l.
> 
> Feedback, bug reports, etc. are welcomed and encouraged!  Please feel
> free to
> contact me via email at:  abraham.manu@gmail.com
> 
> If you have an unsupported device, please let me know!
> 
> Best Regards,
> Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
