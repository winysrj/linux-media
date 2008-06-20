Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1K9gVk-0004Hn-An
	for linux-dvb@linuxtv.org; Fri, 20 Jun 2008 15:18:40 +0200
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1K9gVa-0004M5-T3
	for linux-dvb@linuxtv.org; Fri, 20 Jun 2008 13:18:31 +0000
Received: from h240n2fls32o1121.telia.com ([217.211.84.240])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Fri, 20 Jun 2008 13:18:30 +0000
Received: from dvenion by h240n2fls32o1121.telia.com with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Fri, 20 Jun 2008 13:18:30 +0000
To: linux-dvb@linuxtv.org
From: Daniel <dvenion@hotmail.com>
Date: Fri, 20 Jun 2008 13:18:22 +0000 (UTC)
Message-ID: <loom.20080620T131302-220@post.gmane.org>
References: <200805122042.43456.ajurik@quick.cz>
	<200806161020.05437.ajurik@quick.cz>
	<200806162114.27912.joep@groovytunes.nl>
	<200806162245.22999.ajurik@quick.cz>
Mime-Version: 1.0
Subject: Re: [linux-dvb]
	=?utf-8?q?Re_=3A_Re_=3A_Re_=3A_No_lock_possible_at_so?=
	=?utf-8?q?me_DVB-S2=09channels_with_TT_S2-3200/linux?=
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

Ales Jurik <ajurik <at> quick.cz> writes:

> 
> On Monday 16 of June 2008, joep wrote:
> >
> > The most important thing I can't get working is diseqc switching.
> > Does anyone use Astra23,5 or hotbird13 with the multiproto driver?
> 
> I'm using multiproto with TT S2-3200 and 4-way diseqc switch (13.0E, 19.2E, 
> 23.5 and motor with secondary dish). No problem, but for motor I'm using 
> patch in vdr (vdr-1.6.0-gotox.diff).
> 
> BR,
> Ales
> 

I have the exact same problem. When Telenor moved the DVB-S2 channels and
changed FEC from 2/3 to 3/4 and turned pilot off all DVB-S2 channels just
stopped working for me. Before the changed I had no problems at all with them.
It have to be somekind of driverproblem since I have done no changes to my
linuxsetup and when I try the card in windoze it works just fine. 
I noticed in the pressrelease Telenor published that the netbitrate increased
from 48.391Mbps to 55.703Mbps along with the FEC change. Could that cause any
problems? Or could it be problems with the pilothandling in the driver?

Daniel




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
