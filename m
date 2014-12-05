Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:62474 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaLEOvi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Dec 2014 09:51:38 -0500
Received: by mail-ob0-f182.google.com with SMTP id wo20so601399obc.13
        for <linux-media@vger.kernel.org>; Fri, 05 Dec 2014 06:51:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52F01925.4060701@iki.fi>
References: <72f12ec0f50db8495447b3104923aa61@mail.vanmierlo.nu> <52F01925.4060701@iki.fi>
From: Eddi De Pieri <eddi@depieri.net>
Date: Fri, 5 Dec 2014 15:51:17 +0100
Message-ID: <CAKdnbx4869X8nfX3u--3nW4nVPc+FU0F5RiX6KSGQRmC1gDZjQ@mail.gmail.com>
Subject: Re: Terratec H7 with yet another usb ID
To: Antti Palosaari <crope@iki.fi>
Cc: Rik van Mierlo <rik@vanmierlo.nu>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I got a sample usb tuner with similar issue with following
vendor/product 13d3:0ccd.

Onboard it have: CY7C68013A-56PVXC and a SI2168-40. The tuner isn't
visible since is covered by a shield.

I've tried to patch the az6007 to make it working.

si2168 4-0064: Silicon Labs Si2168 successfully attached
si2157 5-0060: unknown chip version Si2147-A30

after applying latest patch from patchwork:

si2157 5-0060: Silicon Labs Si2157/Si2158 successfully attached

Now tuner seems to be connected but a w_scan don't detect any channel...

Can you give me some some hint on troubleshooting this issue?

Actually I'm brutally changed the initialization with copy and paste
of silab attach from cxusb.c and em28xx-dvb.c by removing the drxk
init..

Since the chinese producer recicled old vid/pid.but what is the
correct way to probe for multiple frontend and choose the right one?

Eddi


