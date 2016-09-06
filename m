Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33936 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933999AbcIFKVr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Sep 2016 06:21:47 -0400
Received: from mobile-access-5d6aa6-113.dhcp.inet.fi ([93.106.166.113] helo=[192.168.1.2])
        by mail.kapsi.fi with esmtpsa (TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.80)
        (envelope-from <timo.helkio@kapsi.fi>)
        id 1bhDVg-0005fU-JJ
        for linux-media@vger.kernel.org; Tue, 06 Sep 2016 13:21:44 +0300
Reply-To: timo.helkio@kapsi.fi
To: linux-media@vger.kernel.org
From: =?UTF-8?Q?Timo_Helki=c3=b6?= <timo.helkio@kapsi.fi>
Subject: Build fails
Message-ID: <7f64a902-3436-e21c-653d-5dff2c1115a2@kapsi.fi>
Date: Tue, 6 Sep 2016 13:21:43 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

make -C /omat/media_build/v4l allyesconfig
make[1]: Entering directory '/omat/media_build/v4l'
No version yet, using 4.4.0-36-generic
make[2]: Entering directory '/omat/media_build/linux'
Syncing with dir ../media/
Applying patches for kernel 4.4.0-36-generic
patch -s -f -N -p1 -i ../backports/api_version.patch
patch -s -f -N -p1 -i ../backports/pr_fmt.patch
patch -s -f -N -p1 -i ../backports/debug.patch
patch -s -f -N -p1 -i ../backports/drx39xxj.patch
patch -s -f -N -p1 -i ../backports/v4.7_dma_attrs.patch
patch -s -f -N -p1 -i ../backports/v4.6_i2c_mux.patch
1 out of 2 hunks FAILED
Makefile:138: recipe for target 'apply_patches' failed
make[2]: *** [apply_patches] Error 1
make[2]: Leaving directory '/omat/media_build/linux'
Makefile:369: recipe for target 'allyesconfig' failed
make[1]: *** [allyesconfig] Error 2
make[1]: Leaving directory '/omat/media_build/v4l'
Makefile:26: recipe for target 'allyesconfig' failed
make: *** [allyesconfig] Error 2
can't select all drivers at ./build line 490.


          Timo Helkiö
