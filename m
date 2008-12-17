Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LCrjP-0001cM-0g
	for linux-dvb@linuxtv.org; Wed, 17 Dec 2008 09:26:12 +0100
Received: by ug-out-1314.google.com with SMTP id x30so312807ugc.16
	for <linux-dvb@linuxtv.org>; Wed, 17 Dec 2008 00:26:07 -0800 (PST)
Date: Wed, 17 Dec 2008 09:26:00 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Ian Molton <ian@mnementh.co.uk>
In-Reply-To: <4948B5AB.7020500@mnementh.co.uk>
Message-ID: <alpine.DEB.2.00.0812170921540.18619@ybpnyubfg.ybpnyqbznva>
References: <4948B5AB.7020500@mnementh.co.uk>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] freecom dvb-t v4
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

On Wed, 17 Dec 2008, Ian Molton wrote:

> I can build the source, but the module fails to load complaaining of:
> dvb_usb_rtl2831u: Unknown symbol dvb_usb_device_init

A `grep' in my modules shows this is apparently provided by
dvb-usb.ko.

Does `lsmod' reveal a line similar to
dvb_usb                15532  2 dvb_usb_cxusb,dvb_usb_opera
 ?


Of course, this is with old source/modules, so if something
has changed, then I'm wasting your time...

thanks
barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
