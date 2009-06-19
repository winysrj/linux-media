Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f202.google.com ([209.85.216.202]:44423 "EHLO
	mail-px0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbZFSVMh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 17:12:37 -0400
Received: by pxi40 with SMTP id 40so195542pxi.33
        for <linux-media@vger.kernel.org>; Fri, 19 Jun 2009 14:12:40 -0700 (PDT)
To: m-karicheri2@ti.com
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
Subject: Re: [PATCH 0/11 - v3] ARM: DaVinci: Video: DM355/DM6446 VPFE Capture driver
References: <1245269484-8325-1-git-send-email-m-karicheri2@ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Fri, 19 Jun 2009 13:49:07 -0700
In-Reply-To: <1245269484-8325-1-git-send-email-m-karicheri2@ti.com> (m-karicheri2@ti.com's message of "Wed\, 17 Jun 2009 16\:11\:13 -0400")
Message-ID: <87ljnot0e4.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

m-karicheri2@ti.com writes:

> From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>
>
> Big Thanks to all reviewers who have contributed to this driver
> by reviewing and offering valuable comments.
>
> VPFE Capture driver for DaVinci Media SOCs :- DM355 and DM6446
>
> This is the version v3 of the patch series. This is the reworked
> version of the driver based on comments received against the last
> version (v2) of the patch and is expected to be final version
> candidate for merge to upstream kernel

FYI...

I've updated the staging/vpfe branch of davinci git with this series
and the tvp514x v3 patch.

Also, I'll be pushing the arch/arm/* patches of this series to DaVinci
git master and queueing them for upstream merge.

Kevin

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
> Patch 5: ccdc types used across CCDC modules
> Patch 6: Makefile and config files for the driver
> Patch 7: DM355 platform and board setup
> Patch 8: DM644x platform and board setup
> Patch 9: common vpss hw module for video drivers
> Patch 10: Remove outdated driver files from davinci git tree
> Patch 11: Makefile and config files for the davinci git tree (New
> from v2)
>
> NOTE:
>
> 1. Patches 10-11 are only for DaVinci GIT tree. Others applies to
> DaVinci GIT and v4l-dvb
>
> 2. Dependent on the TVP514x decoder driver patch for migrating the
> driver to sub device model from Vaibhav Hiremath. I am sending the
> reworked version of this patch instead of Vaibhav.

> Following tests are performed.
> 	1) Capture and display video (PAL & NTSC) from tvp5146 decoder.
> 	   Displayed using fbdev device driver available on davinci git tree
> 	2) Tested with driver built statically and dynamically
>
> Muralidhara Karicheri
>
> Reviewed by: Hans Verkuil <hverkuil@xs4all.nl>
> Reviewed by: Laurent Pinchart <laurent.pinchart@skynet.be>
> Reviewed by: Alexey Klimov <klimov.linux@gmail.com>
> Reviewed by: Kevin Hilman <khilman@deeprootsystems.com>
> Reviewed by: David Brownell <david-b@pacbell.net>
>
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
