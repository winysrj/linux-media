Return-path: <linux-media-owner@vger.kernel.org>
Received: from fed1rmfepo203.cox.net ([68.230.241.148]:44391 "EHLO
	fed1rmfepo203.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136AbbIUTIR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 15:08:17 -0400
Received: from fed1rmimpo109 ([68.230.241.158]) by fed1rmfepo203.cox.net
          (InterMail vM.8.01.05.15 201-2260-151-145-20131218) with ESMTP
          id <20150921190816.TRHN31460.fed1rmfepo203.cox.net@fed1rmimpo109>
          for <linux-media@vger.kernel.org>;
          Mon, 21 Sep 2015 15:08:16 -0400
From: Eric Nelson <eric@nelint.com>
To: linux-media@vger.kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mchehab@osg.samsung.com,
	mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
	galak@codeaurora.org, patrice.chotard@st.com, fabf@skynet.be,
	wsa@the-dreams.de, heiko@sntech.de, devicetree@vger.kernel.org,
	otavio@ossystems.com.br, Eric Nelson <eric@nelint.com>
Subject: [PATCH V2 0/2] rc: Add timeout support to gpio-ir-recv
Date: Mon, 21 Sep 2015 12:08:05 -0700
Message-Id: <1442862487-3643-1-git-send-email-eric@nelint.com>
In-Reply-To: <1441980024-1944-1-git-send-email-eric@nelint.com>
References: <1441980024-1944-1-git-send-email-eric@nelint.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add timeout support to the gpio-ir-recv driver as discussed
in this original patch:

	https://patchwork.ozlabs.org/patch/516827/

V2 uses the timeout field of the rcdev instead of a device tree 
field to set the timeout value as suggested by Sean Young.

Eric Nelson (2):
  rc-core: define a default timeout for drivers
  rc: gpio-ir-recv: add timeout on idle

 drivers/media/rc/gpio-ir-recv.c | 22 ++++++++++++++++++++++
 include/media/rc-core.h         |  1 +
 2 files changed, 23 insertions(+)

-- 
2.5.2

