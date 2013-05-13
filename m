Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:64631 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab3EMOAE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 10:00:04 -0400
Received: by mail-bk0-f53.google.com with SMTP id mx1so276043bkb.26
        for <linux-media@vger.kernel.org>; Mon, 13 May 2013 07:00:01 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 13 May 2013 22:00:01 +0800
Message-ID: <CAPgLHd8gFagqNM8y3WAfw1F8sddPWzB9TN1U8EOF8VrknOoeOg@mail.gmail.com>
Subject: [PATCH v2] [media] sta2x11_vip: fix error return code in sta2x11_vip_init_one()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mchehab@redhat.com, hans.verkuil@cisco.com,
	giancarlo.asnaghi@st.com, federico.vaga@gmail.com,
	prabhakar.csengg@gmail.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The orig code will release all the resources if v4l2_device_register()
failed and return 0. But what we need in this case is to return an
negative error code to let the caller known we are failed.
So the patch save the return value of v4l2_device_register() to 'ret'
and return it when error.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
v1 -> v2: change the commit message
---
 drivers/media/pci/sta2x11/sta2x11_vip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 7005695..77edc11 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -1047,7 +1047,8 @@ static int sta2x11_vip_init_one(struct pci_dev *pdev,
 	ret = sta2x11_vip_init_controls(vip);
 	if (ret)
 		goto free_mem;
-	if (v4l2_device_register(&pdev->dev, &vip->v4l2_dev))
+	ret = v4l2_device_register(&pdev->dev, &vip->v4l2_dev);
+	if (ret)
 		goto free_mem;
 
 	dev_dbg(&pdev->dev, "BAR #0 at 0x%lx 0x%lx irq %d\n",

