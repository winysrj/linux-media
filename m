Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out1.iol.cz ([194.228.2.86])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ajurik@quick.cz>) id 1KJRoN-0002m4-2x
	for linux-dvb@linuxtv.org; Thu, 17 Jul 2008 13:38:30 +0200
Received: from ales-debian.local (unknown [88.103.120.47])
	by smtp-out1.iol.cz (Postfix) with ESMTP id 7D7F15DBFD
	for <linux-dvb@linuxtv.org>; Thu, 17 Jul 2008 13:37:41 +0200 (CEST)
From: Ales Jurik <ajurik@quick.cz>
To: linux-dvb@linuxtv.org
Date: Thu, 17 Jul 2008 13:37:29 +0200
References: <200807170023.57637.ajurik@quick.cz>
	<3efb10970807170320w39377ae9p9db0081dda9c3f5f@mail.gmail.com>
In-Reply-To: <3efb10970807170320w39377ae9p9db0081dda9c3f5f@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807171337.30023.ajurik@quick.cz>
Subject: Re: [linux-dvb] TT S2-3200 driver
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

On Thursday 17 of July 2008, you wrote:
> Hello Ales and Marc,
>
> > please try attached patch. With this patch I'm able to get lock on
> > channels
>
> Okay, I want to test it too, but I have some troubles getting the
> multiproto drivers up and running.
> The S2-3200 is detected properly in my system, but I have no working
> szap2, or scan, or dvbstream tools.
>
> The two of you seem to have it working, so maybe you can give me some
> hints: What sources (what version) do I need?

Hi,
I've used last one, multiproto-2a911b8f9910.tar.bz2.

> Is there a clear manual available somewhere that describes how to use
> the multiproto drivers?

Have a look at 
http://www.vdr-wiki.de/wiki/index.php/OpenSUSE_DVB-S2_-_Teil2:_DVB_Treiber, 
part "Installation - DVB-Treiber" (it is in german, but the main part is in 
computer-language).

> What version of szap2 (and scan) should I use? and where can I find it?
> Does dvbstream still work? Or can I use Mythtv directly?

Don't know, I'm using vdr (with some plugins) and simpledvbtune 
(http://www.linuxtv.org/pipermail/linux-dvb/attachments/20080419/6a41e0b0/attachment-0002.bin - 
it is bz2 archive).

BR,

Ales

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
