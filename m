Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:46357
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752151AbdHDMfQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Aug 2017 08:35:16 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: devel@driverdev.osuosl.org
Cc: bhumirks@gmail.com, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 0/5] constify videobuf_queue_ops structures
Date: Fri,  4 Aug 2017 14:09:43 +0200
Message-Id: <1501848588-22628-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These videobuf_queue_ops structures are only passed as the second
argument to videobuf_queue_vmalloc_init, which is declared as const.
Thus the videobuf_queue_ops structures themselves can be const.

Done with the help of Coccinelle.

---

 drivers/media/pci/cx18/cx18-streams.c                     |    2 +-
 drivers/media/usb/cx231xx/cx231xx-417.c                   |    2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c                 |    2 +-
 drivers/media/usb/tm6000/tm6000-video.c                   |    2 +-
 drivers/media/usb/zr364xx/zr364xx.c                       |    2 +-
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c |    4 ++--
 6 files changed, 7 insertions(+), 7 deletions(-)
