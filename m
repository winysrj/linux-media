Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:50057 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbZFJRhR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 13:37:17 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id n5AHbEBZ004866
	for <linux-media@vger.kernel.org>; Wed, 10 Jun 2009 12:37:19 -0500
Received: from dlep20.itg.ti.com (localhost [127.0.0.1])
	by dlep35.itg.ti.com (8.13.7/8.13.7) with ESMTP id n5AHbD0P003153
	for <linux-media@vger.kernel.org>; Wed, 10 Jun 2009 12:37:13 -0500 (CDT)
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
Date: Wed, 10 Jun 2009 12:37:12 -0500
Subject: RE: [PATCH 0/10 - v2] ARM: DaVinci: Video: DM355/DM6446 VPFE
 Capture driver
Message-ID: <A69FA2915331DC488A831521EAE36FE40139A08C1A@dlee06.ent.ti.com>
References: <1244573204-20391-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1244573204-20391-1-git-send-email-m-karicheri2@ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

My patch 1/10 of this series somehow doesn't make it to linux-media@vger.kernel.org. I can see it locally. 

Here is the header part of the patch. I can't see any thing wrong.
I have tried re-sending with subject changed as follows, but nothing helped.
Do you know what could cause this?

[PATCH 1/10 - v2] vpfe capture bridge driver fro DM355 & DM6446
[PATCH 1/10 - v2] vpfe capture bridge driver fro DM355 and DM6446

[PATCH 1/10 - v2] vpfe-capture bridge driver fro DM355 & DM6446

From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>

VPFE Capture bridge driver

This is version, v2 of vpfe capture bridge driver for doing video
capture on DM355 and DM6446 evms. The ccdc hw modules register with the
driver and are used for configuring the CCD Controller for a specific
decoder interface. The driver also registers the sub devices required
for a specific evm. More than one sub devices can be registered.
This allows driver to switch dynamically to capture video from
any sub device that is registered. Currently only one sub device
(tvp5146) is supported. But in future this driver is expected
to do capture from sensor devices such as Micron's MT9T001,MT9T031
and MT9P031 etc. The driver currently supports MMAP based IO.

Following are the updates based on review comments:-
	1) minor number is allocated dynamically
	2) updates to QUERYCAP handling
	3) eliminated intermediate vpfe pixel format
	4) refactored few functions
	5) reworked isr routines for reducing indentation
	6) reworked vpfe_check_format and added a documentation
	   for algorithm
	7) fixed memory leak in probe()

TODO list :
	1) load sub device from bridge driver. Hans has enhanced
	the v4l2-subdevice framework to do this. Will be updated
	soon to pick this.
	
		
Reviewed By "Hans Verkuil".
Reviewed By "Laurent Pinchart".

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to v4l-dvb repository

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
Phone : 301-515-3736
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Karicheri, Muralidharan
>Sent: Tuesday, June 09, 2009 2:47 PM
>To: linux-media@vger.kernel.org
>Cc: davinci-linux-open-source@linux.davincidsp.com; Muralidharan Karicheri;
>Karicheri, Muralidharan
>Subject: [PATCH 0/10 - v2] ARM: DaVinci: Video: DM355/DM6446 VPFE Capture
>driver
>
>From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>
>
>VPFE Capture driver for DaVinci Media SOCs :- DM355 and DM6446
>
>This is the version v2 of the patch series. This is the reworked
>version of the driver based on comments received against the last
>version of the patch.
>
>+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>These patches add support for VPFE (Video Processing Front End) based
>video capture on DM355 and DM6446 EVMs. For more details on the hardware
>configuration and capabilities, please refer the vpfe_capture.c header.
>This patch set consists of following:-
>
>Patch 1: VPFE Capture bridge driver
>Patch 2: CCDC hw device header file
>Patch 3: DM355 CCDC hw module
>Patch 4: DM644x CCDC hw module
>Patch 5: common types used across CCDC modules
>Patch 6: Makefile and config files for the driver
>Patch 7: DM355 platform and board setup
>Patch 8: DM644x platform and board setup
>Patch 9: Remove outdated driver files from davinci git tree
>Patch 10: common vpss hw module for video drivers
>
>NOTE:
>
>Dependent on the TVP514x decoder driver patch for migrating the
>driver to sub device model from Vaibhav Hiremath
>
>Following tests are performed.
>	1) Capture and display video (PAL & NTSC) from tvp5146 decoder.
>	   Displayed using fbdev device driver available on davinci git tree
>	2) Tested with driver built statically and dynamically
>
>Muralidhara Karicheri
>
>Reviewed By "Hans Verkuil".
>Reviewed By "Laurent Pinchart".
>
>Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
