Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f121.mail.ru ([194.67.57.127])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1JRRxv-0003aO-EG
	for linux-dvb@linuxtv.org; Tue, 19 Feb 2008 13:52:55 +0100
From: Igor <goga777@bk.ru>
To: Zenon Mousmoulas <zmousm@admin.grnet.gr>
Mime-Version: 1.0
Date: Tue, 19 Feb 2008 15:52:21 +0300
References: <8EDD5E70-F34A-4B5E-8A31-64FC3BCE1672@admin.grnet.gr>
In-Reply-To: <8EDD5E70-F34A-4B5E-8A31-64FC3BCE1672@admin.grnet.gr>
Message-Id: <E1JRRxN-000Jur-00.goga777-bk-ru@f121.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb]
	=?koi8-r?b?SGF1cHBhdWdlIFdpblRWLUhWUjQwMDAgYW5kIERW?=
	=?koi8-r?b?Qi1TMi4uLg==?=
Reply-To: Igor <goga777@bk.ru>
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

> >> My goal is to get this card to tune to a DVB-S2 transponder, more
> >> specifically this one:
> >> http://en.kingofsat.net/tp.php?tp=2656
> >> I have a dish with 4 LNBs connected to the HVR4000 through a DiSEqC
> >> 1.0 4x1 switch.
> >> The 4th LNB is pointed to this satellite and I can tune to DVB-S
> >> transponders there just fine with another card as well as this one
> >> (more on that later).
> >>
> >> I assume multiproto is necessary for DVB-S2 tuning to actually work.
> >> Right?
> >
> > yes, right. Latest version of multiproto will help you.
> 
> Thanks. Since I asked this in the first place, let me put it another  
> way:
> Currently there is no other way to get DVB-S2 tuning, other than going  
> with the multiproto tree, such as a patch-set for the main hg tree?

there's other way - the hvr4000-patches from Darron Broad for current hg tree
http://dev.kewl.org/hauppauge/

> So, to conclude, as Holger Steinhaus noted:
> 
> The 2 things that can "speak" to the multiproto drivers a compatible  
> version of the DVB API "language" are
> - szap2 and
> - vdr-1.5.14 + h264 patch ?
> 
> Are there any others?

there's multiproto-patch for mythtv , I don't know anything abot kaffeine. 

> If I use szap2 first, then I can also use dvbstream or dvbsnoop as  
> well. I have to keep szap2 running though, because the frontend shuts  
> down after some time, despite the dvb-core module option  
> dvb_shutdown_timeout=0 (I think I have seen this previously reported).

yes, we are waiting for the answer from Manu about this option in multiproto - it's seems it was broken.

Igor


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
