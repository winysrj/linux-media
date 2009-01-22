Return-path: <linux-media-owner@vger.kernel.org>
Received: from promwad.com ([83.149.69.23]:57535 "EHLO promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZAVUlt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2009 15:41:49 -0500
From: Vladimir Davydov <vladimir.davydov@promwad.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Request for new pixel format (JPEG2000)
Date: Thu, 22 Jan 2009 22:40:30 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	linux-media@vger.kernel.org
References: <200901212146.39153.vladimir.davydov@promwad.com> <200901221203.48823.vladimir.davydov@promwad.com> <20090122173700.208f290c@caramujo.chehab.org>
In-Reply-To: <20090122173700.208f290c@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901222240.31923.vladimir.davydov@promwad.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 22 January 2009 21:37:00 Mauro Carvalho Chehab wrote:
> On Thu, 22 Jan 2009 12:03:48 +0200
>
> Vladimir Davydov <vladimir.davydov@promwad.com> wrote:
> > On Thursday 22 January 2009 09:19:54 Hans Verkuil wrote:
> > > On Thursday 22 January 2009 06:09:02 Alexey Klimov wrote:
> > > > (added linux-media mail-list)
> > > >
> > > > Hello, Vladimir
> > > >
> > > > On Wed, 2009-01-21 at 21:46 +0200, Vladimir Davydov wrote:
> > > > > Hi,
> > > > > Is it possible to add new pixel format to videodev2.h file?
> > > > >
> > > > > #define V4L2_PIX_FMT_MJ2C   v4l2_fourcc('M','J','2','C') /* Morgan
> > > > > JPEG 2000*/
> > > > >
> > > > > I have developed a V4L2 driver for the board with hardware JPEG2000
> > > > > codec (ADV202 chip). This driver uses that pixel format.
> > > > > I think JPEG 2000 is very perspective codec and it will be good if
> > > > > V4L2 will support it.
> > > > >
> > > > > Short description of the device is here:
> > > > > http://www.promwad.com/markets/linux-video-jpeg2000-blackfin.html
> > >
> > > Vladimir,
> > >
> > > It shouldn't be a problem adding this, but we prefer to only add such
> > > things when the driver code is also added at the same time. Are you
> > > going to submit the driver code as well to the list?
> > >
> > > Thanks,
> > >
> > > 	Hans
> >
> > Hans,
> > I can sibmit the driver code. But this driver is only for the blackfin
> > processor and will not work on other platforms. Does it make sense to
> > include the driver to the kernel source?
> > Maybe it will be better to include this driver to the blackfin.uclinux
> > kernel tree. How do you think?
>
> Please submit the driver to linux-media. The proper place for those drivers
> are under drivers/media. We have also other drivers there that are
> architecture specific (like omap drivers, OLPC, etc).
>

Good,  I will prepare the source and submit to linux-media. 


> Cheers,
> Mauro.



-- 
Vladimir Davydov
Senior Developer
Promwad Innovation Company
Web: www.promwad.com
22, Olshevskogo St.,
220073, Minsk,
BELARUS
Phone/Fax: +375 (17) 312–1246
E-mail: vladimir.davydov@promwad.com
Skype: v_davydov
