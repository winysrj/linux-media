Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53546 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab3LELjD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Dec 2013 06:39:03 -0500
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-media@vger.kernel.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	laurent.pinchart@ideasonboard.com,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	Grant Likely <grant.likely@linaro.org>
Subject: [PATCH v10 0/2] S5K5BAF camera sensor driver
Date: Thu, 05 Dec 2013 12:38:38 +0100
Message-id: <1386243520-17117-1-git-send-email-a.hajda@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is the 10th iteration of S5K5BAF camera patch (time for celebration).
All changes are described in patches.

Regards
Andrzej

Andrzej Hajda (2):
  s5k5baf: add camera sensor driver
  s5k5baf: add DT bindings for camera sensor

 .../devicetree/bindings/media/samsung-s5k5baf.txt  |   58 +
 MAINTAINERS                                        |    7 +
 drivers/media/i2c/Kconfig                          |    7 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/s5k5baf.c                        | 2043 ++++++++++++++++++++
 5 files changed, 2116 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
 create mode 100644 drivers/media/i2c/s5k5baf.c

-- 
1.8.3.2

