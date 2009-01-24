Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from as-10.de ([212.112.241.2] helo=mail.as-10.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <halim.sahin@t-online.de>) id 1LQgeH-0000nH-Rj
	for linux-dvb@linuxtv.org; Sat, 24 Jan 2009 12:26:04 +0100
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.as-10.de (Postfix) with ESMTP id E0CC233A869
	for <linux-dvb@linuxtv.org>; Sat, 24 Jan 2009 12:25:23 +0100 (CET)
Received: from mail.as-10.de ([127.0.0.1])
	by localhost (as-10.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lEghEVwDzqB8 for <linux-dvb@linuxtv.org>;
	Sat, 24 Jan 2009 12:25:23 +0100 (CET)
Received: from halim.local (p54AE62B9.dip.t-dialin.net [84.174.98.185])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested) (Authenticated sender: web11p28)
	by mail.as-10.de (Postfix) with ESMTPSA id A394D33A826
	for <linux-dvb@linuxtv.org>; Sat, 24 Jan 2009 12:25:23 +0100 (CET)
Date: Sat, 24 Jan 2009 12:25:27 +0100
From: Halim Sahin <halim.sahin@t-online.de>
To: linux-dvb@linuxtv.org
Message-ID: <20090124112527.GA5727@halim.local>
References: <20090118150155.GA4871@halim.local>
	<8fa153640901182324o566aceb8l73069650506d56cb@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8fa153640901182324o566aceb8l73069650506d56cb@mail.gmail.com>
Subject: [linux-dvb] Status: Re: dvb-usb: could not submit URB no. 0 -
	get	them all back
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

Hi,
Whats the status of this problem?
Could you solve this?????
BR.
halim

On Mo, Jan 19, 2009 at 09:24:41 +0200, Tero Siironen wrote:
> 2009/1/18 Halim Sahin <halim.sahin@t-online.de>:
> > Hello all,
> > I can't use my dvb-usb-vp7045 based dvb-t stick with latest v4l-dvb drivers.
> > I have tested latest hg and the standard dvb drivers.
> > My kernel is 2.6.28.
> > dmesg |grep -i dvb-usb shows:
> > dvb-usb: found a 'Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II)'
> > dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> > dvb-usb: MAC address: 08:ff:ff:ff:ff:ff
> > dvb-usb: Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II) successfu
> > dvb-usb: Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II) successfu
> > dvb-usb: found a 'Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II)'
> > dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> > dvb-usb: MAC address: 08:ff:ff:ff:ff:ff
> > dvb-usb: Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II) successfu
> > dvb-usb: could not submit URB no. 0 - get them all back
> >
> > Can someone confirm or can tell me howto solve this???
> 
> 
> Hi,
> 
> I don't have the answer for solving this, but I do have the same
> problem with my Artec T14BR DVB-T USB stick and 2.6.28 kernel. When
> I'm using 2.6.28-rc6 kernel the device works fine.
> 
> Here is my dmesg :
> 
> usb 1-5: new high speed USB device using ehci_hcd and address 8
> usb 1-5: configuration #1 chosen from 1 choice
> usb 1-5: New USB device found, idVendor=05d8, idProduct=810f
> usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 1-5: Product: ART7070
> usb 1-5: Manufacturer: Ultima
> usb 1-5: SerialNumber: 001
> dib0700: loaded with support for 8 different device-types
> dvb-usb: found a 'Artec T14BR DVB-T' in cold state, will try to load a firmware
> usb 1-5: firmware: requesting dvb-usb-dib0700-1.20.fw
> dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
> dib0700: firmware started successfully.
> dvb-usb: found a 'Artec T14BR DVB-T' in warm state.
> dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> DVB: registering new adapter (Artec T14BR DVB-T)
> DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
> DiB0070: successfully identified
> dvb-usb: Artec T14BR DVB-T successfully initialized and connected.
> usbcore: registered new interface driver dvb_usb_dib0700
> usbcore: registered new interface driver dvb_usb_dibusb_mc
> dvb-usb: could not submit URB no. 0 - get them all back
> 
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

-- 
Halim Sahin
E-Mail:				
halim.sahin (at) t-online.de

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
