Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:34022 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750987AbdE2PqZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 11:46:25 -0400
Received: by mail-wm0-f45.google.com with SMTP id 123so20771788wmg.1
        for <linux-media@vger.kernel.org>; Mon, 29 May 2017 08:46:24 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        David Airlie <airlied@linux.ie>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Olivier Moysan <olivier.moysan@st.com>,
        Rob Clark <robdclark@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Takashi Iwai <tiwai@suse.com>,
        Tony Lindgren <tony@atomide.com>, linux-iio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        freedreno@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-media@vger.kernel.org
Subject: [PATCH 00/15] make more driver use devm_of_platform_populate()
Date: Mon, 29 May 2017 17:45:48 +0200
Message-Id: <1496072763-31209-1-git-send-email-benjamin.gaignard@linaro.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Number of calls to of_platform_populate() aren't unbalanced by a call to
of_platform_depopulate() that could generate issue will loading/unloading
the drivers. Make those drivers use devm_of_platform_populate() fix the problem
without need to add remove function.

In some case replacing of_platform_populate() by devm_of_platform_populate()
allow to delete driver remove function and save some lines of code.

This series of patches based on v4.12-rc3 tag.

CC: Alexandre Torgue <alexandre.torgue@st.com>
CC: David Airlie <airlied@linux.ie>
CC: Fabrice Gasnier <fabrice.gasnier@st.com>
CC: Hartmut Knaack <knaack.h@gmx.de>
CC: Jaroslav Kysela <perex@perex.cz>
CC: Javier Martinez Canillas <javier@osg.samsung.com>
CC: Jonathan Cameron <jic23@kernel.org>
CC: Krzysztof Kozlowski <krzk@kernel.org>
CC: Kukjin Kim <kgene@kernel.org>
CC: Kyungmin Park <kyungmin.park@samsung.com>
CC: Lars-Peter Clausen <lars@metafoo.de>
CC: Lee Jones <lee.jones@linaro.org>
CC: Liam Girdwood <lgirdwood@gmail.com>
CC: Mark Brown <broonie@kernel.org>
CC: Mauro Carvalho Chehab <mchehab@kernel.org>
CC: Olivier Moysan <olivier.moysan@st.com>
CC: Rob Clark <robdclark@gmail.com>
CC: Shawn Guo <shawnguo@kernel.org>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: Takashi Iwai <tiwai@suse.com>
CC: Tony Lindgren <tony@atomide.com>

CC: linux-iio@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org
CC: linux-kernel@vger.kernel.org
CC: dri-devel@lists.freedesktop.org
CC: linux-arm-msm@vger.kernel.org
CC: freedreno@lists.freedesktop.org
CC: linux-samsung-soc@vger.kernel.org
CC: alsa-devel@alsa-project.org
CC: linux-media@vger.kernel.org

Benjamin Gaignard (15):
  iio: adc: stm32: use devm_of_platform_populate()
  iio: dac: stm32: use devm_of_platform_populate()
  drm: zte: use devm_of_platform_populate()
  drm: msm: use devm_of_platform_populate()
  mfd: stm32-timers: use devm_of_platform_populate
  mfd: atmel: use devm_of_platform_populate()
  mfd: cros_ec: use devm_of_platform_populate()
  mfd: exynos: use devm_of_platform_populate()
  mfd: fsl-imx25: use devm_of_platform_populate()
  mfd: motorola-cpcap: use devm_of_platform_populate()
  mfd: palmas: use devm_of_platform_populate()
  mfd: qcom-spmi-pmic: use devm_of_platform_populate()
  mfd: smsc-ece: use devm_of_platform_populate()
  sound: stm32: use devm_of_platform_populate()
  media: exynos4-is: use devm_of_platform_populate()

 drivers/gpu/drm/msm/msm_drv.c               | 10 ++--------
 drivers/gpu/drm/zte/zx_drm_drv.c            |  2 +-
 drivers/iio/adc/stm32-adc-core.c            |  4 +---
 drivers/iio/dac/stm32-dac-core.c            |  3 +--
 drivers/media/platform/exynos4-is/fimc-is.c |  7 ++-----
 drivers/mfd/atmel-flexcom.c                 |  2 +-
 drivers/mfd/cros_ec.c                       |  2 +-
 drivers/mfd/exynos-lpass.c                  |  2 +-
 drivers/mfd/fsl-imx25-tsadc.c               |  5 +----
 drivers/mfd/motorola-cpcap.c                | 13 +------------
 drivers/mfd/palmas.c                        |  2 +-
 drivers/mfd/qcom-spmi-pmic.c                |  9 +--------
 drivers/mfd/smsc-ece1099.c                  |  3 +--
 drivers/mfd/stm32-timers.c                  | 10 +---------
 sound/soc/stm/stm32_sai.c                   | 11 +----------
 15 files changed, 17 insertions(+), 68 deletions(-)

-- 
1.9.1
