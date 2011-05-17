Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35914 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228Ab1EQNae (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 09:30:34 -0400
Received: by eyx24 with SMTP id 24so135671eyx.19
        for <linux-media@vger.kernel.org>; Tue, 17 May 2011 06:30:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=u26EwJ+yV9Z96J0yPyCGEUcgiiQ@mail.gmail.com>
References: <BANLkTinp69oB1qCK_ieX8vYm3F+Qd=e2mg@mail.gmail.com>
	<B2B80B47-7366-41D4-8051-FF82B9198FA8@wilsonet.com>
	<BANLkTi=u26EwJ+yV9Z96J0yPyCGEUcgiiQ@mail.gmail.com>
Date: Tue, 17 May 2011 23:30:32 +1000
Message-ID: <BANLkTimCW_HYBbESXjth4nqr2U34+-mLgQ@mail.gmail.com>
Subject: Re: imon: spews to dmesg
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I think I have found the source of this.

linux/drivers/media/video/omap3isp/Makefile  contains this:
 ifdef CONFIG_VIDEO_OMAP3_DEBUG
 EXTRA_CFLAGS += -DDEBUG
 endif

but this module is not turned on,nor is the _DEBUG setting for it.
 % grep OMAP3 media_build/v4l/.config
 # CONFIG_VIDEO_OMAP3_DEBUG is not set
 # CONFIG_VIDEO_OMAP3 is not set
 % grep OMAP3 media_build/v4l/.myconfig
 CONFIG_VIDEO_OMAP3_DEBUG                     := n
 CONFIG_VIDEO_OMAP3                           := n

nonetheless:
 % grep DDEBUG media_build/v4l/.imon.o.cmd
...
-fconserve-stack -Idrivers/media/dvb/dvb-core
-Idrivers/media/dvb/dvb-usb -Idrivers/media/dvb/frontends
-Idrivers/media/dvb/dvb-core -Idrivers/media/video
-Idrivers/media/common/tuners -Idrivers/media/dvb/dvb-core
-Idrivers/media/dvb/frontends -Idrivers/media/video
-Idrivers/media/common/tuners -Idrivers/media/dvb/dvb-core
-Idrivers/media/dvb/frontends -DDEBUG -Isound
-Idrivers/staging/cxd2099/ -g
...

Commenting out the three lines above in the omap3isp/Makefile gets rid
of the -DDEBUG
in the .cmd files. It seems to be the only Makefile that sets -DDEBUG
in this way.
Not sure what the real remedy is here.
