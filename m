Return-path: <mchehab@gaivota>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53197 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab0KDORB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Nov 2010 10:17:01 -0400
Received: by bwz11 with SMTP id 11so1694404bwz.19
        for <linux-media@vger.kernel.org>; Thu, 04 Nov 2010 07:17:00 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 4 Nov 2010 15:16:59 +0100
Message-ID: <AANLkTimpXwWGJfXRa=_38SKbKyfu_6sEME=in7YESV8x@mail.gmail.com>
Subject: Tevii S470 on Debian Squeeze
From: Josu Lazkano <josu.lazkano@gmail.com>
To: linux-media@vger.kernel.org,
	Discussion about mythtv <mythtv-users@mythtv.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello, I am having some problems to get working my Tevii S470 DVB-S2 PCIe card.

I am using a Debian Squeeze (2.6.32-5-686) system on a Intel Atom 330
(Nvidia ION) machine. I read the LinuxTV wiki:
http://www.linuxtv.org/wiki/index.php/TeVii_S470#Older_kernels

These are my steps:

1. Donwloas the Tevii driver:
  wget -c http://tevii.com/tevii_ds3000.tar.gz
  tar zxfv tevii_ds3000.tar.gz
  su
  cp tevii_ds3000/dvb-fe-ds3000.fw /lib/firmware/

2. Download s2-liplianin:
  hg clone http://mercurial.intuxication.org/hg/s2-liplianin

3. When I run make I have some warnings and errors: (all the log from
make: http://dl.dropbox.com/u/1541853/tevii/s2-liplianin_make)
  make[5]: *** [/home/lazkano/s2-liplianin/v4l/ir-sysfs.o] Error 1
  make[4]: *** [_module_/home/lazkano/s2-liplianin/v4l] Error 2

This is my card info:
  $ lspci | grep CX23885
  05:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885
PCI Video and Audio Decoder (rev 02)

Can you help with this?

Thanks for all your help and best regards


-- 
Josu Lazkano
