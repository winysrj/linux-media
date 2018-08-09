Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39716 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725757AbeHIEB6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Aug 2018 00:01:58 -0400
Received: by mail-wr1-f65.google.com with SMTP id h10-v6so3652311wre.6
        for <linux-media@vger.kernel.org>; Wed, 08 Aug 2018 18:39:40 -0700 (PDT)
From: petrcvekcz@gmail.com
To: marek.vasut@gmail.com, mchehab@kernel.org
Cc: Petr Cvek <petrcvekcz@gmail.com>, linux-media@vger.kernel.org,
        robert.jarzmik@free.fr, slapin@ossfans.org, philipp.zabel@gmail.com
Subject: [PATCH v1 1/5] [media] soc_camera: ov9640: move ov9640 out of soc_camera
Date: Thu,  9 Aug 2018 03:39:45 +0200
Message-Id: <3852f6ed6544bfa3d8d0850b993190094eb09999.1533774451.git.petrcvekcz@gmail.com>
In-Reply-To: <cover.1533774451.git.petrcvekcz@gmail.com>
References: <cover.1533774451.git.petrcvekcz@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Petr Cvek <petrcvekcz@gmail.com>

Initial part of ov9640 transition from soc_camera subsystem to a standalone
v4l2 subdevice.

Signed-off-by: Petr Cvek <petrcvekcz@gmail.com>
---
 drivers/media/i2c/{soc_camera => }/ov9640.c | 0
 drivers/media/i2c/{soc_camera => }/ov9640.h | 0
 2 files changed, 0 insertions(+), 0 deletions(-)
 rename drivers/media/i2c/{soc_camera => }/ov9640.c (100%)
 rename drivers/media/i2c/{soc_camera => }/ov9640.h (100%)

diff --git a/drivers/media/i2c/soc_camera/ov9640.c b/drivers/media/i2c/ov9640.c
similarity index 100%
rename from drivers/media/i2c/soc_camera/ov9640.c
rename to drivers/media/i2c/ov9640.c
diff --git a/drivers/media/i2c/soc_camera/ov9640.h b/drivers/media/i2c/ov9640.h
similarity index 100%
rename from drivers/media/i2c/soc_camera/ov9640.h
rename to drivers/media/i2c/ov9640.h
-- 
2.18.0
