Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt1.poste.it ([62.241.4.164])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nicola.sabbi@poste.it>) id 1LIhNU-0003HC-1J
	for linux-dvb@linuxtv.org; Fri, 02 Jan 2009 11:35:41 +0100
Received: from [192.168.1.116] (79.42.61.188) by relay-pt1.poste.it (7.3.122)
	(authenticated as nicola.sabbi@poste.it)
	id 495D6758000028CA for linux-dvb@linuxtv.org;
	Fri, 2 Jan 2009 11:35:36 +0100
From: Nico Sabbi <nicola.sabbi@poste.it>
To: linux-dvb@linuxtv.org
In-Reply-To: <1230891602.3791.4.camel@linux-wcrt.site>
References: <ecc841d80901011033s58b2fecawd3dd2d42c1b09cd7@mail.gmail.com>
	<alpine.DEB.2.00.0901021055060.32128@ybpnyubfg.ybpnyqbznva>
	<1230891602.3791.4.camel@linux-wcrt.site>
Date: Fri, 02 Jan 2009 11:29:33 +0100
Message-Id: <1230892173.3791.12.camel@linux-wcrt.site>
Mime-Version: 1.0
Subject: Re: [linux-dvb] dvbsream v0-5 and -n switch
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

Il giorno ven, 02/01/2009 alle 11.20 +0100, Nico Sabbi ha scritto:
> Il giorno ven, 02/01/2009 alle 11.00 +0100, BOUWSMA Barry ha scritto:
> > 
> > --- /mnt/usr/local/src/dvbtools/dvbstream/dvbstream.c-DIST	2005-01-06 11:25:27.000000000 +0100
> > +++ /mnt/usr/local/src/dvbtools/dvbstream/dvbstream.c	2005-12-05 14:55:50.000000000 +0100
> > @@ -846,7 +849,7 @@
> >    if(map_cnt > 0)
> >      fprintf(stderr, "\n");
> >    for (i=0;i<map_cnt;i++) {
> > -    if ((secs==-1) || (secs < pids_map[i].end_time)) { secs=pids_map[i].end_time; }
> > +    if ((secs==-1) || ((long)secs < pids_map[i].end_time)) { secs=pids_map[i].end_time; }
> >      if(pids_map[i].filename != NULL)
> >      	fprintf(stderr,"MAP %d, file %s: From %ld secs, To %ld secs, %d PIDs - ",i,pids_map[i].filename,pids_map[i].start_time,pids_map[i].end_time,pids_map[i].pid_cnt);
> >      else
> > 
> > 
> > There are a lot of other hacks in the version I'm running;
> > either I'll post them as-is against the 2005 source code,
> > or I'll try to create diffs where applicable against the
> > lastest source, or I won't bother -- depends how lazy I
> > am -- maybe I'll just post a description of hacks I've
> > added in case there's interest...
> > 
> > 
> > thanks
> > barry bouwsma
> > 
> 
> can you post a patch against latest cvs, please?
> 

I forgot to add that the -ps bug is fixed in cvs.

BTW, for years I asked to insert the correct "reply-to" header in this
*fuckingly broken* mailing list (to send replies to the list rather than
to the poster), but not a single time I received an answer by His
Majesty the ML administrator.
Can someone fix this issue, please? If not, can the admin at least
explain *why* he/she wants to keep it broken?
Please, no speculations: just facts.

Thanks,
	Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
