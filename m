Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt2.poste.it ([62.241.5.253])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nicola.sabbi@poste.it>) id 1KMNOi-0008KY-HJ
	for linux-dvb@linuxtv.org; Fri, 25 Jul 2008 15:31:53 +0200
Received: from [192.168.1.116] (79.42.63.191) by relay-pt2.poste.it (7.3.122)
	(authenticated as nicola.sabbi@poste.it)
	id 488909EF00005E63 for linux-dvb@linuxtv.org;
	Fri, 25 Jul 2008 15:31:48 +0200
From: Nico Sabbi <nicola.sabbi@poste.it>
To: linux-dvb@linuxtv.org
In-Reply-To: <4889D176.1030702@gmx.de>
References: <3a665c760807240246x7bb3d442lac2b407dd138accf@mail.gmail.com>
	<200807241153.55596.Nicola.Sabbi@poste.it>
	<3a665c760807250212i1902e4fdud47da351262c140f@mail.gmail.com>
	<200807251116.54407.Nicola.Sabbi@poste.it>  <4889D176.1030702@gmx.de>
Date: Fri, 25 Jul 2008 15:35:23 +0200
Message-Id: <1216992923.3726.1.camel@suse.site>
Mime-Version: 1.0
Subject: Re: [linux-dvb] question about definition of section in
	PSI	of	Transport stream
Reply-To: nicola.sabbi@poste.it
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

Il giorno ven, 25/07/2008 alle 15.13 +0200, Andreas Regel ha scritto:
> Nico Sabbi wrote:
> > On Friday 25 July 2008 11:12:53 you wrote:
> >> Hi:
> >> thanks for your explanation.
> >> BTW, I find all my Ts only have one section, section_number and
> >> last_section_number are both 0.
> > 
> > yes, there's only one section
> > 
> >> Would you please tell me where I can get multi-sections TS for
> >> tracing?
> >>
> >> appreciate your help,
> >> miloody
> > 
> > Please,  don't top-post.
> > Some satellite transponder with many programs surely has multi-section
> > PMTs, but I never found any
> 
> PMTs are always just one section. PATs could have more than one but that 
> would normally need more than 250 programmes on one TS, so it's not that 
> easy to find a TS with multi section PATs. Other tables, like NIT or SDT 
> often are bigger than 1024 bytes and split over several sections.
> 
> Regards
> Andreas
> 

yes, but in theory even PMTs can be sectioned


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
