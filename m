Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:55672 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157AbaA1RSo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jan 2014 12:18:44 -0500
Received: by mail-oa0-f45.google.com with SMTP id i11so744237oag.18
        for <linux-media@vger.kernel.org>; Tue, 28 Jan 2014 09:18:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390833264-8503-1-git-send-email-hverkuil@xs4all.nl>
References: <1390833264-8503-1-git-send-email-hverkuil@xs4all.nl>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Tue, 28 Jan 2014 18:18:23 +0100
Message-ID: <CAPybu_2TbWi6Vpo=hY2A=u3rfkUYazWf3za2CvwHaqZqu_wHuQ@mail.gmail.com>
Subject: Re: [RFCv3 PATCH 00/22] Add support for complex controls
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans

Congratulations for the set, I think it is a step in the right direction.

I have some questions. I hope I havent entered the discussion too late.

1) One problem that I am facing now is how to give userland a list of
"dead pixels". Could we also add a v4l2_prop_type_matrix_pixel? I
believe it could be useful for more people. Or do we have another
standard way to do it now?


2)  Assuming selection is a property. id will tell if we are setting
CAPTURE_CROP, CAPTURE_COMPOSE, OUTPUT_CROP or OUTPUT_COMPOSE and type
will tell if it is an array or a single element?

something like:
type=V4L2_PROP_TYPE_MATRIX | V4L2_PROP_TYPE_SELECTION ?
type= V4L2_PROP_TYPE_SELECTION ;

On the patchset there is nothing about selections. Or I am missing something?



Thanks!

On Mon, Jan 27, 2014 at 3:34 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> This patch series adds support for complex controls (aka 'Properties') to
> the control framework. It is the first part of a larger patch series that
> adds support for configuration stores, motion detection matrix controls and
> support for 'Multiple Selections'.
>
> This patch series is based on this RFC:
>
> http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/71822
>
> A more complete patch series (including configuration store support and the
> motion detection work) can be found here:
>
> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/propapi-doc
>
> This patch series is a revision of RFCv2:
>
> http://www.spinics.net/lists/linux-media/msg71828.html
>
> Changes since RFCv2 are:
>
> - incorporated Sylwester's comments
> - split up patch [20/21] into two: one for the codingstyle fixes in the example
>   code, one for the actual DocBook additions.
> - fixed a bug in patch 6 that broke the old-style VIDIOC_QUERYCTRL. Also made
>   the code in v4l2_query_ext_ctrl() that sets the mask/match variables more
>   readable. If I had to think about my own code, then what are the chances others
>   will understand it? :-)
> - dropped the support for setting/getting partial matrices. That's too ambiguous
>   at the moment, and we can always add that later if necessary.
>
> The API changes required to support complex controls are minimal:
>
> - A new V4L2_CTRL_FLAG_HIDDEN has been added: any control with this flag (and
>   complex controls will always have this flag) will never be shown by control
>   panel GUIs. The only way to discover them is to pass the new _FLAG_NEXT_HIDDEN
>   flag to QUERYCTRL.
>
> - A new VIDIOC_QUERY_EXT_CTRL ioctl has been added: needed to get the number of elements
>   stored in the control (rows by columns) and the size in byte of each element.
>   As a bonus feature a unit string has also been added as this has been requested
>   in the past. In addition min/max/step/def values are now 64-bit.
>
> - A new 'p' field is added to struct v4l2_ext_control to set/get complex values.
>
> - A helper flag V4L2_CTRL_FLAG_IS_PTR has been added to tell apps whether the
>   'value' or 'value64' fields of the v4l2_ext_control struct can be used (bit
>   is cleared) or if the 'p' pointer can be used (bit it set).
>
> Once everyone agrees with this API extension I will make a next version of this
> patch series that adds the Motion Detection support for the solo6x10 and go7007
> drivers that can now use the new matrix controls. That way actual drivers will
> start using this (and it will allow me to move those drivers out of staging).
>
> Regards,
>
>         Hans
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Ricardo Ribalda
