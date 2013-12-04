Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48631 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383Ab3LDP2e (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Dec 2013 10:28:34 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: [PATCH 0/5] Atmel ISI fixes and improvements
Date: Wed,  4 Dec 2013 16:28:31 +0100
Message-Id: <1386170916-13723-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Here's a set of miscellaneous fixes and improvement patches for the atmel-isi
driver. Please see individual commit messages for more information.

The last patch makes the MCK clock optional. The goal is to remove it
completely, but we first need to port boards to the new clock handling
mechanism. The patch in itself will not have any effect until then, but
getting it in v3.14 will help with dependency management for arch/ changes in
the next kernel versions.

Josh, do you want to take those patches in your tree and send a pull request
to Mauro ? I'd like to get the patches to mainline in v3.14 if possible.

Josh Wu (1):
  v4l: atmel-isi: remove SOF wait in start_streaming()

Laurent Pinchart (4):
  v4l: atmel-isi: Use devm_* managed allocators
  v4l: atmel-isi: Defer clock (un)preparation to enable/disable time
  v4l: atmel-isi: Reset the ISI when starting the stream
  v4l: atmel-isi: Make the MCK clock optional

 drivers/media/platform/soc_camera/atmel-isi.c | 168 +++++++-------------------
 1 file changed, 46 insertions(+), 122 deletions(-)

-- 
Regards,

Laurent Pinchart

