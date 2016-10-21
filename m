Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36062 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755380AbcJUOAa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 10:00:30 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 1/4] mtk_mdp_vpu: fix build with COMPILE_TEST for 32 bits
Date: Fri, 21 Oct 2016 11:59:16 -0200
Message-Id: <cd14afdb178cf490e257368bc899c7a0c690d140.1477058332.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When building on i386 in 32 bits, several new warnings appear:

drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c: In function 'mtk_mdp_vpu_handle_init_ack':
drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c:28:28: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
  struct mtk_mdp_vpu *vpu = (struct mtk_mdp_vpu *)msg->ap_inst;
                            ^
drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c: In function 'mtk_mdp_vpu_ipi_handler':
drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c:40:28: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
  struct mtk_mdp_vpu *vpu = (struct mtk_mdp_vpu *)msg->ap_inst;
                            ^
drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c: In function 'mtk_mdp_vpu_send_ap_ipi':
drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c:111:16: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
  msg.ap_inst = (uint64_t)vpu;
                ^
drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c: In function 'mtk_mdp_vpu_init':
drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c:129:16: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
  msg.ap_inst = (uint64_t)vpu;
                ^

That's because the driver assumes that it will be built only on
64 bits. As we don't want extra warnings when building with 32
bits, we need to double-cast.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c b/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c
index fb07bf3dbd8b..b38d29e99f7a 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_vpu.c
@@ -25,7 +25,7 @@ static inline struct mtk_mdp_ctx *vpu_to_ctx(struct mtk_mdp_vpu *vpu)
 
 static void mtk_mdp_vpu_handle_init_ack(struct mdp_ipi_comm_ack *msg)
 {
-	struct mtk_mdp_vpu *vpu = (struct mtk_mdp_vpu *)msg->ap_inst;
+	struct mtk_mdp_vpu *vpu = (struct mtk_mdp_vpu *)(long)msg->ap_inst;
 
 	/* mapping VPU address to kernel virtual address */
 	vpu->vsi = (struct mdp_process_vsi *)
@@ -37,7 +37,7 @@ static void mtk_mdp_vpu_ipi_handler(void *data, unsigned int len, void *priv)
 {
 	unsigned int msg_id = *(unsigned int *)data;
 	struct mdp_ipi_comm_ack *msg = (struct mdp_ipi_comm_ack *)data;
-	struct mtk_mdp_vpu *vpu = (struct mtk_mdp_vpu *)msg->ap_inst;
+	struct mtk_mdp_vpu *vpu = (struct mtk_mdp_vpu *)(long)msg->ap_inst;
 	struct mtk_mdp_ctx *ctx;
 
 	vpu->failure = msg->status;
@@ -108,7 +108,7 @@ static int mtk_mdp_vpu_send_ap_ipi(struct mtk_mdp_vpu *vpu, uint32_t msg_id)
 	msg.msg_id = msg_id;
 	msg.ipi_id = IPI_MDP;
 	msg.vpu_inst_addr = vpu->inst_addr;
-	msg.ap_inst = (uint64_t)vpu;
+	msg.ap_inst = (uint64_t)(long)vpu;
 	err = mtk_mdp_vpu_send_msg((void *)&msg, sizeof(msg), vpu, IPI_MDP);
 	if (!err && vpu->failure)
 		err = -EINVAL;
@@ -126,7 +126,7 @@ int mtk_mdp_vpu_init(struct mtk_mdp_vpu *vpu)
 
 	msg.msg_id = AP_MDP_INIT;
 	msg.ipi_id = IPI_MDP;
-	msg.ap_inst = (uint64_t)vpu;
+	msg.ap_inst = (uint64_t)(long)vpu;
 	err = mtk_mdp_vpu_send_msg((void *)&msg, sizeof(msg), vpu, IPI_MDP);
 	if (!err && vpu->failure)
 		err = -EINVAL;
-- 
2.7.4

