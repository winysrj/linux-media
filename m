Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <andrew.williams@joratech.com>) id 1LSWHs-0003va-O8
	for linux-dvb@linuxtv.org; Thu, 29 Jan 2009 13:46:29 +0100
MIME-Version: 1.0
Date: Thu, 29 Jan 2009 23:45:45 +1100
Content-class: urn:content-classes:message
Message-ID: <546B4176F0487A4CBA62FC16EFC1D9D6026FC2@EXCHANGE.joratech.com>
From: "Andrew Williams" <andrew.williams@joratech.com>
To: <linux-dvb@linuxtv.org>
Subject: [linux-dvb] KWorld PlusTV Dual DVB-T Stick (DVB-T 399U) / AF9015 -
	Dual tuner enabled by default =Bad signal reception
Reply-To: linux-media@vger.kernel.org
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

Good day everybody,

In the past I have had problems with reception for the AF9015 if both
tuners were enabled.
It was disabled by default or I could manually enable dual tuners with
dvb-usb-af9015 dual_mode=1 (modprobe.d/options)

If both tuners were enabled there was a lot of signal degradation,
however, with only 1 tuner enabled the quality was VERY good.

I have just downloaded the latest drivers and it seems that both tuners
are enabled by default and there is no parameter that I can find to
disable the second tuner.
Now I am back to where I was before with bad signal degradation but no
way to disable the second tuner.

With drivers dated 22 Dec 2008 the second tuner was still disabled by
default. Also the driver from 22 December 2008 lit an LED on the Tuner
to indicate that the firmware was loaded/stick was initialised.
Something that I did not have before (the LED).

Now with the latest driver, the LED does not function anymore but more
importantly, both tuners are enabled by default.

Is there any way that I can disable the second tuner without having to
revert to the old drivers?

Thank You



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
