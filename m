Return-path: <mchehab@pedra>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59421 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab1D3Obk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Apr 2011 10:31:40 -0400
Received: by pwi15 with SMTP id 15so2147168pwi.19
        for <linux-media@vger.kernel.org>; Sat, 30 Apr 2011 07:31:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTikBm0gmNd8oQ6CN+cAEbYhWEGvWPA@mail.gmail.com>
References: <BANLkTikBm0gmNd8oQ6CN+cAEbYhWEGvWPA@mail.gmail.com>
Date: Sat, 30 Apr 2011 10:31:38 -0400
Message-ID: <BANLkTim9vtBAE1dbOXAwW2Crh7aiMucD3w@mail.gmail.com>
Subject: Build Failure
From: Colin Minihan <colin.minihan@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Ubuntu 10.04 attempting to run

git clone git://linuxtv.org/media_build.git
cd media_build
./check_needs.pl
make -C linux/ download
make -C linux/ untar
make stagingconfig
make

 results in the following failure
...
  CC [M]  /home/colm/media_build/v4l/lirc_zilog.o
/home/colm/media_build/v4l/lirc_zilog.c: In function 'destroy_rx_kthread':
/home/colm/media_build/v4l/lirc_zilog.c:238: error: implicit
declaration of function 'IS_ERR_OR_NULL'
make[3]: *** [/home/colm/media_build/v4l/lirc_zilog.o] Error 1
make[2]: *** [_module_/home/colm/media_build/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.32-31-generic'
make[1]: *** [default] Error 2
make[1]: Leaving directory `/home/colm/media_build/v4l'
make: *** [all] Error 2
