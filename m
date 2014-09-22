Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:40612 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbaIVPXH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 11:23:07 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v6 0/6] LED / flash API integration - Documentation
Date: Mon, 22 Sep 2014 17:22:50 +0200
Message-id: <1411399376-16497-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch set is the follow-up of the LED / flash API integration
series [1]. For clarity reasons the patchset has been split into
four subsets:

- LED Flash Class
- V4L2 Flash
- LED Flash Class drivers
- Documentation

========================
Changes since version 5:
========================

- removed flash manager framework - its implementation needs
  further thorough discussion.
- removed external strobe facilities from the LED Flash Class
  and provided external_strobe_set op in v4l2-flash. LED subsystem
  should be strobe provider agnostic.

Thanks,
Jacek Anaszewski

[1] https://lkml.org/lkml/2014/7/11/914

Jacek Anaszewski (6):
  Documentation: leds: Add description of LED Flash Class extension
  DT: leds: Add flash led devices related properties
  DT: Add documentation for exynos4-is 'flashes' property
  DT: Add documentation for the mfd Maxim max77693
  of: Add Skyworks Solutions, Inc. vendor prefix
  DT: Add documentation for the Skyworks AAT1290

 Documentation/devicetree/bindings/leds/common.txt  |   16 +++++
 .../devicetree/bindings/leds/leds-aat1290.txt      |   17 ++++++
 .../devicetree/bindings/media/samsung-fimc.txt     |    5 ++
 Documentation/devicetree/bindings/mfd/max77693.txt |   62 ++++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 Documentation/leds/leds-class-flash.txt            |   51 ++++++++++++++++
 6 files changed, 152 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-aat1290.txt
 create mode 100644 Documentation/leds/leds-class-flash.txt

-- 
1.7.9.5

