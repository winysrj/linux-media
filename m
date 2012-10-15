Return-path: <linux-media-owner@vger.kernel.org>
Received: from eos.fwall.u-szeged.hu ([160.114.120.248]:39384 "EHLO
	eos.fwall.u-szeged.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab2JOWMP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 18:12:15 -0400
Received: from [192.168.105.4] (helo=esym.fwall.u-szeged.hu)
	by eos.fwall.u-szeged.hu with esmtp (Exim 4.63)
	(envelope-from <zarvai@inf.u-szeged.hu>)
	id 1TNsV5-0006Km-Lz
	for linux-media@vger.kernel.org; Mon, 15 Oct 2012 23:47:03 +0200
Received: from mail.inf.u-szeged.hu ([160.114.37.227])
	by eos.fwall.u-szeged.hu with esmtp (Exim 4.63)
	(envelope-from <zarvai@inf.u-szeged.hu>)
	id 1TNsV5-0006Kf-Gw
	for linux-media@vger.kernel.org; Mon, 15 Oct 2012 23:47:03 +0200
Received: from [10.20.0.225] (sedvpn.inf.u-szeged.hu [160.114.36.233])
	by mail.inf.u-szeged.hu (Postfix) with ESMTP id 3CC1A16A0146
	for <linux-media@vger.kernel.org>; Mon, 15 Oct 2012 23:47:03 +0200 (CEST)
Message-ID: <507C844C.7090001@inf.u-szeged.hu>
Date: Mon, 15 Oct 2012 23:46:52 +0200
From: =?ISO-8859-2?Q?=C1rvai_Zolt=E1n?= <zarvai@inf.u-szeged.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: media_build smiapp-core.c implicit-function-declaration
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

In the last few weeks I got errors when I tried to build media drivers 
on the raspberry pi "raspbian wheezy".

git clone git://linuxtv.org/media_build.git
cd media_build
./build

Error message:

   CC [M] /home/pi/media_build/v4l/smiapp-core.o
/home/pi/media_build/v4l/smiapp-core.c: In function 'smiapp_registered':
/home/pi/media_build/v4l/smiapp-core.c:2377:2: error: implicit 
declaration of function 'devm_regulator_get' 
[-Werror=implicit-function-declaration]
/home/pi/media_build/v4l/smiapp-core.c:2377:15: warning: assignment 
makes pointer from integer without a cast [enabled by default]
/home/pi/media_build/v4l/smiapp-core.c:2384:3: error: implicit 
declaration of function 'devm_clk_get' 
[-Werror=implicit-function-declaration]
/home/pi/media_build/v4l/smiapp-core.c:2384:19: warning: assignment 
makes pointer from integer without a cast [enabled by default]
cc1: some warnings being treated as errors
make[3]: *** [/home/pi/media_build/v4l/smiapp-core.o] Error 1
make[2]: *** [_module_/home/pi/media_build/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-source-3.2.27+'

Just a guess, after searching for similar error messages I found 
something here:
https://patchwork.kernel.org/patch/1337011/
Maybe some backport patch is missing from the current media_build.

Linux revision (3.2.27+):
https://github.com/raspberrypi/linux/tree/807223a562933b1906c70f1c5249db7635dd4574

Please, take a look at this issue.

Regards,
Zoltan Arvai
