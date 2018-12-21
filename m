Return-Path: <SRS0=g7QC=O6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A07EC43387
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 01:18:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 384E821904
	for <linux-media@archiver.kernel.org>; Fri, 21 Dec 2018 01:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545355086;
	bh=UTN62N183Ah3lnE3aR75mfhLjkc30Np95KuQLFLBNvs=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=r6wAJAD3Zd3xGJiiz9m1rXqBhEk2PbDw4IgcgpiQen5lDWIimKEA92jrE+Nn9Ac+Y
	 sfh2CAtU3duQe2U8G7sy34Lv2jf6+gGM+asZo1/LBfJIKU/D5CUjZF4yBMdMyL+HZG
	 O25JAzo1jckfgTG3CXsFpuSjCb8bUjgUrmdYXNN0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388527AbeLUBSA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 20 Dec 2018 20:18:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387963AbeLUBSA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Dec 2018 20:18:00 -0500
Received: from mail.kernel.org (unknown [185.216.33.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B25B8218E0;
        Fri, 21 Dec 2018 01:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545355079;
        bh=UTN62N183Ah3lnE3aR75mfhLjkc30Np95KuQLFLBNvs=;
        h=From:To:Cc:Subject:Date:From;
        b=tLSKfAnbHXuokROVLbpid2m/IlBtemyDFnK0MQoY+kQRUDiR0DEh5bNjaB8UsLsbw
         fvyjNgo0opW3rVuDpQ50nxdr3mYxlywBlvxWbFCgwj3NY4t6sAbwJUpOG2TS1y47GS
         Wpba9VUApwlDyZrHO6Ptu2z8NIQpV13xcc9QZHUY=
From:   Sebastian Reichel <sre@kernel.org>
To:     Sebastian Reichel <sre@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Tony Lindgren <tony@atomide.com>
Cc:     Rob Herring <robh@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>, linux-bluetooth@vger.kernel.org,
        linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/14] Add support for FM radio in hcill and kill TI_ST
Date:   Fri, 21 Dec 2018 02:17:38 +0100
Message-Id: <20181221011752.25627-1-sre@kernel.org>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

This moves all remaining users of the legacy TI_ST driver to hcill (patches
1-3). Then patches 4-7 convert wl128x-radio driver to a standard platform
device driver with support for multiple instances. Patch 7 will result in
(userless) TI_ST driver no longer supporting radio at runtime. Patch 8-11 do
some cleanups in the wl128x-radio driver. Finally patch 12 removes the TI_ST
specific parts from wl128x-radio and adds the required infrastructure to use it
with the serdev hcill driver instead. The remaining patches 13 and 14 remove
the old TI_ST code.

The new code has been tested on the Motorola Droid 4. For testing the audio
should be configured to route Ext to Speaker or Headphone. Then you need to
plug headphone, since its cable is used as antenna. For testing there is a
'radio' utility packages in Debian. When you start the utility you need to
specify a frequency, since initial get_frequency returns an error:

$ radio -f 100.0

Merry Christmas!

-- Sebastian

Sebastian Reichel (14):
  ARM: dts: LogicPD Torpedo: Add WiLink UART node
  ARM: dts: IGEP: Add WiLink UART node
  ARM: OMAP2+: pdata-quirks: drop TI_ST/KIM support
  media: wl128x-radio: remove module version
  media: wl128x-radio: remove global radio_disconnected
  media: wl128x-radio: remove global radio_dev
  media: wl128x-radio: convert to platform device
  media: wl128x-radio: use device managed memory allocation
  media: wl128x-radio: load firmware from ti-connectivity/
  media: wl128x-radio: simplify fmc_prepare/fmc_release
  media: wl128x-radio: fix skb debug printing
  media: wl128x-radio: move from TI_ST to hci_ll driver
  Bluetooth: btwilink: drop superseded driver
  misc: ti-st: Drop superseded driver

 .../boot/dts/logicpd-torpedo-37xx-devkit.dts  |   8 +
 arch/arm/boot/dts/omap3-igep0020-rev-f.dts    |   8 +
 arch/arm/boot/dts/omap3-igep0030-rev-g.dts    |   8 +
 arch/arm/mach-omap2/pdata-quirks.c            |  52 -
 drivers/bluetooth/Kconfig                     |  11 -
 drivers/bluetooth/Makefile                    |   1 -
 drivers/bluetooth/btwilink.c                  | 350 -------
 drivers/bluetooth/hci_ll.c                    | 115 ++-
 drivers/media/radio/wl128x/Kconfig            |   2 +-
 drivers/media/radio/wl128x/fmdrv.h            |   5 +-
 drivers/media/radio/wl128x/fmdrv_common.c     | 211 ++--
 drivers/media/radio/wl128x/fmdrv_common.h     |   4 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c       |  55 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.h       |   2 +-
 drivers/misc/Kconfig                          |   1 -
 drivers/misc/Makefile                         |   1 -
 drivers/misc/ti-st/Kconfig                    |  18 -
 drivers/misc/ti-st/Makefile                   |   6 -
 drivers/misc/ti-st/st_core.c                  | 922 ------------------
 drivers/misc/ti-st/st_kim.c                   | 868 -----------------
 drivers/misc/ti-st/st_ll.c                    | 169 ----
 include/linux/ti_wilink_st.h                  | 337 +------
 22 files changed, 213 insertions(+), 2941 deletions(-)
 delete mode 100644 drivers/bluetooth/btwilink.c
 delete mode 100644 drivers/misc/ti-st/Kconfig
 delete mode 100644 drivers/misc/ti-st/Makefile
 delete mode 100644 drivers/misc/ti-st/st_core.c
 delete mode 100644 drivers/misc/ti-st/st_kim.c
 delete mode 100644 drivers/misc/ti-st/st_ll.c

-- 
2.19.2

