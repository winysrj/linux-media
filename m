Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay0222.hostedemail.com ([216.40.44.222]:34696 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725985AbeI2EW7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Sep 2018 00:22:59 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Eugen Hristev <eugen.hristev@microchip.com>,
        linux-media@vger.kernel.org
Subject: Bad MAINTAINERS pattern in section 'MICROCHIP ISC DRIVER'
Date: Fri, 28 Sep 2018 14:57:14 -0700
Message-Id: <20180928215714.30346-1-joe@perches.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Please fix this defect appropriately.

linux-next MAINTAINERS section:

	9542	MICROCHIP ISC DRIVER
	9543	M:	Eugen Hristev <eugen.hristev@microchip.com>
	9544	L:	linux-media@vger.kernel.org
	9545	S:	Supported
	9546	F:	drivers/media/platform/atmel/atmel-isc.c
	9547	F:	drivers/media/platform/atmel/atmel-isc-regs.h
-->	9548	F:	devicetree/bindings/media/atmel-isc.txt

Commit that introduced this:

commit 71fb2c74287d186938cde830ad8980f57a38b597
 Author: Songjun Wu <songjun.wu@microchip.com>
 Date:   Wed Aug 17 03:05:29 2016 -0300
 
     [media] MAINTAINERS: atmel-isc: add entry for Atmel ISC
     
     Add the MAINTAINERS' entry for Microchip / Atmel Image Sensor Controller.
     
     Signed-off-by: Songjun Wu <songjun.wu@microchip.com>
     Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
     Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
     Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
 
  MAINTAINERS | 8 ++++++++
  1 file changed, 8 insertions(+)

No commit with devicetree/bindings/media/atmel-isc.txt found
