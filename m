Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58338 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbbHRUIh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 16:08:37 -0400
Date: Tue, 18 Aug 2015 17:08:31 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH RFC v5 0/8] MC preparation patches
Message-ID: <20150818170831.26a63807@recife.lan>
In-Reply-To: <cover.1439927113.git.mchehab@osg.samsung.com>
References: <cover.1439927113.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 18 Aug 2015 17:04:13 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

Hmm... I forgot to remove the "RFC" prefix. For me, this patch series is
OK to be merged at the media-controller topic branch.


> Those are the initial patches from my RFCv3 series of MC changes,
> plus one additional renaming patch and two debug ones. They address
> the comments received on PATCH v4 series.
> 
> The first 5 patches on this series ensures that all existing object
> types (entities, pads and links) will have an unique ID, as agreed
> at the MC workshop.
> 
> The next two patches add two debug functions, that helps with the
> tests of the MC changes. Both are enabled only if DEBUG or dynamic
> debug is enabled.
> 
> The first one just help to identify when the media_device register,
> remove and unregister functions are called. It helps to identify if
> those events happen before or after object creation.
> 
> The second one is more interesting: it hooks at the object init and
> remove functions and dump what's there at the new object when it
> got created. This is very useful to test the future patches, as we'll
> be able to track any topology changes.
> 
> Also, it demonstates the capability of the functions
> media_gobj_init() and media_gobj_remove() to track topology
> changes. Tracking topology changes is fundamental for the new API,
> in order to implement G_TOPOLOGY ioctl. They should contain, in
> the future, a callback to warn the several drivers envolved at the
> MC topology build about topology changes.
> 
> The last patch on this preparation series is just a renaming patch,
> that will avoid mess when future patches introduce the
> entity->interface links.
> 
> They're tested using the cx231xx V4L2 support.
> 
> Those are the new debug messages when the device is probed:
> 
> [ 2684.265619] cx231xx 3-2.4:1.1: Media device registered
> [ 2684.357670] cx231xx 3-2.4:1.1: media_gobj_init: id 0x00000001 entity#1 'cx25840 19-0044'
> [ 2684.359191] cx231xx 3-2.4:1.1: media_gobj_init: id 0x01000001 cx25840 19-0044 pad#1
> [ 2684.360693] cx231xx 3-2.4:1.1: media_gobj_init: id 0x01000002 cx25840 19-0044 pad#2
> [ 2684.362208] cx231xx 3-2.4:1.1: media_gobj_init: id 0x01000003 cx25840 19-0044 pad#3
> 
> [ 2686.437870] cx231xx 3-2.4:1.1: media_gobj_init: id 0x00000002 entity#2 '(tuner unset)'
> [ 2686.439474] cx231xx 3-2.4:1.1: media_gobj_init: id 0x01000004 (tuner unset) pad#4
> 
> [ 2688.450710] cx231xx 3-2.4:1.1: media_gobj_init: id 0x00000003 entity#3 'cx231xx #0 video'
> [ 2688.452395] cx231xx 3-2.4:1.1: media_gobj_init: id 0x01000005 cx231xx #0 video pad#5
> 
> [ 2688.455892] cx231xx 3-2.4:1.1: media_gobj_init: id 0x00000004 entity#4 'cx231xx #0 vbi'
> [ 2688.457632] cx231xx 3-2.4:1.1: media_gobj_init: id 0x01000006 cx231xx #0 vbi pad#6
> 
> [ 2688.500233] cx231xx 3-2.4:1.1: media_gobj_init: id 0x02000001 link#1: 'NXP TDA18271HD' pad#4 ==> 'cx25840 19-0044' pad#1
> [ 2688.501830] cx231xx 3-2.4:1.1: media_gobj_init: id 0x02000002 link#2: 'NXP TDA18271HD' pad#4 ==> 'cx25840 19-0044' pad#1
> [ 2688.503415] cx231xx 3-2.4:1.1: media_gobj_init: id 0x02000003 link#3: 'cx25840 19-0044' pad#2 ==> 'cx231xx #0 video' pad#5
> [ 2688.504977] cx231xx 3-2.4:1.1: media_gobj_init: id 0x02000004 link#4: 'cx25840 19-0044' pad#2 ==> 'cx231xx #0 video' pad#5
> [ 2688.506505] cx231xx 3-2.4:1.1: media_gobj_init: id 0x02000005 link#5: 'cx25840 19-0044' pad#3 ==> 'cx231xx #0 vbi' pad#6
> [ 2688.508074] cx231xx 3-2.4:1.1: media_gobj_init: id 0x02000006 link#6: 'cx25840 19-0044' pad#3 ==> 'cx231xx #0 vbi' pad#6
> 
> Those are the new debug messages when the device is removed:
> 
> [ 2953.872780] cx231xx 3-2.4:1.1: media_gobj_remove: id 0x02000002 link#2: 'NXP TDA18271HD' pad#4 ==> 'cx25840 19-0044' pad#1
> [ 2953.874470] cx231xx 3-2.4:1.1: media_gobj_remove: id 0x02000003 link#3: 'cx25840 19-0044' pad#2 ==> 'cx231xx #0 video' pad#5
> [ 2953.876199] cx231xx 3-2.4:1.1: media_gobj_remove: id 0x02000005 link#5: 'cx25840 19-0044' pad#3 ==> 'cx231xx #0 vbi' pad#6
> [ 2953.877830] cx231xx 3-2.4:1.1: media_gobj_remove: id 0x01000001 cx25840 19-0044 pad#1
> [ 2953.879454] cx231xx 3-2.4:1.1: media_gobj_remove: id 0x01000002 cx25840 19-0044 pad#2
> [ 2953.881020] cx231xx 3-2.4:1.1: media_gobj_remove: id 0x01000003 cx25840 19-0044 pad#3
> [ 2953.882569] cx231xx 3-2.4:1.1: media_gobj_remove: id 0x00000001 entity#1 'cx25840 19-0044'
> 
> [ 2953.884093] cx231xx 3-2.4:1.1: media_gobj_remove: id 0x02000001 link#1: 'NXP TDA18271HD' pad#4 ==> 'cx25840 19-0044' pad#1
> [ 2953.885611] cx231xx 3-2.4:1.1: media_gobj_remove: id 0x01000004 NXP TDA18271HD pad#4
> [ 2953.887200] cx231xx 3-2.4:1.1: media_gobj_remove: id 0x00000002 entity#2 'NXP TDA18271HD'
> 
> [ 2953.888638] cx231xx 3-2.4:1.1: media_gobj_remove: id 0x02000004 link#4: 'cx25840 19-0044' pad#2 ==> 'cx231xx #0 video' pad#5
> [ 2953.890093] cx231xx 3-2.4:1.1: media_gobj_remove: id 0x01000005 cx231xx #0 video pad#5
> [ 2953.891549] cx231xx 3-2.4:1.1: media_gobj_remove: id 0x00000003 entity#3 'cx231xx #0 video'
> 
> [ 2953.893006] cx231xx 3-2.4:1.1: media_gobj_remove: id 0x02000006 link#6: 'cx25840 19-0044' pad#3 ==> 'cx231xx #0 vbi' pad#6
> [ 2953.894471] cx231xx 3-2.4:1.1: media_gobj_remove: id 0x01000006 cx231xx #0 vbi pad#6
> [ 2953.895955] cx231xx 3-2.4:1.1: media_gobj_remove: id 0x00000004 entity#4 'cx231xx #0 vbi'
> [ 2953.897505] cx231xx 3-2.4:1.1: Media device released
> [ 2953.898924] cx231xx 3-2.4:1.1: Media device unregistered
> 
> It should be noticed that both links and backlinks are reported
> on the above. That's because now they're implemented as two separate
> links right now.
> 
> Mauro Carvalho Chehab (8):
>   [media] media: create a macro to get entity ID
>   [media] media: add a common struct to be embed on media graph objects
>   [media] media: use media_gobj inside entities
>   [media] media: use media_gobj inside pads
>   [media] media: use media_gobj inside links
>   [media] media: add messages when media device gets (un)registered
>   [media] media: add a debug message to warn about gobj creation/removal
>   [media] media: rename the function that create pad links
> 
>  Documentation/media-framework.txt                  |   2 +-
>  drivers/media/dvb-core/dvbdev.c                    |   8 +-
>  drivers/media/i2c/s5c73m3/s5c73m3-core.c           |   4 +-
>  drivers/media/i2c/s5k5baf.c                        |   2 +-
>  drivers/media/i2c/smiapp/smiapp-core.c             |   4 +-
>  drivers/media/media-device.c                       |  41 +++++--
>  drivers/media/media-entity.c                       | 123 ++++++++++++++++++++-
>  drivers/media/platform/exynos4-is/media-dev.c      |  16 +--
>  drivers/media/platform/omap3isp/isp.c              |  18 +--
>  drivers/media/platform/omap3isp/ispccdc.c          |   2 +-
>  drivers/media/platform/omap3isp/ispccp2.c          |   2 +-
>  drivers/media/platform/omap3isp/ispcsi2.c          |   2 +-
>  drivers/media/platform/omap3isp/isppreview.c       |   4 +-
>  drivers/media/platform/omap3isp/ispresizer.c       |   4 +-
>  drivers/media/platform/s3c-camif/camif-core.c      |   4 +-
>  drivers/media/platform/vsp1/vsp1_drv.c             |   4 +-
>  drivers/media/platform/vsp1/vsp1_rpf.c             |   2 +-
>  drivers/media/platform/vsp1/vsp1_video.c           |   4 +-
>  drivers/media/platform/vsp1/vsp1_wpf.c             |   2 +-
>  drivers/media/platform/xilinx/xilinx-vipp.c        |   4 +-
>  drivers/media/usb/cx231xx/cx231xx-cards.c          |   6 +-
>  drivers/media/usb/uvc/uvc_entity.c                 |   2 +-
>  drivers/staging/media/davinci_vpfe/dm365_ipipeif.c |   2 +-
>  drivers/staging/media/davinci_vpfe/dm365_isif.c    |   2 +-
>  drivers/staging/media/davinci_vpfe/dm365_resizer.c |   8 +-
>  .../staging/media/davinci_vpfe/vpfe_mc_capture.c   |  10 +-
>  drivers/staging/media/omap4iss/iss.c               |  12 +-
>  drivers/staging/media/omap4iss/iss_csi2.c          |   2 +-
>  drivers/staging/media/omap4iss/iss_ipipeif.c       |   2 +-
>  drivers/staging/media/omap4iss/iss_resizer.c       |   2 +-
>  include/media/media-device.h                       |   7 +-
>  include/media/media-entity.h                       |  82 +++++++++++++-
>  32 files changed, 302 insertions(+), 87 deletions(-)
> 
