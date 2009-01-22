Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4309 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbZAVHUU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 02:20:20 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Vladimir Davydov <vladimir.davydov@promwad.com>
Subject: Re: Request for new pixel format (JPEG2000)
Date: Thu, 22 Jan 2009 08:19:54 +0100
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	linux-media@vger.kernel.org
References: <200901212146.39153.vladimir.davydov@promwad.com> <1232600942.3764.130.camel@tux.localhost>
In-Reply-To: <1232600942.3764.130.camel@tux.localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901220819.54460.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 22 January 2009 06:09:02 Alexey Klimov wrote:
> (added linux-media mail-list)
>
> Hello, Vladimir
>
> On Wed, 2009-01-21 at 21:46 +0200, Vladimir Davydov wrote:
> > Hi,
> > Is it possible to add new pixel format to videodev2.h file?
> >
> > #define V4L2_PIX_FMT_MJ2C   v4l2_fourcc('M','J','2','C') /* Morgan JPEG
> > 2000*/
> >
> > I have developed a V4L2 driver for the board with hardware JPEG2000
> > codec (ADV202 chip). This driver uses that pixel format.
> > I think JPEG 2000 is very perspective codec and it will be good if V4L2
> > will support it.
> >
> > Short description of the device is here:
> > http://www.promwad.com/markets/linux-video-jpeg2000-blackfin.html

Vladimir,

It shouldn't be a problem adding this, but we prefer to only add such things 
when the driver code is also added at the same time. Are you going to 
submit the driver code as well to the list?

Thanks,

	Hans

> >
> > Thanks,
> > Vladimir.
>
> Please, send patches and other e-mails related to drivers development to
> linux-media@vger.kernel.org
> Such tool like patchwork.kernel.org will cares about patches, so they
> don't lost.
>
> I think you already check this page
> http://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches
> if not, please check.



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
