Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58804 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725198AbeJUEkL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Oct 2018 00:40:11 -0400
Date: Sat, 20 Oct 2018 23:28:30 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFP] Which V4L2 ioctls could be replaced by better versions?
Message-ID: <20181020202830.olmbndl263nwj2op@valkosipuli.retiisi.org.uk>
References: <d49940b7-af62-594e-06ad-8ec113589340@xs4all.nl>
 <1711632.PTPtFUq1Nv@avalon>
 <3d5261b9-05e5-8d32-37c9-628ac0071ef3@xs4all.nl>
 <6196083.rF33JJoUHB@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6196083.rF33JJoUHB@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 17, 2018 at 11:46:54PM +0300, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Wednesday, 17 October 2018 12:16:14 EEST Hans Verkuil wrote:
> > On 10/17/2018 10:57 AM, Laurent Pinchart wrote:
> > > On Thursday, 20 September 2018 17:42:15 EEST Hans Verkuil wrote:
> > >> Some parts of the V4L2 API are awkward to use and I think it would be
> > >> a good idea to look at possible candidates for that.
> > >> 
> > >> Examples are the ioctls that use struct v4l2_buffer: the multiplanar
> > >> support is really horrible, and writing code to support both single and
> > >> multiplanar is hard. We are also running out of fields and the timeval
> > >> isn't y2038 compliant.
> > >> 
> > >> A proof-of-concept is here:
> > >> 
> > >> https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=v4l2-buffer&id=
> > >> a95 549df06d9900f3559afdbb9da06bd4b22d1f3
> > >> 
> > >> It's a bit old, but it gives a good impression of what I have in mind.
> > >> 
> > >> Another candidate is
> > >> VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL/VIDIOC_ENUM_FRAMEINTERVALS: expressing
> > >> frame intervals as a fraction is really awkward and so is the fact that
> > >> the subdev and 'normal' ioctls are not the same.
> > >> 
> > >> Would using nanoseconds or something along those lines for intervals be
> > >> better?
> > >> 
> > >> I have similar concerns with VIDIOC_SUBDEV_ENUM_FRAME_SIZE where there is
> > >> no stepwise option, making it different from VIDIOC_ENUM_FRAMESIZES. But
> > >> it should be possible to extend VIDIOC_SUBDEV_ENUM_FRAME_SIZE with
> > >> stepwise support, I think.
> > > 
> > > If we refresh the enumeration ioctls, I propose moving away from the one
> > > syscall per value model, and returning everything in one
> > > (userspace-allocated) buffer. The same could apply to all enumerations
> > > (such as controls for instance), even if we don't address them all in one
> > > go.
> > 
> > I'm not convinced about this, primarily because I think these enums are done
> > at configuration time, and rarely if ever while streaming. So does it
> > really make a difference in practice? Feedback on this would be welcome
> > during the summit meeting.
> 
> It's indeed not a hot path in most cases, but if you enumerate formats, frame 
> sizes and frame intervals, you end up with three nested loops with lots of 
> ioctl calls. This makes the code on the userspace side more complex than it 
> should be, and incurs an overhead. If we rework the enumeration ioctls for 
> other reasons, I believe we should fix this as wel.

Agreed; an interface that can tell you how many entries there are, and then
give those to you is more straightforward to use and more efficient. I
wouldn't change how things work just the sake of doing that, though; there
needs to be something else that needs to be changed and cannot be supported
using the existing API as well.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
