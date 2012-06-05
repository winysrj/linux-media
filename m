Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36787 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761368Ab2FEDgi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2012 23:36:38 -0400
Received: by qcro28 with SMTP id o28so2533029qcr.19
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2012 20:36:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201206042358.07234.hverkuil@xs4all.nl>
References: <1337775027-9489-1-git-send-email-t.stanislaws@samsung.com>
	<CAB2ybb-0D4vs=k6GjBuw8OitDpPSjDdyOcEqogFtGdZUk0pasQ@mail.gmail.com>
	<CALJcvx6zPB2fvUX9hNF9kVbfgRX_NeaMAf0LiS8xbwsTQtGgHw@mail.gmail.com>
	<201206042358.07234.hverkuil@xs4all.nl>
Date: Mon, 4 Jun 2012 20:36:37 -0700
Message-ID: <CALJcvx7zKGxGWkjXVPtrAvwSJeyOZcs33vKwALD_5nODKy3W8A@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCHv6 00/13] Integration of videobuf2 with dmabuf
From: Rebecca Schultz Zavin <rebecca@android.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linaro-mm-sig@lists.linaro.org,
	"Semwal, Sumit" <sumit.semwal@ti.com>, remi@remlab.net,
	pawel@osciak.com, kyungmin.park@samsung.com,
	dri-devel@lists.freedesktop.org, robdclark@gmail.com,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	airlied@redhat.com, linux-media@vger.kernel.org,
	g.liakhovetski@gmx.de, mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It probably is a fixed offset, but all the information describing it
is in userspace...  In my experience, it's always almost one of the
pre-defined formats, but then there's some extra padding, weird
alignment etc.  I'm trying to convert code that used userptr, but
where the planes were offsets into the same buffer, to use dma_buf.
Looks like I need to dig a bit deeper.

Thanks,
Rebecca


On Mon, Jun 4, 2012 at 2:58 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Rebecca,
>
> On Mon June 4 2012 21:34:23 Rebecca Schultz Zavin wrote:
>> I have a system where the data is planar, but the kernel drivers
>> expect to get one allocation with offsets for the planes.  I can't
>> figure out how to do that with the current dma_buf implementation.  I
>> thought I could pass the same dma_buf several times and use the
>> data_offset field of the v4l2_plane struct but it looks like that's
>> only for output.  Am I missing something?  Is this supported?
>
> v4l2_plane is typically used if the planes are allocated separately.
> If you allocate it in one go, aren't the planes then at well-defined
> offsets from the start? If so, then it is either one of the already
> pre-defined planar formats found here:
>
> http://hverkuil.home.xs4all.nl/spec/media.html#yuv-formats
>
> or you define a pixelformat specific to your own hardware that identifies
> that particular format.
>
> If it is one allocation, but there is no clear calculation based on width
> and height that gives you the start of each plane, then we do not support
> that at the moment. I believe I had a discussion about something similar
> with people from Qualcomm, but that never came to anything.
>
> That would be something to discuss on the linux-media mailinglist.
>
> Regards,
>
>        Hans
