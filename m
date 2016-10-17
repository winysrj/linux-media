Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36008
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932930AbcJQPob (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 11:44:31 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        kernel@stlinux.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        devel@driverdev.osuosl.org, Kevin Hilman <khilman@baylibre.com>,
        linux-renesas-soc@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Carlo Caione <carlo@caione.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-amlogic@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH 0/5] [media] Fix module autoload for media platform drivers
Date: Mon, 17 Oct 2016 12:44:07 -0300
Message-Id: <1476719053-17600-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

I noticed that module autoload won't be working in a bunch of media
platform drivers because the module alias information is not filled
in the modules. This patch series contains the fixes for them.

Best regards,
Javier


Javier Martinez Canillas (5):
  [media] v4l: vsp1: Fix module autoload for OF registration
  [media] v4l: rcar-fcp: Fix module autoload for OF registration
  [media] rc: meson-ir: Fix module autoload
  [media] s5p-cec: Fix module autoload
  [media] st-cec: Fix module autoload

 drivers/media/platform/rcar-fcp.c       | 1 +
 drivers/media/platform/vsp1/vsp1_drv.c  | 1 +
 drivers/media/rc/meson-ir.c             | 1 +
 drivers/staging/media/s5p-cec/s5p_cec.c | 1 +
 drivers/staging/media/st-cec/stih-cec.c | 1 +
 5 files changed, 5 insertions(+)

-- 
2.7.4

