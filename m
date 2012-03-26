Return-path: <linux-media-owner@vger.kernel.org>
Received: from avasout07.plus.net ([84.93.230.235]:53640 "EHLO
	avasout07.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932960Ab2CZQsq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 12:48:46 -0400
Message-ID: <4F709CBD.7060404@bogzab.plus.com>
Date: Mon, 26 Mar 2012 17:43:41 +0100
From: Bogus Zaba <bogus@bogzab.plus.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Cannot compile media_build from git sources
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am trying to compile the media_build according to the instructions on 
this page:
http://git.linuxtv.org/media_build.git

Instructions are very clear and all seems to work well regarding 
download of sources and the build command initiates compilation which 
runs OK until I get to the following stage:

/root/Add_SW/other/media_build/v4l/radio-rtrack2.c: In function 
'rtrack2_alloc':
/root/Add_SW/other/media_build/v4l/radio-rtrack2.c:46:2: error: implicit 
declaration of function 'kzalloc'
/root/Add_SW/other/media_build/v4l/radio-rtrack2.c:46:2: warning: return 
makes pointer from integer without a cast
make[3]: *** [/root/Add_SW/other/media_build/v4l/radio-rtrack2.o] Error 1
make[2]: *** [_module_/root/Add_SW/other/media_build/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-2.6.37.6'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/root/Add_SW/other/media_build/v4l'
make: *** [all] Error 2
build failed at ./build line 410.

This looks like a source code error which causes the compilation to fail.

Am I doing something obviously wrong or is there indeed a souce code 
error here?

Many thanks

Bogus N Zaba
