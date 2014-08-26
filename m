Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1212 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbaHZGWk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 02:22:40 -0400
Message-ID: <53FC2759.4020704@xs4all.nl>
Date: Tue, 26 Aug 2014 08:21:13 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: ivtv-devel@ivtvdriver.org, Andy Walls <awalls@md.metrocast.net>
Subject: [PATCH for v3.17] cx18: fix kernel oops with tda8290 tuner
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This was caused by an uninitialized setup.config field.

Based on a suggestion from Devin Heitmueller.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Thanks-to: Devin Heitmueller <dheitmueller@kernellabs.com>
Reported-by: Scott Robinson <scott.robinson55@gmail.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: stable@vger.kernel.org      # for v3.10 and up
---
 drivers/media/pci/cx18/cx18-driver.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
index 716bdc5..83f5074 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -1091,6 +1091,7 @@ static int cx18_probe(struct pci_dev *pci_dev,
 		setup.addr = ADDR_UNSET;
 		setup.type = cx->options.tuner;
 		setup.mode_mask = T_ANALOG_TV;  /* matches TV tuners */
+		setup.config = NULL;
 		if (cx->options.radio > 0)
 			setup.mode_mask |= T_RADIO;
 		setup.tuner_callback = (setup.type == TUNER_XC2028) ?
-- 
2.1.0.rc1

