Return-path: <linux-media-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30440 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab2CUUBB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 16:01:01 -0400
Message-ID: <4F6A337C.7050708@kc.rr.com>
Date: Wed, 21 Mar 2012 15:01:00 -0500
From: Joe Henley <joehenley@kc.rr.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Problem with building linuxtv.org's V4L-DVB drivers
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm running kernel-ml-2.6.35-14.1.el5.elrepo

I'm following the info on:
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

First I run:
git clone git://linuxtv.org/media_build.git
cd media_build

Then when I run ./build, it stops with the following error:
.... snip...
/root/media_build/v4l/radio-rtrack2.c: In function 'rtrack2_alloc':
/root/media_build/v4l/radio-rtrack2.c:46: error: implicit declaration of
function 'kzalloc'
/root/media_build/v4l/radio-rtrack2.c:46: warning: return makes pointer
from integer without a cast
make[3]: *** [/root/media_build/v4l/radio-rtrack2.o] Error 1
make[2]: *** [_module_/root/media_build/v4l] Error 2
make[1]: *** [default] Error 2
make: *** [all] Error 2
build failed at ./build line 410.

Hopefully this can fixed.

Joe Henley
