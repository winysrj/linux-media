Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.daveoxley.co.uk ([58.96.80.19])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dave@daveoxley.co.uk>) id 1L94Ic-0007wo-Sn
	for linux-dvb@linuxtv.org; Sat, 06 Dec 2008 22:02:53 +0100
Received: from [192.168.1.148] ([192.168.1.148]) (authenticated bits=0)
	by mail.daveoxley.co.uk (8.14.0/8.14.0) with ESMTP id mB6L2Z3H027534
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Sun, 7 Dec 2008 08:02:35 +1100
Message-ID: <493AE86B.7040805@daveoxley.co.uk>
Date: Sun, 07 Dec 2008 08:02:35 +1100
From: Dave Oxley <dave@daveoxley.co.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] tm6010 - Compiles All Drivers,
	but not tm6010 Strange!
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

> I'm currently working on the driver and I'll probably merge soon a version with
> analog support working fine, including the tm6000-alsa module. The current
> version has no sound, and have a serious issue on analog handling, causing
> kernel hangs.
>
> Cheers,
> Mauro
>   

I've just been trying the latest and am getting a gpf when modprobe'ing 
tm6000. As it sounds like you know about some problems already I'll hold 
off trying again until the latest is merged. But one thing I am unsure 
about is how to make sure there isn't a conflict between code that is in 
your branch and what I have compiled into my kernel. I've made sure that 
videobuf-core and videobuf-vmalloc aren't compiled in already, but is 
there anything else I need to check to prevent possible conflicts?

Also, do you have any timeframe for this driver to be merged into main?

Cheers,
Dave.



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
