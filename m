Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54672 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934160AbZHEO2f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Aug 2009 10:28:35 -0400
Date: Wed, 5 Aug 2009 11:27:35 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: efa@iol.it, linux-media@vger.kernel.org
Subject: Re: Terratec Cinergy HibridT XS
Message-ID: <20090805112735.41ad3b0f@pedra.chehab.org>
In-Reply-To: <829197380908050627u892b526wc5fb8ef1f6be6b53@mail.gmail.com>
References: <4A6F8AA5.3040900@iol.it>
	<829197380907281744o5c3a7eb7rd0d2cb8c53cd646f@mail.gmail.com>
	<4A7140DD.7040405@iol.it>
	<829197380907300533l488acd0bt2188c4c599417966@mail.gmail.com>
	<4A729117.6010001@iol.it>
	<829197380907310109r1ca7231cqd86803f0fe640904@mail.gmail.com>
	<4A739DD6.8030504@iol.it>
	<829197380908032002v196384c9oa0aff78627959db@mail.gmail.com>
	<4A79320B.7090401@iol.it>
	<829197380908050627u892b526wc5fb8ef1f6be6b53@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 5 Aug 2009 09:27:13 -0400
Devin Heitmueller <dheitmueller@kernellabs.com> escreveu:

> On Wed, Aug 5, 2009 at 3:17 AM, Valerio Messina<efa@iol.it> wrote:
> > Devin Heitmueller ha scritto:
> >>
> >> Please try the following:
> >> hg clone http://kernellabs.com/hg/~dheitmueller/ttxs-remote
> >> cd ttxs-remote
> >> make
> >> make install
> >> reboot
> >>
> >> Then see if the remote control works.  If not, I will give you some
> >> commands to turn on the logging.  This should work though since I had
> >> tested it myself when I had the device in question a couple of weeks
> >> ago.
> >
> > with this repository compiled, installed and after reboot, Kaffeine does not
> > see at all the TV tuner.
> > Logging instructions are always welcomed.
> > Valerio
> >
> > dmesg report this log when I connect the USB tuner:
> >
> > Aug  5 08:46:31 01ath3200 kernel: [  365.276042] usb 1-3: new high speed USB
> > device using ehci_hcd and address 4
> > Aug  5 08:46:31 01ath3200 kernel: [  365.458835] usb 1-3: configuration #1
> > chosen from 1 choice
> > Aug  5 08:46:31 01ath3200 kernel: [  365.474488] Linux video capture
> > interface: v2.00
> > Aug  5 08:46:31 01ath3200 kernel: [  365.523111] em28xx: disagrees about
> > version of symbol v4l_compat_translate_ioctl
> > Aug  5 08:46:31 01ath3200 kernel: [  365.523122] em28xx: Unknown symbol
> > v4l_compat_translate_ioctl
> > Aug  5 08:46:31 01ath3200 kernel: [  365.525987] em28xx: disagrees about
> > version of symbol video_unregister_device
> > Aug  5 08:46:31 01ath3200 kernel: [  365.525992] em28xx: Unknown symbol
> > video_unregister_device
> > Aug  5 08:46:31 01ath3200 kernel: [  365.526369] em28xx: disagrees about
> > version of symbol video_device_alloc
> > Aug  5 08:46:31 01ath3200 kernel: [  365.526374] em28xx: Unknown symbol
> > video_device_alloc
> > Aug  5 08:46:31 01ath3200 kernel: [  365.526559] em28xx: disagrees about
> > version of symbol video_register_device
> > Aug  5 08:46:31 01ath3200 kernel: [  365.526564] em28xx: Unknown symbol
> > video_register_device
> > Aug  5 08:46:31 01ath3200 kernel: [  365.527584] em28xx: disagrees about
> > version of symbol video_usercopy
> > Aug  5 08:46:31 01ath3200 kernel: [  365.527589] em28xx: Unknown symbol
> > video_usercopy
> > Aug  5 08:46:31 01ath3200 kernel: [  365.527774] em28xx: disagrees about
> > version of symbol video_device_release
> > Aug  5 08:46:31 01ath3200 kernel: [  365.527779] em28xx: Unknown symbol
> > video_device_release
> > Aug  5 08:46:32 01ath3200 pulseaudio[4176]: alsa-util.c: Cannot find
> > fallback mixer control "Mic" or mixer control is no combination of
> > switch/volume.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> Seems like your compile environment got messed up somehow.  Which
> distro is this, and have you updated the kernel since checking out the
> code?  It's also possible if you were playing around with the mcentral
> repository that both versions of em28xx are still installed.

Try a make rminstall. This is required with Ubuntu, since it installs
drivers/media at the wrong dir



Cheers,
Mauro
