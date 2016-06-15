Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:33227 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290AbcFOWaf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2016 18:30:35 -0400
From: Janusz Krzysztofik <jmkrzyszt@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Amitoj Kaur Chawla <amitoj1606@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Lee Jones <lee.jones@linaro.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
	Janusz Krzysztofik <jmkrzyszt@gmail.com>
Subject: [PATCH 0/3] media: fixes for Amstrad Delta camera
Date: Thu, 16 Jun 2016 00:29:47 +0200
Message-Id: <1466029790-31094-1-git-send-email-jmkrzyszt@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Janusz Krzysztofik (3):
  staging: media: omap1: fix null pointer dereference in
    omap1_cam_probe()
  staging: media: omap1: fix sensor probe not working anymore
  media: i2c/soc_camera: fix ov6650 sensor getting wrong clock

 drivers/media/i2c/soc_camera/ov6650.c      |  2 +-
 drivers/staging/media/omap1/omap1_camera.c | 16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

-- 
2.7.3

