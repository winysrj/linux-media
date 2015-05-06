Return-path: <linux-media-owner@vger.kernel.org>
Received: from nasmtp01.atmel.com ([192.199.1.245]:43026 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751626AbbEFKWj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2015 06:22:39 -0400
From: Josh Wu <josh.wu@atmel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	<linux-arm-kernel@lists.infradead.org>, Josh Wu <josh.wu@atmel.com>
Subject: [PATCH v3 0/3] media: atmel-isi: rework on the clock part and add runtime pm support
Date: Wed, 6 May 2015 18:25:52 +0800
Message-ID: <1430907955-28665-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series fix the peripheral clock code and enable runtime pm
support.
Also it clean up the code which is for the compatiblity of mck.

Changes in v3:
- remove useless definition: ISI_DEFAULT_MCLK_FREQ

Changes in v2:
- this file is new added.
- merged v1 two patch into one.
- use runtime_pm_put() instead of runtime_pm_put_sync()
- enable peripheral clock before access ISI registers.
- totally remove clock_start()/clock_stop() as they are optional.

Josh Wu (3):
  media: atmel-isi: remove the useless code which disable isi
  media: atmel-isi: add runtime pm support
  media: atmel-isi: remove mck back compatiable code as it's not need

 drivers/media/platform/soc_camera/atmel-isi.c | 102 ++++++++++++--------------
 1 file changed, 45 insertions(+), 57 deletions(-)

-- 
1.9.1

