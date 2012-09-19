Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50726 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2ISUV1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 16:21:27 -0400
Received: by bkwj10 with SMTP id j10so764457bkw.19
        for <linux-media@vger.kernel.org>; Wed, 19 Sep 2012 13:21:26 -0700 (PDT)
Message-ID: <505A2943.6070801@gmail.com>
Date: Wed, 19 Sep 2012 22:21:23 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sangwook Lee <sangwook.lee@linaro.org>,
	javier Martin <javier.martin@vista-silicon.com>
Subject: [GIT PULL FOR 3.7] s5k4ecgx sensor driver and m2m capability fix
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 4313902ebe33155209472215c62d2f29d117be29:

  [media] ivtv-alsa, ivtv: Connect ivtv PCM capture stream to ivtv-alsa interface driver (2012-09-18 13:29:07 -0300)

are available in the git repository at:
  git://linuxtv.org/snawrocki/media.git v4l-next

Sangwook Lee (1):
      Add v4l2 subdev driver for S5K4ECGX sensor

Sylwester Nawrocki (1):
      m2m-deinterlace: Add V4L2_CAP_VIDEO_M2M capability flag

 drivers/media/i2c/Kconfig                |    7 +
 drivers/media/i2c/Makefile               |    1 +
 drivers/media/i2c/s5k4ecgx.c             | 1036 ++++++++++++++++++++++++++++++
 drivers/media/platform/m2m-deinterlace.c |    9 +-
 include/media/s5k4ecgx.h                 |   37 ++
 5 files changed, 1088 insertions(+), 2 deletions(-)
 create mode 100644 drivers/media/i2c/s5k4ecgx.c
 create mode 100644 include/media/s5k4ecgx.h

---

Regards,
Sylwester
