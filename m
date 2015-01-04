Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59615 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbADMIg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Jan 2015 07:08:36 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so1726798wiv.5
        for <linux-media@vger.kernel.org>; Sun, 04 Jan 2015 04:08:35 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 4 Jan 2015 13:08:35 +0100
Message-ID: <CAL9G6WXsWP9L67hWTw7k864SKBH0RBS3HJTaEDiJgcpVJ-yMrA@mail.gmail.com>
Subject: TeVii S482 driver installation
From: Josu Lazkano <josu.lazkano@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I am trying to install the drivers for the TeVii S482 device, I am
using official drivers:

cd /usr/src/
wget http://www.tevii.com/Tevii_Product_20140428_media_build_b6.tar.bz2.rar
bzip2 -dc Tevii_Product_20140428_media_build_b6.tar.bz2.rar | tar -xv
cd b6/media_build/

When execute "make", I get this:

# make
make -C /usr/src/b6/media_build/v4l
make[1]: Entering directory '/usr/src/b6/media_build/v4l'

... [complete output: http://paste.debian.net/139122/ ]

/usr/src/linux-headers-3.16.0-4-common/scripts/Makefile.build:262:
recipe for target '/usr/src/b6/media_build/v4l/altera-lpt.o' failed
make[5]: *** [/usr/src/b6/media_build/v4l/altera-lpt.o] Error 1
/usr/src/linux-headers-3.16.0-4-common/Makefile:1350: recipe for
target '_module_/usr/src/b6/media_build/v4l' failed
make[4]: *** [_module_/usr/src/b6/media_build/v4l] Error 2
Makefile:181: recipe for target 'sub-make' failed
make[3]: *** [sub-make] Error 2
Makefile:8: recipe for target 'all' failed
make[2]: *** [all] Error 2
make[2]: Leaving directory '/usr/src/linux-headers-3.16.0-4-amd64'
Makefile:51: recipe for target 'default' failed
make[1]: *** [default] Error 2
make[1]: Leaving directory '/usr/src/b6/media_build/v4l'
Makefile:26: recipe for target 'all' failed
make: *** [all] Error 2

I am in Debian Jessie with 3.16.0-4-amd64 kernel.

I need to install or configure some software? Anyone with this device?

Thanks and regards.

-- 
Josu Lazkano
