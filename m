Return-path: <mchehab@gaivota>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:58211 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759641Ab0LNUFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 15:05:39 -0500
Received: by wwi17 with SMTP id 17so4965350wwi.1
        for <linux-media@vger.kernel.org>; Tue, 14 Dec 2010 12:05:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101214200817.045422e7@tele>
References: <cover.1291926689.git.mchehab@redhat.com>
	<20101209184236.53824f09@pedra>
	<20101210115124.57ccd43e@tele>
	<AANLkTim7iGe=tZXniHXG_33hCyiKFPZVuVDRLu43C3BQ@mail.gmail.com>
	<20101214200817.045422e7@tele>
Date: Tue, 14 Dec 2010 22:05:37 +0200
Message-ID: <AANLkTimeLZwRhP8GfyZbNRiv3JduKJg8ZA3XZ6q7r2uQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] [media] gspca core: Fix regressions gspca breaking
 devices with audio
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Brian Johnson <brijohn@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Tue, Dec 14, 2010 at 9:08 PM, Jean-Francois Moine <moinejf@free.fr> wrote:
> On Tue, 14 Dec 2010 20:52:43 +0200
> Anca Emanuel <anca.emanuel@gmail.com> wrote:
>
>> How can I disable the noise from camera ?
>> There is no physical microphone in it.
>> ( mute do not work )
>        [snip]
>> [  139.848996] usb 8-1: usb_probe_device
>> [  139.849003] usb 8-1: configuration #1 chosen from 1 choice
>> [  139.851825] usb 8-1: adding 8-1:1.0 (config #1, interface 0)
>> [  139.851932] usb 8-1: adding 8-1:1.1 (config #1, interface 1)
>> [  139.851992] usb 8-1: adding 8-1:1.2 (config #1, interface 2)
>> [  139.898020] gspca: v2.11.0 registered
>> [  139.904357] ov519 8-1:1.0: usb_probe_interface
>> [  139.904362] ov519 8-1:1.0: usb_probe_interface - got id
>
> This is an old version. May you get the last one from my web page?
> (actual 2.11.15)

The same bizzzzzzzzz ...

[   74.272034] usb 8-1: new full speed USB device using uhci_hcd and address 2
[   74.404016] usb 8-1: ep0 maxpacket = 8
[   74.440242] usb 8-1: skipped 3 descriptors after interface
[   74.440245] usb 8-1: skipped 2 descriptors after interface
[   74.440248] usb 8-1: skipped 1 descriptor after endpoint
[   74.445234] usb 8-1: default language 0x0409
[   74.464241] usb 8-1: udev 2, busnum 8, minor = 897
[   74.464244] usb 8-1: New USB device found, idVendor=05a9, idProduct=4519
[   74.464247] usb 8-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   74.464250] usb 8-1: Product: USB Camera
[   74.464252] usb 8-1: Manufacturer: OmniVision Technologies, Inc.
[   74.464365] usb 8-1: usb_probe_device
[   74.464369] usb 8-1: configuration #1 chosen from 1 choice
[   74.467255] usb 8-1: adding 8-1:1.0 (config #1, interface 0)
[   74.467326] usb 8-1: adding 8-1:1.1 (config #1, interface 1)
[   74.467356] usb 8-1: adding 8-1:1.2 (config #1, interface 2)
[   74.467409] hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0002
[   74.508926] gspca: v2.11.0 registered
[   74.515078] ov519 8-1:1.0: usb_probe_interface
[   74.515083] ov519 8-1:1.0: usb_probe_interface - got id
[   74.515088] gspca-2.11.5: probing 05a9:4519
[   74.700355] ov519-2.11.5: I2C synced in 0 attempt(s)
[   74.700358] ov519-2.11.5: starting OV7xx0 configuration
[   74.712360] ov519-2.11.5: Sensor is a OV7660
[   76.070091] input: ov519 as
/devices/pci0000:00/0000:00:1d.3/usb8/8-1/input/input5
[   76.070213] gspca-2.11.5: video0 created
[   76.070224] ov519 8-1:1.1: usb_probe_interface
[   76.070227] ov519 8-1:1.1: usb_probe_interface - got id
[   76.070239] ov519 8-1:1.2: usb_probe_interface
[   76.070241] ov519 8-1:1.2: usb_probe_interface - got id
[   76.070262] usbcore: registered new interface driver ov519
[   76.178628] snd-usb-audio 8-1:1.1: usb_probe_interface
[   76.178635] snd-usb-audio 8-1:1.1: usb_probe_interface - got id
[   76.185357] usbcore: registered new interface driver snd-usb-audio
[   76.279093] uhci_hcd 0000:00:1d.3: reserve dev 2 ep82-ISO, period
1, phase 0, 40 us
[   76.804108] hub 2-0:1.0: hub_suspend
[   76.804117] usb usb2: bus auto-suspend
[   76.804121] ehci_hcd 0000:00:1d.7: suspend root hub
[   81.286524] uhci_hcd 0000:00:1d.3: release dev 2 ep82-ISO, period
1, phase 0, 40 us
