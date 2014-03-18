Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp02.atmel.com ([204.2.163.16]:49806 "EHLO
	SJOEDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753743AbaCRLZV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Mar 2014 07:25:21 -0400
From: Josh Wu <josh.wu@atmel.com>
To: <g.liakhovetski@gmx.de>
CC: <linux-media@vger.kernel.org>, <m.chehab@samsung.com>,
	<nicolas.ferre@atmel.com>, <linux-arm-kernel@lists.infradead.org>,
	Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 0/3] [media] atmel-isi: Add DT support for Atmel ISI driver
Date: Tue, 18 Mar 2014 19:13:56 +0800
Message-ID: <1395141238-5948-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series add DT support for atmel ISI driver. It can support the
common v4l2 DT interfaces.

Josh Wu (3):
  [media] atmel-isi: add v4l2 async probe support
  [media] atmel-isi: convert the pdata from pointer to structure
  [media] atmel-isi: add primary DT support

 .../devicetree/bindings/media/atmel-isi.txt        |   51 +++++++++++++++++
 drivers/media/platform/soc_camera/atmel-isi.c      |   58 ++++++++++++++++----
 include/media/atmel-isi.h                          |    4 ++
 3 files changed, 101 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/atmel-isi.txt

-- 
1.7.9.5

