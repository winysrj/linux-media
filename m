Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2819 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929Ab2FDV6c (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2012 17:58:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linaro-mm-sig@lists.linaro.org
Subject: Re: [Linaro-mm-sig] [PATCHv6 00/13] Integration of videobuf2 with dmabuf
Date: Mon, 4 Jun 2012 23:58:07 +0200
Cc: Rebecca Schultz Zavin <rebecca@android.com>,
	"Semwal, Sumit" <sumit.semwal@ti.com>, remi@remlab.net,
	pawel@osciak.com, kyungmin.park@samsung.com,
	dri-devel@lists.freedesktop.org, robdclark@gmail.com,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	airlied@redhat.com, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de, mchehab@redhat.com
References: <1337775027-9489-1-git-send-email-t.stanislaws@samsung.com> <CAB2ybb-0D4vs=k6GjBuw8OitDpPSjDdyOcEqogFtGdZUk0pasQ@mail.gmail.com> <CALJcvx6zPB2fvUX9hNF9kVbfgRX_NeaMAf0LiS8xbwsTQtGgHw@mail.gmail.com>
In-Reply-To: <CALJcvx6zPB2fvUX9hNF9kVbfgRX_NeaMAf0LiS8xbwsTQtGgHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206042358.07234.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rebecca,

On Mon June 4 2012 21:34:23 Rebecca Schultz Zavin wrote:
> I have a system where the data is planar, but the kernel drivers
> expect to get one allocation with offsets for the planes.  I can't
> figure out how to do that with the current dma_buf implementation.  I
> thought I could pass the same dma_buf several times and use the
> data_offset field of the v4l2_plane struct but it looks like that's
> only for output.  Am I missing something?  Is this supported?

v4l2_plane is typically used if the planes are allocated separately.
If you allocate it in one go, aren't the planes then at well-defined
offsets from the start? If so, then it is either one of the already
pre-defined planar formats found here:

http://hverkuil.home.xs4all.nl/spec/media.html#yuv-formats

or you define a pixelformat specific to your own hardware that identifies
that particular format.

If it is one allocation, but there is no clear calculation based on width
and height that gives you the start of each plane, then we do not support
that at the moment. I believe I had a discussion about something similar
with people from Qualcomm, but that never came to anything.

That would be something to discuss on the linux-media mailinglist.

Regards,

	Hans
