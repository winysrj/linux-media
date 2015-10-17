Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:9459 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750943AbbJQJn0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Oct 2015 05:43:26 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 0/2] delete null dereference
Date: Sat, 17 Oct 2015 11:32:18 +0200
Message-Id: <1445074340-21955-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These patches delete NULL dereferences, as detected by
scripts/coccinelle/null/deref_null.cocci.

---

 drivers/media/pci/netup_unidvb/netup_unidvb_spi.c |    6 ++----
 net/nfc/netlink.c                                 |    6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)
