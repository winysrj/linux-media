Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1029 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965713Ab3E2LBU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 May 2013 07:01:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Andy Walls <awalls@md.metrocast.net>
Subject: [PATCHv1 37/38] ivtv: fix register range check
Date: Wed, 29 May 2013 13:00:10 +0200
Message-Id: <1369825211-29770-38-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
References: <1369825211-29770-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Ensure that the register is aligned to a dword, otherwise the range check
could fail since it assumes dword alignment.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Andy Walls <awalls@md.metrocast.net>
---
 drivers/media/pci/ivtv/ivtv-ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 944300f..807b275 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -696,6 +696,8 @@ static int ivtv_itvc(struct ivtv *itv, bool get, u64 reg, u64 *val)
 {
 	volatile u8 __iomem *reg_start;
 
+	if (reg & 0x3)
+		return -EINVAL;
 	if (reg >= IVTV_REG_OFFSET && reg < IVTV_REG_OFFSET + IVTV_REG_SIZE)
 		reg_start = itv->reg_mem - IVTV_REG_OFFSET;
 	else if (itv->has_cx23415 && reg >= IVTV_DECODER_OFFSET &&
-- 
1.7.10.4

