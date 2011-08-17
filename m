Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37830 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab1HQO6G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2011 10:58:06 -0400
Received: by qyk38 with SMTP id 38so2106113qyk.19
        for <linux-media@vger.kernel.org>; Wed, 17 Aug 2011 07:58:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <009201cc5ce0$bd34de10$379e9a30$%szyprowski@samsung.com>
References: <Pine.LNX.4.64.1108042329460.31239@axis700.grange>
 <201108081116.41126.hansverk@cisco.com> <Pine.LNX.4.64.1108151324220.7851@axis700.grange>
 <201108151336.07258.hansverk@cisco.com> <Pine.LNX.4.64.1108151530410.7851@axis700.grange>
 <009201cc5ce0$bd34de10$379e9a30$%szyprowski@samsung.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Wed, 17 Aug 2011 07:57:44 -0700
Message-ID: <CAMm-=zBhUVnY3gd32PTs+TyP0pdJOY_gfiJkb0K6PF3=yskFGQ@mail.gmail.com>
Subject: Re: [PATCH 1/6 v4] V4L: add two new ioctl()s for multi-size
 videobuffer management
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hansverk@cisco.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 17, 2011 at 06:22, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Hello,
>
> On Monday, August 15, 2011 3:46 PM Guennadi Liakhovetski wrote:
>> While switching back, I have to change the struct vb2_ops::queue_setup()
>> operation to take a struct v4l2_create_buffers pointer. An earlier version
>> of this patch just added one more parameter to .queue_setup(), which is
>> easier - changes to videobuf2-core.c are smaller, but it is then
>> redundant. We could use the create pointer for both input and output. The
>> video plane configuration in frame format is the same as what is
>> calculated in .queue_setup(), IIUC. So, we could just let the driver fill
>> that one in. This would require then the videobuf2-core.c to parse struct
>> v4l2_format to decide which union member we need, depending on the buffer
>> type. Do we want this or shall drivers duplicate plane sizes in separate
>> .queue_setup() parameters?
>
> IMHO if possible we should have only one callback for the driver. Please
> notice that the driver should be also allowed to increase (or decrease) the
> number of buffers for particular format/fourcc.
>

Or remove queue_setup altogether (please see my example above). What
do you think Marek?

-- 
Best regards,
Pawel Osciak
