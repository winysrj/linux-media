Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1876 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab2FGGoS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2012 02:44:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [Linaro-mm-sig] [PATCHv6 00/13] Integration of videobuf2 with dmabuf
Date: Thu, 7 Jun 2012 08:43:56 +0200
Cc: Rebecca Schultz Zavin <rebecca@android.com>,
	"Semwal, Sumit" <sumit.semwal@ti.com>, remi@remlab.net,
	pawel@osciak.com, mchehab@redhat.com, robdclark@gmail.com,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	kyungmin.park@samsung.com, airlied@redhat.com,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de
References: <1337775027-9489-1-git-send-email-t.stanislaws@samsung.com> <201206061017.03945.hverkuil@xs4all.nl> <4173899.dEXarKynNP@avalon>
In-Reply-To: <4173899.dEXarKynNP@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206070843.56440.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu June 7 2012 02:52:06 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Wednesday 06 June 2012 10:17:03 Hans Verkuil wrote:
> > On Wed 6 June 2012 05:46:34 Laurent Pinchart wrote:
> > > On Monday 04 June 2012 12:34:23 Rebecca Schultz Zavin wrote:
> > > > I have a system where the data is planar, but the kernel drivers
> > > > expect to get one allocation with offsets for the planes.  I can't
> > > > figure out how to do that with the current dma_buf implementation.  I
> > > > thought I could pass the same dma_buf several times and use the
> > > > data_offset field of the v4l2_plane struct but it looks like that's
> > > > only for output.  Am I missing something?  Is this supported?
> > > 
> > > data_offset is indeed for video output only at the moment, and doesn't
> > > seem to be used by any driver in mainline for now.
> > 
> > Actually, data_offset may be set by capture drivers. For output buffers it
> > is set by userspace, for capture buffers it is set by the driver. This
> > data_offset typically contains meta data.
> 
> Is that documented somewhere ? I wasn't aware of this use case.

It is documented in the proposal that Pawel sent, but very poorly if at all in
the spec. That needs to be improved.

> > > I can't really see a reason why data_offset couldn't be used for video
> > > capture devices as well.
> > > 
> > > Sanity checks are currently missing. For output devices we should check
> > > that data_offset + bytesused < length in the vb2 core. For input devices
> > > the check will have to be performed by drivers. Taking data_offset into
> > > account automatically would also be useful. I think most of that should
> > > be possible to implement in the allocators.
> > 
> > See this proposal of how to solve this:
> > 
> > http://www.spinics.net/lists/linux-media/msg40376.html
> 
> This requires more discussions regarding how the app_offset and data_offset 
> fields should be used for the different memory types we support.
> 
> For instance app_offset would not make that much sense for the USERPTR memory 
> type, as we can include the offset in the user pointer already (using 
> app_offset there would only make the code more complex without any added 
> benefit).
> 
> For the MMAP memory type adding an app_offset would require allocating buffers 
> large enough to accomodate the offset, and would thus only be useful with 
> CREATE_BUFS. I'm also wondering whether the main use case (passing the buffer 
> to another device that requires that app_offset) wouldn't be better addressed 
> by the DMABUF memory type anyway.

I'm not going to pursue this unless Google indicates that they need this. And
actually I would suggest that they ask Pawel to work on this, after all he made
the proposal AND he works for Google :-)

Regards,

	Hans
