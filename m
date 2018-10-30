Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:42227 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727645AbeJaBAu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Oct 2018 21:00:50 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-usb@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH 0/2] constify vb2_ops structures
Date: Tue, 30 Oct 2018 16:31:20 +0100
Message-Id: <1540913482-22130-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vb2_ops structures can be const as they are only stored in the ops
field of a vb2_queue structure and this field is const.

Done with the help of Coccinelle.

---

 drivers/media/i2c/video-i2c.c           |    2 +-
 drivers/usb/gadget/function/uvc_queue.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
