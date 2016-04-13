Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:5755 "EHLO
	nasmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234AbcDMHvd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2016 03:51:33 -0400
From: Songjun Wu <songjun.wu@atmel.com>
To: <g.liakhovetski@gmx.de>, <nicolas.ferre@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>,
	Songjun Wu <songjun.wu@atmel.com>,
	Fabien Dessenne <fabien.dessenne@st.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	<devicetree@vger.kernel.org>,
	"Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	"Benoit Parrot" <bparrot@ti.com>,
	Kumar Gala <galak@codeaurora.org>,
	<linux-kernel@vger.kernel.org>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?= <richard@puffinpack.se>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mark Rutland <mark.rutland@arm.com>,
	<linux-media@vger.kernel.org>
Subject: [PATCH 0/2] [media] atmel-isc: add driver for Atmel ISC
Date: Wed, 13 Apr 2016 15:44:18 +0800
Message-ID: <1460533460-32336-1-git-send-email-songjun.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Image Sensor Controller driver includes two parts.
1) Driver code to implement the ISC function.
2) Device tree binding documentation, it describes how
   to add the ISC in device tree.


Songjun Wu (2):
  [media] atmel-isc: add the Image Sensor Controller code
  [media] atmel-isc: DT binding for Image Sensor Controller driver

 .../devicetree/bindings/media/atmel-isc.txt        |   84 ++
 drivers/media/platform/Kconfig                     |    1 +
 drivers/media/platform/Makefile                    |    2 +
 drivers/media/platform/atmel/Kconfig               |    9 +
 drivers/media/platform/atmel/Makefile              |    3 +
 drivers/media/platform/atmel/atmel-isc-regs.h      |  280 ++++
 drivers/media/platform/atmel/atmel-isc.c           | 1537 ++++++++++++++++++++
 7 files changed, 1916 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/atmel-isc.txt
 create mode 100644 drivers/media/platform/atmel/Kconfig
 create mode 100644 drivers/media/platform/atmel/Makefile
 create mode 100644 drivers/media/platform/atmel/atmel-isc-regs.h
 create mode 100644 drivers/media/platform/atmel/atmel-isc.c

-- 
2.7.4

