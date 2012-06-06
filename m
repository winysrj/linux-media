Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:58514 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862Ab2FFIRH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2012 04:17:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [Linaro-mm-sig] [PATCHv6 00/13] Integration of videobuf2 with dmabuf
Date: Wed, 6 Jun 2012 10:17:03 +0200
Cc: Rebecca Schultz Zavin <rebecca@android.com>,
	"Semwal, Sumit" <sumit.semwal@ti.com>, remi@remlab.net,
	pawel@osciak.com, mchehab@redhat.com, robdclark@gmail.com,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	kyungmin.park@samsung.com, airlied@redhat.com,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de
References: <1337775027-9489-1-git-send-email-t.stanislaws@samsung.com> <CALJcvx6zPB2fvUX9hNF9kVbfgRX_NeaMAf0LiS8xbwsTQtGgHw@mail.gmail.com> <4653855.fA1y5y3jSF@avalon>
In-Reply-To: <4653855.fA1y5y3jSF@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206061017.03945.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed 6 June 2012 05:46:34 Laurent Pinchart wrote:
> Hi Rebecca,
> 
> On Monday 04 June 2012 12:34:23 Rebecca Schultz Zavin wrote:
> > I have a system where the data is planar, but the kernel drivers
> > expect to get one allocation with offsets for the planes.  I can't
> > figure out how to do that with the current dma_buf implementation.  I
> > thought I could pass the same dma_buf several times and use the
> > data_offset field of the v4l2_plane struct but it looks like that's
> > only for output.  Am I missing something?  Is this supported?
> 
> data_offset is indeed for video output only at the moment, and doesn't seem to 
> be used by any driver in mainline for now.

Actually, data_offset may be set by capture drivers. For output buffers it is
set by userspace, for capture buffers it is set by the driver. This data_offset
typically contains meta data.

> I can't really see a reason why data_offset couldn't be used for video capture 
> devices as well.
> 
> Sanity checks are currently missing. For output devices we should check that 
> data_offset + bytesused < length in the vb2 core. For input devices the check 
> will have to be performed by drivers. Taking data_offset into account 
> automatically would also be useful. I think most of that should be possible to 
> implement in the allocators.

See this proposal of how to solve this:

http://www.spinics.net/lists/linux-media/msg40376.html

Regards,

	Hans
