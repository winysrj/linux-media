Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8104CC43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 19:53:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EDED206BB
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 19:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546977199;
	bh=w9i95yBLuR3TpkuAGgeQD60hGiwEjkqcWeyfpQ0nvPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Fk9A/dlZEnmgJlUFXgtyWeSqXP3oIpBBkyyZERu/ndRLvjZ+dAkVEi2bZgd83qPCJ
	 TMqRt1EESP3jNpMvuX4yn5J5+/xHG/+zdh+eSaRJAqyPTGSsuS7cxsvY1V2Vnxl0jI
	 itBu4UXsBNUuu4uCxvwY0LRxBDl2i/EyBr/3Xcn4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732925AbfAHTxG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 14:53:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:38988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730954AbfAHTbC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Jan 2019 14:31:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 821A120665;
        Tue,  8 Jan 2019 19:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546975861;
        bh=w9i95yBLuR3TpkuAGgeQD60hGiwEjkqcWeyfpQ0nvPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v38QvSDEIpMAYKAkTFxMjhwBDklO6LvVzLNZFFVFdqYLwnd/aGatK1umChdDBl3lP
         NF/Y/obmc3/En/PzJKoh4MbnkqVoyxRi4MLFiTbtsS5XxmjOU0xJXy98lX2M6ldHg6
         2WHUdRD/1GxqKgC535s5joX8UtgYWDq33/4EvdDQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vivek Gautam <vivek.gautam@codeaurora.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 43/97] media: venus: core: Set dma maximum segment size
Date:   Tue,  8 Jan 2019 14:28:52 -0500
Message-Id: <20190108192949.122407-43-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190108192949.122407-1-sashal@kernel.org>
References: <20190108192949.122407-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Vivek Gautam <vivek.gautam@codeaurora.org>

[ Upstream commit de2563bce7a157f5296bab94f3843d7d64fb14b4 ]

Turning on CONFIG_DMA_API_DEBUG_SG results in the following error:

[  460.308650] ------------[ cut here ]------------
[  460.313490] qcom-venus aa00000.video-codec: DMA-API: mapping sg segment longer than device claims to support [len=4194304] [max=65536]
[  460.326017] WARNING: CPU: 3 PID: 3555 at src/kernel/dma/debug.c:1301 debug_dma_map_sg+0x174/0x254
[  460.338888] Modules linked in: venus_dec venus_enc videobuf2_dma_sg videobuf2_memops hci_uart btqca bluetooth venus_core v4l2_mem2mem videobuf2_v4l2 videobuf2_common ath10k_snoc ath10k_core ath lzo lzo_compress zramjoydev
[  460.375811] CPU: 3 PID: 3555 Comm: V4L2DecoderThre Tainted: G        W         4.19.1 #82
[  460.384223] Hardware name: Google Cheza (rev1) (DT)
[  460.389251] pstate: 60400009 (nZCv daif +PAN -UAO)
[  460.394191] pc : debug_dma_map_sg+0x174/0x254
[  460.398680] lr : debug_dma_map_sg+0x174/0x254
[  460.403162] sp : ffffff80200c37d0
[  460.406583] x29: ffffff80200c3830 x28: 0000000000010000
[  460.412056] x27: 00000000ffffffff x26: ffffffc0f785ea80
[  460.417532] x25: 0000000000000000 x24: ffffffc0f4ea1290
[  460.423001] x23: ffffffc09e700300 x22: ffffffc0f4ea1290
[  460.428470] x21: ffffff8009037000 x20: 0000000000000001
[  460.433936] x19: ffffff80091b0000 x18: 0000000000000000
[  460.439411] x17: 0000000000000000 x16: 000000000000f251
[  460.444885] x15: 0000000000000006 x14: 0720072007200720
[  460.450354] x13: ffffff800af536e0 x12: 0000000000000000
[  460.455822] x11: 0000000000000000 x10: 0000000000000000
[  460.461288] x9 : 537944d9c6c48d00 x8 : 537944d9c6c48d00
[  460.466758] x7 : 0000000000000000 x6 : ffffffc0f8d98f80
[  460.472230] x5 : 0000000000000000 x4 : 0000000000000000
[  460.477703] x3 : 000000000000008a x2 : ffffffc0fdb13948
[  460.483170] x1 : ffffffc0fdb0b0b0 x0 : 000000000000007a
[  460.488640] Call trace:
[  460.491165]  debug_dma_map_sg+0x174/0x254
[  460.495307]  vb2_dma_sg_alloc+0x260/0x2dc [videobuf2_dma_sg]
[  460.501150]  __vb2_queue_alloc+0x164/0x374 [videobuf2_common]
[  460.507076]  vb2_core_reqbufs+0xfc/0x23c [videobuf2_common]
[  460.512815]  vb2_reqbufs+0x44/0x5c [videobuf2_v4l2]
[  460.517853]  v4l2_m2m_reqbufs+0x44/0x78 [v4l2_mem2mem]
[  460.523144]  v4l2_m2m_ioctl_reqbufs+0x1c/0x28 [v4l2_mem2mem]
[  460.528976]  v4l_reqbufs+0x30/0x40
[  460.532480]  __video_do_ioctl+0x36c/0x454
[  460.536610]  video_usercopy+0x25c/0x51c
[  460.540572]  video_ioctl2+0x38/0x48
[  460.544176]  v4l2_ioctl+0x60/0x74
[  460.547602]  do_video_ioctl+0x948/0x3520
[  460.551648]  v4l2_compat_ioctl32+0x60/0x98
[  460.555872]  __arm64_compat_sys_ioctl+0x134/0x20c
[  460.560718]  el0_svc_common+0x9c/0xe4
[  460.564498]  el0_svc_compat_handler+0x2c/0x38
[  460.568982]  el0_svc_compat+0x8/0x18
[  460.572672] ---[ end trace ce209b87b2f3af88 ]---

>From above warning one would deduce that the sg segment will overflow
the device's capacity. In reality, the hardware can accommodate larger
sg segments.
So, initialize the max segment size properly to weed out this warning.

Based on a similar patch sent by Sean Paul for mdss:
https://patchwork.kernel.org/patch/10671457/

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
Acked-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index bb6add9d340e..5b8350e87e75 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -264,6 +264,14 @@ static int venus_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	if (!dev->dma_parms) {
+		dev->dma_parms = devm_kzalloc(dev, sizeof(*dev->dma_parms),
+					      GFP_KERNEL);
+		if (!dev->dma_parms)
+			return -ENOMEM;
+	}
+	dma_set_max_seg_size(dev, DMA_BIT_MASK(32));
+
 	INIT_LIST_HEAD(&core->instances);
 	mutex_init(&core->lock);
 	INIT_DELAYED_WORK(&core->work, venus_sys_error_handler);
-- 
2.19.1

