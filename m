Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1342 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab1BXJug (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 04:50:36 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.38] Implement core priority handling
Date: Thu, 24 Feb 2011 10:50:27 +0100
Cc: Andy Walls <awalls@md.metrocast.net>
References: <201101110921.36394.hverkuil@xs4all.nl>
In-Reply-To: <201101110921.36394.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102241050.27236.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This pull request is cancelled. I'm respinning this for 2.6.39.

Regards,

	Hans

On Tuesday, January 11, 2011 09:21:36 Hans Verkuil wrote:
> This implements core support for priority handling. This is basically the same
> as my RFCv3 patch series, except without some of the driver changes (I want to
> do that for 2.6.39) and with the single fix to patch 05/16 I posted to the list.
> 
> Currently the only drivers this affects are ivtv (which is the only user of
> v4l2_fh at the moment) and vivi.
> 
> I will probably also adapt cx18 this weekend since as it stands now it is possible
> for a lower prio process to change controls for a higher prio process. To fix
> this requires core prio handling anyway, so let's get this in for 2.6.38 so
> people can start using it.
> 
> Regards,
> 
> 	Hans
> 
> The following changes since commit 04c3fafd933379fbc8b1fa55ea9b65281af416f7:
>   Hans Verkuil (1):
>         [media] vivi: convert to the control framework and add test controls
> 
> are available in the git repository at:
> 
>   ssh://linuxtv.org/git/hverkuil/media_tree.git prio2
> 
> Hans Verkuil (9):
>       v4l2_prio: move from v4l2-common to v4l2-dev.
>       v4l2: add v4l2_prio_state to v4l2_device and video_device
>       v4l2-fh: implement v4l2_priority support.
>       v4l2-fh: add v4l2_fh_open and v4l2_fh_release helper functions
>       v4l2-ioctl: add priority handling support.
>       v4l2-fh: add v4l2_fh_is_singular
>       ivtv: convert to core priority handling.
>       v4l2-framework.txt: improve v4l2_fh/priority documentation
>       vivi: add priority support
> 
>  Documentation/video4linux/v4l2-framework.txt |  120 +++++++++++++++++++-------
>  drivers/media/radio/radio-si4713.c           |    3 +-
>  drivers/media/video/cx18/cx18-ioctl.c        |    3 +-
>  drivers/media/video/davinci/vpfe_capture.c   |    2 +-
>  drivers/media/video/ivtv/ivtv-driver.h       |    2 -
>  drivers/media/video/ivtv/ivtv-fileops.c      |    2 -
>  drivers/media/video/ivtv/ivtv-ioctl.c        |   59 ++++---------
>  drivers/media/video/meye.c                   |    3 +-
>  drivers/media/video/mxb.c                    |    3 +-
>  drivers/media/video/v4l2-common.c            |   63 --------------
>  drivers/media/video/v4l2-dev.c               |   70 +++++++++++++++
>  drivers/media/video/v4l2-device.c            |    1 +
>  drivers/media/video/v4l2-fh.c                |   46 ++++++++++
>  drivers/media/video/v4l2-ioctl.c             |   64 ++++++++++++--
>  drivers/media/video/vivi.c                   |   13 ++-
>  include/media/v4l2-common.h                  |   15 ---
>  include/media/v4l2-dev.h                     |   18 ++++
>  include/media/v4l2-device.h                  |    3 +
>  include/media/v4l2-fh.h                      |   29 ++++++
>  include/media/v4l2-ioctl.h                   |    2 +-
>  20 files changed, 346 insertions(+), 175 deletions(-)
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
