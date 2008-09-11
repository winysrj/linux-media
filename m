Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web38807.mail.mud.yahoo.com ([209.191.125.98])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <urishk@yahoo.com>) id 1Kdezi-0001Ve-8o
	for linux-dvb@linuxtv.org; Thu, 11 Sep 2008 07:45:33 +0200
Date: Wed, 10 Sep 2008 22:44:56 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
To: linux-dvb@linuxtv.org, Andreas Oberritter <obi@linuxtv.org>
In-Reply-To: <48C89D12.4060207@linuxtv.org>
MIME-Version: 1.0
Message-ID: <288726.58958.qm@web38807.mail.mud.yahoo.com>
Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation support
Reply-To: urishk@yahoo.com
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




--- On Thu, 9/11/08, Andreas Oberritter <obi@linuxtv.org> wrote:

> From: Andreas Oberritter <obi@linuxtv.org>
> Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation support
> To: linux-dvb@linuxtv.org
> Date: Thursday, September 11, 2008, 7:22 AM
> Steven Toth wrote:
> > Christophe Thommeret wrote:
> >> Sounds logical. And that's why Kaffeine search
> for frontend/demux/dvr > 0 and 
> >> uses demux1 with frontend1. (That was just a guess
> since i've never seen 
> >> neither any such devices nor
> comments/recommendations/rules about such case).
> >>
> >> However, all dual tuners devices drivers i know
> expose the 2 frontends as 
> >> frontend0 in separate adapters. But all these
> devices seems to be USB.
> 
> The way I described is used on dual and quad tuner Dreambox
> models.
> 
> >> The fact that Kaffeine works with the experimental
> hvr4000 drier indicates 
> >> that this driver populates frontend1/demux1/dvr1
> and then doesn't follow the 
> >> way you describe (since the tuners can't be
> used at once).
> >> I would like to hear from Steve on this point.
> >>
> >>
> > 
> > Correct, frontend1, demux1, dvr1 etc. All on the same
> adapter. The 
> > driver and multi-frontend patches manage exclusive
> access to the single 
> > internal resource.
> 
> How about dropping demux1 and dvr1 for this adapter, since
> they don't
> create any benefit? IMHO the number of demux devices should
> always equal
> the number of simultaneously usable transport stream
> inputs.
> 
> Regards,
> Andreas
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

My input for this -

Some of the hardware devices which using our chipset have two tuners per instance, and should expose 1-2 tuners with 0-2 demux (TS), since not all DTV standard are TS based, and when they are (TS based), it depends when you are using two given tuners together (diversity  mode, same content) or each one is used separately (different frequency and modulation, different content, etc.). 

Those hardware devices can use various bus interfaces - SDIO, USB, SPI, TS, I2C, HIF.....


Uri Shkolnik
Software Architect
Siano Mobile Silicon


      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
