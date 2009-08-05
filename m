Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:54235 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbZHESeV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 14:34:21 -0400
Received: by yxe5 with SMTP id 5so362539yxe.33
        for <linux-media@vger.kernel.org>; Wed, 05 Aug 2009 11:34:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A79CEBD.1050909@iol.it>
References: <4A6F8AA5.3040900@iol.it> <4A7140DD.7040405@iol.it>
	 <829197380907300533l488acd0bt2188c4c599417966@mail.gmail.com>
	 <4A729117.6010001@iol.it>
	 <829197380907310109r1ca7231cqd86803f0fe640904@mail.gmail.com>
	 <4A739DD6.8030504@iol.it>
	 <829197380908032002v196384c9oa0aff78627959db@mail.gmail.com>
	 <4A79320B.7090401@iol.it>
	 <829197380908050627u892b526wc5fb8ef1f6be6b53@mail.gmail.com>
	 <4A79CEBD.1050909@iol.it>
Date: Wed, 5 Aug 2009 14:34:19 -0400
Message-ID: <829197380908051134x5fda787fx5bf9adf786aa739e@mail.gmail.com>
Subject: Re: Terratec Cinergy HibridT XS
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: efa@iol.it
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 5, 2009 at 2:26 PM, Valerio Messina<efa@iol.it> wrote:
> Devin Heitmueller wrote:
>>
>> Which distro is this
>
> Ubuntu 9.04
> kernel 2.6.28-14-generic
>
>> and have you updated the kernel since checking out the code?
>
> no
>
>> It's also possible if you were playing around with the mcentral
>> repository that both versions of em28xx are still installed.
>
> Mauro Carvalho Chehab wrote:
>>
>> Try a make rminstall. This is required with Ubuntu, since it installs
>> drivers/media at the wrong dir
>
> I disconnected the TV tuner, then
> $ sudo make unload
> $ sudo make rminstall
> in the three following subdirectories:
> v4l-dvb
> v4l-dvb-kernel  (mcentral hg copy)
> ttxs-remote
>
> Then follow instructions from Devin:
> hg clone http://kernellabs.com/hg/~dheitmueller/ttxs-remote
> cd ttxs-remote
> make
> sudo make install
> reboot
>
> No error on compile and install time.
> But same results, Kaffeine do not see the TVtuner, and dmesg report this on
> USB connect:
>
> Aug  5 20:12:16 01ath3200 kernel: [  182.312039] usb 1-3: new high speed USB
> device using ehci_hcd and address 3
> Aug  5 20:12:16 01ath3200 kernel: [  182.497009] usb 1-3: configuration #1
> chosen from 1 choice
> Aug  5 20:12:16 01ath3200 kernel: [  182.622103] usbcore: registered new
> interface driver snd-usb-audio
> Aug  5 20:12:17 01ath3200 kernel: [  182.810124] Linux video capture
> interface: v2.00
> Aug  5 20:12:17 01ath3200 kernel: [  182.831714] em28xx: disagrees about
> version of symbol v4l_compat_translate_ioctl
> Aug  5 20:12:17 01ath3200 kernel: [  182.831725] em28xx: Unknown symbol
> v4l_compat_translate_ioctl
> Aug  5 20:12:17 01ath3200 kernel: [  182.835363] em28xx: disagrees about
> version of symbol video_unregister_device
> Aug  5 20:12:17 01ath3200 kernel: [  182.835370] em28xx: Unknown symbol
> video_unregister_device
> Aug  5 20:12:17 01ath3200 kernel: [  182.835754] em28xx: disagrees about
> version of symbol video_device_alloc
> Aug  5 20:12:17 01ath3200 kernel: [  182.835759] em28xx: Unknown symbol
> video_device_alloc
> Aug  5 20:12:17 01ath3200 kernel: [  182.835944] em28xx: disagrees about
> version of symbol video_register_device
> Aug  5 20:12:17 01ath3200 kernel: [  182.835949] em28xx: Unknown symbol
> video_register_device
> Aug  5 20:12:17 01ath3200 kernel: [  182.836988] em28xx: disagrees about
> version of symbol video_usercopy
> Aug  5 20:12:17 01ath3200 kernel: [  182.836993] em28xx: Unknown symbol
> video_usercopy
> Aug  5 20:12:17 01ath3200 kernel: [  182.837178] em28xx: disagrees about
> version of symbol video_device_release
> Aug  5 20:12:17 01ath3200 kernel: [  182.837183] em28xx: Unknown symbol
> video_device_release
> ... (repeated 3 times)
> Aug  5 20:12:18 01ath3200 pulseaudio[4364]: alsa-util.c: Cannot find
> fallback mixer control "Mic" or mixer control is no combination of
> switch/volume.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Try running this:

find /lib/modules/ -name "em28*"

Then pastebin the output and send us a link.  Also send us the output of:

uname -a

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
