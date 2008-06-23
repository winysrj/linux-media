Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web53206.mail.re2.yahoo.com ([206.190.49.76])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <deloptes@yahoo.com>) id 1KAqGu-0004m3-3t
	for linux-dvb@linuxtv.org; Mon, 23 Jun 2008 19:56:09 +0200
Date: Mon, 23 Jun 2008 10:54:43 -0700 (PDT)
From: Emanoil Kotsev <deloptes@yahoo.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <mailman.65.1214228554.883.linux-dvb@linuxtv.org>
MIME-Version: 1.0
Message-ID: <77331.9483.qm@web53206.mail.re2.yahoo.com>
Subject: Re: [linux-dvb] Getting Avermedia AverTV E506 DVB-T to work
Reply-To: deloptes@yahoo.com
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



> >
> > I am struggling to enjoy DVB-T on my AverTV E506
> PCMCIA card. It seams
> > I'm doing something terribly wrong but I cannot
> find the solution on my
> > own. I am grateful for any help provided.

which program are you using for TV (I'm using kplayer that runs mplayer)

> >
> > What I did so far:
> >
> > I'm running Gentoo with a 2.6.24-r8 kernel on my
> Centrino Laptop. I have
> > selected "Video for Linux" (nothing else, no
> cards, no frontends, no
> > chips..) as a module in my kernel configuration and
> compiled the
> > "v4l-dvb" drivers from the mercurial
> repository. I also have obtained
> > the (hopefully) correct firmware for my card.
> >
> > Well when I plug the PCMCIA device in this is what
> dmesg shows me:

This one seems to be OK.

> > xc2028 5-0061: creating new instance
> > xc2028 5-0061: type set to XCeive xc2028/xc3028 tuner
> > xc2028 5-0061: Loading 80 firmware images from
> xc3028-v27.fw, type:
> > xc2028 firmware, ver 2.7
> > xc2028 5-0061: Loading firmware for type=BASE F8MHZ
> (3), id
> > 0000000000000000.
> > (0), id 00000000000000ff:
> > xc2028 5-0061: Loading firmware for type=(0), id
> 0000000100000007.
> > SCODE (20000000), id 0000000100000007:
> > xc2028 5-0061: Loading SCODE for type=MONO SCODE
> HAS_IF_5320 (60008000),
> > id 0000000800000007.
> > saa7133[0]: registered device video0 [v4l2]
> > saa7133[0]: registered device vbi0
> > saa7133[0]: registered device radio0
> >
> > Analog TV works with this setup, but I have no signs
> of DVB-T. No
> > /dev/dvb devices are created although the module for

Your DVB device is vbi0

/dev/vbi0

see the last lines from your dmsg

I've tried vlc too it works also very well. You just have to point your tv app to read from vbi0

I think this is your problem

regards



      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
