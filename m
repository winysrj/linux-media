Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52825 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaJNHUu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Oct 2014 03:20:50 -0400
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH 0/2] media: soc_camera: rcar_vin: Add r8a7794, r8a7793 device support
Date: Tue, 14 Oct 2014 16:20:22 +0900
Message-Id: <1413271224-9792-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series is against master branch of linuxtv.org/media_tree.git.

Koji Matsuoka (2):
  media: soc_camera: rcar_vin: Add r8a7794 device support
  media: soc_camera: rcar_vin: Add r8a7793 device support

 drivers/media/platform/soc_camera/rcar_vin.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
1.9.1

