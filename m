Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:53636 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab3FVJqt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jun 2013 05:46:49 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Rob Landley <rob@landley.net>,
	devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 0/2] media: i2c: ths8200: Feature enhancement
Date: Sat, 22 Jun 2013 15:16:33 +0530
Message-Id: <1371894395-14414-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

The first patch of the series adds supports for asynchronous subdev
registration for ths8200 driver, and the second patch of the series
adds OF support the driver.

Lad, Prabhakar (2):
  media: i2c: ths8200: support asynchronous probing
  media: i2c: ths8200: add OF support

 .../devicetree/bindings/media/i2c/ths8200.txt      |   19 +++++++++++++++++++
 drivers/media/i2c/ths8200.c                        |   18 +++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ths8200.txt

-- 
1.7.9.5

