Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from fides.aptilo.com ([62.181.224.35])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jonas@anden.nu>) id 1JMqzh-0002BU-EQ
	for linux-dvb@linuxtv.org; Wed, 06 Feb 2008 21:35:45 +0100
Received: from [192.168.1.8] (h-134-69.A157.cust.bahnhof.se [81.170.134.69])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by fides.aptilo.com (Postfix) with ESMTP id 3D82C1F9063
	for <linux-dvb@linuxtv.org>; Wed,  6 Feb 2008 21:35:09 +0100 (CET)
From: Jonas Anden <jonas@anden.nu>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <1202327817.20362.28.camel@youkaida>
References: <47A98F3D.9070306@raceme.org> <1202326173.20362.23.camel@youkaida>
	<1202327817.20362.28.camel@youkaida>
Date: Wed, 06 Feb 2008 21:34:57 +0100
Message-Id: <1202330097.4825.3.camel@anden.nu>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Not too much comfort, but...

> Maybe a different problem, but the tuner is really lost until a reboot
> all the same.

You don't need to reboot to regain the other tuner. I use the following:

service mythbackend stop
modprobe -r dvb_usb_dib0700
modprobe dvb_usb_dib0700
service mythbackend start

After that, the tuner is back on line.

  // J


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
