Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:49871 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaJPGNQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Oct 2014 02:13:16 -0400
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH v2 0/3] media: soc_camera: rcar_vin: Add scaling support
Date: Thu, 16 Oct 2014 15:12:45 +0900
Message-Id: <1413439968-6349-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series is against master branch of linuxtv.org/media_tree.git.

Koji Matsuoka (3):
  media: soc_camera: rcar_vin: Add scaling support
  media: soc_camera: rcar_vin: Add capture width check for NV16 format
  media: soc_camera: rcar_vin: Add NV16 horizontal scaling-up support

 drivers/media/platform/soc_camera/rcar_vin.c | 482 ++++++++++++++++++++++++++-
 1 file changed, 472 insertions(+), 10 deletions(-)

-- 
1.9.1

