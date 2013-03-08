Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:55538 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933454Ab3CHJa4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Mar 2013 04:30:56 -0500
Message-ID: <5139AFCA.6040409@ti.com>
Date: Fri, 8 Mar 2013 15:00:50 +0530
From: Sekhar Nori <nsekhar@ti.com>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
	<Davinci-linux-open-source@linux.davincidsp.com>
Subject: Error while building vpbe display as module
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prabhakar,

Building with CONFIG_VIDEO_DAVINCI_VPBE_DISPLAY=m in latest mainline
gives the error:

   MODPOST 130 modules
drivers/media/platform/davinci/vpbe_osd: struct platform_device_id is 24
bytes.  The last of 3 is:
0x64 0x6d 0x33 0x35 0x35 0x2c 0x76 0x70 0x62 0x65 0x2d 0x6f 0x73 0x64
0x00 0x00 0x00 0x00 0x00 0x00 0x03 0x00 0x00 0x00
FATAL: drivers/media/platform/davinci/vpbe_osd: struct
platform_device_id is not  terminated with a NULL entry!

Can you please look into this?

Thanks,
Sekhar
