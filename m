Return-path: <linux-media-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:39865 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbbCEE6v (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Mar 2015 23:58:51 -0500
From: Josh Wu <josh.wu@atmel.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
CC: <linux-arm-kernel@lists.infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Josh Wu <josh.wu@atmel.com>
Subject: [PATCH 0/3] media: atmel-isi: rework on the clock part and add runtime pm support
Date: Thu, 5 Mar 2015 13:00:58 +0800
Message-ID: <1425531661-20040-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series fix the peripheral clock code and enable runtime pm
support.
Aslo clean up the code which is for the compatiblity of mck.


Josh Wu (3):
  media: atmel-isi: move the peripheral clock to start/stop_stream()
    function
  media: atmel-isi: add runtime pm support
  media: atmel-isi: remove mck back compatiable code as we don't need it

 drivers/media/platform/soc_camera/atmel-isi.c | 72 +++++++++++++--------------
 1 file changed, 34 insertions(+), 38 deletions(-)

-- 
1.9.1

