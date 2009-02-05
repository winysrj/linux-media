Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f20.google.com ([209.85.220.20]:37540 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758211AbZBEP7T (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Feb 2009 10:59:19 -0500
Received: by fxm13 with SMTP id 13so484662fxm.13
        for <linux-media@vger.kernel.org>; Thu, 05 Feb 2009 07:59:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <617be8890902050754p4b8828c9o14b43b6879633cd7@mail.gmail.com>
References: <617be8890902050754p4b8828c9o14b43b6879633cd7@mail.gmail.com>
Date: Thu, 5 Feb 2009 16:59:16 +0100
Message-ID: <617be8890902050759x74c08498o355be1d34d7735fe@mail.gmail.com>
Subject: cx8802.ko module not being built with current HG tree
From: Eduard Huguet <eduardhc@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
  Maybe I'm wrong, but I think there is something wrong in current
Kconfig file for cx88 drivers. I've been struggling for some hours
trying to find why, after compiling a fresh copy of the LinuxTV HG
drivers, I wasn't unable to modprobe cx88-dvb module, which I need for
HVR-3000.

The module was not being load because kernel was failing to find
cx8802_get_driver, etc... entry points, which are exported by
cx88-mpeg.c.

The strange part is that, according to the cx88/Kconfig file this file
should be automatically added as dependency if either CX88_DVB or
CX88_BLACKBIRD were selected,
but for some strange reason it wasn't.

After a 'make menuconfig' in HG tree the kernel configuration
contained these lines (this was using the default config, without
adding / removing anything):
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_MPEG=y
CONFIG_VIDEO_CX88_VP3054=m

Notice that they are all marked as 'm' excepting
CONFIG_VIDEO_CX88_MPEG, which is marked as 'y'. I don't know if it's
relevant or not, but the fact is that the module was not being
compiled at all. The option was not visible inside menuconfig, by the
way.

I've done some changes inside Kconfig to make it visible in
menuconfig, and by doing this I've been able to set it to 'm' and
rebuild, which has just worked apparently.

This Kconfig file was edited in revisions 10190 & 10191, precisely for
reasons related to cx8802 dependencies, so I'm not sure the solution
taken there was the right one.

Best regards,
 Eduard Huguet
