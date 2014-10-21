Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41438 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaJUFKj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Oct 2014 01:10:39 -0400
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH v3 0/3] media: soc_camera: rcar_vin: Add scaling support
Date: Tue, 21 Oct 2014 14:10:26 +0900
Message-Id: <1413868229-22205-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series is against master branch of linuxtv.org/media_tree.git.

Koji Matsuoka (3):
  media: soc_camera: rcar_vin: Add scaling support
  media: soc_camera: rcar_vin: Add capture width check for NV16 format
  media: soc_camera: rcar_vin: Add NV16 horizontal scaling-up support

 drivers/media/platform/soc_camera/rcar_vin.c | 478 ++++++++++++++++++++++++++-
 1 file changed, 468 insertions(+), 10 deletions(-)

-- 
1.9.1

