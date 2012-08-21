Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:56911 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753737Ab2HUOb5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 10:31:57 -0400
Received: by lagy9 with SMTP id y9so3930281lag.19
        for <linux-media@vger.kernel.org>; Tue, 21 Aug 2012 07:31:56 -0700 (PDT)
Message-ID: <50339BCB.3090006@iki.fi>
Date: Tue, 21 Aug 2012 17:31:39 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: "M. Fletcher" <mpf30@cam.ac.uk>
CC: linux-media@vger.kernel.org
Subject: Re: Unable to load dvb-usb-rtl2832u driver in Ubuntu 12.04
References: <00d701cd7fa8$b592c320$20b84960$@cam.ac.uk>
In-Reply-To: <00d701cd7fa8$b592c320$20b84960$@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/21/2012 05:24 PM, M. Fletcher wrote:
> I am trying to setup a Compro U680F USB DVB-T adaptor in Ubuntu 12.04
> (kernel
> 3.2.0-29-generic).
>
> The compro device ID is given (lsusb) as 185b:0680. The following page
> suggests
> this device is supported by the RT2832U driver:
> http://www.dfragos.me/2011/11/installation-of-the-rt2832u-driver-in-linux/
>
> I successfully built the v4l-dvb package from source following this how to,
> using the "Basic Approach":
> http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_D
> evice_Drivers
>
> After restarting the system the device does not appear to be working. The
> output from "lsmod | grep dvb" is as follows:
>
> root@DCTbox:/home/dct# lsmod | grep dvb
> dvb_usb                32369  0
> dvb_core              110590  1 dvb_usb
> rc_core                26343  1 dvb_usb
>
>
> If I unplug the device and plug back in, I get the following from "dmesg |
> tail":
>
> root@DCTbox:/home/dct# dmesg | tail -n 27
> [  160.015155] usb 5-2: new high-speed USB device number 4 using xhci_hcd
> [  160.051152] usb 5-2: ep 0x81 - rounding interval to 32768 microframes, ep
> desc says 0 microframes
> [  160.133825] WARNING: You are using an experimental version of the media
> stack.
> [  160.133826]     As the driver is backported to an older kernel, it
> doesn't
> offer
> [  160.133827]     enough quality for its usage in production.
> [  160.133828]     Use it with care.
> [  160.133829] Latest git patches (needed if you report a bug to
> linux-media@vger.kernel.org):
> [  160.133830]     9b78c5a3007e10a172d4e83bea18509fdff2e8e3 [media] b2c2:
> export b2c2_flexcop_debug symbol
> [  160.133832]     88f8472c9fc6c08f5113887471f1f4aabf7b2929 [media] Fix some
> Makefile rules
> [  160.133833]     893430558e5bf116179915de2d3d119ad25c01cf [media]
> cx23885-cards: fix netup card default revision
> [  160.144374] WARNING: You are using an experimental version of the media
> stack.
> [  160.144376]     As the driver is backported to an older kernel, it
> doesn't
> offer
> [  160.144377]     enough quality for its usage in production.
> [  160.144378]     Use it with care.
> [  160.144379] Latest git patches (needed if you report a bug to
> linux-media@vger.kernel.org):
> [  160.144380]     9b78c5a3007e10a172d4e83bea18509fdff2e8e3 [media] b2c2:
> export b2c2_flexcop_debug symbol
> [  160.144381]     88f8472c9fc6c08f5113887471f1f4aabf7b2929 [media] Fix some
> Makefile rules
> [  160.144383]     893430558e5bf116179915de2d3d119ad25c01cf [media]
> cx23885-cards: fix netup card default revision
> [  160.173311] dvb_usb_rtl2832u: disagrees about version of symbol
> dvb_usb_device_init
> [  160.173315] dvb_usb_rtl2832u: Unknown symbol dvb_usb_device_init (err
> -22)
> [  392.860811] dvb_usb_rtl2832u: disagrees about version of symbol
> dvb_usb_device_init
> [  392.860815] dvb_usb_rtl2832u: Unknown symbol dvb_usb_device_init (err
> -22)
> [ 1282.328055] usb 5-2: USB disconnect, device number 4
> [ 1288.697208] usb 5-2: new high-speed USB device number 5 using xhci_hcd
> [ 1288.732785] usb 5-2: ep 0x81 - rounding interval to 32768 microframes, ep
> desc says 0 microframes
> [ 1288.747585] dvb_usb_rtl2832u: disagrees about version of symbol
> dvb_usb_device_init
> [ 1288.747589] dvb_usb_rtl2832u: Unknown symbol dvb_usb_device_init (err
> -22)
>
>
>
> If I attempt to load the driver manually I get the following error message:
>
> root@DCTbox:/home/dct# modprobe dvb_usb_rtl2832u
> FATAL: Error inserting dvb_usb_rtl2832u
> (/lib/modules/3.2.0-29-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-rtl2
> 832u.ko):
> Invalid argument
>
>
>
> Any advice on how to get this device working successfully would be greatly
> appreciated.
>
> Kind regards,
> Marc

There is no driver named dvb_usb_rtl2832u. It is dvb_usb_rtl28xxu. I 
don't know how in the world you could have such driver. It is not from 
the LinuxTV.org / Kernel as you argue.

regards
Antti

-- 
http://palosaari.fi/
