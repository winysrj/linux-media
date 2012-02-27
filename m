Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39668 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab2B0T0H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Feb 2012 14:26:07 -0500
Received: by vbbff1 with SMTP id ff1so1165758vbb.19
        for <linux-media@vger.kernel.org>; Mon, 27 Feb 2012 11:26:07 -0800 (PST)
MIME-Version: 1.0
Reply-To: martin@herrman.nl
In-Reply-To: <4F4A0547.9060903@cinnamon-sage.de>
References: <CADR1r6jbuGD5hecgC-gzVda1G=vCcOn4oMsf5TxcyEVWsWdVuQ@mail.gmail.com>
	<01cc01ccce54$4f9e9770$eedbc650$@coexsi.fr>
	<CADR1r6iKj7MrTVx4aObbMUVswwT-8LMgGR=BVtpX9r+PKWzw9g@mail.gmail.com>
	<4F0B6480.30900@kaiser-linux.li>
	<CADR1r6jR+zrWMJoq9zKKVw+ucjFCc4BshfxZxhPoKfNduiFx-w@mail.gmail.com>
	<CADR1r6jSO7c-k-31t730s8ozx8Z8jJHhK4-xXH+RmcZz7qE=iQ@mail.gmail.com>
	<4F4A0547.9060903@cinnamon-sage.de>
Date: Mon, 27 Feb 2012 20:26:06 +0100
Message-ID: <CADR1r6i_=J7==O6P+vPRKRaq+T_YJLFQzBVvOMWmo_Ye5TxW0Q@mail.gmail.com>
Subject: Re: [DVB Digital Devices Cine CT V6] status support
From: Martin Herrman <martin@herrman.nl>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Op 26 februari 2012 11:11 heeft Lars Hanisch <dvb@cinnamon-sage.de>
het volgende geschreven:

>  Since you are using Ubuntu, you can find a nearly up-to-date dkms of
> linux-media with the patches of Oliver Endriss at
>  https://launchpad.net/~yavdr/+archive/main called linux-media-dkms
>
>  With this my Cine-C/T with a ddbridge runs without any problems.
>
> Regards,
> Lars.

Thomas and Lars,

thanks to both of you for your input.

I first tried the solution proposed by Lars because it seems to be
more future-proof. After install of linux-media-dkms package (note: it
took me a while to find out which kernel packages I had to install to
have linux-media-dkms installation find the kernel sources) and a
reboot, dmesg shows:

