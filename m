Return-path: <linux-media-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16222 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab2BTJrj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Feb 2012 04:47:39 -0500
From: Ravi Kumar V <kumarrav@codeaurora.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Trilok soni <tsoni@codeaurora.org>,
	David Brown <davidb@codeaurora.org>, bryanh@codeaurora.org,
	Jarod Wilson <jarod@redhat.com>,
	Anssi Hannula <anssi.hannula@iki.fi>,
	"Juan J. Garcia de Soria" <skandalfo@gmail.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ravi Kumar V <kumarrav@codeaurora.org>,
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 0/1] Add support for GPIO IR receiver driver
Date: Mon, 20 Feb 2012 15:17:24 +0530
Message-Id: <1329731244-31440-1-git-send-email-kumarrav@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver is for GPIO based IR receivers, it can listen only to IR receiver
modules which gives demodulated signal as output, this driver only passes the
interrupt events to rc framework where pulse and space widths are calculated
and input to decoders avaliable.

Ravi Kumar V (1):
  rc: Add support for GPIO based IR Receiver driver.

 drivers/media/rc/Kconfig        |    9 ++
 drivers/media/rc/Makefile       |    1 +
 drivers/media/rc/gpio-ir-recv.c |  189 +++++++++++++++++++++++++++++++++++++++
 include/media/gpio-ir-recv.h    |   23 +++++
 4 files changed, 222 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/rc/gpio-ir-recv.c
 create mode 100644 include/media/gpio-ir-recv.h

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

