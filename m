Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38320 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbaKIV2i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Nov 2014 16:28:38 -0500
Message-ID: <545FDC84.4020602@iki.fi>
Date: Sun, 09 Nov 2014 23:28:36 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jan Tisje <jan.tisje@gmx.de>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Technisat DVB-S2 USB: reduced buffer sizes
References: <545E4FA1.9010509@gmx.de>
In-Reply-To: <545E4FA1.9010509@gmx.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
I forget to mention, but the technique I use some error and trial to 
find out smallest possible buffer in a worst case. Worst case is case 
where stream bandwidth is ~biggest possible. Most effective modulation, 
less error coding, maximum channel bandwidth (symbol rate). Then add 
some 20% extra to that. You will see it immediately when USB buffers are 
too small - data starts dropping, which means audio and video are so 
broken you could see pixels on video and crackle on audio.

Minimum size of needed USB buffer is largely dependent use USB chip 
buffer size (FIFO) and data stream size which is transferred over the USB.

According to interface descriptors, that chip supports both bulk and 
isochronous transfers (select using different alternative setting). I 
would prefer always bulk over isoc due to performance reasons. Isoc 
guarantee some timing and bandwidth for just this device, whilst bulk is 
just like a best-effort delivery. For DVB streaming timing issues are 
not critical and you surely find it very soon if you try use too many 
devices on same bus, which are using all the bus bandwidth, as the 
stream goes garbage. I think isoc device will be just rejected if USB 
core cannot reserve bandwidth it requests (from interface descriptors(?)).

Also, it is very often seen that those interface descriptors are wrong. 
Even it says isoc payload 2x 1024, it could be something else, like 
1x1024. Using maximum 3x1024 and adding debugs will print real used size.

regards
Antti


On 11/08/2014 07:15 PM, Jan Tisje wrote:
> Hi,
>
> I reduced the buffer size in order to make this driver work on my NAS
> station. It's an arm system and thus only has limited resources.
>
> I compiled and ran with kernel 3.16.3 for some weeks and now compiled
> and booted kernel 3.17.2 today.
> Without this patch the device doesn't work at all, in both kernel versions.
>
> This is what Antti Palosaar crope@iki.fi wrote:
>> If I didn't remember wrong, that means allocated buffers are 8 * 32 * 2048 = 524288 bytes.
>> It sounds rather big for my taste. Probably even wrong. IIRC USB2.0 frames are 1024 and there could be 1-3 frames.
>> You could use lsusb with all verbosity levels to see if it is 1024/2048/3072. And set value according to that info.
>> So I would recommend .count = 6, .framesperurb = 8, .framesize = 1024
>
>
> I only changed one value because this was sufficient to make it work.
>
> I believe these sizes correspond to the output of lsusb -v
> But to be honest: I don't have any idea of what this all is about. USB
> wasn't invented yet when I studied computer science. ;)
> maybe someone knows better.
>
>      Interface Descriptor:
>        bAlternateSetting       0
>        Endpoint Descriptor:
>          bEndpointAddress     0x82  EP 2 IN
>          wMaxPacketSize     0x0200  1x 512 bytes
>        Endpoint Descriptor:
>          bEndpointAddress     0x81  EP 1 IN
>          wMaxPacketSize     0x0200  1x 512 bytes
>        Endpoint Descriptor:
>          bEndpointAddress     0x01  EP 1 OUT
>          wMaxPacketSize     0x0200  1x 512 bytes
>      Interface Descriptor:
>        bAlternateSetting       1
>        Endpoint Descriptor:
>          bEndpointAddress     0x82  EP 2 IN
>          wMaxPacketSize     0x0c00  2x 1024 bytes
>            Transfer Type            Isochronous
>        Endpoint Descriptor:
>          bEndpointAddress     0x81  EP 1 IN
>          wMaxPacketSize     0x0200  1x 512 bytes
>        Endpoint Descriptor:
>          bEndpointAddress     0x01  EP 1 OUT
>          wMaxPacketSize     0x0200  1x 512 bytes
>
>
> This is the first kernel patch I submitted. I hope everything is fine.
>
> Jan
>
>
> diff -uNr linux-3.17.2.orig/drivers/media/usb/dvb-usb/technisat-usb2.c
> linux-3.17.2/drivers/media/usb/dvb-usb/technisat-usb2.c
> --- linux-3.17.2.orig/drivers/media/usb/dvb-usb/technisat-usb2.c
> 2014-10-30 17:43:25.000000000 +0100
> +++ linux-3.17.2/drivers/media/usb/dvb-usb/technisat-usb2.c
> 2014-11-08 17:31:18.716668708 +0100
> @@ -708,7 +708,7 @@
>                                  .endpoint = 0x2,
>                                  .u = {
>                                          .isoc = {
> -                                               .framesperurb = 32,
> +                                               .framesperurb = 8,
>                                                  .framesize = 2048,
>                                                  .interval = 1,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
http://palosaari.fi/
