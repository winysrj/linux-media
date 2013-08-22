Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34417 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab3HVRzs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 13:55:48 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 0/2] Renesas VSP1 fixes
Date: Thu, 22 Aug 2013 19:56:55 +0200
Message-Id: <1377194217-24235-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here's two fixes for the Renesas VSP1 driver. The first one reports the platform
device name through the media device bus_info field, allowing applications to
differentiate between VSP1 instances. The second one gets rid of a crash related
to missing clocks for the VSPR and VSPS instances.

I'd like to get those patches in v3.12-rc1 if possible.

Laurent Pinchart (2):
  v4l: vsp1: Initialize media device bus_info field
  v4l: vsp1: Add support for RT clock

 drivers/media/platform/vsp1/vsp1.h     |  1 +
 drivers/media/platform/vsp1/vsp1_drv.c | 42 ++++++++++++++++++++++++++++++----
 2 files changed, 38 insertions(+), 5 deletions(-)

-- 
Regards,

Laurent Pinchart

