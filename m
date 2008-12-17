Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.mnementh.co.uk ([173.45.232.4] helo=mnementh.co.uk)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ian@mnementh.co.uk>) id 1LCrY4-000869-3x
	for linux-dvb@linuxtv.org; Wed, 17 Dec 2008 09:14:29 +0100
Message-ID: <4948B5AB.7020500@mnementh.co.uk>
Date: Wed, 17 Dec 2008 08:17:47 +0000
From: Ian Molton <ian@mnementh.co.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] freecom dvb-t v4
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

Hi!

Im trying to get the freecom v4 stick up and runnign on 2.6.26

I can build the source, but the module fails to load complaaining of:

dvb_usb_rtl2831u: Unknown symbol dvb_usb_device_init

Clearly the API for initialising the driveer has changed, and I'd like 
to fi this, but cant find any real record of how or why this change was 
made.

Any help greatly appreciated.

-Ian

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
