Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab1LGNoF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Dec 2011 08:44:05 -0500
Message-ID: <4EDF6DA0.5040406@redhat.com>
Date: Wed, 07 Dec 2011 11:44:00 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [GIT PATCHES FOR 3.3] v4l: introduce selection API
References: <4EC13CEA.4020705@samsung.com>
In-Reply-To: <4EC13CEA.4020705@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14-11-2011 14:08, Tomasz Stanislawski wrote:
> Hi Mauro,
>
> This is the second 'pull-requested' version of the selection API. The patch-set introduces new ioctls to V4L2 API for the configuration of the selection rectangles like crop and compose areas.

Tomasz,

A way better than the previous pull request. The only missing issue is related
to the scaling. As I told you on IRC, the scale for it should be decided
in advance, as a latter change would break binaries compiled with old Kernel
versions.

So, we need to decide if the scale for cropping will be pixels or sub-pixels,
or to add some flag that would allow userspace to decide between them.

PS.: As I've reviewed already the other patches, please add a new patch with the
incremental change for scaling, as this saves my time to review the patches that
are already ok.

Thanks,
Mauro

>
> Changelog:
>
> - changed naming of constraints flags to form V4L2_SEL_FLAG_*
> - changed naming of selection target to form V4L2_SEL_TGT_*
> - size of PNG files in the documentation is greatly reduced
> - fixes to handling of output queues for old cropping emulation
> - VIDIOC_{S/G}_SELECTION for s5p-mixer accepts single- and multiplane buffers as VIDIOC_{S/G}_CROP did
>
> Best regards,
> Tomasz Stanislawski
>
> The following changes since commit e9eb0dadba932940f721f9d27544a7818b2fa1c5:
>
> [media] V4L menu: add submenu for platform devices (2011-11-08 12:09:52 -0200)
>
> are available in the git repository at:
> git://git.infradead.org/users/kmpark/linux-samsung v4l-selection
>
> Tomasz Stanislawski (5):
> v4l: add support for selection api
> doc: v4l: add binary images for selection API
> doc: v4l: add documentation for selection API
> v4l: emulate old crop API using extended crop/compose API
> v4l: s5p-tv: mixer: add support for selection API
>
> Documentation/DocBook/media/constraints.png.b64 | 59 ++++
> Documentation/DocBook/media/selection.png.b64 | 206 ++++++++++++
> Documentation/DocBook/media/v4l/common.xml | 2 +
> Documentation/DocBook/media/v4l/compat.xml | 9 +
> Documentation/DocBook/media/v4l/selection-api.xml | 327 +++++++++++++++++++
> Documentation/DocBook/media/v4l/v4l2.xml | 1 +
> .../DocBook/media/v4l/vidioc-g-selection.xml | 304 +++++++++++++++++
> drivers/media/video/s5p-tv/mixer.h | 14 +-
> drivers/media/video/s5p-tv/mixer_grp_layer.c | 157 +++++++--
> drivers/media/video/s5p-tv/mixer_video.c | 342 +++++++++++++-------
> drivers/media/video/s5p-tv/mixer_vp_layer.c | 108 ++++---
> drivers/media/video/v4l2-compat-ioctl32.c | 2 +
> drivers/media/video/v4l2-ioctl.c | 116 +++++++-
> include/linux/videodev2.h | 46 +++
> include/media/v4l2-ioctl.h | 4 +
> 15 files changed, 1495 insertions(+), 202 deletions(-)
> create mode 100644 Documentation/DocBook/media/constraints.png.b64
> create mode 100644 Documentation/DocBook/media/selection.png.b64
> create mode 100644 Documentation/DocBook/media/v4l/selection-api.xml
> create mode 100644 Documentation/DocBook/media/v4l/vidioc-g-selection.xml
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

