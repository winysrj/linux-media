Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <kmieciu@jabster.pl>) id 1LGt8I-0000dY-Mz
	for linux-dvb@linuxtv.org; Sun, 28 Dec 2008 11:44:32 +0100
Received: by bwz11 with SMTP id 11so9251102bwz.17
	for <linux-dvb@linuxtv.org>; Sun, 28 Dec 2008 02:43:57 -0800 (PST)
Message-ID: <4957586A.1000603@jabster.pl>
Date: Sun, 28 Dec 2008 11:43:54 +0100
From: kmieciu <kmieciu@jabster.pl>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <49567A9E.8080700@jabster.pl>
	<1230436330.2545.11.camel@pc10.localdom.local>
In-Reply-To: <1230436330.2545.11.camel@pc10.localdom.local>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Avermedia AVerTV GO 007 FM don't work with kernels
 >= 2.6.27
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

> 
> Out of some reason the tda827x module must be deselected within tuner
> customization of your later kernels and you don't have it.
> 
> Make sure its build is enabled in the .config of the kernel.
> 

I selected custmize analog tuners to build, selected all tuner modules and now card works again. Thanks :) I can finally get rid of 2.6.24 kernel, no more reboot-to-watch-tv :)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
