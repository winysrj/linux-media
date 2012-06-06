Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39243 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab2FFDqj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2012 23:46:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Rebecca Schultz Zavin <rebecca@android.com>
Cc: "Semwal, Sumit" <sumit.semwal@ti.com>, remi@remlab.net,
	pawel@osciak.com, mchehab@redhat.com, robdclark@gmail.com,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	kyungmin.park@samsung.com, airlied@redhat.com,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de
Subject: Re: [Linaro-mm-sig] [PATCHv6 00/13] Integration of videobuf2 with dmabuf
Date: Wed, 06 Jun 2012 05:46:34 +0200
Message-ID: <4653855.fA1y5y3jSF@avalon>
In-Reply-To: <CALJcvx6zPB2fvUX9hNF9kVbfgRX_NeaMAf0LiS8xbwsTQtGgHw@mail.gmail.com>
References: <1337775027-9489-1-git-send-email-t.stanislaws@samsung.com> <CAB2ybb-0D4vs=k6GjBuw8OitDpPSjDdyOcEqogFtGdZUk0pasQ@mail.gmail.com> <CALJcvx6zPB2fvUX9hNF9kVbfgRX_NeaMAf0LiS8xbwsTQtGgHw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rebecca,

On Monday 04 June 2012 12:34:23 Rebecca Schultz Zavin wrote:
> I have a system where the data is planar, but the kernel drivers
> expect to get one allocation with offsets for the planes.  I can't
> figure out how to do that with the current dma_buf implementation.  I
> thought I could pass the same dma_buf several times and use the
> data_offset field of the v4l2_plane struct but it looks like that's
> only for output.  Am I missing something?  Is this supported?

data_offset is indeed for video output only at the moment, and doesn't seem to 
be used by any driver in mainline for now.

I can't really see a reason why data_offset couldn't be used for video capture 
devices as well.

Sanity checks are currently missing. For output devices we should check that 
data_offset + bytesused < length in the vb2 core. For input devices the check 
will have to be performed by drivers. Taking data_offset into account 
automatically would also be useful. I think most of that should be possible to 
implement in the allocators.

-- 
Regards,

Laurent Pinchart

