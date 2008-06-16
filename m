Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fmmailgate01.web.de ([217.72.192.221])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <SiestaGomez@web.de>) id 1K8JKY-0004s5-Se
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 20:21:27 +0200
Received: from smtp07.web.de (fmsmtp07.dlan.cinetic.de [172.20.5.215])
	by fmmailgate01.web.de (Postfix) with ESMTP id 71BFAE441F3F
	for <linux-dvb@linuxtv.org>; Mon, 16 Jun 2008 20:20:53 +0200 (CEST)
Received: from [88.152.136.212] (helo=midian.waldorf.intern)
	by smtp07.web.de with asmtp (WEB.DE 4.109 #226) id 1K8JK1-000328-00
	for linux-dvb@linuxtv.org; Mon, 16 Jun 2008 20:20:53 +0200
Date: Mon, 16 Jun 2008 20:20:53 +0200
From: SG <SiestaGomez@web.de>
To: linux-dvb@linuxtv.org
Message-Id: <20080616202053.f7883c6d.SiestaGomez@web.de>
In-Reply-To: <20080616194256.cc5f9a55.SiestaGomez@web.de>
References: <20080615192300.90886244.SiestaGomez@web.de>
	<4855F6B0.8060507@gmail.com> <1213620050.6543.6.camel@pascal>
	<20080616142616.75F9C3BC99@waldorfmail.homeip.net>
	<1213626832.6543.23.camel@pascal>
	<20080616194256.cc5f9a55.SiestaGomez@web.de>
Mime-Version: 1.0
Subject: Re: [linux-dvb] [PATCH] experimental support for C-1501
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

On Mon, 16 Jun 2008 19:42:56 +0200
SG <SiestaGomez@web.de> wrote:

> On Mon, 16 Jun 2008 16:33:52 +0200
> Sigmund Augdal <sigmund@snap.tv> wrote:
> 
> > On Mon, 2008-06-16 at 16:26 +0200, siestagomez@web.de wrote:
> > > Sigmund Augdal schrieb: 
> > > 
> > > > On Mon, 2008-06-16 at 08:14 +0300, Arthur Konovalov wrote:
> > > >> SG wrote:
> > > >> > The patch works quite well and nearly all channels seem to work.
> > > >> > 
> > > >> > But when tuning to some radio channels I'll get this kernel message:
> > > >> > 
> > > >> > saa7146 (0) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
> > > >> > 
> > > >> > Also I'm not able to tune to 'transponder 386000000 6900000 0 3' which works
> > > >> > smoothly when using Win32.
> > > >> > 
> > > >> > initial transponder 386000000 6900000 0 3
> > > >> >  >>> tune to: 386:M64:C:6900:
> > > >> > WARNING: >>> tuning failed!!!
> > > >> >  >>> tune to: 386:M64:C:6900: (tuning failed)
> > > >> > WARNING: >>> tuning failed!!!
> > > >> > ERROR: initial tuning failed
> > > >> > dumping lists (0 services)
> > > >> > Done. 
> > > >> 
> > > >> Yes, I discovered too that tuning to frequency 386MHz has no lock.
> > > >> VDR channels.conf: TV3:386000:C0M64:C:6875:703:803:0:0:1003:16:1:0 
> > > >> 
> > > >> At same time, 394MHz (and others) works.
> > > > Hi. 
> > > > 
> > > > Both transponders reported to not tune here has different symbolrates
> > > > from what I used for my testing. Maybe this is relevant in some way.
> > > > Could you please compare this with the channels that did tune to see if
> > > > there is a pattern? 
> > > > 
> > > > About the i2c message, I get that every now and then here as well, but I
> > > > have not seen any ill effect from it. I also see that on some other TT
> > > > cards so I think that might be unrelated to the demod/tuner. 
> > > > 
> > > > Regards 
> > > > 
> > > > Sigmund Augdal
> > > 
> > > The symbolrate is the same on all other working channels. 
> > > 
> > > Regarding the i2c message when watching video I'll get this only once but 
> > > when tuning to a radio channel my log gets flooded and it seems to hangup. 
> > How does radio or not make a difference? As far as I know the card is
> > DVB only and should not care whether the tuned transponder contains
> > radio or video or whatever. Could you send a list of transponders that
> > work (with tuning parameters) and ones that doesn't?
> > 
> 
> Odd today no problem with radio and kernel log.
> Anyway here are a few entries from transponder.ini which I use for dvbscan:
> C 362000000 6900000 NONE QAM64		OK
> C 370000000 6900000 NONE QAM64		OK
> C 378000000 6900000 NONE QAM64		OK
> C 386000000 6900000 NONE QAM64		NOT OK
> C 394000000 6900000 NONE QAM64		OK
> C 402000000 6900000 NONE QAM256		NOT OK
> C 410000000 6900000 NONE QAM64		OK
> C 426000000 6900000 NONE QAM64		OK
> 
> I noticed when using Win32 the signal strenght is very poor on the non working transponders for linux-dvb.
> Perhaps it's enough for Win32 but not for the linux driver.
> 
> Regards
> Martin
> 

Hi 

I just added a line to get the bundled IR-remote to work using lirc.


--- a/linux/drivers/media/dvb/ttpci/budget-ci.c 2008-06-16 19:58:04.000000000 +0200
+++ b/linux/drivers/media/dvb/ttpci/budget-ci.c 2008-06-08 17:19:39.000000000 +0200
@@ -237,6 +237,7 @@
        break;
    case 0x1010:
    case 0x1017:
+   case 0x101a:
        /* for the Technotrend 1500 bundled remote */
        ir_input_init(input_dev, &budget_ci->ir.state,
                  IR_TYPE_RC5, ir_codes_tt_1500);


Regards
Martin




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
