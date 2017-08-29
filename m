Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxout017.mail.hostpoint.ch ([217.26.49.177]:48237 "EHLO
        mxout017.mail.hostpoint.ch" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751186AbdH2TU0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 15:20:26 -0400
Received: from [10.0.2.46] (helo=asmtp013.mail.hostpoint.ch)
        by mxout017.mail.hostpoint.ch with esmtp (Exim 4.89 (FreeBSD))
        (envelope-from <linux-dvb@kaiser-linux.li>)
        id 1dmloZ-0003wd-0H
        for linux-media@vger.kernel.org; Tue, 29 Aug 2017 21:04:43 +0200
Received: from 80-72-52-213.dynamic.modem.fl1.li ([80.72.52.213] helo=[192.168.0.104])
        by asmtp013.mail.hostpoint.ch with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89 (FreeBSD))
        (envelope-from <linux-dvb@kaiser-linux.li>)
        id 1dmloY-0000RO-UO
        for linux-media@vger.kernel.org; Tue, 29 Aug 2017 21:04:42 +0200
To: linux-media <linux-media@vger.kernel.org>
From: Thomas Kaiser <linux-dvb@kaiser-linux.li>
Subject: make menuconfig on media_build
Message-ID: <ff182a17-1ff8-cd92-5be7-7cb30f7e91ad@kaiser-linux.li>
Date: Tue, 29 Aug 2017 21:04:41 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear List

When I run "make menuconfig" on media_build the following errors occur:

thomas@Intel64:~/Projects/dvb/media_build$ make menuconfig
make -C /home/thomas/Projects/dvb/media_build/v4l menuconfig
make[1]: Entering directory '/home/thomas/Projects/dvb/media_build/v4l'
/lib/modules/4.10.0-33-generic/build/scripts/kconfig/mconf ./Kconfig
./Kconfig:5033: syntax error
./Kconfig:5032: unknown option "Choose"
./Kconfig:5035: syntax error
./Kconfig:5034:warning: ignoring unsupported character ','
./Kconfig:5034: unknown option "In"
./Kconfig:5035: unknown option "that"
./Kconfig:5036: unknown option "this"
./Kconfig:5036:warning: ignoring unsupported character '<'
./Kconfig:5037:warning: ignoring unsupported character ':'
./Kconfig:5037: unknown option "file"
Makefile:379: recipe for target 'menuconfig' failed
make[1]: *** [menuconfig] Error 1
make[1]: Leaving directory '/home/thomas/Projects/dvb/media_build/v4l'
Makefile:26: recipe for target 'menuconfig' failed
make: *** [menuconfig] Error 2
thomas@Intel64:~/Projects/dvb/media_build$

The 2 spaces in the 2 lines after the "--help--" entry of "config RADIO_WL128X" are the problem (v4l/Kconfig).

Anyway I don't know where these 2 spaces come from. In the media_tree, I don't see these two spaces.

Can somebody look what is going wrong here, thanks.

Thomas
