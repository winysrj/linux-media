Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35424 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab2HKScb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Aug 2012 14:32:31 -0400
Received: by obbuo13 with SMTP id uo13so4144121obb.19
        for <linux-media@vger.kernel.org>; Sat, 11 Aug 2012 11:32:30 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 11 Aug 2012 15:32:30 -0300
Message-ID: <CALF0-+XgUONGHF+TTch42vDHyLNOdVu6yjZ-N55xU-PWiB8Bpg@mail.gmail.com>
Subject: [PATCH 0/2] media: Replace easycap driver with stk1160
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Here's the stk1160 inclusion patch, splitted as two patches
(easycap removal and stk1160 add) as requested by Mauro.

I'd like to thanks Hans, Sylwester, Takashi and Mauro
(and everyone else) for their reviewing and their help.

Regards,
Ezequiel.

Ezequiel Garcia (2):
 staging: media: Remove easycap driver
 media: Add stk1160 new driver (easycap replacement)

 drivers/media/video/Kconfig                      |    2 +
 drivers/media/video/Makefile                     |    1 +
 drivers/media/video/stk1160/Kconfig              |   20 +
 drivers/media/video/stk1160/Makefile             |   11 +
 drivers/media/video/stk1160/stk1160-ac97.c       |  153 +
 drivers/media/video/stk1160/stk1160-core.c       |  432 +++
 drivers/media/video/stk1160/stk1160-i2c.c        |  294 ++
 drivers/media/video/stk1160/stk1160-reg.h        |   93 +
 drivers/media/video/stk1160/stk1160-v4l.c        |  738 ++++
 drivers/media/video/stk1160/stk1160-video.c      |  518 +++
 drivers/media/video/stk1160/stk1160.h            |  208 ++
 drivers/staging/media/Kconfig                    |    2 -
 drivers/staging/media/Makefile                   |    1 -
 drivers/staging/media/easycap/Kconfig            |   30 -
 drivers/staging/media/easycap/Makefile           |   10 -
 drivers/staging/media/easycap/README             |  141 -
 drivers/staging/media/easycap/easycap.h          |  567 ---
 drivers/staging/media/easycap/easycap_ioctl.c    | 2443 -------------
 drivers/staging/media/easycap/easycap_low.c      |  968 -----
 drivers/staging/media/easycap/easycap_main.c     | 4239 ----------------------
 drivers/staging/media/easycap/easycap_settings.c |  696 ----
 drivers/staging/media/easycap/easycap_sound.c    |  750 ----
 drivers/staging/media/easycap/easycap_testcard.c |  155 -
 23 files changed, 2470 insertions(+), 10002 deletions(-)
