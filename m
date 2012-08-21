Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33461 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756872Ab2HULHC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 07:07:02 -0400
Date: Tue, 21 Aug 2012 14:06:58 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC API] Renumber subdev ioctls
Message-ID: <20120821110657.GG721@valkosipuli.retiisi.org.uk>
References: <201208201030.30590.hverkuil@xs4all.nl>
 <20120820204604.GE721@valkosipuli.retiisi.org.uk>
 <201208210839.53924.hverkuil@xs4all.nl>
 <2078906.YdiCh5Z7RM@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2078906.YdiCh5Z7RM@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Aug 21, 2012 at 11:01:03AM +0200, Laurent Pinchart wrote:
> > > videodev2.h, and if there was even a loosely corresponding IOCTL in V4L2
> > > then use the same number (e.g. formats vs. media bus pixel codes) and
> > > otherwise something else. The "something else" case hasn't happened yet.
> > > 
> > > It might have made sense to use a different type for the IOCTLs that
> > > aren't V4L2 IOCTLs (i.e. are subdev IOCTLs) for clarity but it's quite
> > > late for such a change. However if we think we definitely should do it
> > > then it should be done now or not at all...
> > > 
> > > If we want to just improve the efficiency of the switch statement in
> > > subdev_do_ioctl() we could divide the IOCTLs based on e.g. a few last bits
> > > of the IOCTL number into buckets.
> > 
> > It's not so much the switch efficiency. In practice there will be no
> > measurable speed difference. But a lookup table allows one to easily look
> > up information about the ioctl.
> > 
> > But the main goal would be to guarantee that subdev ioctls and V4L2 ioctls
> > will never clash, since both types of ioctls can be used with a subdev node.
> 
> We could also do that by redefining the V4L2 ioctls we use on subdevs in 
> include/linux/v4l2-subdev.h with a VIDIOC_SUBDEV_ prefix. That would guarantee 
> that all subdev-related ioctls are listed in a single place. However, I agree 
> that it could be confusing for tools like strace.

Just as a wrapper for V4L2 controls IOCTLs, i.e. the IOCTL code would be the
same?

> > > I don't have a strong opinion on this either way, but unless there's a
> > > concrete problem related to it I'd keep it as-is. We will definitely pick
> > > a new type for the property API when once we get that far. ;-)
> > > 
> > > Could you elaborate what you were about to add? Something that would fall
> > > into the "something else" category perhaps?
> > 
> > Yes indeed. It's two new ioctls for setting/getting the EDID.
> > 
> > Currently I've chosen ioctl numbers that are not used by V4L2 (there are a
> > number of 'holes' in the ioctl list).
> > 
> > If people think it is not worth the effort, then so be it. But if we do want
> > to do this, then we can't wait any longer.
> 
> I'm not opposed to renumber subdev ioctls. I agree with you and Sakari that we 
> should do it now if we want to do it. It would actually be a good occasion to 
> introduce a change I've been thinking about for some time now by redefining 
> control ioctls for subdevs to include a pad number in the structures used as 
> arguments (v4l2_queryctrl, v4l2_querymenu and v4l2_ext_control) to allow for 
> pad-specific controls later.

Hmm... v4l2_queryctrl and v4l2_ext_control both have a reserved field half
of which would be enough to hold the pad number. Wouldn't that be enough? We
would just say the pad field isn't used on V4L2 in a similar fashion as the
padded and default selection targets are only valid on V4L2, not on subdevs.
It's quite a benefit that controls can be accessed on both V4L2 and V4L2
subdev using the same API, It'd be nice to keep that.

The subdev API currently uses controls most of which are not (and must not
be) associated to any pad but the subdev itself. Perhaps a flag in
v4l2_queryctrl to tell the pad field is valid for a control, plus
documenting it so in the spec?

On the other hand, there might be a need to extend the extended controls by
e.g. adding limits and step to 64-bit controls so that v4l2_queryctrl would
need to be extended, too. So if we're changing the actual IOCTL API I'd
rather extend it on V4L2 as well.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
