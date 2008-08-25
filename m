Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out1.iol.cz ([194.228.2.86])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ajurik@quick.cz>) id 1KXiBz-0007NZ-Ir
	for linux-dvb@linuxtv.org; Mon, 25 Aug 2008 21:57:36 +0200
From: Ales Jurik <ajurik@quick.cz>
To: linux-dvb@linuxtv.org
Date: Mon, 25 Aug 2008 21:56:52 +0200
References: <1219648828.2816407742@mx16.mail.ru>
	<E1KXWht-0009u2-00.goga777-bk-ru@f48.mail.ru>
In-Reply-To: <E1KXWht-0009u2-00.goga777-bk-ru@f48.mail.ru>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808252156.52323.ajurik@quick.cz>
Subject: Re: [linux-dvb]
 =?iso-8859-1?q?HVR_4000_recomneded_driver_and_firmwar?=
 =?iso-8859-1?q?e_for_VDR_1=2E7=2E0?=
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

On Monday 25 of August 2008, Goga777 wrote:
> Yesterday Igor updated his repo, please update it and try again.
>
> here you can read more about firmware for hvr4000
> http://allrussian.info/thread.php?threadid=98587
>

I could confirm that this new version of drivers is running better (I have the 
same problem as Marek and I use his hint with patched multiproto_plus drivers 
to make HV-4000 under linux running) but not for all channels. I couldn't get 
lock for some dvb-s2 channels (ANIXE HD, Premiere HD) which is with patched 
multiproto_plus possible without problem. Also switching seems to be sometimes 
slower.

I've tested it with kernel 2.6.25-2 and with fw for cs24116 version 1.20.79.0 
and version 1.23.86.1.

Many thanks to Goga and Igor for their work.

BR,

Ales


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
