Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2359 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3A1K5N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jan 2013 05:57:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [RFC PATCH 0/7] saa7134: improve v4l2-compliance
Date: Mon, 28 Jan 2013 11:56:59 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <1359315912-1767-1-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1359315912-1767-1-git-send-email-linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301281156.59112.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun January 27 2013 20:45:05 Ondrej Zary wrote:
> Hello,
> this patch series improves v4l2-compliance of saa7134 driver. There are still
> some problems. Controls require conversion to control framework which I was
> unable to finish (because the driver accesses other controls and also the
> file handle from within s_ctrl).

To convert to the control framework this driver needs quite a bit of work:
the saa6752hs driver should be done first (and moved to media/i2c as well as
it really doesn't belong here).

The filehandle shouldn't be a problem, I think after the prio conversion that's
no longer needed at all.

> 
> Radio is now OK except for controls.
> Video has problems with controls, debugging, formats and buffers:
> Debug ioctls:
>         test VIDIOC_DBG_G_CHIP_IDENT: OK (Not Supported)
>                 fail: v4l2-test-debug.cpp(84): doioctl(node, VIDIOC_DBG_G_CHIP_IDENT, &chip)
> Format ioctls:
>         test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>                 fail: v4l2-test-formats.cpp(836): !cap->readbuffers

That should be easy to fix. It's a pretty bogus field and I usually set it to
the minimum number of buffers (which is 2 for this driver).

>         test VIDIOC_G/S_PARM: FAIL
>                 fail: v4l2-test-formats.cpp(335): !fmt.width || !fmt.height
>         test VIDIOC_G_FBUF: FAIL
>                 fail: v4l2-test-formats.cpp(382): !pix.colorspace

That's easy enough to solve. Typically this should be set to V4L2_COLORSPACE_SMPTE170M.

But after solving this you'll probably get a bunch of other issues due to
a problem this driver shared with quite a few other related drivers: the
format state is stored in struct saa7134_fh instead of in the top-level
struct. These format states are all global and should never have been placed
in this struct.

In fact if I look at the fields in saa7134_fh then:

- radio and type can be removed (this info can be obtained from existing fields
  elsewhere)
- the fields win until pt_vbi should all be global fields
- I suspect resources and qos_request should also be global, but you would have
  to analyze that.

In fact, it is likely that the whole structure can be removed and only v4l2_fh
be used instead.

> Buffer ioctls:
>                 fail: v4l2-test-buffers.cpp(109): can_stream && !mmap_valid && !userptr_valid && !dmabuf_valid

Fixing this requires changing to vb2.

>         test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL
> 
> 
> Haven't looked into VBI yet:
> Format ioctls:
>                 fail: v4l2-test-formats.cpp(914): G/S_PARM is only allowed for video capture/output
>         test VIDIOC_G/S_PARM: FAIL
>                 fail: v4l2-test-formats.cpp(432): vbi.reserved not zeroed
>                 fail: v4l2-test-formats.cpp(570): VBI Capture is valid, but TRY_FMT failed to return a format
>         test VIDIOC_TRY_FMT: FAIL
>                 fail: v4l2-test-formats.cpp(432): vbi.reserved not zeroed
>                 fail: v4l2-test-formats.cpp(728): VBI Capture is valid, but no S_FMT was implemented
>         test VIDIOC_S_FMT: FAIL

These shouldn't be hard to fix.

Regards,

	Hans
