Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:65090 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbaIVWWO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 18:22:14 -0400
Received: by mail-we0-f179.google.com with SMTP id u56so3677270wes.10
        for <linux-media@vger.kernel.org>; Mon, 22 Sep 2014 15:22:12 -0700 (PDT)
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Maxime Coquelin <maxime.coquelin@st.com>,
	Patrice Chotard <patrice.chotard@st.com>,
	linux-arm-kernel@lists.infradead.org, kernel@stlinux.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 0/3] media:st-rc: Misc fixes.
Date: Mon, 22 Sep 2014 23:21:41 +0100
Message-Id: <1411424501-12673-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thankyou for the "[media] enable COMPILE_TEST for media drivers" patch
which picked up few things in st-rc driver in linux-next testing.

Here is a few minor fixes to the driver, could you consider them for
the next merge window.

Thanks,
srini

Srinivas Kandagatla (3):
  media: st-rc: move to using reset_control_get_optional
  media: st-rc: move pm ops setup out of conditional compilation.
  media: st-rc: Remove .owner field for driver

 drivers/media/rc/st_rc.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

-- 
1.9.1

