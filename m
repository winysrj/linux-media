Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:45252 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbcCOAkj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2016 20:40:39 -0400
From: Simon Horman <horms+renesas@verge.net.au>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH v4 0/2] media: soc_camera: rcar_vin: add fallback and r8a7792 bindings
Date: Tue, 15 Mar 2016 09:40:25 +0900
Message-Id: <1458002427-3063-1-git-send-email-horms+renesas@verge.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this short series adds add fallback and r8a7792 bindings to rcar_vin.

Based on media-tree/master

Changes since v3:
* Add Acks
* Correct typo in changelog

Simon Horman (1):
  media: soc_camera: rcar_vin: add device tree support for r8a7792

Yoshihiro Kaneko (1):
  media: soc_camera: rcar_vin: add R-Car Gen 2 and 3 fallback
    compatibility strings

 Documentation/devicetree/bindings/media/rcar_vin.txt | 12 ++++++++++--
 drivers/media/platform/soc_camera/rcar_vin.c         |  2 ++
 2 files changed, 12 insertions(+), 2 deletions(-)

-- 
2.1.4

