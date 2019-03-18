Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4831C10F0D
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 19:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C6CB2133F
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 19:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbfCRTQ5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 15:16:57 -0400
Received: from retiisi.org.uk ([95.216.213.190]:55186 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727572AbfCRTQ5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 15:16:57 -0400
Received: from lanttu.localdomain (lanttu.retiisi.org.uk [IPv6:2a01:4f9:c010:4572::c1:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id E0ECE634C7B;
        Mon, 18 Mar 2019 21:15:02 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Subject: [RFC 0/8] Rework V4L2 fwnode parsing; add defaults and avoid iteration
Date:   Mon, 18 Mar 2019 21:16:45 +0200
Message-Id: <20190318191653.7197-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi folks,

This patchset reworks V4L2 fwnode endpoint parsing. It enables the use of
endpoint configuration defaults that is available sensors and other
drivers that only use a single endpoint. Well, the functionality was
available already but no driver used it likely because of two reasons:
lack of any examples in a non-trivial problem area as well as lack of a
needed functionality to obtain through non-iterative means in the fwnode
graph API. Also the fwnode framework did not provide the most convenient
APIs to perform this for drivers.

Conversion from the iterative API is done for the omap3isp and ipu3-cio2
drivers. A downside here is that this adds code: what used to be done in
the framework in a one-size-fits-all fashion is now the responsibility of
the driver. The benefits (default settings and simplicity of the
implementation from driver's point of view) are not really achievable
without some of that.

Also baked in the set is matching devices with endpoints by endpoint node
rather than the device's node. This allows finding out more information
than just the device bound (i.e. the port --- or endpoint --- through
which it was bound). Compatibility support is provided for existing
drivers by setting the fwnode to be matched based on the available
endpoints. Drivers that use the async non-notifier API and have multiple
ports will likely need special care and this is right now missing from the
set, hence this is RFC for now.

The set depends on a few other patches. They all can be found here:

<URL:https://git.linuxtv.org/sailus/media_tree.git/log/?h=fwnode-linear>

Sakari Ailus (8):
  v4l2-async: Use endpoint node, not device node, for fwnode match
  v4l2-async: Add v4l2_async_notifier_add_fwnode_remote_subdev
  v4l2-fwnode: Use v4l2_async_notifier_add_fwnode_remote_subdev
  omap3isp: Rework OF endpoint parsing
  v4l2-async: Safely clean up an uninitialised notifier
  ipu3-cio2: Clean up notifier's subdev list if parsing endpoints fails
  ipu3-cio2: Proceed with notifier init even if there are no subdevs
  ipu3-cio2: Parse information from firmware without using callbacks

 drivers/media/pci/intel/ipu3/ipu3-cio2.c      |  97 ++++----
 drivers/media/platform/am437x/am437x-vpfe.c   |   2 +-
 drivers/media/platform/atmel/atmel-isc.c      |   2 +-
 drivers/media/platform/atmel/atmel-isi.c      |   2 +-
 drivers/media/platform/cadence/cdns-csi2rx.c  |   2 +-
 drivers/media/platform/davinci/vpif_capture.c |  14 +-
 drivers/media/platform/exynos4-is/media-dev.c |  14 +-
 drivers/media/platform/omap3isp/isp.c         | 334 +++++++++++++++-----------
 drivers/media/platform/pxa_camera.c           |   2 +-
 drivers/media/platform/qcom/camss/camss.c     |  10 +-
 drivers/media/platform/rcar_drif.c            |   3 +-
 drivers/media/platform/renesas-ceu.c          |   2 +-
 drivers/media/platform/stm32/stm32-dcmi.c     |   2 +-
 drivers/media/platform/ti-vpe/cal.c           |   2 +-
 drivers/media/platform/xilinx/xilinx-vipp.c   |  13 +-
 drivers/media/v4l2-core/v4l2-async.c          |  33 ++-
 drivers/media/v4l2-core/v4l2-fwnode.c         |  12 +-
 drivers/staging/media/soc_camera/soc_camera.c |  14 +-
 include/media/v4l2-async.h                    |  24 ++
 19 files changed, 354 insertions(+), 230 deletions(-)

-- 
2.11.0
