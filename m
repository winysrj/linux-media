Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay.chp.ru ([213.170.120.254] helo=ns.chp.ru)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1KBA4p-0003M5-2u
	for linux-dvb@linuxtv.org; Tue, 24 Jun 2008 17:04:59 +0200
Received: from cherep2.ptl.ru (localhost.ptl.ru [127.0.0.1])
	by cherep.quantum.ru (Postfix) with SMTP id ED89E19E68C8
	for <linux-dvb@linuxtv.org>; Tue, 24 Jun 2008 19:04:24 +0400 (MSD)
Received: from localhost.localdomain (hpool.chp.ptl.ru [213.170.123.250])
	by ns.chp.ru (Postfix) with ESMTP id 9A11419E6881
	for <linux-dvb@linuxtv.org>; Tue, 24 Jun 2008 19:04:24 +0400 (MSD)
Date: Tue, 24 Jun 2008 19:09:26 +0400
From: Goga777 <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Message-ID: <20080624190926.525c8571@bk.ru>
In-Reply-To: <976C5CAC-6426-456A-9509-B7575CB3C5B0@krastelcom.ru>
References: <36ADB82E-9B62-4847-BB60-0AD1AB572391@krastelcom.ru>
	<DD6302F4D4084A839650A2FE7D164C76@ua0lnjhome>
	<976C5CAC-6426-456A-9509-B7575CB3C5B0@krastelcom.ru>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Express AM2 11044 H 45 MSps and hvr4000
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

I have checked this high SR on two Russian satellites - Express AM22 53E and ExpressAM2 80E. No any lock. I have tried to
increase/decrease SR/FREQ step by step , but it didn't help me.

11606,V,44948,56
11044,V,44951,34




> Cool. But TT S-1500 and TT S2-3200 have different tuners. Can you take  
> a look at those?
> 
> Regards,
> Vladimir
> 
> On Jun 24, 2008, at 8:06 AM, ua0lnj wrote:
> 
> > I use TT budget S-1102, it have Philips su-1278 tuner.
> > Locked SR 45 MSps on AM2 80E fine.
> > But need use my patch for dvb driver, I posted it twice in dvb mail- 
> > list, but no response from any user...
> >
> >
> > ----- Original Message ----- From: "Vladimir Prudnikov" <vpr@krastelcom.ru 
> > >
> > To: "Linux DVB Mailing List" <linux-dvb@linuxtv.org>
> > Sent: Monday, June 23, 2008 4:53 PM
> > Subject: [linux-dvb] Express AM2 11044 H 45 MSps
> >
> >
> >> Hi!
> >>
> >> I have recently realized that none of the available cards are able to
> >> properly lock on Express AM2 11044H 45 MSps . The only one that can  
> >> is
> >> TT-S1401 with buf[5] register corrections.
> >>
> >> I have tried:
> >>
> >> TT S-1500
> >> TT S2-3200
> >> Skystar 2.6
> >> TT S-1401 with non-modified drivers.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
