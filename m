Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:21830 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664AbbIVFIl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 01:08:41 -0400
From: Josh Wu <josh.wu@atmel.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 0/5] media: atmel-isi: enable preview path to output RGB565 format
Date: Tue, 22 Sep 2015 13:14:29 +0800
Message-ID: <1442898875-7147-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series will enable preview path support in atmel-isi. Which can
make atmel-isi convert the YUV format (from sensor) to RGB565 format.


Josh Wu (5):
  media: atmel-isi: correct yuv swap according to different sensor
    outputs
  media: atmel-isi: prepare for the support of preview path
  media: atmel-isi: add code to setup correct resolution for preview
    path
  media: atmel-isi: setup YCC_SWAP correctly when using preview path
  media: atmel-isi: support RGB565 output when sensor output YUV formats

 drivers/media/platform/soc_camera/atmel-isi.c | 181 ++++++++++++++++++++------
 drivers/media/platform/soc_camera/atmel-isi.h |  10 ++
 2 files changed, 148 insertions(+), 43 deletions(-)

-- 
1.9.1

