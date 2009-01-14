Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1LMwGx-000680-6c
	for linux-dvb@linuxtv.org; Wed, 14 Jan 2009 04:18:29 +0100
From: hermann pitton <hermann-pitton@arcor.de>
To: Robin Perkins <robin.perkins@internode.on.net>
In-Reply-To: <4FBB1DE4-17DA-4F3B-9FF6-9B076D4D7803@internode.on.net>
References: <8CB43CAAC52A98D-680-A5D@MBLK-M28.sysops.aol.com>
	<4FBB1DE4-17DA-4F3B-9FF6-9B076D4D7803@internode.on.net>
Date: Wed, 14 Jan 2009 04:18:15 +0100
Message-Id: <1231903095.7435.50.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compro T750
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

Hello,

Am Mittwoch, den 14.01.2009, 12:36 +1000 schrieb Robin Perkins:
> On 14/01/2009, at 5:17 AM, td9678td@aim.com wrote:
> 
> > Hello,
> >
> > i writing a small application, that shuts down the pc, if there isn't
> > any scheduled recording. For this i would like to use the wakeup
> > feature of this card, because the acpi (nvram) wakeup doesn't seem to
> > work on my pc. There was alredy an attempt to support this card:
> > http://www.linuxtv.org/pipermail/linux-dvb/2007-April/017001.html
> > Can someone help me, howto program the counter on this card (under
> > Linux or Windows)?
> >
> > Regards
> > Daniel
> 
> Hello Daniel,
> 
> I'm currently trying to write a driver for the Compro Videomate T220  
> which I understand is in the same series as your T750 (and also  
> includes the T100). I created a wiki page for my card at http://www.linuxtv.org/wiki/index.php/Compro_VideoMate_DVB-T220 
>   and was just wondering if you could please do the same for your card  
> just so that I can get some idea about the similarities/differences  
> between our cards. At this stage my priority is just getting the card  
> to tune, however my card has the power feature as well and it would be  
> nice to include it at some later stage.
> 
> Thanks,
> 
> Rob
> 

that is a long story and very unpleasant for Compro customers and all
trying to help.

You can't trust on PCI subsystem detection at all with those cards and
we will kick them out soon of auto detection, because of that.

Like many other manufacturers they enjoy some freedom to mislead their
customers by abusing the PCI subsystem, being the same for very
different cards, which leads to kicking out potential rivals by
introducing to be exclusive/incompatible on m$, mostly going away from
trusted conventions by for example changing tuner type enumeration in
the eeprom. (install compro and uninstall all others ;)

In fact they don't have any driver at all themselves, just that little
clock chip.

We would prefer if they would start to clean up their stuff according
the eeprom conventions they are using ;)

Cheers,
Hermann



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
