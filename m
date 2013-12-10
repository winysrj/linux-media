Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35776 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab3LJNmz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 08:42:55 -0500
Received: from avalon.localnet (9.6-200-80.adsl-dyn.isp.belgacom.be [80.200.6.9])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id E392935A6A
	for <linux-media@vger.kernel.org>; Tue, 10 Dec 2013 14:42:06 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.14] MT9V032 sensor driver fixes and features
Date: Tue, 10 Dec 2013 14:43:05 +0100
Message-ID: <6204235.ElnWnsnMf4@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 431cb350187c6bf1ed083622d633418a298a7216:

  [media] az6007: support Technisat Cablestar Combo HDCI (minus remote) 
(2013-12-10 07:15:54 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git sensors/mt9v034

for you to fetch changes up to eea7b9b80c2495491791ca3a0577e64d25ca5f1a:

  mt9v032: Add support for the MT9V034 (2013-12-10 14:40:10 +0100)

----------------------------------------------------------------
Laurent Pinchart (6):
      mt9v032: Remove unused macro
      mt9v032: Fix pixel array size
      mt9v032: Fix binning configuration
      mt9v032: Add support for monochrome models
      mt9v032: Add support for model-specific parameters
      mt9v032: Add support for the MT9V034

 drivers/media/i2c/mt9v032.c | 232 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 187 insertions(+), 45 deletions(-)

-- 
Regards,

Laurent Pinchart

