Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:63977
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726254AbeJ0Vcv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 27 Oct 2018 17:32:51 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] constify v4l2_ctrl_ops structures
Date: Sat, 27 Oct 2018 14:16:38 +0200
Message-Id: <1540642600-25840-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make const v4l2_ctrl_ops structures that are only stored in a
const field or passed to a function having a const parameter.

Done with the help of Coccinelle.

---

 drivers/media/i2c/ov5645.c                    |    2 +-
 drivers/media/platform/vicodec/vicodec-core.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
