Return-path: <linux-media-owner@vger.kernel.org>
Received: from n27.bullet.mail.ukl.yahoo.com ([87.248.110.144]:38104 "HELO
	n27.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754932AbZCKNYF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2009 09:24:05 -0400
From: bloehei <bloehei@yahoo.de>
To: Antti Palosaari <crope@iki.fi>
Subject: Re: EC168 support?!
Date: Wed, 11 Mar 2009 14:24:01 +0100
References: <200903111217.17846.bloehei@yahoo.de> <49B7A1DF.1080204@iki.fi>
In-Reply-To: <49B7A1DF.1080204@iki.fi>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903111424.02606.bloehei@yahoo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> moi Jo!
>
> bloehei wrote:
> > Hi,
> > I'm reading this list because I'm - like many others I guess - waiting
> > for my EC168 based Sinovideo 3420b to be supported under linux. Now I've
> > read this
> > (https://www.dealextreme.com/forums/Default.dx/sku.8325~threadid.278942)
> > post and was supprised that there already is some code that seems to be
> > working for some other EC168 sticks. Sadly, it doesn't work for my
> > device. I want to thank Antti Palosaari for the work on the driver and
> > suggest, that it should be communicated more clearly that there already
> > is a code base for a driver.
>
> It is ugly few hour hack driver which I did when I tried to order Intel
> ce6230 based stick but got E3C ec168 one.
> Anyhow, it seems to work with 8 MHz bandwidth. I think you have 6 or 7
> MHz? It is rather easy to add 6 and 7 too, just take usb-sniff and look
> registers programmed differently.
> Are you using 6 or 7 MHz?
>
> regards
> Antti

For me, the firmware doesn't get loaded, so I don't get that far. But I'm not 
posting because I expect this to be fixed for my stick now, I'm just happy 
that there is development going on at all, so that my device could be 
supported some day. I think it should be made known better, that there is 
some basic code, that's why I was posting.

If it is of interest, here's my system log:

> usb 1-1: new full speed USB device using uhci_hcd and address 2
> usb 1-1: configuration #1 chosen from 1 choice
> ec168_probe: interface:0
> ec168_identify_state:
> c0 01 00 00 01 00 01 00 <<< 00
> ec168_identify_state: reply:00
> dvb-usb: found a 'E3C EC168 DVB-T USB2.0 reference design' in cold state,
> will try to load a firmware usb 1-1: firmware: requesting dvb-usb-ec168.fw
> dvb-usb: downloading firmware from file 'dvb-usb-ec168.fw'
> ec168_download_firmware:
> 40 00 00 00 00 00 00 08 >>> 02 13 e4 02 0e d3 00 00 00 00 00 02 14 f7 00 00
> 00 <... cut ...>
> 40 00 00 00 40 08 00 08 >>> 12 0c 93 80 06 12 0d 43 74 83 f0 e5 48 30 e3 78
> 54 30 60 1d <... cut ...>
> 40 00 00 00 40 08 00 08 >>> 12 0c 93 80 06 12 0d 43 74 83 f0 e5 48 30 e3 78
> 54 30 60 1d 12 09 2d e0 12 0c 7f a3 f0 e5 48 <....cut....>
> 40 00 00 00 40 08 c5 03 >>> 12 0c 93 80 06 12 0d 43 74 83 f0 e5 48 30 e3 78
> 54 30 60 1d 12 09 2d e0 <...cut...>
> 40 01 00 00 01 00 00 00 >>>
> 40 04 01 00 08 00 00 00 >>>
> ec168_rw_udev: usb_control_msg failed :-75
> 40 04 00 00 06 02 00 00 >>>
> ec168_rw_udev: usb_control_msg failed :-71
> init failed :-71
> dvb_usb_ec168: probe of 1-1:1.0 failed with error -71
> ec168_probe: interface:1
> set interface failed
> ec168_identify_state:
> c0 01 00 00 01 00 01 00 <<< 00
> ec168_rw_udev: usb_control_msg failed :-71

If I can help with more informations or tests, just let me know.
Regards,
Jo





