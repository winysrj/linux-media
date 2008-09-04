Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KbIci-0004KQ-CD
	for linux-dvb@linuxtv.org; Thu, 04 Sep 2008 19:28:01 +0200
Received: from [212.12.32.49] (helo=smtp.work.de)
	by mail.work.de with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KbIcf-0006BI-0s
	for linux-dvb@linuxtv.org; Thu, 04 Sep 2008 19:27:57 +0200
Received: from [217.164.61.201] (helo=[192.168.1.10])
	by smtp.work.de with esmtpa (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KbIce-0006Zy-IP
	for linux-dvb@linuxtv.org; Thu, 04 Sep 2008 19:27:56 +0200
Message-ID: <48C01A99.402@gmail.com>
Date: Thu, 04 Sep 2008 21:27:53 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48C00822.4030509@gmail.com> <48C01698.4060503@gmail.com>
In-Reply-To: <48C01698.4060503@gmail.com>
Subject: [linux-dvb] Multiproto API/Driver Update
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

Greetings.

First I would like to thank everyone for their patience.  Multiproto
has been under development for some time and I know many of you have
been anxious for its arrival.  I would also like to thank all the
people who've helped code and test the new api.  Last but not least, a
thanks to the app developers who've supported multiproto, and whose
continued support is very much appreciated.

As you might already know, I've been out-of-town for the last few
months and haven't been able to progress multiproto further.  I've now
returned and am glad to announce I've been putting the finishing
touches on the multiproto api, along with many fixes/updates to
supported drivers.  Multiproto has reached a state where it is ready
to be adopted into the kernel and already has a pull request to do so.

Here are some important pieces of information for you to know:

current supported modulations with supported hardware:
DVB-S, DVB-S2, DVB-T, DVB-C, DVB-H

How big is multiproto?
It's not.  It doesn't exceed the size of the legacy api and is infact
smaller when used in non-legacy mode.

Does it support ISDB-T, ATSC-MH, CMMB, DBM-T/H?
Intentionally, no!  Experience with the old api development has proven
that making blind assumptions about delivery systems is a bad idea.
It's better to add in support for these when the hardware actually arrives
and can be properly tested. There is enough reserved space in the api to
support future modulations.

current supported chipsets/devices:
STB0899 based cards (AD SP400/VP-1041, TT S2 3200, KNC1 DVB-S2 etc.)

drivers currently in development:
STB0900/STB0903 based (eg. SAA716x based cards: AD SE-200/VP-1028, etc.)

To clear up some misinformation and misconceptions:

Is multiproto backwards compatible with previously built binaries?
YES!  You don't need to do anything to make it backward compatible.

Does multiproto have support for drivers found in v4l?
YES!  Multiproto includes the v4l tree as well.  However, the software
you use must support the multiproto api in order to use them.
Fortunately many already do but in the event support for the api must
be added, it can usually be done with minor changes.

Are new modulations possible?
YES!  Multiproto has been designed so that adding new future
modulations may be done with minimal effort.  This will help speed up
the driver development process and allow us to use this api for some
time to come.

If you would like to use any of these drivers now, you may pull the
tree from http://jusst.de/hg/multiproto.  Drivers may be configured
with 'make menuconfig' the same as you've done with v4l.

Feedback, bug reports, etc. are welcomed and encouraged!  Please feel
free to
contact me via email at:  abraham.manu@gmail.com

If you have an unsupported device, please let me know!

Best Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
