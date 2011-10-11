Return-path: <linux-media-owner@vger.kernel.org>
Received: from newsmtp5.atmel.com ([204.2.163.5]:27848 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab1JKLEL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Oct 2011 07:04:11 -0400
From: Josh Wu <josh.wu@atmel.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	plagnioj@jcrosoft.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	nicolas.ferre@atmel.com, s.nawrocki@samsung.com
Subject: [PATCH v4 0/3] add Atmel ISI, ov2640 support for sam9m10/sam9g45
Date: Tue, 11 Oct 2011 19:03:37 +0800
Message-Id: <1318331020-22031-1-git-send-email-josh.wu@atmel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, all

Accroding to the comments from Guennadi, please see below the changes since V3:
1. Move isi_mck registration to at91_add_device_isi, but the user has a chance to or not to use the Programmable clock of the SoC.
2. In board file, e.g. board-sam9m10g45ek.c, user can pass a boolean to at91_add_device_isi, so that the SoC programmable clock can be used or not.

To summary, programmable clock is managed in SoC level. The user can decide to use or not to use SoC clock as the sensor MCK at board level. 
In later case, user has to provide a clock source named "isi_mck"

Best Regards,
Josh Wu
