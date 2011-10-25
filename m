Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47672 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab1JYCsP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Oct 2011 22:48:15 -0400
Received: by faan17 with SMTP id n17so71655faa.19
        for <linux-media@vger.kernel.org>; Mon, 24 Oct 2011 19:48:14 -0700 (PDT)
MIME-Version: 1.0
Reply-To: whittenburg@gmail.com
Date: Mon, 24 Oct 2011 21:48:13 -0500
Message-ID: <CABcw_OkE=ANKDCVRRxgj33Mt=b3KAtGpe3RMnL3h0UMgOQ0ZdQ@mail.gmail.com>
Subject: media0 not showing up on beagleboard-xm
From: Chris Whittenburg <whittenburg@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm using oe-core to build the 3.0.7+ kernel, which runs fine on my
beagleboard-xm.

I'm interested in the media controller framework, which I believe is
in this kernel.

I expected there to be a /dev/media0, but it is not there.  I do see
"Linux media interface: v0.10" in my dmesg log, so I know
media_devnode_init() is being called.

Even without a sensor connected and camera defined, I should still get
a media0 which represents the ISP, correct?  I do have
CONFIG_VIDEO_OMAP3=y in my kernel config.  The only reference in the
log that I see related to the isp is:
omap-iommu omap-iommu.0: isp registered

It looks like the kernel I'm using doesn't have support for the
"camera=" cmdline option, so hopefully the presence of the camera is
not required to kick things off.

Thanks,
Chris
