Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:46700 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbZF3BFZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2009 21:05:25 -0400
Received: by qw-out-2122.google.com with SMTP id 9so1926738qwb.37
        for <linux-media@vger.kernel.org>; Mon, 29 Jun 2009 18:05:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c21478f30906291719r41ba5accu75c5bfd3dcb81276@mail.gmail.com>
References: <c21478f30906291719r41ba5accu75c5bfd3dcb81276@mail.gmail.com>
Date: Mon, 29 Jun 2009 20:59:27 -0400
Message-ID: <829197380906291759q7ded8117tee12214073d85e67@mail.gmail.com>
Subject: Re: XC2028 Tuner - firmware issues
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andrej Falout <andrej@falout.org>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 29, 2009 at 8:19 PM, Andrej Falout<andrej@falout.org> wrote:
> Hello *,
>
> Device: Kaiser Baas USB Hybrid (Analogue and Digital) TV Tuner (KBA01003):
>
> http://www.kaiserbaas.com/KBA01003_KB202-1_Kaiser_Baas_USB_Hybrid_HD_TV_Tuner.html
>
> Digital DVB-T works fine, but analogue TV & FM radio does not.
>
> Current Mercurial:
>
> Jun 29 18:53:53 polar kernel: usb 8-1: new high speed USB device using
> ehci_hcd and address 4
> Jun 29 18:53:54 polar kernel: usb 8-1: configuration #1 chosen from 1 choice
> Jun 29 18:53:54 polar kernel: dvb-usb: found a 'YUAN High-Tech
> STK7700PH' in cold state, will try to load a firmware
> Jun 29 18:53:54 polar kernel: firmware: requesting dvb-usb-dib0700-1.20.fw
> Jun 29 18:53:54 polar kernel: dvb-usb: downloading firmware from file
> 'dvb-usb-dib0700-1.20.fw'
> Jun 29 18:53:54 polar kernel: dib0700: firmware started successfully.
> Jun 29 18:53:54 polar kernel: dvb-usb: found a 'YUAN High-Tech
> STK7700PH' in warm state.
> Jun 29 18:53:54 polar kernel: dvb-usb: will pass the complete MPEG2
> transport stream to the software demuxer.
> Jun 29 18:53:54 polar kernel: DVB: registering new adapter (YUAN
> High-Tech STK7700PH)
> Jun 29 18:53:55 polar kernel: DVB: registering adapter 2 frontend 0
> (DiBcom 7000PC)...
> Jun 29 18:53:55 polar kernel: xc2028 11-0061: creating new instance
> Jun 29 18:53:55 polar kernel: xc2028 11-0061: type set to XCeive
> xc2028/xc3028 tuner
> Jun 29 18:53:55 polar kernel: input: IR-receiver inside an USB DVB
> receiver as /devices/pci0000:00/0000:00:1d.7/usb8/8-1/input/input11
> Jun 29 18:53:55 polar kernel: dvb-usb: schedule remote query interval
> to 50 msecs.
> Jun 29 18:53:55 polar kernel: dvb-usb: YUAN High-Tech STK7700PH
> successfully initialized and connected.
> Jun 29 18:53:55 polar kernel: usb 8-1: New USB device found,
> idVendor=1164, idProduct=1f08
> Jun 29 18:53:55 polar kernel: usb 8-1: New USB device strings: Mfr=1,
> Product=2, SerialNumber=3
> Jun 29 18:53:55 polar kernel: usb 8-1: Product: STK7700D
> Jun 29 18:53:55 polar kernel: usb 8-1: Manufacturer: YUANRD
> Jun 29 18:53:55 polar kernel: usb 8-1: SerialNumber: 0000000001
>
> Please note that xc2028 load ended WITHOUT an attempt to load the firmware.
>
> Reading on http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028 :
>
> "In order for the proper firmware to load, the bridge chip must be
> coded with a xc3028-specific setup and a tuner_callback, with the
> proper GPIO codes to reset the xc2028/3038. "... etc
>
> Googling around I also found that there was/is a known problem with
> loading firmware:
>
> http://www.linuxtv.org/pipermail/linux-dvb/2008-September/028559.html :
>> >> [ 274.439468] xc2028 3-0061: seek_firmware called, want type=D2620
>> >> DTV6 (28), id 0000000000000000.
>> >> [ 274.439472] xc2028 3-0061: Can't find firmware for type=D2620 DTV6
>> >> (28), id 0000000000000000.
>> >> [ 274.439475] xc2028 3-0061: load_firmware called
>> >> [ 274.439477] xc2028 3-0061: seek_firmware called, want type=D2620
>> >> DTV6 (28), id 0000000000000000.
>> >> [ 274.439481] xc2028 3-0061: Can't find firmware for type=D2620 DTV6
>> >> (28), id 0000000000000000.
>
> I also find out that others are experiencing exactly the same behavior:
>
> https://www.linuxquestions.org/questions/linux-hardware-18/tv-tuner-yuan-mc770a-analog-part-help-719282/
>
>
> I did spend a fair bit of time researching this, so please dont hate
> me if the answer is already available somewhere :-) Just a pointer
> will do...
>
> If this is not an issue with a known solution, is there anything I can
> do? I am a SW developer, but my understanding of HW drivers is close
> to zero.
>
> Your knowledge and help is very much appreciated!
>
> Cheers,
> Andrej Falout
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

The dvb-usb framework doesn't have any analog support.  Therefore none
of the dib0700 based devices will support analog either (the problem
is not specific to your device and has nothing to do with the xc3028
firmware).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
