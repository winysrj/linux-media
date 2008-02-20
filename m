Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.224])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <filippo.argiolas@gmail.com>) id 1JRkE5-0001k0-UK
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 09:22:50 +0100
Received: by wx-out-0506.google.com with SMTP id s11so2057444wxc.17
	for <linux-dvb@linuxtv.org>; Wed, 20 Feb 2008 00:22:49 -0800 (PST)
From: Filippo Argiolas <filippo.argiolas@gmail.com>
To: Matthew Vermeulen <mattvermeulen@gmail.com>
In-Reply-To: <950c7d180802191310x5882541h61bc60195a998da4@mail.gmail.com>
References: <1203434275.6870.25.camel@tux>
	<1203441662.9150.29.camel@acropora> <1203448799.28796.3.camel@youkaida>
	<1203449457.28796.7.camel@youkaida>
	<950c7d180802191310x5882541h61bc60195a998da4@mail.gmail.com>
Date: Wed, 20 Feb 2008 09:22:53 +0100
Message-Id: <1203495773.7026.15.camel@tux>
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


Il giorno mer, 20/02/2008 alle 06.10 +0900, Matthew Vermeulen ha
scritto:
> Hi all... I'm seeing exactly the same problems everyone else is (log
> flooding etc) except that I can't seem to get any keys picked by lirc
> or /dev/input/event7 at all...

Are you sure that the input device is receiving the events?
Did you try evtest /dev/input/event7?
Is LIRC properly configured?
Are you using this file for lircd.conf
[http://linux.bytesex.org/v4l2/linux-input-layer-lircd.conf]?
Does irw catch some event?

Regarding log flooding, that should be fixed with this patch.
Regards,
Filippo




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
