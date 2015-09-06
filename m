Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34512 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbbIFTx7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Sep 2015 15:53:59 -0400
Date: Sun, 6 Sep 2015 16:53:54 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Ronald Tallent <ron@tallent.ws>
Cc: linux-media@vger.kernel.org
Subject: Re: 3rd posting: em28xx: new board id [1f4d:1abe]
Message-ID: <20150906165354.7f6f0c96@recife.lan>
In-Reply-To: <1441567008.5526.8.camel@Amy>
References: <1441567008.5526.8.camel@Amy>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ronald,

Well, probably nobody knows what to do with that ;)

If I understood well your post, video didn't work, right?

So, either you or someone else with the same hardware as you have would
need to make it work and send a patch to the mailing list adding support
for this new ID.

Probably, it is just either a GPIO or the video input that it is wrong.
In order to fix it, you would either need some help from the manufacturer
or to sniff the USB message exchanges from the original driver and check
the settings for saa7113 and em28xx. The wiki has some info about how
to do it.

Regards,
Mauro


Em Sun, 06 Sep 2015 14:16:48 -0500
Ronald Tallent <ron@tallent.ws> escreveu:

> Hi, 
> 
> This is my third attempt to post this information to mailing list in a
> little over a week. Am I invisible? Can nobody see my messages? I have
> precisely followed the instructions posted on
> linuxtv.org/wiki/index.php/Em28xx_devices#How_to_validate_my_vendor.2Fproduct_id_at_upstream_kernel.3F
> trying to get my hardware validated. What else do I need to do?  Can
> someone answer please and help me. 
> 
> Thanks,
> --Ronald
> 
> 
> I've tested my USB easycap device (Geniatech iGrabber) in Ubuntu
> 14.04.
> 
> Make: Geniatech
> Model: iGrabber for MAC
> Vendor/Product ID: [1f4d:1abe]
> Product website: www.geniatech.com/pa/igrabber.asp
> 
> Tests Made:
> - Audio Capture [worked]
> - Video Capture [device not detected]
> - DVB [does not have DVB]
> 
> Tested by:
> ron@tallent.ws
> 
> 
> Detailed information on device and system below for reference:
> 
> uname -a:
> 3.13.0-62-generic #102-Ubuntu SMP Tue Aug 11 14:29:36 UTC 2015 x86_64 
> x86_64 x86_64 GNU/Linux
> 
> dmesg:
> [] usb 3-3.3: new high-speed USB device number 8 using xhci_hcd
> [] usb 3-3.3: New USB device found, idVendor=1f4d, idProduct=1abe
> [] usb 3-3.3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
> [] usb 3-3.3: Product: USB Device
> [] usbcore: registered new interface driver snd-usb-audio
> 
> lsusb:
> Bus 003 Device 008: ID 1f4d:1abe G-Tek Electronics Group 
> 
> Hardware: 
> Opened the case and found the following text printed on the board:
>    HandyCap
>    v1.51
>    2007-4-24
> 
> Three chips on board are:
> 1: empia
>    EM2860
>    P8367-010
>    201036-01AG
> 
> 2: Trident
>    SAA7113H
>    C2P409.00 02
>    A5G11152
> 
> 3: eMPIA
>    Technology
>    EMP202
>    UT11958
>    1027
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
