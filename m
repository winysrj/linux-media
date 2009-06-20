Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1989 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbZFTHBU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jun 2009 03:01:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH 0/11 - v3] ARM: DaVinci: Video: DM355/DM6446 VPFE Capture driver
Date: Sat, 20 Jun 2009 09:01:13 +0200
Cc: Kevin Hilman <khilman@deeprootsystems.com>, m-karicheri2@ti.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>,
	linux-media@vger.kernel.org
References: <1245269484-8325-1-git-send-email-m-karicheri2@ti.com> <87ljnot0e4.fsf@deeprootsystems.com>
In-Reply-To: <87ljnot0e4.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906200901.14067.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 19 June 2009 22:49:07 Kevin Hilman wrote:
> m-karicheri2@ti.com writes:
> > From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>
> >
> > Big Thanks to all reviewers who have contributed to this driver
> > by reviewing and offering valuable comments.
> >
> > VPFE Capture driver for DaVinci Media SOCs :- DM355 and DM6446
> >
> > This is the version v3 of the patch series. This is the reworked
> > version of the driver based on comments received against the last
> > version (v2) of the patch and is expected to be final version
> > candidate for merge to upstream kernel
>
> FYI...
>
> I've updated the staging/vpfe branch of davinci git with this series
> and the tvp514x v3 patch.
>
> Also, I'll be pushing the arch/arm/* patches of this series to DaVinci
> git master and queueing them for upstream merge.

Hi Kevin,

It's better to leave that to Mauro (the v4l-dvb maintainer): that will 
ensure that the v4l driver changes and the arch/arm changes go into the 
mainline in the correct order. If you prefer to do this yourself, then you 
should contact Mauro first.

Also note that my pull request for this driver contains one additional patch 
fixing some missing newlines and a wrong error code.

Here is the link to that diff in my repository:

http://linuxtv.org/hg/%7Ehverkuil/v4l-dvb-vpfe-cap/raw-diff/ae2ca5c20d85/linux/drivers/media/video/davinci/vpfe_capture.c

Regards,

	Hans

> Kevin
>
> > +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > These patches add support for VPFE (Video Processing Front End) based
> > video capture on DM355 and DM6446 EVMs. For more details on the
> > hardware configuration and capabilities, please refer the
> > vpfe_capture.c header. This patch set consists of following:-
> >
> > Patch 1: VPFE Capture bridge driver
> > Patch 2: CCDC hw device header file
> > Patch 3: DM355 CCDC hw module
> > Patch 4: DM644x CCDC hw module
> > Patch 5: ccdc types used across CCDC modules
> > Patch 6: Makefile and config files for the driver
> > Patch 7: DM355 platform and board setup
> > Patch 8: DM644x platform and board setup
> > Patch 9: common vpss hw module for video drivers
> > Patch 10: Remove outdated driver files from davinci git tree
> > Patch 11: Makefile and config files for the davinci git tree (New
> > from v2)
> >
> > NOTE:
> >
> > 1. Patches 10-11 are only for DaVinci GIT tree. Others applies to
> > DaVinci GIT and v4l-dvb
> >
> > 2. Dependent on the TVP514x decoder driver patch for migrating the
> > driver to sub device model from Vaibhav Hiremath. I am sending the
> > reworked version of this patch instead of Vaibhav.
> >
> > Following tests are performed.
> > 	1) Capture and display video (PAL & NTSC) from tvp5146 decoder.
> > 	   Displayed using fbdev device driver available on davinci git tree
> > 	2) Tested with driver built statically and dynamically
> >
> > Muralidhara Karicheri
> >
> > Reviewed by: Hans Verkuil <hverkuil@xs4all.nl>
> > Reviewed by: Laurent Pinchart <laurent.pinchart@skynet.be>
> > Reviewed by: Alexey Klimov <klimov.linux@gmail.com>
> > Reviewed by: Kevin Hilman <khilman@deeprootsystems.com>
> > Reviewed by: David Brownell <david-b@pacbell.net>
> >
> > Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> > _______________________________________________
> > Davinci-linux-open-source mailing list
> > Davinci-linux-open-source@linux.davincidsp.com
> > http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
>
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
