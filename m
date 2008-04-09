Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [213.161.191.158] (helo=patton.snap.tv)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sigmund@snap.tv>) id 1JjVLS-00011q-4v
	for linux-dvb@linuxtv.org; Wed, 09 Apr 2008 10:07:50 +0200
From: Sigmund Augdal <sigmund@snap.tv>
To: Gurumurti Laxman Maharana <gurumurti@nkindia.com>
In-Reply-To: <42688.203.200.233.130.1207715070.squirrel@203.200.233.138>
References: <200804081441.49529.christophpfister@gmail.com>
	<60949.203.200.233.130.1207662815.squirrel@203.200.233.138>
	<42688.203.200.233.130.1207715070.squirrel@203.200.233.138>
Date: Wed, 09 Apr 2008 10:07:45 +0200
Message-Id: <1207728466.12385.213.camel@rommel.snap.tv>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Extract Satelite Info
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

ons, 09.04.2008 kl. 09.54 +0530, skrev Gurumurti Laxman Maharana:
> Hi All
> I want to know weather is it possible to extract satellite information from
> streams captured by DVB-S card?
> Can any body help in this regard?

Use dvbsnoop. 

dvbsnoop -s ts -tssubdecode -if capture.ts 16|less

Regards

Sigmund
> bye
> 
> 
> > Hi
> > I want to weather is it possoble to extract satellite information from
> > streams capture by DVB card?
> > bye
> >> From a kaffeine user ...
> >>
> >> Christoph
> >>
> >>
> >> ----------  Weitergeleitete Nachricht  ----------
> >>
> >> Betreff: [kaffeine-user] Satellites at 80E and 90E
> >> Datum: Sonntag 06 April 2008
> >> Von: Roman Kashcheev <kashcheevr@rambler.ru>
> >> An: kaffeine-user@lists.sf.net
> >>
> >> Hello!
> >> There are files for dvb-s folder of kaffeine - Siberian satellites, most
> >> popular in eastern Russia.
> >> Thanks for good program - Kaffeine. I use it to look satellite tv since
> >> spring 2006.
> >> Forgive me for my bad english.
> >>
> >> Best regards,
> >> Roman Kashcheev
> >> Bodajbo city, Irkutsk region, Russia
> >>
> >> -------------------------------------------------------
> >> _______________________________________________
> >> linux-dvb mailing list
> >> linux-dvb@linuxtv.org
> >> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
> >
> > --
> > gurumurti@nkindia.com
> >
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
