Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:57283 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbaK3RiZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Nov 2014 12:38:25 -0500
Received: by mail-oi0-f49.google.com with SMTP id i138so6333196oig.8
        for <linux-media@vger.kernel.org>; Sun, 30 Nov 2014 09:38:24 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 30 Nov 2014 18:38:24 +0100
Message-ID: <CA+QJwyh2OupTtNJ89TWgyBZm0dhaHQ2Ax1XPDPjaFat-aTKsCA@mail.gmail.com>
Subject: Re: Kernel 3.17.0 broke xc4000-based DTV1800h
From: =?UTF-8?B?SXN0dsOhbiwgVmFyZ2E=?= <istvan_v@mailbox.hu>
To: linux-media@vger.kernel.org
Cc: Rodney Baker <rodney@jeremiah31-10.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On 16 Oct 2014, at 17:33, Rodney Baker <rodney.baker <at> iinet.net.au> wrote:
>
> Since installing kernel 3.17.0-1.gc467423-desktop (on openSuSE 13.1) my
> xc4000/zl10353/cx88 based DTV card has failed to initialise on boot.

Apparently, the default firmware file name has been changed to
dvb-fe-xc4000-1.4.1.fw,
and the firmware package for the kernel now includes this file from
kernellabs.com.
However, this firmware file is incomplete (only includes minimal DVB-T
support for the
PCTV 340e), and also incompatible with the driver. That is why trying
to load it results
in i2c errors.

To get a firmware file that actually works, download this package, and build it:
  http://juropnet.hu/~istvan_v/xc4000_firmware.tar.gz
Actually, it was posted to the linux-media list in the past, but the
file did not end up being
included with the kernel firmware packages for some reason. The include path to
tuner-xc2028-types.h needs to be changed in build_fw.c, since the
"tuners" subdirectory is
now in "drivers/media", rather than "drivers/media/common". After
that, running make will
produce a correct firmware file named dvb-fe-xc4000-1.4.fw.

Some distributions include older firmware files from this page:
  http://istvanv.users.sourceforge.net/v4l/xc4000.html
These are slightly different from the newer one, and are extracted
from the Windows
drivers, rather than from the xc4000_firmwares.h file provided by
Xceive, but should still
work nevertheless.
