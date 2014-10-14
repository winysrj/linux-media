Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:49901 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419AbaJNG1K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Oct 2014 02:27:10 -0400
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH 0/3] media: soc_camera: rcar_vin: Add scaling support
Date: Tue, 14 Oct 2014 15:26:50 +0900
Message-Id: <1413268013-8437-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series is against master branch of linuxtv.org/media_tree.git.

Koji Matsuoka (3):
  media: soc_camera: rcar_vin: Add scaling support
  media: soc_camera: rcar_vin: Add capture width check for NV16 format
  media: soc_camera: rcar_vin: Add NV16 horizontal scaling-up support

 drivers/media/platform/soc_camera/rcar_vin.c | 488 ++++++++++++++++++++++++++-
 1 file changed, 478 insertions(+), 10 deletions(-)

-- 
1.9.1

