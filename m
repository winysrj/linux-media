Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33168 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757307AbcAKSAj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 13:00:39 -0500
From: Yoshihiro Kaneko <ykaneko0929@gmail.com>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: [PATCH 0/3] media: soc_camera: rcar_vin: add rcar-gen3 support
Date: Tue, 12 Jan 2016 03:00:08 +0900
Message-Id: <1452535211-4869-1-git-send-email-ykaneko0929@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* add rcar compatibility strings

  This series adds generic rcar and SoC-specific r8a7795 compatibility
  strings to the rcar-vin driver. The intention is to provide a complete
  set of compatibility strings for known R-Car Gen2 and Gen3 SoCs.

* add ARGB8888 capture format support 

  This series contain a patch which adds the ARGB8888 capture format
  support for R-Car Gen3.

* compile tested only

This series is based on the master branch of linuxtv.org/media_tree.git.


Koji Matsuoka (1):
  media: soc_camera: rcar_vin: Add ARGB8888 caputre format support

Yoshihiko Mori (1):
  media: soc_camera: rcar_vin: Add R-Car Gen3 support

Yoshihiro Kaneko (1):
  media: soc_camera: rcar_vin: Add rcar fallback compatibility string

 .../devicetree/bindings/media/rcar_vin.txt         |  9 +++++++-
 drivers/media/platform/soc_camera/rcar_vin.c       | 24 ++++++++++++++++++++--
 2 files changed, 30 insertions(+), 3 deletions(-)

-- 
1.9.1

