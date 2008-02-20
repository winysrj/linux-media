Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JRowZ-0004ez-Nl
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 14:25:03 +0100
From: Nicolas Will <nico@youplala.net>
To: Matthew Vermeulen <mattvermeulen@gmail.com>
In-Reply-To: <950c7d180802200436s68bab78ej3eb01a93090c313f@mail.gmail.com>
References: <1203434275.6870.25.camel@tux>
	<1203441662.9150.29.camel@acropora> <1203448799.28796.3.camel@youkaida>
	<1203449457.28796.7.camel@youkaida>
	<950c7d180802191310x5882541h61bc60195a998da4@mail.gmail.com>
	<1203495773.7026.15.camel@tux> <1203496068.7026.19.camel@tux>
	<950c7d180802200436s68bab78ej3eb01a93090c313f@mail.gmail.com>
Date: Wed, 20 Feb 2008 13:23:34 +0000
Message-Id: <1203513814.6682.30.camel@acropora>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [patch] support for key repeat with dib0700
	ir	receiver
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


On Wed, 2008-02-20 at 21:36 +0900, Matthew Vermeulen wrote:
> 
> I've got that file all set up, my hardware.conf for lirc is pasted
> below:

I'm running Ubuntu Gutsy and my /etc/lirc/hardware.conf has wildly
different variable names.

See what I have here:

http://www.youplala.net/~will/htpc/LIRC/

You are running Hardy, but I would't expect conf files to change so
dramatically. I may be wrong, so I'll check.

Ah, yes they are... oh well, I'm wrong.


> # /etc/lirc/hardware.conf
> #
> #Chosen Remote Control
> REMOTE="Compro Videomate U500"
> REMOTE_MODULES=""
> REMOTE_DRIVER="devinput"

shouldn't that be dev/input, instead?

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
