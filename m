Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam03on0074.outbound.protection.outlook.com ([104.47.42.74]:55456
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752056AbeBIBVY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Feb 2018 20:21:24 -0500
From: Satish Kumar Nagireddy <satish.nagireddy.nagireddy@xilinx.com>
To: <linux-media@vger.kernel.org>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <hyun.kwon@xilinx.com>
CC: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Satish Kumar Nagireddy <satishna@xilinx.com>
Subject: [PATCH v2 1/9] v4l: xilinx: dma: Remove colorspace check in xvip_dma_verify_format
Date: Thu, 8 Feb 2018 17:21:12 -0800
Message-ID: <1518139272-21588-1-git-send-email-satishna@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

In current implementation driver only checks the colorspace
between the last subdev in the pipeline and the connected video node,
the pipeline could be configured with wrong colorspace information
until the very end. It thus makes little sense to check the
colorspace only at the video node. So check can be dropped until
we find a better solution to carry colorspace information
through pipelines and to userspace.

Signed-off-by: Satish Kumar Nagireddy <satishna@xilinx.com>
---
 drivers/media/platform/xilinx/xilinx-dma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/pla=
tform/xilinx/xilinx-dma.c
index 522cdfd..cb20ada 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -75,8 +75,7 @@ static int xvip_dma_verify_format(struct xvip_dma *dma)

        if (dma->fmtinfo->code !=3D fmt.format.code ||
            dma->format.height !=3D fmt.format.height ||
-           dma->format.width !=3D fmt.format.width ||
-           dma->format.colorspace !=3D fmt.format.colorspace)
+           dma->format.width !=3D fmt.format.width)
                return -EINVAL;

        return 0;
--
2.7.4

This email and any attachments are intended for the sole use of the named r=
ecipient(s) and contain(s) confidential information that may be proprietary=
, privileged or copyrighted under applicable law. If you are not the intend=
ed recipient, do not read, copy, or forward this email message or any attac=
hments. Delete this email message and any attachments immediately.
