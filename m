Return-path: <mchehab@pedra>
Received: from 5571f1ba.dsl.concepts.nl ([85.113.241.186]:52058 "EHLO
	his10.thuis.hoogenraad.info" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753268Ab1GBUYD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Jul 2011 16:24:03 -0400
Message-ID: <4E0F7E5F.3040702@hoogenraad.net>
Date: Sat, 02 Jul 2011 22:23:59 +0200
From: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>
MIME-Version: 1.0
To: Arthur Marsh <arthur.marsh@internode.on.net>
CC: linux-media@vger.kernel.org, Joel Stanley <joel@jms.id.au>
Subject: Re: Fwd: 0bda:2838 Ezcap DVB USB adaptor - no device files created
 /  RTL2831U/RTL2832U
References: <4E0EC37F.1010201@internode.on.net>
In-Reply-To: <4E0EC37F.1010201@internode.on.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is the same problem why the tree on
http://linuxtv.org/hg/~jhoogenraad/rtl2831-r2/
does not work for newer kernels.

I have decided AGAINST making it runnable on newer kernels, as there are 
some people working right now on a new release.

Once the status becomes more clear, I'll update
http://www.linuxtv.org/wiki/index.php/Realtek_RTL2831U

Arthur Marsh wrote:
> Hi, I bought one of these things having seen the Linux penguin on the
> box and compiled the code from the
> http://jms.id.au/wiki/EzcapDvbAdapter web page on a quad core AMD64
> machine using 3.0.0-rc5 Linux kernel and GCC 4.6.1 under Debian sid.
>
> On boot-up the device is at least partially recognised:
>
> [ 1.430924] usb 1-5: New USB device found, idVendor=0bda, idProduct=2838
> [ 1.431005] usb 1-5: Product: RTL2838UHIDIR
> [ 6.245292] IR NEC protocol handler initialized
> [ 6.284327] IR RC5(x) protocol handler initialized
> [ 6.338049] IR RC6 protocol handler initialized
> [ 6.371470] IR JVC protocol handler initialized
> [ 6.448155] IR Sony protocol handler initialized
> [ 6.590577] lirc_dev: IR Remote Control driver registered, major 252
> [ 6.591144] IR LIRC bridge handler initialized
> [ 7.085160] usbcore: registered new interface driver dvb_usb_rtl2832u
>
>
> $ lsmod|grep dvb
> dvb_usb_rtl2832u 111764 0
> dvb_usb 18302 1 dvb_usb_rtl2832u
> dvb_core 77682 1 dvb_usb
> rc_core 18294 7
> dvb_usb,ir_lirc_codec,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,ir_nec_decoder
>
> i2c_core 23876 7
> dvb_usb,max6650,radeon,drm_kms_helper,drm,i2c_algo_bit,i2c_piix4
> usbcore 119731 5 dvb_usb_rtl2832u,dvb_usb,ohci_hcd,ehci_hcd
>
> but apparently no device files are created (there is no /dev/dvb tree).
>
> Any suggestions for things to try to get this working welcome.
>
> Regards,
>
> Arthur.
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>


-- 
Jan Hoogenraad
Hoogenraad Interface Services
Postbus 2717
3500 GS Utrecht
