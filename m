Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36378 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbaGQL4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 07:56:51 -0400
Received: from avalon.localnet (unknown [91.178.197.224])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 95F16359FB
	for <linux-media@vger.kernel.org>; Thu, 17 Jul 2014 13:55:47 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v3.17] MC and V4L2 core fixes
Date: Thu, 17 Jul 2014 13:56:58 +0200
Message-ID: <6926072.lWPNHLIZK6@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 3c0d394ea7022bb9666d9df97a5776c4bcc3045c:

  [media] dib8000: improve the message that reports per-layer locks 
(2014-07-07 09:59:01 -0300)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git v4l2/core

for you to fetch changes up to 65ab45056f77770f777bf0e98c4060c74e91c624:

  media-device: Remove duplicated memset() in media_enum_entities() 
(2014-07-17 13:56:08 +0200)

----------------------------------------------------------------
Sakari Ailus (1):
      v4l: subdev: Unify argument validation across IOCTLs

Salva Peiró (1):
      media-device: Remove duplicated memset() in media_enum_entities()

 drivers/media/media-device.c          |   2 -
 drivers/media/v4l2-core/v4l2-subdev.c | 120 +++++++++++++++++++++------------
 2 files changed, 74 insertions(+), 48 deletions(-)

-- 
Regards,

Laurent Pinchart

