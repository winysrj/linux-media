Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <luca.i@gmx.net>) id 1Jp3x7-0002Ij-QT
	for linux-dvb@linuxtv.org; Thu, 24 Apr 2008 18:05:42 +0200
From: Luca Ingianni <luca.i@gmx.net>
To: linux-dvb@linuxtv.org
Date: Thu, 24 Apr 2008 18:05:13 +0200
References: <200804181939.39153.luca.i@gmx.net> <1209015127.7013.6.camel@tux>
In-Reply-To: <1209015127.7013.6.camel@tux>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804241805.14002.luca.i@gmx.net>
Subject: Re: [linux-dvb] Hauppauge Nova-TD trouble: still or again?
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

Am Donnerstag 24 April 2008 07:32:07 schrieben Sie:
> Il giorno ven, 18/04/2008 alle 19.39 +0200, Luca Ingianni ha scritto:

> Hi, as fas as I understood reading the list your problem shouldn't be
> fixed. You have to distinguish the usb disconnect problem that affected
> generic dib0700 (mainly nova-t) devices which has been fixed, and the
> nova td500 issue that happens when using both tuners with sb600
> southbridge. Afaict this is a sb600 hardware issue and it affects both
> linux and windows users so I doubt it's driver related, i'm not sure but
> i think i remember it affects other usb devices too with that chipset.

Filippo, thanks for your reply even though it wasn't quite what I was hoping 
to hear :( 

But as can be read in
http://www.hauppauge.co.uk/board/showthread.php?s=e7596bd39ebab6db780176ccdc62d52f&t=14454&page=2&highlight=southbridge
Hauppauge have released a new Windows driver which apparently fixes this 
problem. So it is solveable in software. I'm not quite sure whether this is a 
dib0700 or a generic-usb-driver problem.

Do you know wheter anyone is working on this?

Have fun,
Luca

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
