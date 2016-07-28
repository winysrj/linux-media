Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:34210 "EHLO
	mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbcG1HyG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2016 03:54:06 -0400
Received: by mail-lf0-f47.google.com with SMTP id l69so43634133lfg.1
        for <linux-media@vger.kernel.org>; Thu, 28 Jul 2016 00:54:05 -0700 (PDT)
MIME-Version: 1.0
From: Eduard Gavin <egavin@iseebcn.com>
Date: Thu, 28 Jul 2016 09:54:03 +0200
Message-ID: <CAPjucKa0+pzdKosnkaO9=DPSvULfwXWA+gr6PYRBonxhoh3JPQ@mail.gmail.com>
Subject: omap3-isp bt656 10bit
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm trying to read 10 bit BT656 using an omap3 DM3730 (omap3-isp).

The bt565 data comes from ADV7842 configured manually from i2c, I have
checked the ADV configuration using an evaluation board
(EVAL-ADV7842-7511P) in BT656 10 bits mode. Then I assume that the
10bit BT656 arrives to the omap isp.

In the kernel side, I use a tvp5150 driver like a dummy driver in
order to configure the MC and V4L2, this dummy driver only have
patched the i2c read/write and is well registered.

My question is about 10bit instead of 8 bits of tvp5150, in the
omap3-isp driver the 10 bits for BT656 is not configured (the
ISPCCDC_CFG_BW656 is not set in ispccdc.c file)

I just added

    isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG, ISPCCDC_CFG_BW656);

inside of ccdc_set_stream function, and I have checked that the bit 5
in 0x480B_C654 CCDC_CFG omap register and comes to "1"

But with yavta I can't capture the image sent from ADV7842, after
convert with raw2rgbpnm appear the "image", attached link.
http://picpaste.com/test-0HlXySLu.png

Any clue about how to use BT656 10 bits in omap3 (DM3730)?

I have tested with kernel v4.5 mainline and v4.3 that was used for
validate the tvp5150(bt656 8bit) video captures to omap3-isp.

Best Regards
Eduard Gavin
