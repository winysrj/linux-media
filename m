Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:36572 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbcB2NN4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 08:13:56 -0500
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-renesas-soc@vger.kernel.org
Subject: [PATCH/RFC 0/4] media: soc_camera: rcar_vin: Add UDS and NV16 scaling support
Date: Mon, 29 Feb 2016 22:12:39 +0900
Message-Id: <1456751563-21246-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series adds UDS support, NV16 scaling support and callback functions
to be required by a clipping process.

This series is against the master branch of linuxtv.org/media_tree.git.

Koji Matsuoka (3):
  media: soc_camera: rcar_vin: Add get_selection callback function
  media: soc_camera: rcar_vin: Add cropcap callback function
  media: soc_camera: rcar_vin: Add NV16 scaling support

Yoshihiko Mori (1):
  media: soc_camera: rcar_vin: Add UDS support

 drivers/media/platform/soc_camera/rcar_vin.c | 220 ++++++++++++++++++++++-----
 1 file changed, 184 insertions(+), 36 deletions(-)

-- 
1.9.1

