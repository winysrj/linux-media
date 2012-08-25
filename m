Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43894 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757093Ab2HYTGh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Aug 2012 15:06:37 -0400
Received: by wgbdr13 with SMTP id dr13so2433095wgb.1
        for <linux-media@vger.kernel.org>; Sat, 25 Aug 2012 12:06:36 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: Compiling v4l-dvb.git-modules for stock kernel without media_build
Date: Sat, 25 Aug 2012 21:06:33 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201208252106.33528.pboettcher@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi list,

Not so long ago I used a special version of v4l-dvb.git (v3,2 + a patch) on 
my system together with a debian stock kernel. It worked. Now I update my 
system and thus the kernel and what I did last time doesn't seem to work any 
longer:

1) checkout v3.2 of v4l-dvb.git and apply my path
2) get .config, .kernelvariables and Module.symvers from linux-
headers-3.2.0-3-amd64 (which corresponds to my running kernel)
3) make oldconfig modules_prepare  in v4l-dvb.git
4) make M=drivers/media
5) install all the .ko into /lib/modules
6) depmod -a
7) reboot

Now I have the following symptoms:
a) for the 3 PCI-cards I have the b2c2-flexcop-pci charged automatically but 
it fails to initialize the devices and bails out with -22
b) the USB-device is not triggering the loading of its driver and upon a 
modprobe it doesn't get claimed.

Something is wrong, but I don't know what.

Could it be the symbol versions? 

Thanks for any hints.

--
Patrick.

