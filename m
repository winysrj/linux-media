Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay4.synopsys.com ([198.182.47.9]:52585 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119AbcFCRgz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jun 2016 13:36:55 -0400
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: mchehab@osg.samsung.com, robh+dt@kernel.org,
	Ramiro.Oliveira@synopsys.com, CARLOS.PALMINHA@synopsys.com
Subject: [PATCH 0/2] OV5647 sensor driver
Date: Fri,  3 Jun 2016 18:36:39 +0100
Message-Id: <cover.1464966020.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: roliveir <roliveir@synopsys.com>

Hello,

This patch adds support for the Omnivision OV5647 sensor.

At the moment it only supports 640x480 in Raw 8.

Ramiro Oliveira (2):
  Add OV5647 device tree documentation
  Add support for Omnivision OV5647

 .../devicetree/bindings/media/i2c/ov5647.txt       |  19 +
 MAINTAINERS                                        |   7 +
 drivers/media/i2c/Kconfig                          |  11 +
 drivers/media/i2c/Makefile                         |   1 +
 drivers/media/i2c/ov5647.c                         | 891 +++++++++++++++++++++
 5 files changed, 929 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5647.txt
 create mode 100644 drivers/media/i2c/ov5647.c

-- 
2.8.1


