Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:56203 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab1ISFJT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Sep 2011 01:09:19 -0400
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Date: Mon, 19 Sep 2011 10:39:04 +0530
Subject: RE: [PATCH v2 0/8] RFC for Media Controller capture driver for DM365
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB593025729ADE2@dbde02.ent.ti.com>
References: <1314630439-1122-1-git-send-email-manjunath.hadli@ti.com>
 <4E7601C2.9030900@redhat.com>
In-Reply-To: <4E7601C2.9030900@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,
  Thank you for your note.
  The first RFC for this (VPFE MC) driver was sent only in August this year. The other driver being discussed before was VPBE (which did go through some grind but not 2 years) which you accepted. This series of patches is definitely not two years old (unless I am mistaken somewhere).
 Currently Sakari is taking active interest in reviewing the patches, but I would like to take the cue from your note to request others also to actively review these patches and help me get them accepted.

Thanks and Regards,
-Manju


On Sun, Sep 18, 2011 at 20:05:46, Mauro Carvalho Chehab wrote:
> Em 29-08-2011 12:07, Manjunath Hadli escreveu:
> > changes from last patch set:
> > 1. Made changes based on Sakari's feedback mainly:
> >         a. returned early to allow unindenting
> >         b. reformatting to shift the code to left where possible
> >         c. changed hex numbers to lower case
> >         d. corrected the defines according to module names.
> >         e. magic numbers removed.
> >         f. changed non-integer returning functions to void
> >         g. removed unwanted paranthses.
> >         h. fixed error codes.
> >         i. fixed some RESET_BIt code to what it was intended for.
> > 2. reorganized the header files to move the kernel-only headers along 
> > with the c files and interface headers in the include folder.
> 
> Manju,
> 
> Please be sure to send me a pull request when you think this driver is ready for merge. The first submission I'm noticing for this driver was back on 2009, and still today, nobody sent me a git pull request for it. Two years seems too much time to solve the pending issues and sending a pull request for me to merge it!
> > 
> > Manjunath Hadli (6):
> >   davinci: vpfe: add dm3xx IPIPEIF hardware support module
> >   davinci: vpfe: add support for CCDC hardware for dm365
> >   davinci: vpfe: add ccdc driver with media controller interface
> >   davinci: vpfe: add v4l2 video driver support
> >   davinci: vpfe: v4l2 capture driver with media interface
> >   davinci: vpfe: build infrastructure for dm365
> > 
> > Nagabhushana Netagunte (2):
> >   davinci: vpfe: add IPIPE hardware layer support
> >   davinci: vpfe: add IPIPE support for media controller driver
> > 
> >  drivers/media/video/davinci/Kconfig           |   46 +-
> >  drivers/media/video/davinci/Makefile          |   17 +-
> >  drivers/media/video/davinci/ccdc_hw_device.h  |   10 +-
> >  drivers/media/video/davinci/ccdc_types.h      |   43 +
> >  drivers/media/video/davinci/dm365_ccdc.c      | 1519 ++++++++++
> >  drivers/media/video/davinci/dm365_ccdc.h      |   88 +
> >  drivers/media/video/davinci/dm365_ccdc_regs.h |  309 ++  
> > drivers/media/video/davinci/dm365_def_para.c  |  486 +++
> >  drivers/media/video/davinci/dm365_def_para.h  |   39 +
> >  drivers/media/video/davinci/dm365_ipipe.c     | 3966 +++++++++++++++++++++++++
> >  drivers/media/video/davinci/dm365_ipipe.h     |  300 ++
> >  drivers/media/video/davinci/dm365_ipipe_hw.c  |  949 ++++++  
> > drivers/media/video/davinci/dm365_ipipe_hw.h  |  539 ++++
> >  drivers/media/video/davinci/dm3xx_ipipeif.c   |  317 ++
> >  drivers/media/video/davinci/dm3xx_ipipeif.h   |  258 ++
> >  drivers/media/video/davinci/imp_common.h      |   85 +
> >  drivers/media/video/davinci/imp_hw_if.h       |  178 ++
> >  drivers/media/video/davinci/vpfe_capture.c    |  793 +++++
> >  drivers/media/video/davinci/vpfe_capture.h    |  104 +
> >  drivers/media/video/davinci/vpfe_ccdc.c       |  813 +++++
> >  drivers/media/video/davinci/vpfe_ccdc.h       |   85 +
> >  drivers/media/video/davinci/vpfe_video.c      | 1712 +++++++++++
> >  drivers/media/video/davinci/vpfe_video.h      |  142 +
> >  include/linux/davinci_vpfe.h                  | 1223 ++++++++
> >  include/linux/dm365_ccdc.h                    |  664 +++++
> >  include/linux/dm3xx_ipipeif.h                 |   64 +
> >  include/media/davinci/vpfe.h                  |   91 +
> >  27 files changed, 14829 insertions(+), 11 deletions(-)  create mode 
> > 100644 drivers/media/video/davinci/ccdc_types.h
> >  create mode 100644 drivers/media/video/davinci/dm365_ccdc.c
> >  create mode 100644 drivers/media/video/davinci/dm365_ccdc.h
> >  create mode 100644 drivers/media/video/davinci/dm365_ccdc_regs.h
> >  create mode 100644 drivers/media/video/davinci/dm365_def_para.c
> >  create mode 100644 drivers/media/video/davinci/dm365_def_para.h
> >  create mode 100644 drivers/media/video/davinci/dm365_ipipe.c
> >  create mode 100644 drivers/media/video/davinci/dm365_ipipe.h
> >  create mode 100644 drivers/media/video/davinci/dm365_ipipe_hw.c
> >  create mode 100644 drivers/media/video/davinci/dm365_ipipe_hw.h
> >  create mode 100644 drivers/media/video/davinci/dm3xx_ipipeif.c
> >  create mode 100644 drivers/media/video/davinci/dm3xx_ipipeif.h
> >  create mode 100644 drivers/media/video/davinci/imp_common.h
> >  create mode 100644 drivers/media/video/davinci/imp_hw_if.h
> >  create mode 100644 drivers/media/video/davinci/vpfe_capture.c
> >  create mode 100644 drivers/media/video/davinci/vpfe_capture.h
> >  create mode 100644 drivers/media/video/davinci/vpfe_ccdc.c
> >  create mode 100644 drivers/media/video/davinci/vpfe_ccdc.h
> >  create mode 100644 drivers/media/video/davinci/vpfe_video.c
> >  create mode 100644 drivers/media/video/davinci/vpfe_video.h
> >  create mode 100644 include/linux/davinci_vpfe.h  create mode 100644 
> > include/linux/dm365_ccdc.h  create mode 100644 
> > include/linux/dm3xx_ipipeif.h  create mode 100644 
> > include/media/davinci/vpfe.h
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" 
> > in the body of a message to majordomo@vger.kernel.org More majordomo 
> > info at  http://vger.kernel.org/majordomo-info.html
> 
> 

