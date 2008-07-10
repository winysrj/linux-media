Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out1.iol.cz ([194.228.2.86])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ajurik@quick.cz>) id 1KGpk8-0007Q6-5t
	for linux-dvb@linuxtv.org; Thu, 10 Jul 2008 08:35:05 +0200
Received: from ales-debian.local (unknown [88.103.120.47])
	by smtp-out1.iol.cz (Postfix) with ESMTP id EF8E65C7EA
	for <linux-dvb@linuxtv.org>; Thu, 10 Jul 2008 08:34:23 +0200 (CEST)
From: Ales Jurik <ajurik@quick.cz>
To: linux-dvb@linuxtv.org
Date: Thu, 10 Jul 2008 08:34:23 +0200
References: <loom.20080628T180915-166@post.gmane.org>
	<loom.20080701T091940-412@post.gmane.org>
	<Pine.LNX.4.64.0807100053310.6335@shogun.pilppa.org>
In-Reply-To: <Pine.LNX.4.64.0807100053310.6335@shogun.pilppa.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807100834.23532.ajurik@quick.cz>
Subject: Re: [linux-dvb]
	=?iso-8859-1?q?Re_=3A_Re_=3A_How_to_solve_the_TT-S2-3?=
	=?iso-8859-1?q?200_tuning=09problems=3F?=
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

On Wednesday 09 of July 2008, Mika Laitio wrote:
> > http://www.gossamer-threads.com/lists/engine?do=post_view_flat;post=33605
> >3; page=2;sb=post_latest_reply;so=ASC;mh=25;list=mythtv
> >
> > In this thread there is a small patch posted. I am not into coding so it
> > dosen't say to much to me. But for those of you who are into coding might
> > get some ideas. Maybe could it be a step in the right direction to solve
> > our problems maybe?
>
> Has with tuning problems with TT-S2-3200 tried the patch suggested in
> the link?
>
> Mika

Yes, but without big success - the patch is not applicable to my version of 
multiproto (last from hg) - structure stb0899_internal doesn't have member 
sub_range.

But BTW the patch is for dvb-s (QPSK) part of tuning procedure, but (for 
example) my problems are with dvb-s2 and 8PSK.

Ales

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
