Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:34199 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750952AbdEaA5G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 20:57:06 -0400
Received: by mail-qk0-f182.google.com with SMTP id d14so972623qkb.1
        for <linux-media@vger.kernel.org>; Tue, 30 May 2017 17:57:06 -0700 (PDT)
Received: from mail-qk0-f170.google.com (mail-qk0-f170.google.com. [209.85.220.170])
        by smtp.gmail.com with ESMTPSA id 101sm6301838qkx.28.2017.05.30.17.57.04
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 May 2017 17:57:05 -0700 (PDT)
Received: by mail-qk0-f170.google.com with SMTP id d14so972418qkb.1
        for <linux-media@vger.kernel.org>; Tue, 30 May 2017 17:57:04 -0700 (PDT)
MIME-Version: 1.0
From: Olli Salonen <olli.salonen@iki.fi>
Date: Wed, 31 May 2017 03:57:04 +0300
Message-ID: <CAAZRmGw=S+SGAHUOOL7wYNj040n9h6B9qNtSakHqzLpJMCGx1A@mail.gmail.com>
Subject: media_build: fails to install
To: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It seems that I'm able to build the media_build correctly on Ubuntu
16.04.2 with kernel 4.8, but make install fails:

~/src/media_build$ sudo make install
make -C /home/olli/src/media_build/v4l install
make[1]: Entering directory '/home/olli/src/media_build/v4l'
make[1]: *** No rule to make target 'media-install', needed by 'install'.  Stop.
make[1]: Leaving directory '/home/olli/src/media_build/v4l'
Makefile:15: recipe for target 'install' failed
make: *** [install] Error 2

Full console log here:
http://paste.ubuntu.com/24720478/

Cheers,
-olli
