Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <n.wagenaar@xs4all.nl>) id 1KA3I3-0001ln-Rx
	for linux-dvb@linuxtv.org; Sat, 21 Jun 2008 15:38:06 +0200
Received: from webmail.xs4all.nl (dovemail6.xs4all.nl [194.109.26.8])
	by smtp-vbr3.xs4all.nl (8.13.8/8.13.8) with ESMTP id m5LDbtvN039001
	for <linux-dvb@linuxtv.org>; Sat, 21 Jun 2008 15:38:00 +0200 (CEST)
	(envelope-from n.wagenaar@xs4all.nl)
Message-ID: <18643.82.95.219.165.1214055480.squirrel@webmail.xs4all.nl>
Date: Sat, 21 Jun 2008 15:38:00 +0200 (CEST)
From: "Niels Wagenaar" <n.wagenaar@xs4all.nl>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] s2-3200 fec problem?
Reply-To: n.wagenaar@xs4all.nl
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

> -- SNIP --
>
> Thats great news!
> I did patch mythtv-0.21 with this patch:
> http://svn.mythtv.org/trac/ticket/5403
> I don't have problems with the dvb-s2 channels from astra19,2 with mythtv.
>

I know the following (Swedish, but we all speak code!) guide seems to work:

http://www.minhembio.com/forum/index.php?s=344f35e74353fb173446a5c7d3250854&showtopic=172770&st=30&start=30

> However mythtv and even szap didn't tune to the transponder on astra 23.5
> I have to go to a festival today so I will try multiproto_plus and vdr on
> sunday.

If you do, be sure to follow this guide (it's for Ubuntu but you get the
information on how to get it working)

http://www.kipdola.com/skerit/?language=nl

> Do you know what the differece is betweed the normal multiproto and the
> plus version?
>

It's a combine of multiproto and the mantis or v4l tree if I've got it
right. The last revisions of multiproto didn't seem to work for me (a lot
of lock problems on DVB-S2 transponders with H264 channles). I have to use
the revisions from March to get it working.

> Thanks for your reply,
> Joep Admiraal

No problem at all.

Cheers,

Niels Wagenaar



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
