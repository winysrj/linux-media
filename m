Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bane.moelleritberatung.de ([77.37.2.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <artem@moelleritberatung.de>) id 1L5g5U-0004Aw-DR
	for linux-dvb@linuxtv.org; Thu, 27 Nov 2008 13:35:17 +0100
Date: Thu, 27 Nov 2008 13:35:05 +0100
From: Artem Makhutov <artem@makhutov.org>
To: Udo Richter <udo_richter@gmx.de>
Message-ID: <20081127123505.GI13103@titan.makhutov-it.de>
References: <49293640.10808@cadsoft.de> <492A53C4.5030509@makhutov.org>
	<492DC5F5.3060501@gmx.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <492DC5F5.3060501@gmx.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API
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

On Wed, Nov 26, 2008 at 10:56:05PM +0100, Udo Richter wrote:
> Artem Makhutov wrote:
> > Klaus Schmidinger schrieb:
> >> The attached patch adds a capability flag that allows an application
> >> to determine whether a particular device can handle "second generation
> >> modulation" transponders. 
> > Wouldn't it be better to add something like this:
> > 
> > FE_CAN_8PSK
> > FE_CAN_16APSK
> > FE_CAN_32APSK
> 
> Without knowing enough about the differences between -S and -S2 tuners 
> and whatever cards are on the market, I'll try to step back and give 
> this my 2c point of view:
> 
> What does a DVB app need to know? A DVB app probably just needs to know 
> "What devices are capable of tuning to channel XYZ?". The API could 
> answer this the same way as it would tune to channel XYZ, just without 
> actually doing it. Try-before-you-buy.
> 
> This would also give maximum flexibility to the driver, as a device that 
> supports some -S2 features could offer these, or a device that has known 
> bugs on some tuning modes could also deny these. Non-standard modes 
> could be offered without requiring yet another FE_CAN_XYZ.

If I understand you correct you would like to call an function like:

bool ItWorks = DoFakeTune(a lot of Paramters);

Sure, this would work, but it would make the implementation more
difficult for both the driver and the application.

So in this case the application would have to call DoFakeTune() for a lot of
different modulations, FEC's and so on and interprete the results.

The application must then call

DoFakeTune(DVB-S,FEC_AUTO);
DoFakeTune(DVB-S,FEC_3_4);
DoFakeTune(DVB-S,FEC_2_4);
DoFakeTune(DVB-S,FEC_4_5);
DoFakeTune(DVB-S2,FEC_AUTO);
[...]
DoFakeTune(DVB-T,FEC_XYZ);
DoFakeTune(DVB-T2,FEC_XYZ);

This would not make much fun and this could be achieved much easier using some kind of capability flags.

Regards, Artem

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
