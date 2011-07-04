Return-path: <mchehab@pedra>
Received: from fep27.mx.upcmail.net ([62.179.121.47]:53401 "EHLO
	fep27.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758381Ab1GDQl5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2011 12:41:57 -0400
From: "Hans von Marwijk" <ching@hispeed.ch>
To: "'Oliver Endriss'" <o.endriss@gmx.de>,
	<linux-media@vger.kernel.org>
Cc: "'Mauro Carvalho Chehab'" <mchehab@redhat.com>
References: <201107031831.20378@orion.escape-edv.de>
In-Reply-To: <201107031831.20378@orion.escape-edv.de>
Subject: RE: [PATCH 00/16] New drivers: DRX-K, TDA18271c2, Updates: CXD2099 and ngene
Date: Mon, 4 Jul 2011 18:41:10 +0200
Message-ID: <00a001cc3a69$2e07ec30$8a17c490$@ch>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-gb
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi

In which GIT or HG repository can I find these patches.

drivers/media/dvb/ngene/ngene-core.c  
...

Regards
Eckhard

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-owner@vger.kernel.org] On Behalf Of Oliver Endriss
> Sent: 03 July 2011 18:31
> To: linux-media@vger.kernel.org
> Cc: Mauro Carvalho Chehab
> Subject: [PATCH 00/16] New drivers: DRX-K, TDA18271c2, Updates: CXD2099 and ngene
> 
> [PATCH 01/16] tda18271c2dd: Initial check-in
> [PATCH 02/16] tda18271c2dd: Lots of coding-style fixes
> [PATCH 03/16] DRX-K: Initial check-in
> [PATCH 04/16] DRX-K: Shrink size of drxk_map.h
> [PATCH 05/16] DRX-K: Tons of coding-style fixes
> [PATCH 06/16] DRX-K, TDA18271c2: Add build support
> [PATCH 07/16] get_dvb_firmware: Get DRX-K firmware for Digital Devices DVB-CT cards
> [PATCH 08/16] ngene: Support Digital Devices DuoFlex CT
> [PATCH 09/16] ngene: Coding style fixes
> [PATCH 10/16] ngene: Fix return code if no demux was found
> [PATCH 11/16] ngene: Fix name of Digital Devices PCIe/miniPCIe
> [PATCH 12/16] ngene: Support DuoFlex CT attached to CineS2 and SaTiX-S2
> [PATCH 13/16] cxd2099: Update to latest version
> [PATCH 14/16] cxd2099: Codingstyle fixes
> [PATCH 15/16] ngene: Update for latest cxd2099
> [PATCH 16/16] ngene: Strip dummy packets inserted by the driver
> 
> --
> ----------------------------------------------------------------
> VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
> 4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
> Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
> ----------------------------------------------------------------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

