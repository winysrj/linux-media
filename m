Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:38294 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752077AbeCQP2h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Mar 2018 11:28:37 -0400
From: Dmitry Osipenko <digetx@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 4/5] media: staging: tegra-vde: Do not handle spurious interrupts
Date: Sat, 17 Mar 2018 18:28:14 +0300
Message-Id: <8d1b583bde182ab79a18f43df83f87affda6b174.1521300358.git.digetx@gmail.com>
In-Reply-To: <cover.1521300358.git.digetx@gmail.com>
References: <cover.1521300358.git.digetx@gmail.com>
In-Reply-To: <cover.1521300358.git.digetx@gmail.com>
References: <cover.1521300358.git.digetx@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Do not handle interrupts if we haven't asked for them, potentially that
could happen if HW wasn't programmed properly.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
 drivers/staging/media/tegra-vde/tegra-vde.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/media/tegra-vde/tegra-vde.c b/drivers/staging/media/tegra-vde/tegra-vde.c
index 94b4db55cdb5..9e542c6288f1 100644
--- a/drivers/staging/media/tegra-vde/tegra-vde.c
+++ b/drivers/staging/media/tegra-vde/tegra-vde.c
@@ -935,6 +935,9 @@ static irqreturn_t tegra_vde_isr(int irq, void *data)
 {
 	struct tegra_vde *vde = data;
 
+	if (completion_done(&vde->decode_completion))
+		return IRQ_NONE;
+
 	tegra_vde_set_bits(vde, 0, vde->frameid + 0x208);
 	complete(&vde->decode_completion);
 
-- 
2.16.1
