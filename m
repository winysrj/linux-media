Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:50723 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZASHYn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jan 2009 02:24:43 -0500
Received: by fg-out-1718.google.com with SMTP id 19so1228711fgg.17
        for <linux-media@vger.kernel.org>; Sun, 18 Jan 2009 23:24:41 -0800 (PST)
Message-ID: <8fa153640901182324o566aceb8l73069650506d56cb@mail.gmail.com>
Date: Mon, 19 Jan 2009 09:24:41 +0200
From: "Tero Siironen" <izero79@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] dvb-usb: could not submit URB no. 0 - get them all back
Cc: linux-dvb@linuxtv.org
In-Reply-To: <20090118150155.GA4871@halim.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090118150155.GA4871@halim.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/1/18 Halim Sahin <halim.sahin@t-online.de>:
> Hello all,
> I can't use my dvb-usb-vp7045 based dvb-t stick with latest v4l-dvb drivers.
> I have tested latest hg and the standard dvb drivers.
> My kernel is 2.6.28.
> dmesg |grep -i dvb-usb shows:
> dvb-usb: found a 'Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II)'
> dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> dvb-usb: MAC address: 08:ff:ff:ff:ff:ff
> dvb-usb: Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II) successfu
> dvb-usb: Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II) successfu
> dvb-usb: found a 'Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II)'
> dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
> dvb-usb: MAC address: 08:ff:ff:ff:ff:ff
> dvb-usb: Twinhan USB2.0 DVB-T receiver (TwinhanDTV Alpha/MagicBox II) successfu
> dvb-usb: could not submit URB no. 0 - get them all back
>
> Can someone confirm or can tell me howto solve this???


Hi,

I don't have the answer for solving this, but I do have the same
problem with my Artec T14BR DVB-T USB stick and 2.6.28 kernel. When
I'm using 2.6.28-rc6 kernel the device works fine.

Here is my dmesg :

usb 1-5: new high speed USB device using ehci_hcd and address 8
usb 1-5: configuration #1 chosen from 1 choice
usb 1-5: New USB device found, idVendor=05d8, idProduct=810f
usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-5: Product: ART7070
usb 1-5: Manufacturer: Ultima
usb 1-5: SerialNumber: 001
dib0700: loaded with support for 8 different device-types
dvb-usb: found a 'Artec T14BR DVB-T' in cold state, will try to load a firmware
usb 1-5: firmware: requesting dvb-usb-dib0700-1.20.fw
dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.20.fw'
dib0700: firmware started successfully.
dvb-usb: found a 'Artec T14BR DVB-T' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
DVB: registering new adapter (Artec T14BR DVB-T)
DVB: registering adapter 0 frontend 0 (DiBcom 7000PC)...
DiB0070: successfully identified
dvb-usb: Artec T14BR DVB-T successfully initialized and connected.
usbcore: registered new interface driver dvb_usb_dib0700
usbcore: registered new interface driver dvb_usb_dibusb_mc
dvb-usb: could not submit URB no. 0 - get them all back
