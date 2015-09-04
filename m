Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:47774 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753108AbbIDLCL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Sep 2015 07:02:11 -0400
Message-ID: <55E979F4.2030100@xs4all.nl>
Date: Fri, 04 Sep 2015 13:01:08 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mike Isely <isely@pobox.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Steven Toth <stoth@kernellabs.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Vincent Palatin <vpalatin@chromium.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/10] Support getting default values from any control
References: <1440163169-18047-1-git-send-email-ricardo.ribalda@gmail.com>
In-Reply-To: <1440163169-18047-1-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series looks good. I'll drop the saa7164 patches since I made a
patch series converting it to the control framework. Once Steve gives me the
Ack for that I can merge that series.

All I need to merge your series (minus the saa7164 patches) is the Ack from
Laurent for the uvc patch.

Regards,

	Hans

On 08/21/2015 03:19 PM, Ricardo Ribalda Delgado wrote:
> Integer controls provide a way to get their default/initial value, but
> any other control (p_u32, p_u8.....) provide no other way to get the
> initial value than unloading the module and loading it back.
> 
> *What is the actual problem?
> I have a custom control with WIDTH integer values. Every value
> represents the calibrated FPN (fixed pattern noise) correction value for that
> column
> -Application A changes the FPN correction value
> -Application B wants to restore the calibrated value but it cant :(
> 
> *What is the proposed solution?
> 
> (Kudos to Hans Verkuil!!!)
> 
> The key change is in struct v4l2_ext_controls where the __u32 ctrl_class field
> is changed to:
> 
>         union {
>                 __u32 ctrl_class;
>                 __u32 which;
>         };
> 
> And two new defines are added:
> 
> #define V4L2_CTRL_WHICH_CUR_VAL        0
> #define V4L2_CTRL_WHICH_DEF_VAL        0x0f000000
> 
> The 'which' field tells you which controls are get/set/tried.
> 
> V4L2_CTRL_WHICH_CUR_VAL: the current value of the controls
> V4L2_CTRL_WHICH_DEF_VAL: the default value of the controls
> V4L2_CTRL_CLASS_*: the current value of the controls belonging to the specified class.
>         Note: this is deprecated usage and is only there for backwards compatibility.
>         Which is also why I don't think there is a need to add V4L2_CTRL_WHICH_
>         aliases for these defines.
> 
> 
> I have posted a copy of my working tree to
> 
> https://github.com/ribalda/linux/tree/which_def_v2
> 
> Changelog v2:
> 
> Suggested by Hans Verkuil <hverkuil@xs4all.nl>
> 
> Replace ctrls_class with which on all the codebase
> Changes in Documentation
> (Thanks!)
> 
> Ricardo Ribalda Delgado (10):
>   videodev2.h: Fix typo in comment
>   videodev2.h: Extend struct v4l2_ext_controls
>   media/v4l2-compat-ioctl32: Simple stylechecks
>   media/core: Replace ctrl_class with which
>   media/v4l2-core: struct struct v4l2_ext_controls param which
>   usb/uvc: Support for V4L2_CTRL_WHICH_DEF_VAL
>   media/usb/pvrusb2: Support for V4L2_CTRL_WHICH_DEF_VAL
>   media/pci/saa7164-encoder Support for V4L2_CTRL_WHICH_DEF_VAL
>   media/pci/saa7164-vbi Support for V4L2_CTRL_WHICH_DEF_VAL
>   Docbook: media: Document changes on struct v4l2_ext_controls
> 
>  Documentation/DocBook/media/v4l/v4l2.xml           |  9 ++++
>  .../DocBook/media/v4l/vidioc-g-ext-ctrls.xml       | 28 ++++++++--
>  drivers/media/pci/saa7164/saa7164-encoder.c        | 59 ++++++++++++---------
>  drivers/media/pci/saa7164/saa7164-vbi.c            | 61 +++++++++++++---------
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |  2 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |  2 +-
>  drivers/media/usb/pvrusb2/pvrusb2-v4l2.c           | 17 +++++-
>  drivers/media/usb/uvc/uvc_v4l2.c                   | 14 ++++-
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c      | 17 +++---
>  drivers/media/v4l2-core/v4l2-ctrls.c               | 54 +++++++++++++------
>  drivers/media/v4l2-core/v4l2-ioctl.c               | 14 ++---
>  include/uapi/linux/videodev2.h                     | 14 ++++-
>  12 files changed, 200 insertions(+), 91 deletions(-)
> 

