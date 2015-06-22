Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38419 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933376AbbFVMUI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2015 08:20:08 -0400
Date: Mon, 22 Jun 2015 09:20:01 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: poma <pomidorabelisima@gmail.com>
Cc: For testing and quality assurance of Fedora releases
	<test@lists.fedoraproject.org>,
	linux-media <linux-media@vger.kernel.org>,
	Development discussions related to Fedora
	<devel@lists.fedoraproject.org>,
	Kevin Thayer <nufan_wfk@yahoo.com>,
	Chris Kennedy <c@groovy.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	Josh Boyer <jwboyer@redhat.com>,
	Richard Vollkommer <linux@hauppauge.com>,
	Fred Richter <frichter@hauppauge.com>,
	Hauppauge Tech Support <support@hauppauge.com>
Subject: Re: ivtv - firmware - v4l-cx2341x*.fw - Upstream & Fedora
Message-ID: <20150622092001.6c3b9350@recife.lan>
In-Reply-To: <558730FE.1030700@gmail.com>
References: <558730FE.1030700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(please disregard my last e-mail - I pressed, by mistake, some control sequence
to send it before finishing it)

Hi,

Em Sun, 21 Jun 2015 23:47:42 +0200
poma <pomidorabelisima@gmail.com> escreveu:

> 
> Háu kola
> 
> 
> $ lspci -d 4444:0016 -knn
> 01:08.0 Multimedia video controller [0400]: Internext Compression Inc iTVC16 (CX23416) Video Decoder [4444:0016] (rev 01)
> 	Subsystem: Hauppauge computer works Inc. WinTV PVR 150 [0070:8801]
> 	Kernel driver in use: ivtv
> 	Kernel modules: ivtv
> 
> ~~~~~~~~~~~~~~~~~~~~
> 
> $ dmesg | grep ivtv
> [   10.082881] ivtv: Start initialization, version 1.4.3
> [   10.085644] ivtv0: Initializing card 0
> [   10.088287] ivtv0: Autodetected Hauppauge card (cx23416 based)
> [   10.094502] ivtv0: Unreasonably low latency timer, setting to 64 (was 32)
> [   10.183374] ivtv0: Autodetected Hauppauge WinTV PVR-150
> [   10.240409] cx25840 2-0044: cx25843-23 found @ 0x88 (ivtv i2c driver #0)
> [   10.380617] wm8775 2-001b: chip found @ 0x36 (ivtv i2c driver #0)
> [   10.431991] ivtv0: Registered device video0 for encoder MPG (4096 kB)
> [   10.432151] ivtv0: Registered device video32 for encoder YUV (2048 kB)
> [   10.432256] ivtv0: Registered device vbi0 for encoder VBI (1024 kB)
> [   10.432358] ivtv0: Registered device video24 for encoder PCM (320 kB)
> [   10.432459] ivtv0: Registered device radio0 for encoder radio
> [   10.432473] ivtv0: Initialized card: Hauppauge WinTV PVR-150
> [   10.433869] ivtv: End initialization
> [   11.820105] ivtv 0000:01:08.0: Direct firmware load for v4l-cx2341x-enc.fw failed with error -2
> [   11.820119] ivtv0: Unable to open firmware v4l-cx2341x-enc.fw (must be 376836 bytes)
> [   11.820124] ivtv0: Did you put the firmware in the hotplug firmware directory?
> [   11.820129] ivtv0: Retry loading firmware
> [   12.439735] ivtv 0000:01:08.0: Direct firmware load for v4l-cx2341x-enc.fw failed with error -2
> [   12.439747] ivtv0: Unable to open firmware v4l-cx2341x-enc.fw (must be 376836 bytes)
> [   12.439752] ivtv0: Did you put the firmware in the hotplug firmware directory?
> [   12.439757] ivtv0: Failed to initialize on device video32
> [   12.439788] ivtv0: Failed to initialize on device video0
> [   12.439953] ivtv0: Failed to initialize on device vbi0
> [   12.439968] ivtv0: Failed to initialize on device video24
> [   12.440110] ivtv0: Failed to initialize on device radio0
> 
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> $ modinfo ivtv | grep 'author\|firmware'
> author:         Kevin Thayer, Chris Kennedy, Hans Verkuil
> firmware:       v4l-cx2341x-init.mpg
> firmware:       v4l-cx2341x-dec.fw
> firmware:       v4l-cx2341x-enc.fw
> 
> ~~~~~~~~~~~~~~~~~~~~~~~~
> 
> $ rpm -qi linux-firmware
> ...
> Packager    : Fedora Project
> Vendor      : Fedora Project
> ...
> Summary     : Firmware files used by the Linux kernel
> Description :
> This package includes firmware files required for some devices to
> operate.
> 
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> $ rpm -ql linux-firmware | grep v4l-cx2341x
> $ 
> 
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> # yum install ivtv-firmware
> ...
> No package ivtv-firmware available.
> Error: Nothing to do
> 
> ~~~~~~~~~~~~~~~~~~~~
> 
> $ rpm -qilp https://kojipkgs.fedoraproject.org/packages/ivtv-firmware/20080701/26/noarch/ivtv-firmware-20080701-26.noarch.rpm
> Name        : ivtv-firmware
> Epoch       : 2
> Version     : 20080701
> Release     : 26
> Architecture: noarch
> Install Date: (not installed)
> Group       : System Environment/Kernel
> Size        : 857256
> License     : Redistributable, no modification permitted
> Signature   : (none)
> Source RPM  : ivtv-firmware-20080701-26.src.rpm
> Build Date  : Sun 08 Jun 2014 05:38:45 AM CEST
> Build Host  : buildvm-11.phx2.fedoraproject.org
> Relocations : (not relocatable)
> Packager    : Fedora Project
> Vendor      : Fedora Project
> URL         : http://dl.ivtvdriver.org/ivtv/firmware/
> Summary     : Firmware for the Hauppauge PVR 250/350/150/500/USB2 model series
> Description :
> This package contains the firmware for WinTV Hauppauge PVR
> 250/350/150/500/USB2 cards.
> /lib/firmware/ivtv-firmware-license-end-user.txt
> /lib/firmware/ivtv-firmware-license-oemihvisv.txt
> /lib/firmware/v4l-cx2341x-dec.fw
> /lib/firmware/v4l-cx2341x-enc.fw
> /lib/firmware/v4l-cx2341x-init.mpg
> /lib/firmware/v4l-cx25840.fw
> /lib/firmware/v4l-pvrusb2-24xxx-01.fw
> /lib/firmware/v4l-pvrusb2-29xxx-01.fw
> /usr/share/doc/ivtv-firmware
> /usr/share/doc/ivtv-firmware/license-end-user.txt
> /usr/share/doc/ivtv-firmware/license-oemihvisv.txt
> 
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Why these firmwares are not included upstream
> http://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/
> ?
> 
> Why these firmwares are obsoleted(?) downstream
> http://pkgs.fedoraproject.org/cgit/ivtv-firmware.git
> ?
> 
> Why these firmware are not included downstream
> http://pkgs.fedoraproject.org/cgit/linux-firmware.git
> ?

I've no idea who tagged the ivtv-firmware package as obsoleted.

The status of the firmwares is that almost all ivtv firmwares
are part of linux-firmware. However, we didn't manage to get
an ack from Conexant (or Hauppauge) to release a few firmwares
using a license that would allow redistribution. The problem
is that those firmwares are for hardware that are discontinued
by the chipset manufacturer.

So, those should still be released using the license that
was granted on this package.

So, IMO, those files should be kept at the package:
	/lib/firmware/ivtv-firmware-license-end-user.txt
	/lib/firmware/ivtv-firmware-license-oemihvisv.txt
	/lib/firmware/v4l-cx2341x-enc.fw
	/lib/firmware/v4l-pvrusb2-24xxx-01.fw
	/lib/firmware/v4l-pvrusb2-29xxx-01.fw
	/usr/share/doc/ivtv-firmware
	/usr/share/doc/ivtv-firmware/license-end-user.txt
	/usr/share/doc/ivtv-firmware/license-oemihvisv.txt

The other files should be replaced by the ones at linux-firmware,
with has a better license that allows redistribution.

Regards,
Mauro
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
