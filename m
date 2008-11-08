Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wp074.webpack.hosteurope.de ([80.237.132.81])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mail@JuergenBrunenberg.de>) id 1KysQB-0004Es-LL
	for linux-dvb@linuxtv.org; Sat, 08 Nov 2008 19:20:32 +0100
From: =?ISO-8859-1?Q?J=FCrgen?= Brunenberg <mail@JuergenBrunenberg.de>
To: linux-dvb@linuxtv.org
In-Reply-To: 200811060012.57024.liplianin@tut.by
Date: Sat, 08 Nov 2008 19:19:53 +0100
Message-Id: <1226168393.7004.18.camel@nb-d830-lx>
Mime-Version: 1.0
Subject: [linux-dvb]  [linuxtv][PATCH] Cinergy S Usb
Reply-To: mail@JuergenBrunenberg.de
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

hello together,
I although have the Cinergy S USB, and i mad some tests with the dw2102
driver. I patched the driver for the right VID/PID following the
description from Thorsten Leupold. With the result, TV works but the
remote control not. I made some further tests, then i extracted the
firmware from terratec. With this and a other keymap the rc works fine.
So, how to continue ? I just start working with Linux, and not know what
is the next step. Is it a good solution to integrate this in the
existing dw2102 driver from Igor Liplianin or is ist better to make a
new one based on Igor's ?   


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
