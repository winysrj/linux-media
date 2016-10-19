Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:53978 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935717AbcJSSuO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 14:50:14 -0400
Received: from PatrickLaptop ([91.6.177.199]) by smtp.web.de (mrweb103) with
 ESMTPSA (Nemesis) id 0MbyMU-1cCoth0Pag-00JH9l for
 <linux-media@vger.kernel.org>; Wed, 19 Oct 2016 20:50:11 +0200
Reply-To: <ps00de@yahoo.de>
From: <ps00de@yahoo.de>
To: <linux-media@vger.kernel.org>
Subject: Re: em28xx WinTV dualHD in Raspbian
Date: Wed, 19 Oct 2016 20:50:09 +0200
Message-ID: <000901d22a39$9de21e70$d9a65b50$@yahoo.de>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-Language: de
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Based on this log:
> 
> Oct 18 23:08:01 mediapi kernel: [ 7590.369200] em28xx_dvb: disagrees about version of symbol dvb_dmxdev_init Oct 18 23:08:01 mediapi kernel: [ 7590.369228] em28xx_dvb: Unknown symbol dvb_dmxdev_init (err -22)
> 
> it seems you messed the modules install or you have the V4L2 stack compiled builtin with a different version. 

How to fix this?

- I reinstalled the current firmware and kernel on the raspberry.
- I installed the headers with sudo apt-get install raspberrypi-kernel-headers
- Then I have cloned, build and installed the modules:

git clone git://linuxtv.org/media_build.git
cd media_build 
./build
sudo make install

But the same errors appear again.

Thanks,
Patrick

