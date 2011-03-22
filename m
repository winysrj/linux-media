Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50595 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab1CVJRr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 05:17:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES FOR 2.6.39] Make the UVC API public (and bug fixes)
Date: Tue, 22 Mar 2011 10:17:54 +0100
Cc: linux-media@vger.kernel.org,
	Martin Rubli <martin_rubli@logitech.com>
References: <201102271836.01888.laurent.pinchart@ideasonboard.com> <4D87A965.3000506@redhat.com>
In-Reply-To: <4D87A965.3000506@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103221017.55219.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

Thanks for the review.

On Monday 21 March 2011 20:39:17 Mauro Carvalho Chehab wrote:
> Em 27-02-2011 14:36, Laurent Pinchart escreveu:
> > Hi Mauro,
> > 
> > These patches move the uvcvideo.h header file from
> > drivers/media/video/uvc to include/linux, making the UVC API public.
> > 
> > Martin Rubli has committed support for the public API to libwebcam, so
> > userspace support is up to date.
> > 
> > The following changes since commit 
9e650fdb12171a5a5839152863eaab9426984317:
> >   [media] drivers:media:radio: Update Kconfig and Makefile for wl128x FM
> >   driver (2011-02-27 07:50:42 -0300)
> > 
> > are available in the git repository at:
> >   git://linuxtv.org/pinchartl/uvcvideo.git uvcvideo-next
> > 
> > Laurent Pinchart (6):
> >       uvcvideo: Deprecate UVCIOC_CTRL_{ADD,MAP_OLD,GET,SET}
> 
> There are some places there saying that the removal will happen at 2.6.39.

I'll fix that.

> >       uvcvideo: Rename UVC_CONTROL_* flags to UVC_CTRL_FLAG_*
> >       uvcvideo: Include linux/types.h in uvcvideo.h
> >       uvcvideo: Move uvcvideo.h to include/linux
> 
> -'U'    00-0F   drivers/media/video/uvc/uvcvideo.h      conflict!
> +'U'    00-0F   linux/uvcvideo.h        conflict!
> 
> Please avoid conflicts at userspace API's.

The uvcvideo driver already uses 'U'. I can change it, but it will break the 
ABI.

> >       uvcvideo: Fix descriptor parsing for video output devices
> 
> This one seems independent from API changes. Applying it.
> 
> >       v4l: videobuf2: Typo fix

What about this one ?

> > Martin Rubli (2):
> >       uvcvideo: Add UVCIOC_CTRL_QUERY ioctl
> >       uvcvideo: Add driver documentation
> 
> Please, don't use "enum" at the public API:
> 
> +       __u32   id              V4L2 control identifier
> +       __u8    name[32]        V4L2 control name
> +       __u8    entity[16]      UVC extension unit GUID
> +       __u8    selector        UVC control selector
> +       __u8    size            V4L2 control size (in bits)
> +       __u8    offset          V4L2 control offset (in bits)
> +       enum v4l2_ctrl_type
> +               v4l2_type       V4L2 control type
> +       enum uvc_control_data_type
> +               data_type       UVC control data type
> +       struct uvc_menu_info
> +               *menu_info      Array of menu entries (for menu controls
> only) +       __u32   menu_count      Number of menu entries (for menu
> controls only) +
> +       * struct uvc_menu_info
> +
> +       __u32   value           Menu entry value used by the device
> +       __u8    name[32]        Menu entry name
> 
> 
> enum size is not portable. (OK, I know that V4L2 API has some enum's, but
> let's not add new stuff using it). Also, please be sure that the new API
> won't require any compat32 bits.

OK I'll fix that.

> > Stephan Lachowsky (1):
> >       uvcvideo: Fix uvc_fixup_video_ctrl() format search
> 
> This one seems independent from API changes. Applying it.

-- 
Regards,

Laurent Pinchart
