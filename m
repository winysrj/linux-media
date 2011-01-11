Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1935 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab1AKRo3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jan 2011 12:44:29 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.38]
Date: Tue, 11 Jan 2011 18:44:19 +0100
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>
References: <201101110834.51032.hverkuil@xs4all.nl>
In-Reply-To: <201101110834.51032.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101111844.19866.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, January 11, 2011 08:34:48 Hans Verkuil wrote:
> Hi Mauro,
> 
> These patches remove s_config legacy support, replace it with new internal
> operations (also needed for the upcoming subdev device nodes) and finally
> rename has_new to is_new and document that control framework flag.
> 
> My original RFC also converted OLPC drivers, but those are scheduled for
> 2.6.39. It needs a bit more testing and I intend to improve the handling
> of autofoo/foo type of controls in the control framework.

Please forget this patch series: the last patch contained a bug. I knew I
was a bit too hasty when I posted this this morning.

I'll make a new pull request shortly.

Regards,

	Hans

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
>   ssh://linuxtv.org/git/hverkuil/media_tree.git s_config2
> 
> Hans Verkuil (3):
>       v4l2-subdev: remove core.s_config and v4l2_i2c_new_subdev_cfg()
>       v4l2-subdev: add (un)register internal ops
>       v4l2-ctrls: v4l2_ctrl_handler_setup must set is_new to 1
> 
>  Documentation/video4linux/v4l2-controls.txt |   12 ++++
>  drivers/media/video/cafe_ccic.c             |   11 +++-
>  drivers/media/video/cx25840/cx25840-core.c  |   22 ++------
>  drivers/media/video/em28xx/em28xx-cards.c   |   18 ++++---
>  drivers/media/video/ivtv/ivtv-i2c.c         |    9 +++-
>  drivers/media/video/mt9v011.c               |   54 ++++++++++++-------
>  drivers/media/video/mt9v011.h               |   36 -------------
>  drivers/media/video/ov7670.c                |   74 ++++++++++++---------------
>  drivers/media/video/sr030pc30.c             |   10 ----
>  drivers/media/video/v4l2-common.c           |   19 +------
>  drivers/media/video/v4l2-ctrls.c            |   20 ++++---
>  drivers/media/video/v4l2-device.c           |   14 ++++-
>  include/media/mt9v011.h                     |   17 ++++++
>  include/media/v4l2-common.h                 |   13 +----
>  include/media/v4l2-ctrls.h                  |    6 ++-
>  include/media/v4l2-subdev.h                 |   23 +++++++--
>  16 files changed, 174 insertions(+), 184 deletions(-)
>  delete mode 100644 drivers/media/video/mt9v011.h
>  create mode 100644 include/media/mt9v011.h
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
