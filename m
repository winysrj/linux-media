Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from main.gmane.org ([80.91.229.2] helo=ciao.gmane.org)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gldd-linux-dvb@m.gmane.org>) id 1KKJiC-0002QS-IK
	for linux-dvb@linuxtv.org; Sat, 19 Jul 2008 23:11:29 +0200
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KKJi6-00077Y-UP
	for linux-dvb@linuxtv.org; Sat, 19 Jul 2008 21:11:22 +0000
Received: from 77-103-126-124.cable.ubr10.dals.blueyonder.co.uk
	([77.103.126.124]) by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sat, 19 Jul 2008 21:11:22 +0000
Received: from mariofutire by 77-103-126-124.cable.ubr10.dals.blueyonder.co.uk
	with local (Gmexim 0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-dvb@linuxtv.org>; Sat, 19 Jul 2008 21:11:22 +0000
To: linux-dvb@linuxtv.org
From: Andrea <mariofutire@googlemail.com>
Date: Sat, 19 Jul 2008 22:09:23 +0100
Message-ID: <48825803.6080801@googlemail.com>
References: <g5llos$b75$1@ger.gmane.org>
	<200807182246.17897.christophpfister@gmail.com>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
In-Reply-To: <200807182246.17897.christophpfister@gmail.com>
Subject: Re: [linux-dvb] [PATCH] 2 patches for dvb-apps gnutv
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

Christoph Pfister wrote:
> Am Mittwoch 16 Juli 2008 22:28:33 schrieb Andrea:
> 
> But I'll rework the first patch a bit (the sequence of revents <--> errno 
> check is already bogus) and commit them. And I really suggest you to use an 
> application like dvbstream which does its own buffering (at least I hope 
> so ;) - because it has never happened to me yet that the ringbuffer 

I've read the code of dvbstream and it does not use an other buffer,
it writes immediately to the output file, the same as gnutv.

> overflowed (and it shouldn't with sane applications).
> 

It can happen to me when the output file is on a NAS via wireless network.
gnutv is very easy to use, lightweight, command line and saves subtitles too.

> 
> Christoph

Cheers

Andrea


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
