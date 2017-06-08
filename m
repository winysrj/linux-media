Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34417 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751662AbdFHN2T (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 09:28:19 -0400
Received: by mail-pg0-f66.google.com with SMTP id v14so4619325pgn.1
        for <linux-media@vger.kernel.org>; Thu, 08 Jun 2017 06:28:19 -0700 (PDT)
Received: from ubuntu.windy (c122-106-153-7.carlnfd1.nsw.optusnet.com.au. [122.106.153.7])
        by smtp.gmail.com with ESMTPSA id h84sm10443154pfh.45.2017.06.08.06.28.06
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Jun 2017 06:28:07 -0700 (PDT)
Date: Thu, 8 Jun 2017 23:28:28 +1000
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: [media_build] regression at 3a17e11 "update
 v4.10_sched_signal.patch"
Message-ID: <20170608132826.GB11167@ubuntu.windy>
References: <20170608131339.GA11167@ubuntu.windy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170608131339.GA11167@ubuntu.windy>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I managed to find the failing patch, not sure what the fix is.

$ cd linux/
$ patch -f -N -p1 -i ../backports/v4.10_sched_signal.patch
patching file drivers/media/dvb-core/dvb_ca_en50221.c
Hunk #1 succeeded at 35 (offset 1 line).
patching file drivers/media/dvb-core/dvb_demux.c
Hunk #1 succeeded at 20 with fuzz 1 (offset 1 line).
patching file drivers/media/dvb-core/dvb_frontend.c
Hunk #1 succeeded at 30 (offset 1 line).
patching file drivers/media/pci/cx18/cx18-driver.h
patching file drivers/media/pci/ivtv/ivtv-driver.c
patching file drivers/media/pci/ivtv/ivtv-driver.h
Hunk #1 succeeded at 39 (offset 1 line).
patching file drivers/media/pci/pt1/pt1.c
patching file drivers/media/pci/pt3/pt3.c
patching file drivers/media/pci/solo6x10/solo6x10-i2c.c
patching file drivers/media/pci/zoran/zoran_device.c
patching file drivers/media/platform/vivid/vivid-radio-rx.c
patching file drivers/media/platform/vivid/vivid-radio-tx.c
patching file drivers/media/rc/lirc_dev.c
Hunk #1 FAILED at 18.
1 out of 1 hunk FAILED -- saving rejects to file drivers/media/rc/lirc_dev.c.rej
patching file drivers/media/usb/cpia2/cpia2_core.c
patching file drivers/media/usb/gspca/cpia1.c
Hunk #1 succeeded at 28 (offset 1 line).
patching file drivers/media/v4l2-core/videobuf-dma-sg.c
patching file drivers/staging/media/lirc/lirc_zilog.c
patching file include/media/v4l2-ioctl.h

$ cat drivers/media/rc/lirc_dev.c.rej
--- drivers/media/rc/lirc_dev.c
+++ drivers/media/rc/lirc_dev.c
@@ -18,7 +18,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
-#include <linux/sched/signal.h>
+#include <linux/sched.h>
 #include <linux/ioctl.h>
 #include <linux/poll.h>
 #include <linux/mutex.h>
