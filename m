Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from fides.aptilo.com ([62.181.224.35])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jonas@anden.nu>) id 1JN9yx-0005P0-3b
	for linux-dvb@linuxtv.org; Thu, 07 Feb 2008 17:52:15 +0100
Received: from [192.168.121.53] (eddie.sth.aptilo.com [192.168.121.53])
	(using SSLv3 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by fides.aptilo.com (Postfix) with ESMTP id 64A261F9063
	for <linux-dvb@linuxtv.org>; Thu,  7 Feb 2008 17:51:44 +0100 (CET)
From: Jonas Anden <jonas@anden.nu>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <47AB1FC0.8000707@raceme.org>
References: <47A98F3D.9070306@raceme.org>
	<1202326173.20362.23.camel@youkaida>	<1202327817.20362.28.camel@youkaida>
	<1202330097.4825.3.camel@anden.nu>  <47AB1FC0.8000707@raceme.org>
Date: Thu, 07 Feb 2008 17:51:44 +0100
Message-Id: <1202403104.5780.42.camel@eddie.sth.aptilo.com>
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

> Do you have a way to automate this ? Ie to detect that a tuner is gone ?

No, I have yet to find any log message that says things aren't OK.

Mythbackend seems to just fail its recordings and not create the
recording file, which is kind of annoying. In my point of view, it would
be better if mythbackend would *crash*, since this would make the other
backend (which uses analog tuners) take over the recording. It wouldn't
be the same quality, but at least the show would be recorded...

  // J


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
