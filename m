Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out2.iol.cz ([194.228.2.87])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ajurik@quick.cz>) id 1K9gyF-0006RX-3W
	for linux-dvb@linuxtv.org; Fri, 20 Jun 2008 15:48:08 +0200
Received: from ales-debian.local (unknown [88.103.120.47])
	by smtp-out2.iol.cz (Postfix) with ESMTP id 65F681BA871
	for <linux-dvb@linuxtv.org>; Fri, 20 Jun 2008 15:47:31 +0200 (CEST)
From: Ales Jurik <ajurik@quick.cz>
To: linux-dvb@linuxtv.org
Date: Fri, 20 Jun 2008 15:47:28 +0200
References: <200805122042.43456.ajurik@quick.cz>
	<200806162245.22999.ajurik@quick.cz>
	<loom.20080620T131302-220@post.gmane.org>
In-Reply-To: <loom.20080620T131302-220@post.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806201547.28906.ajurik@quick.cz>
Subject: Re: [linux-dvb]
	=?iso-8859-1?q?Re_=3A_Re_=3A_Re_=3A_No_lock_possible_?=
	=?iso-8859-1?q?at_some_DVB-S2=09channels_with_TT_S2-3200/linux?=
Reply-To: ajurik@quick.cz
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

On Friday 20 of June 2008, Daniel wrote:
> Ales Jurik <ajurik <at> quick.cz> writes:
> > On Monday 16 of June 2008, joep wrote:
> > > The most important thing I can't get working is diseqc switching.
> > > Does anyone use Astra23,5 or hotbird13 with the multiproto driver?
> >
> > I'm using multiproto with TT S2-3200 and 4-way diseqc switch (13.0E,
> > 19.2E, 23.5 and motor with secondary dish). No problem, but for motor I'm
> > using patch in vdr (vdr-1.6.0-gotox.diff).
> >
> > BR,
> > Ales
>
> I have the exact same problem. When Telenor moved the DVB-S2 channels and
> changed FEC from 2/3 to 3/4 and turned pilot off all DVB-S2 channels just
> stopped working for me. Before the changed I had no problems at all with
> them. It have to be somekind of driverproblem since I have done no changes
> to my linuxsetup and when I try the card in windoze it works just fine.
> I noticed in the pressrelease Telenor published that the netbitrate
> increased from 48.391Mbps to 55.703Mbps along with the FEC change. Could
> that cause any problems? Or could it be problems with the pilothandling in
> the driver?
>
> Daniel

I'm still trying to find the reason of that problem, but (as I think) this is 
done not by FEC as well not by bitrate. All channels in 8PSK modulation are 
not possible to receive, or the lock is after few minutes. So I'm thinking 
that 8PSK is badly handled within the driver.

BR,

Ales

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
