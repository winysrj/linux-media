Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:40089 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab1GOEHP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 00:07:15 -0400
Received: by fxd18 with SMTP id 18so2110712fxd.11
        for <linux-media@vger.kernel.org>; Thu, 14 Jul 2011 21:07:14 -0700 (PDT)
MIME-Version: 1.0
From: Dave Fine <finerrecliner@gmail.com>
Date: Fri, 15 Jul 2011 00:06:54 -0400
Message-ID: <CAOMmEgmG9R1chrJuR2Fh91c5xyJMUdc=rW-yNugE+08sXfutfg@mail.gmail.com>
Subject: Problem building gspca module
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm trying to build the gspca module and insmod into my current
running system. I can compile the module, but can't insmod it.

steps I take to build:

$ cd /usr/src/linux-source-2.6.38
$ sudo cp /boot/config-2.6.38-8-generic .config
$ sudo make oldconfig
$ sudo make prepare
$ sudo make modules_prepare
$ sudo make scripts
$ sudo make SUBDIRS=drivers/media/video/gspca
$ cd drivers/media/video/gspca
$ sudo insmod gspca_main.ko
$ insmod: error inserting 'gspca_main.ko': -1 Invalid module format
$ dmesg | tail
[995219.523934] gspca_main: no symbol version for module_layout


when compiling the module, I get the following warning, which I feel
is related to problem of not being able to insmod it, but don't know
how to fix it:

  WARNING: Symbol version dump /usr/src/linux-source-2.6.38/Module.symvers
           is missing; modules will have no dependencies and modversions.


Does anyone know what I'm doing wrong?

Thanks,
Dave
