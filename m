Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LIgpp-00005v-6o
	for linux-dvb@linuxtv.org; Fri, 02 Jan 2009 11:00:54 +0100
Received: by nf-out-0910.google.com with SMTP id g13so928628nfb.11
	for <linux-dvb@linuxtv.org>; Fri, 02 Jan 2009 02:00:49 -0800 (PST)
Date: Fri, 2 Jan 2009 11:00:41 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Mike Martin <redtux1@googlemail.com>
In-Reply-To: <ecc841d80901011033s58b2fecawd3dd2d42c1b09cd7@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0901021055060.32128@ybpnyubfg.ybpnyqbznva>
References: <ecc841d80901011033s58b2fecawd3dd2d42c1b09cd7@mail.gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvbsream v0-5 and -n switch
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

On Thu, 1 Jan 2009, Mike Martin wrote:

> I am using dvbstream for an application I am developing
> (www.sourceforge.net/epgrec) and when I try using the -n switch
> (according to help should set number of seconds to record) it has no
> effect

Do you have the source for your version (I presume you
mean v0.5) ?

This is the patch I have applied to v0.6, among lots of
others, which I think will fix it for you, assuming the
code is comparable between versions...

--- /mnt/usr/local/src/dvbtools/dvbstream/dvbstream.c-DIST	2005-01-06 11:25:27.000000000 +0100
+++ /mnt/usr/local/src/dvbtools/dvbstream/dvbstream.c	2005-12-05 14:55:50.000000000 +0100
@@ -846,7 +849,7 @@
   if(map_cnt > 0)
     fprintf(stderr, "\n");
   for (i=0;i<map_cnt;i++) {
-    if ((secs==-1) || (secs < pids_map[i].end_time)) { secs=pids_map[i].end_time; }
+    if ((secs==-1) || ((long)secs < pids_map[i].end_time)) { secs=pids_map[i].end_time; }
     if(pids_map[i].filename != NULL)
     	fprintf(stderr,"MAP %d, file %s: From %ld secs, To %ld secs, %d PIDs - ",i,pids_map[i].filename,pids_map[i].start_time,pids_map[i].end_time,pids_map[i].pid_cnt);
     else


There are a lot of other hacks in the version I'm running;
either I'll post them as-is against the 2005 source code,
or I'll try to create diffs where applicable against the
lastest source, or I won't bother -- depends how lazy I
am -- maybe I'll just post a description of hacks I've
added in case there's interest...


thanks
barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
