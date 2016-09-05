Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:44111 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754635AbcIEPpS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Sep 2016 11:45:18 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by tschai.lan (Postfix) with ESMTPSA id 606471808D8
        for <linux-media@vger.kernel.org>; Mon,  5 Sep 2016 17:45:12 +0200 (CEST)
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.9] Add ST HVA driver
Message-ID: <8c8a2787-c5ac-ca6a-092d-71923e492643@xs4all.nl>
Date: Mon, 5 Sep 2016 17:45:12 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit fb6609280db902bd5d34445fba1c926e95e63914:

  [media] dvb_frontend: Use memdup_user() rather than duplicating its implementation (2016-08-24 17:20:45 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git hva

for you to fetch changes up to c87fbd309e007492f19291d86e3c8b0eddcb6925:

  st-hva: update MAINTAINERS (2016-09-05 17:33:32 +0200)

----------------------------------------------------------------
Jean-Christophe Trotin (4):
      Documentation: DT: add bindings for ST HVA
      st-hva: multi-format video encoder V4L2 driver
      st-hva: add H.264 video encoding support
      st-hva: update MAINTAINERS

 Documentation/devicetree/bindings/media/st,st-hva.txt |   24 +
 MAINTAINERS                                           |    8 +
 drivers/media/platform/Kconfig                        |   15 +
 drivers/media/platform/Makefile                       |    1 +
 drivers/media/platform/sti/hva/Makefile               |    2 +
 drivers/media/platform/sti/hva/hva-h264.c             | 1050 +++++++++++++++++++++++++++++++++
 drivers/media/platform/sti/hva/hva-hw.c               |  538 +++++++++++++++++
 drivers/media/platform/sti/hva/hva-hw.h               |   42 ++
 drivers/media/platform/sti/hva/hva-mem.c              |   59 ++
 drivers/media/platform/sti/hva/hva-mem.h              |   34 ++
 drivers/media/platform/sti/hva/hva-v4l2.c             | 1415 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/media/platform/sti/hva/hva.h                  |  315 ++++++++++
 12 files changed, 3503 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/st,st-hva.txt
 create mode 100644 drivers/media/platform/sti/hva/Makefile
 create mode 100644 drivers/media/platform/sti/hva/hva-h264.c
 create mode 100644 drivers/media/platform/sti/hva/hva-hw.c
 create mode 100644 drivers/media/platform/sti/hva/hva-hw.h
 create mode 100644 drivers/media/platform/sti/hva/hva-mem.c
 create mode 100644 drivers/media/platform/sti/hva/hva-mem.h
 create mode 100644 drivers/media/platform/sti/hva/hva-v4l2.c
 create mode 100644 drivers/media/platform/sti/hva/hva.h
