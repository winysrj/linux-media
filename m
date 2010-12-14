Return-path: <mchehab@gaivota>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52453 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757121Ab0LNSwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 13:52:45 -0500
Received: by wwa36 with SMTP id 36so803323wwa.1
        for <linux-media@vger.kernel.org>; Tue, 14 Dec 2010 10:52:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101210115124.57ccd43e@tele>
References: <cover.1291926689.git.mchehab@redhat.com>
	<20101209184236.53824f09@pedra>
	<20101210115124.57ccd43e@tele>
Date: Tue, 14 Dec 2010 20:52:43 +0200
Message-ID: <AANLkTim7iGe=tZXniHXG_33hCyiKFPZVuVDRLu43C3BQ@mail.gmail.com>
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

On Fri, Dec 10, 2010 at 12:51 PM, Jean-Francois Moine <moinejf@free.fr> wrote:
> On Thu, 9 Dec 2010 18:42:36 -0200
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
>
>> Changeset 35680ba broke several devices:
>>       - Sony Playstation Eye (1415:2000);
>>       - Gigaware model 25-234 (0c45:628f);
>>       - Logitech Messenger Plus (046d:08f6).
>>
>> Probably more devices were broken by this change.
>>
>> What happens is that several devices don't need to save some bandwidth
>> for audio.
>>
>> Also, as pointed by Hans de Goede <hdegoede@redhat.com>, the logic
>> that implements the bandwidth reservation for audio is broken, since
>> it will reduce the alt number twice, on devices with audio.
>>
>> So, let's just revert the broken logic, and think on a better solution
>> for usb 1.1 devices with audio that can't use the maximum packetsize.
>
> Acked-by: Jean-Francois Moine <moinejf@free.fr>
>
> --
> Ken ar c'hentañ |             ** Breizh ha Linux atav! **
> Jef             |               http://moinejf.free.fr/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

How can I disable the noise from camera ?
There is no physical microphone in it.
( mute do not work )

[  139.656021] usb 8-1: new full speed USB device using uhci_hcd and address 2
[  139.788024] usb 8-1: ep0 maxpacket = 8
[  139.824840] usb 8-1: skipped 3 descriptors after interface
[  139.824846] usb 8-1: skipped 2 descriptors after interface
[  139.824851] usb 8-1: skipped 1 descriptor after endpoint
[  139.829822] usb 8-1: default language 0x0409
[  139.848810] usb 8-1: udev 2, busnum 8, minor = 897
[  139.848816] usb 8-1: New USB device found, idVendor=05a9, idProduct=4519
[  139.848821] usb 8-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  139.848826] usb 8-1: Product: USB Camera
[  139.848830] usb 8-1: Manufacturer: OmniVision Technologies, Inc.
[  139.848996] usb 8-1: usb_probe_device
[  139.849003] usb 8-1: configuration #1 chosen from 1 choice
[  139.851825] usb 8-1: adding 8-1:1.0 (config #1, interface 0)
[  139.851932] usb 8-1: adding 8-1:1.1 (config #1, interface 1)
[  139.851992] usb 8-1: adding 8-1:1.2 (config #1, interface 2)
[  139.898020] gspca: v2.11.0 registered
[  139.904357] ov519 8-1:1.0: usb_probe_interface
[  139.904362] ov519 8-1:1.0: usb_probe_interface - got id
[  139.904367] gspca: probing 05a9:4519
[  140.088677] ov519: I2C synced in 0 attempt(s)
[  140.088683] ov519: starting OV7xx0 configuration
[  140.100673] ov519: Sensor is a OV7660
[  141.530010] input: ov519 as
/devices/pci0000:00/0000:00:1d.3/usb8/8-1/input/input5
[  141.530188] gspca: video0 created
[  141.530205] ov519 8-1:1.1: usb_probe_interface
[  141.530210] ov519 8-1:1.1: usb_probe_interface - got id
[  141.530227] ov519 8-1:1.2: usb_probe_interface
[  141.530231] ov519 8-1:1.2: usb_probe_interface - got id
[  141.530267] usbcore: registered new interface driver ov519
[  141.643983] snd-usb-audio 8-1:1.1: usb_probe_interface
[  141.643990] snd-usb-audio 8-1:1.1: usb_probe_interface - got id
[  141.651156] usbcore: registered new interface driver snd-usb-audio
[  141.758522] uhci_hcd 0000:00:1d.3: reserve dev 2 ep82-ISO, period
1, phase 0, 40 us
