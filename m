Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:34329 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753315AbcIXPu4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Sep 2016 11:50:56 -0400
Received: by mail-lf0-f47.google.com with SMTP id y6so112777311lff.1
        for <linux-media@vger.kernel.org>; Sat, 24 Sep 2016 08:50:55 -0700 (PDT)
Received: from tuttifrutti.hemmavid ([92.254.128.62])
        by smtp.googlemail.com with ESMTPSA id g79sm2080477lji.41.2016.09.24.08.50.52
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 24 Sep 2016 08:50:53 -0700 (PDT)
From: =?UTF-8?B?SMOla2FuIExlbm5lc3TDpWw=?= <hakan.lennestal@gmail.com>
Subject: em28xx: usb video grabber
To: linux-media@vger.kernel.org
Message-ID: <80872134-899b-4992-3263-3a17f9ae1bff@gmail.com>
Date: Sat, 24 Sep 2016 17:50:52 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


To whom it may concern.

USB video grabber, Deltaco TV-57, composite and s-video inputs.

Seem to work well with card=31

Linux kernel  4.7.4, x86_64

[241296.432375] em28xx: New device  USB 2821 Device @ 480 Mbps 
(eb1a:2821, interface 0, class 0)
[241296.432380] em28xx: Video interface 0 found: bulk isoc
[241296.432569] em28xx: chip ID is em2710/2820
[241296.529936] em2710/2820 #0: EEPROM ID = 1a eb 67 95, EEPROM hash = 
0x37da7b8a
[241296.529946] em2710/2820 #0: EEPROM info:
[241296.529950] em2710/2820 #0:         AC97 audio (5 sample rates)
[241296.529953] em2710/2820 #0:         500mA max power
[241296.529958] em2710/2820 #0:         Table at offset 0x04, 
strings=0x226a, 0x0000, 0x0000
[241296.561482] em2710/2820 #0: No sensor detected
[241296.575669] em2710/2820 #0: found i2c device @ 0x4a on bus 0 [saa7113h]
[241296.591800] em2710/2820 #0: found i2c device @ 0xa0 on bus 0 [eeprom]
[241296.609416] em2710/2820 #0: Your board has no unique USB ID and thus 
need a hint to be detected.
[241296.609421] em2710/2820 #0: You may try to use card=<n> insmod 
option to workaround that.
[241296.609425] em2710/2820 #0: Please send an email with this log to:
[241296.609429] em2710/2820 #0:         V4L Mailing List 
<linux-media@vger.kernel.org>
[241296.609433] em2710/2820 #0: Board eeprom hash is 0x37da7b8a
[241296.609437] em2710/2820 #0: Board i2c devicelist hash is 0x6ba50080
[241296.609440] em2710/2820 #0: Here is a list of valid choices for the 
card=<n> insmod option:
...

 > rmmod em28xx

 > modprobe em28xx card=31

[241339.959773] usbcore: registered new interface driver em28xx
[241339.972272] em2710/2820 #0: Registering V4L2 extension
[241340.188439] saa7115 9-0025: saa7113 found @ 0x4a (em2710/2820 #0)
[241340.602144] em2710/2820 #0: Config register raw data: 0x90
[241340.614920] em2710/2820 #0: AC97 vendor ID = 0xffffffff
[241340.620923] em2710/2820 #0: AC97 features = 0x6a90
[241340.620932] em2710/2820 #0: Empia 202 AC97 audio processor detected
[241341.806571] em2710/2820 #0: V4L2 video device registered as video0
[241341.806583] em2710/2820 #0: V4L2 extension successfully initialized
[241341.806589] em28xx: Registered (Em28xx v4l2 Extension) extension

