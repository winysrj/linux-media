Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from eeyore.nlsn.nu ([213.115.133.58])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dlist2@nlsn.nu>) id 1Jezg6-0000AX-9u
	for linux-dvb@linuxtv.org; Thu, 27 Mar 2008 22:30:33 +0100
Date: Thu, 27 Mar 2008 22:30:23 +0100 (CET)
From: dlist2@nlsn.nu
To: Sigmund Augdal <sigmund@snap.tv>
In-Reply-To: <1206610705.12385.7.camel@rommel.snap.tv>
Message-ID: <Pine.LNX.4.64.0803272228070.9456@eeyore.nlsn.nu>
References: <Pine.LNX.4.64.0803201256390.4638@eeyore.nlsn.nu>
	<1206610705.12385.7.camel@rommel.snap.tv>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT-Budget C-1501 not working
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

I agree, but I dont have the skills to glue it...
But I can compile, test and report back results if someone can help 
remote.

  Daniel

On Thu, 27 Mar 2008, Sigmund Augdal wrote:

> According to this forum post:
> http://www.dvbviewer.info/forum/index.php?showtopic=24366
> 
> The card uses the tda10023 demod (for which there is a driver in the
> sources) and a tda8274A tuner (which the tda827x driver hopefully will
> handle). So all that should be needed is some glue code.
> 
> Sigmund
> 
> 
> tor, 20.03.2008 kl. 12.56 +0100, skrev dlist2@nlsn.nu:
> > Hi,
> > 
> > I just purchased a Technotrend Budget C-1501.
> > Im running Mythbuntu Beta, and downloaded the latest v4l drivers but it 
> > still fails.
> > 
> > lspci -v
> > 
> > 05:04.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
> >         Subsystem: Technotrend Systemtechnik GmbH Unknown device 101a
> >         Flags: bus master, medium devsel, latency 66, IRQ 5
> >         Memory at fc501000 (32-bit, non-prefetchable) [size=512]
> > 
> > lspci -n
> > 
> > 05:04.0 0480: 1131:7146 (rev 01)
> >         Subsystem: 13c2:101a
> >         Flags: bus master, medium devsel, latency 66, IRQ 5
> >         Memory at fc501000 (32-bit, non-prefetchable) [size=512]
> > 
> > log says
> > 
> >  kernel: [   54.207308] Linux video capture  interface: v2.00
> >  kernel: [   54.501753] saa7146: register extension 'dvb'.
> >  runvdr: stopping after fatal fail (vdr: warning - cannot set dumpable: Invalid argument vdr: no primary device found - using 
> > first device!)
> > 
> > And /dev/dvb is empty of course.
> > Im not a kernel hacker, but if you have any hits on how to get this card 
> > working please let me know.
> > 
> > Thanks
> > 
> >   Daniel
> > 
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > 
> 
> 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
