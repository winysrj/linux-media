Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35485 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751275AbdH2IUp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Aug 2017 04:20:45 -0400
Received: by mail-wm0-f43.google.com with SMTP id y71so16098095wmd.0
        for <linux-media@vger.kernel.org>; Tue, 29 Aug 2017 01:20:44 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH] media: venus: init registered list on streamoff
Date: Tue, 29 Aug 2017 11:19:43 +0300
Message-Id: <20170829081943.29277-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add missing init_list_head for the registered buffer list.
Absence of the init could lead to a unhandled kernel paging
request as below, when streamon/streamoff are called in row.

[338046.571321] Unable to handle kernel paging request at virtual address fffffffffffffe00
[338046.574849] pgd = ffff800034820000
[338046.582381] [fffffffffffffe00] *pgd=00000000b60f5003[338046.582545]
, *pud=00000000b1f31003
, *pmd=0000000000000000[338046.592082]
[338046.597754] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[338046.601671] Modules linked in: venus_enc venus_dec venus_core
usb_f_ecm g_ether usb_f_rndis u_ether libcomposite ipt_MASQUERADE
nf_nat_masquerade_ipv4 arc4 wcn36xx mac80211 btqcomsmd btqca iptable_nat
nf_co]
[338046.662408] CPU: 0 PID: 5433 Comm: irq/160-venus Tainted: G        W
4.9.39+ #232
[338046.668024] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC
(DT)
[338046.675268] task: ffff80003541cb00 task.stack: ffff800026e20000
[338046.682097] PC is at venus_helper_release_buf_ref+0x28/0x88
[venus_core]
[338046.688282] LR is at vdec_event_notify+0xe8/0x150 [venus_dec]
[338046.695029] pc : [<ffff000000af6c48>] lr : [<ffff000000a6fc60>]
pstate: a0000145
[338046.701256] sp : ffff800026e23bc0
[338046.708494] x29: ffff800026e23bc0 x28: 0000000000000000
[338046.718853] x27: ffff000000afd4f8 x26: ffff800031faa700
[338046.729253] x25: ffff000000afd790 x24: ffff800031faa618
[338046.739664] x23: ffff800003e18138 x22: ffff800002fc9810
[338046.750109] x21: ffff800026e23c28 x20: 0000000000000001
[338046.760592] x19: ffff80002a13b800 x18: 0000000000000010
[338046.771099] x17: 0000ffffa3d01600 x16: ffff000008100428
[338046.781654] x15: 0000000000000006 x14: ffff000089045ba7
[338046.792250] x13: ffff000009045bb6 x12: 00000000004f37c8
[338046.802894] x11: 0000000000267211 x10: 0000000000000000
[338046.813574] x9 : 0000000000032000 x8 : 00000000dc400000
[338046.824274] x7 : 0000000000000000 x6 : ffff800031faa728
[338046.835005] x5 : ffff80002a13b850 x4 : 0000000000000000
[338046.845793] x3 : fffffffffffffdf8 x2 : 0000000000000000
[338046.856602] x1 : 0000000000000003 x0 : ffff80002a13b800

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 68933d208063..9b2a401a4891 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -682,6 +682,7 @@ void venus_helper_vb2_stop_streaming(struct vb2_queue *q)
 			hfi_session_abort(inst);
 
 		load_scale_clocks(core);
+		INIT_LIST_HEAD(&inst->registeredbufs);
 	}
 
 	venus_helper_buffers_done(inst, VB2_BUF_STATE_ERROR);
-- 
2.11.0