[    7.316117] WARNING: You are using an experimental version of the
media stack.
[    7.316124]  As the driver is backported to an older kernel, it doesn't offer
[    7.316125]  enough quality for its usage in production.
[    7.316125]  Use it with care.
[    7.316126] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[    7.316127]  59b30294e14fa6a370fdd2bc2921cca1f977ef16 Merge branch
'v4l_for_linus' into staging/for_v3.4
[    7.316128]  72565224609a23a60d10fcdf42f87a2fa8f7b16d [media]
cxd2820r: sleep on DVB-T/T2 delivery system switch
[    7.316129]  46de20a78ae4b122b79fc02633e9a6c3d539ecad [media]
anysee: fix CI init
[    7.355344] cfg80211: Calling CRDA to update world regulatory domain
[    7.612757] Digital Devices PCIE bridge driver, Copyright (C)
2010-11 Digital Devices GmbH
[    7.612805] DDBridge 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    7.612813] DDBridge driver detected: Digital Devices DVBCT V6.1 DVB adapter
[    7.612838] HW 00010007 REG 00010003
[    7.613010] DDBridge 0000:03:00.0: irq 45 for MSI/MSI-X
[    7.614652] Port 0 (TAB 1): DUAL DVB-C/T
[    7.615277] Port 1 (TAB 2): NO MODULE
[    7.615904] Port 2 (TAB 3): NO MODULE
[    7.616278] DVB: registering new adapter (DDBridge)
[    7.616280] DVB: registering new adapter (DDBridge)
(..)
[    7.873616] Linux media interface: v0.10
[    8.021310] stv0367 found
[    8.028799] Linux video capture interface: v2.00
[    8.028801] WARNING: You are using an experimental version of the
media stack.
[    8.028802]  As the driver is backported to an older kernel, it doesn't offer
[    8.028803]  enough quality for its usage in production.
[    8.028804]  Use it with care.
[    8.028804] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[    8.028805]  59b30294e14fa6a370fdd2bc2921cca1f977ef16 Merge branch
'v4l_for_linus' into staging/for_v3.4
[    8.028806]  72565224609a23a60d10fcdf42f87a2fa8f7b16d [media]
cxd2820r: sleep on DVB-T/T2 delivery system switch
[    8.028808]  46de20a78ae4b122b79fc02633e9a6c3d539ecad [media]
anysee: fix CI init
[    8.216959] skipping empty audio interface (v1)
[    8.216970] snd-usb-audio: probe of 1-3:1.0 failed with error -5
[    8.216979] skipping empty audio interface (v1)
[    8.216984] snd-usb-audio: probe of 1-3:1.1 failed with error -5
[    8.227179] AV200 0000:05:00.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    8.229650] uvcvideo: disagrees about version of symbol video_devdata
[    8.229653] uvcvideo: Unknown symbol video_devdata (err -22)
[    8.229670] uvcvideo: disagrees about version of symbol
video_unregister_device
[    8.229672] uvcvideo: Unknown symbol video_unregister_device (err -22)
[    8.229681] uvcvideo: disagrees about version of symbol video_device_alloc
[    8.229683] uvcvideo: Unknown symbol video_device_alloc (err -22)
[    8.229691] uvcvideo: disagrees about version of symbol v4l2_device_register
[    8.229693] uvcvideo: Unknown symbol v4l2_device_register (err -22)
[    8.229701] uvcvideo: disagrees about version of symbol
__video_register_device
[    8.229703] uvcvideo: Unknown symbol __video_register_device (err -22)
[    8.229707] uvcvideo: disagrees about version of symbol
v4l2_device_unregister
[    8.229709] uvcvideo: Unknown symbol v4l2_device_unregister (err -22)
[    8.229713] uvcvideo: disagrees about version of symbol video_usercopy
[    8.229715] uvcvideo: Unknown symbol video_usercopy (err -22)
[    8.229718] uvcvideo: disagrees about version of symbol video_device_release
[    8.229720] uvcvideo: Unknown symbol video_device_release (err -22)
[    8.311744] tda18212dd: ChipID 4724
[    8.312165] tda18212dd: PowerState 02
[    8.331053] HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level,
low) -> IRQ 17
[    8.331107] HDA Intel 0000:01:00.1: irq 46 for MSI/MSI-X
[    8.331131] HDA Intel 0000:01:00.1: setting latency timer to 64

I think that the second part indicates a problem with my webcam, which
worked like a charm before :-)
(it is a logitech 9000 pro)

lsmod output:

root@desktop:/home/martin# lsmod | grep dd
tda18212dd             17291  2
stv0367dd              21759  2
ddbridge               32964  4
dvb_core              109744  1 ddbridge
cxd2099                13281  1 ddbridge

And devices are created:

root@desktop:/home/martin# ls -ltr /dev/dvb/*
/dev/dvb/adapter0:
total 0
crw-rw----+ 1 root video 212, 2 2012-02-27 19:14 net0
crw-rw----+ 1 root video 212, 3 2012-02-27 19:14 frontend0
crw-rw----+ 1 root video 212, 1 2012-02-27 19:14 dvr0
crw-rw----+ 1 root video 212, 0 2012-02-27 19:14 demux0

/dev/dvb/adapter1:
total 0
crw-rw----+ 1 root video 212, 6 2012-02-27 19:14 net0
crw-rw----+ 1 root video 212, 7 2012-02-27 19:14 frontend0
crw-rw----+ 1 root video 212, 5 2012-02-27 19:14 dvr0
crw-rw----+ 1 root video 212, 4 2012-02-27 19:14 demux0

So, everything seems to be recognized, and I can start playing around
with tvheadend etc.

Thanks a lot for your help!
