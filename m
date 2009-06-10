Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1531 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757837AbZFJV2S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 17:28:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: m-karicheri2@ti.com
Subject: Re: [PATCH 0/10 - v2] ARM: DaVinci: Video: DM355/DM6446 VPFE Capture driver
Date: Wed, 10 Jun 2009 23:28:16 +0200
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
References: <1244573204-20391-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1244573204-20391-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906102328.16328.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 09 June 2009 20:46:44 m-karicheri2@ti.com wrote:
> From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>
>
> VPFE Capture driver for DaVinci Media SOCs :- DM355 and DM6446
>
> This is the version v2 of the patch series. This is the reworked
> version of the driver based on comments received against the last
> version of the patch.

I'll be reviewing this Friday or Saturday.

Regards,

	Hans

>
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> These patches add support for VPFE (Video Processing Front End) based
> video capture on DM355 and DM6446 EVMs. For more details on the hardware
> configuration and capabilities, please refer the vpfe_capture.c header.
> This patch set consists of following:-
>
> Patch 1: VPFE Capture bridge driver
> Patch 2: CCDC hw device header file
> Patch 3: DM355 CCDC hw module
> Patch 4: DM644x CCDC hw module
> Patch 5: common types used across CCDC modules
> Patch 6: Makefile and config files for the driver
> Patch 7: DM355 platform and board setup
> Patch 8: DM644x platform and board setup
> Patch 9: Remove outdated driver files from davinci git tree
> Patch 10: common vpss hw module for video drivers
>
> NOTE:
>
> Dependent on the TVP514x decoder driver patch for migrating the
> driver to sub device model from Vaibhav Hiremath
>
> Following tests are performed.
> 	1) Capture and display video (PAL & NTSC) from tvp5146 decoder.
> 	   Displayed using fbdev device driver available on davinci git tree
> 	2) Tested with driver built statically and dynamically
>
> Muralidhara Karicheri
>
> Reviewed By "Hans Verkuil".
> Reviewed By "Laurent Pinchart".
>
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