On Mon, Feb 3, 2014 at 11:33 PM, Antti Palosaari <crope@iki.fi> wrote:
> Hei Rik
>
>
> On 03.02.2014 22:21, Rik van Mierlo wrote:
>>
>> Hi,
>>
>> I've recently purchased a Terratec H7, based on the fact that is was
>> supported for a while now. Unfortunately, it turns out that my device
>> uses a different product id, and maybe is not quite the same device
>> inside either.
>>
>> ProductID for the Terratec H7 revisions in the module is either 10b4 or
>> 10a3, the one I purchased is 10a5. Following this patch:
>>
>> https://patchwork.linuxtv.org/patch/9691
>>
>> I modified drivers/media/usb/dvb-usb-v2/az6007.c to include an
>> additional device:
>>
>> static struct usb_device_id az6007_usb_table[] = {
>>          {DVB_USB_DEVICE(USB_VID_AZUREWAVE, USB_PID_AZUREWAVE_6007,
>>                  &az6007_props, "Azurewave 6007", RC_MAP_EMPTY)},
>>          {DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_H7,
>>                  &az6007_props, "Terratec H7",
>> RC_MAP_NEC_TERRATEC_CINERGY_XS)},
>>          {DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_H7_2,
>>                  &az6007_props, "Terratec H7",
>> RC_MAP_NEC_TERRATEC_CINERGY_XS)},
>>          {DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_H7_3,
>>                  &az6007_props, "Terratec H7",
>> RC_MAP_NEC_TERRATEC_CINERGY_XS)},
>>          {DVB_USB_DEVICE(USB_VID_TECHNISAT,
>> USB_PID_TECHNISAT_USB2_CABLESTAR_HDCI,
>>                  &az6007_cablestar_hdci_props, "Technisat CableStar
>> Combo HD CI", RC_MAP_EMPTY)},
>>          {0},
>> };
>>
>> and added the following to drivers/media/dvb-core/dvb-usb-ids.h
>>
>> #define USB_PID_TERRATEC_H7_3                           0x10a5
>>
>> and recompiled/installed the kernel and modules. The module seems to
>> have changed somewhat in 3.12.6 from the version that the patch was
>> meant for, so I hope I this was all I had to change.
>>
>> Rebooting and plugging in the device now at least leads to a recognized
>> device, but scanning for channels with w_scan does not work, and from
>> the dmesg output below, it seems something is not working after loading
>> the drxk firmware. Does anybody know what I could try next to get this
>> device working? Could it be that the drxk firmware is not suitable for
>> this revision of the device?
>>
>> [  700.112072] usb 4-2: new high-speed USB device number 2 using ehci-pci
>> [  700.245092] usb 4-2: New USB device found, idVendor=0ccd,
>> idProduct=10a5
>> [  700.245105] usb 4-2: New USB device strings: Mfr=1, Product=2,
>> SerialNumber=3
>> [  700.245114] usb 4-2: Product: TERRATEC T2/T/C CI USB
>> [  700.245123] usb 4-2: Manufacturer: TERRATEC
>> [  700.245131] usb 4-2: SerialNumber: 20130903
>> [  700.494693] usb read operation failed. (-32)
>> [  700.495039] usb write operation failed. (-32)
>> [  700.495413] usb write operation failed. (-32)
>> [  700.495787] usb write operation failed. (-32)
>
>
> These low level errors does not promise any good. Are these coming from USB
> stack as there is no even bus ID (4-2)...
>
>> [  700.495800] usb 4-2: dvb_usb_v2: found a 'Terratec H7' in cold state
>> [  700.507381] usb 4-2: firmware: direct-loading firmware
>> dvb-usb-terratec-h7-az6007.fw
>> [  700.507397] usb 4-2: dvb_usb_v2: downloading firmware from file
>> 'dvb-usb-terratec-h7-az6007.fw'
>> [  700.524301] usb 4-2: dvb_usb_v2: found a 'Terratec H7' in warm state
>> [  701.760878] usb 4-2: dvb_usb_v2: will pass the complete MPEG2
>> transport stream to the software demuxer
>> [  701.760947] DVB: registering new adapter (Terratec H7)
>> [  701.763853] usb 4-2: dvb_usb_v2: MAC address: c2:cd:0c:a5:10:00
>> [  701.846469] drxk: frontend initialized.
>> [  701.849123] usb 4-2: firmware: direct-loading firmware
>> dvb-usb-terratec-h7-drxk.fw
>> [  701.849215] usb 4-2: DVB: registering adapter 0 frontend 0 (DRXK)...
>> [  701.881072] drxk: status = 0x00c04125
>> [  701.881082] drxk: DeviceID 0x04 not supported
>> [  701.881090] drxk: Error -22 on init_drxk
>
>
> I suspect there is no DRX-K.
>
>> [  701.908184] mt2063_attach: Attaching MT2063
>> [  701.940248] Registered IR keymap rc-nec-terratec-cinergy-xs
>> [  701.940547] input: Terratec H7 as
>> /devices/pci0000:00/0000:00:1d.7/usb4/4-2/rc/rc0/input16
>> [  701.942559] rc0: Terratec H7 as
>> /devices/pci0000:00/0000:00:1d.7/usb4/4-2/rc/rc0
>> [  701.942575] usb 4-2: dvb_usb_v2: schedule remote query interval to
>> 400 msecs
>> [  701.942587] usb 4-2: dvb_usb_v2: 'Terratec H7' successfully
>> initialized and connected
>> [  701.942643] usbcore: registered new interface driver dvb_usb_az6007
>
>
> hmm, a little bit surprising that driver accepts hardware even those fatal
> errors.
>
> My guess is that there is no DRX-K but some other demod or likely more
> changed chips than demod. DRX-K is rather old demod and there is not very
> many newer alternatives on the market. Silicon Labs chipset ? Open the
> device in look what chips it has eaten.
>
> regards
> Antti
>
> --
> http://palosaari.fi/
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
