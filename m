Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:52991 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750742AbcFSN1i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jun 2016 09:27:38 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id CF10E18161B
	for <linux-media@vger.kernel.org>; Sun, 19 Jun 2016 15:27:32 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH] HDMI CEC rc keymap
Date: Sun, 19 Jun 2016 15:27:31 +0200
Message-Id: <1466342852-5748-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This adds the HDMI CEC keymap module.

This patch depends on these two patches:

https://patchwork.linuxtv.org/patch/34675/
https://patchwork.linuxtv.org/patch/34679/

So those two have to be merged in mainline before this patch can be
merged.

Regards,

	Hans

Kamil Debski (1):
  rc-cec: Add HDMI CEC keymap module

 drivers/media/rc/keymaps/Makefile |   1 +
 drivers/media/rc/keymaps/rc-cec.c | 182 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 183 insertions(+)
 create mode 100644 drivers/media/rc/keymaps/rc-cec.c

-- 
2.8.1

