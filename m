Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f183.google.com ([209.85.211.183]:38484 "EHLO
	mail-yw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933904AbZHEN1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 09:27:14 -0400
Received: by ywh13 with SMTP id 13so118850ywh.15
        for <linux-media@vger.kernel.org>; Wed, 05 Aug 2009 06:27:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A79320B.7090401@iol.it>
References: <4A6F8AA5.3040900@iol.it>
	 <829197380907281744o5c3a7eb7rd0d2cb8c53cd646f@mail.gmail.com>
	 <4A7140DD.7040405@iol.it>
	 <829197380907300533l488acd0bt2188c4c599417966@mail.gmail.com>
	 <4A729117.6010001@iol.it>
	 <829197380907310109r1ca7231cqd86803f0fe640904@mail.gmail.com>
	 <4A739DD6.8030504@iol.it>
	 <829197380908032002v196384c9oa0aff78627959db@mail.gmail.com>
	 <4A79320B.7090401@iol.it>
Date: Wed, 5 Aug 2009 09:27:13 -0400
Message-ID: <829197380908050627u892b526wc5fb8ef1f6be6b53@mail.gmail.com>
Subject: Re: Terratec Cinergy HibridT XS
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: efa@iol.it
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 5, 2009 at 3:17 AM, Valerio Messina<efa@iol.it> wrote:
> Devin Heitmueller ha scritto:
>>
>> Please try the following:
>> hg clone http://kernellabs.com/hg/~dheitmueller/ttxs-remote
>> cd ttxs-remote
>> make
>> make install
>> reboot
>>
>> Then see if the remote control works.  If not, I will give you some
>> commands to turn on the logging.  This should work though since I had
>> tested it myself when I had the device in question a couple of weeks
>> ago.
>
> with this repository compiled, installed and after reboot, Kaffeine does not
> see at all the TV tuner.
> Logging instructions are always welcomed.
> Valerio
>
> dmesg report this log when I connect the USB tuner:
>
> Aug  5 08:46:31 01ath3200 kernel: [  365.276042] usb 1-3: new high speed USB
> device using ehci_hcd and address 4
> Aug  5 08:46:31 01ath3200 kernel: [  365.458835] usb 1-3: configuration #1
> chosen from 1 choice
> Aug  5 08:46:31 01ath3200 kernel: [  365.474488] Linux video capture
> interface: v2.00
> Aug  5 08:46:31 01ath3200 kernel: [  365.523111] em28xx: disagrees about
> version of symbol v4l_compat_translate_ioctl
> Aug  5 08:46:31 01ath3200 kernel: [  365.523122] em28xx: Unknown symbol
> v4l_compat_translate_ioctl
> Aug  5 08:46:31 01ath3200 kernel: [  365.525987] em28xx: disagrees about
> version of symbol video_unregister_device
> Aug  5 08:46:31 01ath3200 kernel: [  365.525992] em28xx: Unknown symbol
> video_unregister_device
> Aug  5 08:46:31 01ath3200 kernel: [  365.526369] em28xx: disagrees about
> version of symbol video_device_alloc
> Aug  5 08:46:31 01ath3200 kernel: [  365.526374] em28xx: Unknown symbol
> video_device_alloc
> Aug  5 08:46:31 01ath3200 kernel: [  365.526559] em28xx: disagrees about
> version of symbol video_register_device
> Aug  5 08:46:31 01ath3200 kernel: [  365.526564] em28xx: Unknown symbol
> video_register_device
> Aug  5 08:46:31 01ath3200 kernel: [  365.527584] em28xx: disagrees about
> version of symbol video_usercopy
> Aug  5 08:46:31 01ath3200 kernel: [  365.527589] em28xx: Unknown symbol
> video_usercopy
> Aug  5 08:46:31 01ath3200 kernel: [  365.527774] em28xx: disagrees about
> version of symbol video_device_release
> Aug  5 08:46:31 01ath3200 kernel: [  365.527779] em28xx: Unknown symbol
> video_device_release
> Aug  5 08:46:32 01ath3200 pulseaudio[4176]: alsa-util.c: Cannot find
> fallback mixer control "Mic" or mixer control is no combination of
> switch/volume.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Seems like your compile environment got messed up somehow.  Which
distro is this, and have you updated the kernel since checking out the
code?  It's also possible if you were playing around with the mcentral
repository that both versions of em28xx are still installed.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
