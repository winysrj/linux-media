Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33264 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaI0XY1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Sep 2014 19:24:27 -0400
Received: by mail-wi0-f178.google.com with SMTP id z2so1331533wiv.5
        for <linux-media@vger.kernel.org>; Sat, 27 Sep 2014 16:24:26 -0700 (PDT)
Received: from [192.168.1.63] (APuteaux-651-1-289-51.w82-120.abo.wanadoo.fr. [82.120.12.51])
        by mx.google.com with ESMTPSA id wx3sm10796318wjc.19.2014.09.27.16.24.25
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 27 Sep 2014 16:24:25 -0700 (PDT)
Message-ID: <54274727.3010808@gmail.com>
Date: Sun, 28 Sep 2014 01:24:23 +0200
From: =?UTF-8?B?RnLDqWTDqXJpYyBCZXJuYXJk?= <fred.pa.bernard@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Error compiling coda-common.c:1893:2 from media_build on Cubox-i
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please check https://bugzilla.kernel.org/show_bug.cgi?id=85201

I aim to use a Cinergy HTC USB XS on ARM with xbmc. The USB stick uses a the driver dvb-usb-dib0700 with the firmware dvb-usb-terratec-htc-stick-drxk.fw taken here

wgethttps://github.com/OpenELEC/dvb-firmware/blob/master/firmware/dvb-usb-terratec-htc-stick-drxk.fw

I checked on a amd64 PC and successfully media_builded, installed VDR and scan utilities and scanned TV channels with

w_scan -ft-A3-c FR >/etc/vdr/channels.conf

So I switched to the ARM real target.

I encountered this error while executing './build' in build_media directory :

   CC [M]  /root/media_build/v4l/mcam-core.o
   CC [M]  /root/media_build/v4l/coda-common.o
/root/media_build/v4l/coda-common.c: In function 'coda_probe':
/root/media_build/v4l/coda-common.c:1893:2: error: implicit declaration of function 'devm_reset_control_get_optional' [-Werror=implicit-function-declaration]
/root/media_build/v4l/coda-common.c:1893:12: warning: assignment makes pointer from integer without a cast [enabled by default]
cc1: some warnings being treated as errors
make[3]: *** [/root/media_build/v4l/coda-common.o] Error 1
make[2]: *** [_module_/root/media_build/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-3.14.14+'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/root/media_build/v4l'
make: *** [all] Error 2
build failed at ./build line 491.

Here is the context

The device is a CuBox-i4Pro (SoC is i.MX6 Quad see here :http://www.solid-run.com/wiki/CuBox-i_Hardware)

I use the Debian wheezy available at the link given herehttp://www.solid-run.com/wiki/Debian_and_derivatives  and more specificallyhttp://www.igorpecovnik.com/2014/08/19/cubox-i-hummingboard-debian-sd-image/

I build a kernel 3.14 as said herehttp://www.solid-run.com/wiki/Building_the_kernel_and_u-boot_for_the_CuBox-i_and_the_HummingBoard  and generated kernel packages with

apt-get install dpkg-dev
apt-get install libfile-fcntllock-perl
make deb-pkg
cd ..
dpkg -i linux*deb

And then

git clone git://linuxtv.org/media_build.git
cd media_build
  ./build

And that's where the error occurs

I can't go farther.

Thanks for helping

Best regards

Frédéric Bernard
F92400 Courbevoie

