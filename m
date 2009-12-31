Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:30187 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbZLaKWe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Dec 2009 05:22:34 -0500
Received: by ey-out-2122.google.com with SMTP id 25so1906854eya.19
        for <linux-media@vger.kernel.org>; Thu, 31 Dec 2009 02:22:33 -0800 (PST)
Date: Thu, 31 Dec 2009 11:22:16 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: sebax75@yahoo.it
cc: linux-media@vger.kernel.org
Subject: Re: Siano SMS1140 problem
In-Reply-To: <580652.33691.qm@smtp112.mail.ukl.yahoo.com>
Message-ID: <alpine.DEB.2.01.0912311056260.20902@ybpnyubfg.ybpnyqbznva>
References: <580652.33691.qm@smtp112.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry for the delay in replying...  A spiffy new year everyone for
whom calendars and clocks and daylight and seasons have meaning,
and also to the rest of you living in your mum's basement.


On Tue, 29 Dec 2009, sebax75@yahoo.it wrote:

> I've already worked with different adapters (Pinnacle 320E with  em28xx, Intel CE9500B1, Hauppauge Nova-T Stick and SAA7134), and all have worked without big problem reading the howto I've found online; but now I've a new dvb-adapter, and it's a Siano SMS1140.

I have a related, but different adapter, which until now I've just
been using for DAB+ and DAB service reception, but I decided I'd
check if there might be a regression in later kernels.  Problem is
I'm using a deliberately crippled machine, so that I don't trust
all that I see.  (Browser `lynx' tossing up kernel malloc failures
I'd never seen before, for example)  That aside,


> - dmesg output:
> usb 1-7: new high speed USB device using ehci_hcd and address 7
> usb 1-7: New USB device found, idVendor=187f, idProduct=0201
> usb 1-7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> usb 1-7: Product: MDTV Receiver
> usb 1-7: Manufacturer: MDTV Receiver
> usb 1-7: configuration #1 chosen from 1 choice
> usb 1-7: firmware: requesting dvb_nova_12mhz_b0.inp
> smscore_set_device_mode: firmware download success: dvb_nova_12mhz_b0.inp
> usbcore: registered new interface driver smsusb

What I see in my first failed attempt is
[422523.242709] usb 3-2.2.1: firmware: requesting dvbt_bda_stellar_usb.inp
[422523.329911] smsusb: probe of 3-2.2.1:1.1 failed with error -71
[422523.331556] usbcore: registered new interface driver smsusb

Unfortunately, that prevents me from identifying at what point in
the following sorta-successful attempt you would see the 
registration of the smsusb...  And I am too lazy to unload those
modules and try again :-)

Here is what I see after a successful load of the firmware, that
the device disconnects, reconnects with a different ID, and then
runs into further problems:

[422545.201374] usb 3-2.2.3: firmware: requesting dvbt_bda_stellar_usb.inp
[422545.468215] usb 3-2.2.3: USB disconnect, address 26
[422547.750697] usb 3-2.2.3: new full speed USB device using uhci_hcd and address 27
[422547.883683] usb 3-2.2.3: New USB device found, idVendor=187f, idProduct=0100[422547.883826] usb 3-2.2.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[422547.883978] usb 3-2.2.3: Product: SMS DVBT-BDA Receiver
[422547.884095] usb 3-2.2.3: Manufacturer: Siano Mobile Silicon
[422547.886690] usb 3-2.2.3: configuration #1 chosen from 1 choice
[422548.012889] smsusb_onresponse: line: 116: error, urb status -84, 0 bytes


I am not sure if you should see the same thing (disconnect, 
reconnect with different ID from the firmware) with your 
particular device after firmware load.


In any case, the kernel version I had used for DAB+ reception is
several versions back, and the last time I attempted to use this
device for DVB-T is even older than that (no problems then, but on
different hardware, with a lot fewer USB hubs in the path to 
cause problems).


I'd offer to see what I could do with the particular kernel source
which gives me the above, except that I've already overwritten 
that source with newer.

Anyway, I will see what I can do with my device with either the
newest kernel, or the older stable one which I've patched into
usefulness, sometime in the coming days or weeks, and report any
successes or failures (plus differences to the Siano library that
supports the Eureka-147 DAB decoding, should that also fail).



> Someone can explain to me how to get it to work or where I miss something ori, if it's due to some regression, how to debug it and support a programmer for this?

This isn't much, but in the absence of any other replies, it's the
best I can offer.

thanks,
barry bouwmsa
