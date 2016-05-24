Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:43048 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbcEXSRF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 14:17:05 -0400
From: roliveir <Ramiro.Oliveira@synopsys.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: mchehab@osg.samsung.com, robh+dt@kernel.org,
	Ramiro.Oliveira@synopsys.com, CARLOS.PALMINHA@synopsys.com
Subject: [RFC 0/2] Add support for OV5647 sensor
Date: Tue, 24 May 2016 19:16:46 +0100
Message-Id: <cover.1464112779.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This RFC patch adds support for the Omnivision OV5647 sensor.

At the moment it only supports 640x480 in Raw 8.

Ramiro Oliveira (2):
  Add OV5647 device tree documentation
  Add support for Omnivision OV5647

 .../devicetree/bindings/media/i2c/ov5647.txt       |  29 +
 MAINTAINERS                                        |   7 +
 drivers/media/i2c/Kconfig                          |  11 +
 drivers/media/i2c/Makefile                         |   1 +
 drivers/media/i2c/ov5647.c                         | 891 +++++++++++++++++++++
 5 files changed, 939 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5647.txt
 create mode 100644 drivers/media/i2c/ov5647.c

-- 
2.8.1


