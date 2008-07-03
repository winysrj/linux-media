Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KEXcb-0000P5-Bb
	for linux-dvb@linuxtv.org; Fri, 04 Jul 2008 00:49:50 +0200
Message-ID: <486D5789.7050006@iki.fi>
Date: Fri, 04 Jul 2008 01:49:45 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Moosy Log <moosylog@gmail.com>
References: <2ff0d0e20807031250s7fd0386ch9f9551f46ff771d2@mail.gmail.com>
In-Reply-To: <2ff0d0e20807031250s7fd0386ch9f9551f46ff771d2@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DUTV005 (CE9500B1) DVB-T USB Dongle
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

hi,
about Intel CE9500B1...

Moosy Log wrote:
> Got myself a cheap USB dvb-t receiver - Are there any drivers for this 
> device?
> I tried the dvb_usb_af9015, no luck.

different chipset.

> usb 2-4: New USB device found, idVendor=8086, idProduct=9500
> usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 2-4: Product: CE9500B1
> usb 2-4: Manufacturer: Intel Corporation (UK) Ltd
> 
> Full specs: 
> http://plone.lucidsolutions.co.nz/dvb/t/usb/forward-video-dutv005
> 
> Thanks
I have seen some discussion earlier in ML with some Intel chipset, 
probably just the same one. Just look ML archives month or two back. 
There is not driver to this chipset, and I think no one is working with 
this yet.

Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
