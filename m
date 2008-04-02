Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1JgqX1-00036y-GQ
	for linux-dvb@linuxtv.org; Wed, 02 Apr 2008 02:08:48 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Another Sillyname <anothersname@googlemail.com>
In-Reply-To: <a413d4880804011641v1d20ebabo376d2b41b179b022@mail.gmail.com>
References: <a413d4880803301640u20b77b9cya5a812efec8ee25c@mail.gmail.com>
	<c8b4dbe10803311302n6edc8d0dtb1f816099e020946@mail.gmail.com>
	<d9def9db0803311559p3b4fe2a7gfb20477a2ac47144@mail.gmail.com>
	<c8b4dbe10804011406i6923397fw84de9393335dfee9@mail.gmail.com>
	<a413d4880804011641v1d20ebabo376d2b41b179b022@mail.gmail.com>
Date: Wed, 02 Apr 2008 02:08:32 +0200
Message-Id: <1207094912.7980.4.camel@pc08.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Lifeview DVB-T from v4l-dvb and Pinnacle Hybrid	USb
	from v4l-dvb-kernel......help
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

Hi,

Am Mittwoch, den 02.04.2008, 00:41 +0100 schrieb Another Sillyname:
> Aidan
> 
> So are you working on integrating the em28xx devices that are working
> in v4l-dvb-kernel version into v4l-dvb (or ever your own version of
> same)?
> 
> Or will it require changes to too much code?
> 
> I have to say as a user/observer I find it ridiculous that there are
> two branches of working code that are pretty close to the same and
> won't work with each other.  If there's one area that Linux really
> clearly pi**es on Windows it's the handling of media and stuff like
> this just switches people off.
> 
> While not looking at the code or drawing any conclusions therein a new
> layer on top of v4l-dvb (whichever version) seems counter productive
> to me.
> 
> Ho hum.....can someone please just tell me how to get my kit working
> without having to re-invent the wheel.
> 
> Thanks in advance.
> 
> J
> 

did not look up what Markus currently has, but as a interim solution,
did you try modprobe/options saa7134 card=94 for the LifeView DVB-T?

Basically we have support for such kind of cards since longer, should
not be that difficult to get in in as a workaround for now.

Cheers,
Hermann





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
