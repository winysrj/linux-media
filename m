Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:25945 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754111AbcEQOy0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2016 10:54:26 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org, devel@driverdev.osuosl.org,
	pmchba@pmcs.com
Subject: [PATCH 0/7] fix typo
Date: Tue, 17 May 2016 16:38:39 +0200
Message-Id: <1463495926-13728-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

firmare -> firmware

---

 drivers/media/dvb-frontends/mn88473.c       |    2 +-
 drivers/net/wireless/ath/ath6kl/core.h      |    2 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c |    2 +-
 drivers/scsi/pm8001/pm8001_init.c           |    2 +-
 drivers/scsi/snic/snic_fwint.h              |    2 +-
 drivers/staging/media/mn88472/mn88472.c     |    2 +-
 drivers/staging/wilc1000/linux_wlan.c       |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)
