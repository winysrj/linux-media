Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:43988 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146AbbJLJgy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2015 05:36:54 -0400
Message-ID: <561B7EC1.9060008@xs4all.nl>
Date: Mon, 12 Oct 2015 11:34:57 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Antonio Ospite <ao2@ao2.it>, linux-media@vger.kernel.org
CC: Hans de Goede <hdegoede@redhat.com>
Subject: Re: gspca/ov534 gets two failures with v4l2-compliance
References: <20151003164428.1dbf4e95936e6e4e62aabb37@ao2.it>
In-Reply-To: <20151003164428.1dbf4e95936e6e4e62aabb37@ao2.it>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/03/2015 04:44 PM, Antonio Ospite wrote:
> Hi,
> 
> I tried running v4l2-compliance with the PS3 Eye and I got these two
> failures:
> 
> ...
> Test input 0:
>         ...
>         Format ioctls:
>                 fail: v4l2-test-formats.cpp(122): found frame intervals for invalid size 321x240
>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: FAIL
>                 test VIDIOC_G/S_PARM: OK
>                 test VIDIOC_G_FBUF: OK (Not Supported)
>                 fail: v4l2-test-formats.cpp(425): unknown pixelformat 56595559 for buftype 1
>                 test VIDIOC_G_FMT: FAIL
>                 test VIDIOC_TRY_FMT: OK (Not Supported)
>                 test VIDIOC_S_FMT: OK (Not Supported)
>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>                 test Cropping: OK (Not Supported)
>                 test Composing: OK (Not Supported)
>                 test Scaling: OK
> 
> About the first failure: by looking at the kernel code in gspca.c it
> looks like the supported frame sizes are declared as
> V4L2_FRMSIZE_TYPE_DISCRETE in vidioc_enum_framesizes(), but then the
> driver accepts invalid ones when listing frameintervals trying to find
> the "closest" size for width and height using wxh_to_mode().
> 
> Can this discrepancy be what makes v4l2-compliance fail?

Yes, that's the reason it fails.

> 
> If you think it's OK to change the gspca behavior to be stricter about
> what frame sizes are considered valid, I may take a shot at it.

I would say this is OK to change. UVC is also strict about this, so apps should
do this correct, otherwise they would fail with uvc webcams.

> By looking at the v4l2-compliance code I think the second failure will
> go away once the first one is fixed: node->buftype_pixfmts does not get
> populated because of the first failure.

Correct.

Regards,

	Hans
