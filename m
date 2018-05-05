Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:53899 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751086AbeEEM0S (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 5 May 2018 08:26:18 -0400
Received: from [192.168.178.21] ([79.222.126.74]) by mail.gmx.com (mrgmx001
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0M2t0Q-1eNWbH0CZS-00sflM for
 <linux-media@vger.kernel.org>; Sat, 05 May 2018 14:26:17 +0200
To: linux-media <linux-media@vger.kernel.org>
From: Martin Dauskardt <martin.dauskardt@gmx.de>
Subject: compile error media-build on 4.15 because of 'device_get_match_data'
Message-ID: <058eb808-5072-d9fb-c83c-5bc1201568fc@gmx.de>
Date: Sat, 5 May 2018 14:26:16 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: de-DE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I tried to compile media-build on Ubuntu 18.04. (gcc 7.3.0) with Kernel 
4.15 and get this error:


/home/martin/media_build/v4l/video-i2c.c: In function 'video_i2c_probe':
/home/martin/media_build/v4l/video-i2c.c:456:16: error: implicit 
declaration of function 'device_get_match_data'; did you mean 
'of_device_get_match_data'? [-Werror=implicit-function-declaration]
    data->chip = device_get_match_data(&client->dev);
                 ^~~~~~~~~~~~~~~~~~~~~
                 of_device_get_match_data
/home/martin/media_build/v4l/video-i2c.c:456:14: warning: assignment 
makes pointer from integer without a cast [-Wint-conversion]
    data->chip = device_get_match_data(&client->dev);
               ^
cc1: some warnings being treated as errors
scripts/Makefile.build:339: recipe for target 
'/home/martin/media_build/v4l/video-i2c.o' failed
make[3]: *** [/home/martin/media_build/v4l/video-i2c.o] Error 1
Makefile:1552: recipe for target '_module_/home/martin/media_build/v4l' 
failed
make[2]: *** [_module_/home/martin/media_build/v4l] Error 2
make[2]: Leaving directory '/usr/src/linux-headers-4.15.0-20-generic'
Makefile:51: recipe for target 'default' failed
make[1]: *** [default] Error 2
make[1]: Verzeichnis „/home/martin/media_build/v4l“ wird verlassen
Makefile:26: recipe for target 'all' failed
make: *** [all] Error 2
build failed at ./build line 526

I hope it is possible to integrate a patch for Kernel 4.15
