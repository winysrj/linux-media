Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59642 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab2HUQQn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 12:16:43 -0400
Received: by lbbgj3 with SMTP id gj3so78716lbb.19
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2012 09:16:41 -0700 (PDT)
Message-ID: <5033B459.1020401@iki.fi>
Date: Tue, 21 Aug 2012 19:16:25 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "M. Fletcher" <mpf30@cam.ac.uk>
CC: linux-media@vger.kernel.org
Subject: Re: Unable to load dvb-usb-rtl2832u driver in Ubuntu 12.04
References: <00f301cd7fb1$b596f2c0$20c4d840$@cam.ac.uk> <5033A9C3.7090501@iki.fi> <00f401cd7fb2$d402c530$7c084f90$@cam.ac.uk> <5033AC22.608@iki.fi> <00f501cd7fb7$f93fc0a0$ebbf41e0$@cam.ac.uk>
In-Reply-To: <00f501cd7fb7$f93fc0a0$ebbf41e0$@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/21/2012 07:13 PM, M. Fletcher wrote:
>> Open the rtl28xxu.c file and find line:
>> 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK, replace
> it:
>> 	{ DVB_USB_DEVICE(0x185b, 0x0680,
>
> Line changed as follows:
>
> //{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_NOXON_DAB_STICK,
> { DVB_USB_DEVICE(0x185b, 0x0680,
> 	&rtl2832u_props, "NOXON DAB/DAB+ USB dongle", NULL) },
>
>> Compile and install.
>
> Successful.
>
>> Enable debugs:
>> #modprobe dvb_usb_rtl28xxu; echo -n 'module dvb_usb_rtl28xxu +p' >
> /sys/kernel/debug/dynamic_debug/control
>
> Executing this entire line produced:
> bash: /sys/kernel/debug/dynamic_debug/control: No such file or directory
>
> Succesfully executed:
> modprobe dvb_usb_rtl28xxu
>
> Module loaded:
> root@DCTbox:/# lsmod | grep dvb
> dvb_usb_rtl28xxu       18522  0
> dvb_usbv2              23726  1 dvb_usb_rtl28xxu
> rc_core                26343  2 dvb_usb_rtl28xxu,dvb_usbv2
> rtl2830                18340  1 dvb_usb_rtl28xxu
> dvb_core              110590  2 dvb_usbv2,rtl2830
>
>> plug stick in and look what dmesg says. With a good luck there is supported
> RF-tuner and it works, but most likely there is some RF-tuner which is >not
> supported and it does not work.
>
> root@DCTbox:/home/dct# dmesg
> [  136.285497] usb 5-2: new high-speed USB device number 4 using xhci_hcd
> [  136.319609] usb 5-2: ep 0x81 - rounding interval to 32768 microframes, ep
> desc says 0 microframes
> [  136.367747] WARNING: You are using an experimental version of the media
> stack.
> [  136.367748] 	As the driver is backported to an older kernel, it doesn't
> offer
> [  136.367749] 	enough quality for its usage in production.
> [  136.367750] 	Use it with care.
> [  136.367750] Latest git patches (needed if you report a bug to
> linux-media@vger.kernel.org):
> [  136.367751] 	9b78c5a3007e10a172d4e83bea18509fdff2e8e3 [media] b2c2:
> export b2c2_flexcop_debug symbol
> [  136.367752] 	88f8472c9fc6c08f5113887471f1f4aabf7b2929 [media] Fix some
> Makefile rules
> [  136.367753] 	893430558e5bf116179915de2d3d119ad25c01cf [media]
> cx23885-cards: fix netup card default revision
> [  136.389963] WARNING: You are using an experimental version of the media
> stack.
> [  136.389964] 	As the driver is backported to an older kernel, it doesn't
> offer
> [  136.389965] 	enough quality for its usage in production.
> [  136.389965] 	Use it with care.
> [  136.389966] Latest git patches (needed if you report a bug to
> linux-media@vger.kernel.org):
> [  136.389966] 	9b78c5a3007e10a172d4e83bea18509fdff2e8e3 [media] b2c2:
> export b2c2_flexcop_debug symbol
> [  136.389967] 	88f8472c9fc6c08f5113887471f1f4aabf7b2929 [media] Fix some
> Makefile rules
> [  136.389968] 	893430558e5bf116179915de2d3d119ad25c01cf [media]
> cx23885-cards: fix netup card default revision
> [  136.407633] usb 5-2: dvb_usbv2: found a 'NOXON DAB/DAB+ USB dongle' in
> warm state
> [  136.407655] usbcore: registered new interface driver dvb_usb_rtl28xxu
> [  136.434729] usb 5-2: dvb_usbv2: will pass the complete MPEG2 transport
> stream to the software demuxer
> [  136.434796] DVB: registering new adapter (NOXON DAB/DAB+ USB dongle)
> [  136.470930] usb 5-2: dvb_usb_rtl28xxu: E4000 tuner found
> [  136.482557] usb 5-2: dvb_usbv2: 'NOXON DAB/DAB+ USB dongle' error while
> loading driver (-19)
> [  136.483313] usb 5-2: dvb_usbv2: 'NOXON DAB/DAB+ USB dongle' successfully
> deinitialized and disconnected
>
> If this is an unsupported tuner do I need to get a different usb device or
> can I try a different rtl driver?

No luck, no driver for e4000.

I think vendor driver could support your device, try to find it.

regards
Antti

-- 
http://palosaari.fi/
