Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hyatt.suomi.net ([82.128.152.22])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1JRBCd-0002CU-L5
	for linux-dvb@linuxtv.org; Mon, 18 Feb 2008 19:58:59 +0100
Received: from tiku.suomi.net ([82.128.154.67])
	by hyatt.suomi.net (Sun Java System Messaging Server 6.2-3.04 (built
	Jul 15 2005)) with ESMTP id <0JWG0079O7DD0G30@hyatt.suomi.net> for
	linux-dvb@linuxtv.org; Mon, 18 Feb 2008 20:58:25 +0200 (EET)
Received: from spam5.suomi.net (spam5.suomi.net [212.50.131.165])
	by mailstore.suomi.net
	(Sun Java(tm) System Messaging Server 6.3-4.01 (built Aug  3 2007;
	32bit)) with ESMTP id <0JWG006477DB1X80@mailstore.suomi.net> for
	linux-dvb@linuxtv.org; Mon, 18 Feb 2008 20:58:25 +0200 (EET)
Date: Mon, 18 Feb 2008 20:57:55 +0200
From: Antti Palosaari <crope@iki.fi>
In-reply-to: <ea4209750801161224p6b75d7fanbdcd29e7d367802d@mail.gmail.com>
To: Albert Comerma <albert.comerma@gmail.com>
Message-id: <47B9D533.7050504@iki.fi>
MIME-version: 1.0
References: <ea4209750801161224p6b75d7fanbdcd29e7d367802d@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Yuan EC372S (STK7700D based device)
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

moikka
I have also this device (express card). I haven't looked inside yet, but 
I think there is DibCOM STK7700D (in my understanding dual demod chip) 
and only *one* MT2266 tuner. I tried various GPIO settings but no luck yet.
GPIO6 is for MT2266.
GPIO9 and GPIO10 are for frontend.

Looks like tuner goes to correct frequency because I got always 
PID-filter timeouts when tuning to correct freq. I will now try to take 
some usb-sniffs to see configuration used. Any help is welcome.

regards
Antti

Albert Comerma wrote:
> Hi!, with Michel (mm-sl@ibelgique.com <mailto:mm-sl@ibelgique.com>) who 
> is a owner of this Yuan card we added the device to dib0700_devices, and 
> we got it recognized without problems. The only problem is that no 
> channel is detected on scan on kaffeine or other software... I post some 
> dmesg. We don't know where it may be the problem... or how to detect it...
> 
> usb 4-2: new high speed USB device using ehci_hcd and address 6
> usb 4-2: new device found, idVendor=1164, idProduct=1edc
> usb 4-2: new device strings: Mfr=1, Product=2, SerialNumber=3
> usb 4-2: Product: STK7700D
> usb 4-2: Manufacturer: YUANRD
> usb 4-2: SerialNumber: 0000000001
> usb 4-2: configuration #1 chosen from 1 choice
> dvb-usb: found a 'Yuan EC372S' in cold state, will try to load a firmware
> dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
> dib0700: firmware started successfully.
> dvb-usb: found a 'Yuan EC372S' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software 
> demuxer.
> DVB: registering new adapter (Yuan EC372S)
> dvb-usb: no frontend was attached by 'Yuan EC372S'
> dvb-usb: will pass the complete MPEG2 transport stream to the software 
> demuxer.
> DVB: registering new adapter (Yuan EC372S)
> DVB: registering frontend 1 (DiBcom 7000PC)...
> MT2266: successfully identified
> input: IR-receiver inside an USB DVB receiver as /class/input/input10
> dvb-usb: schedule remote query interval to 150 msecs.
> dvb-usb: Yuan EC372S successfully initialized and connected.
> 
> 
> ------------------------------------------------------------------------
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
