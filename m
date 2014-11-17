Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40360 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752514AbaKQOgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 09:36:19 -0500
Date: Mon, 17 Nov 2014 16:35:40 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 06/11] videodev2.h: add new v4l2_ext_control flags
 field
Message-ID: <20141117143540.GN8907@valkosipuli.retiisi.org.uk>
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl>
 <1411310909-32825-7-git-send-email-hverkuil@xs4all.nl>
 <20141115141858.GG8907@valkosipuli.retiisi.org.uk>
 <20141115174459.GH8907@valkosipuli.retiisi.org.uk>
 <5469B874.9040008@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5469B874.9040008@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Nov 17, 2014 at 09:57:24AM +0100, Hans Verkuil wrote:
> On 11/15/2014 06:44 PM, Sakari Ailus wrote:
> > Hi,
> > 
> > On Sat, Nov 15, 2014 at 04:18:59PM +0200, Sakari Ailus wrote:
> > ...
> >>>  	union {
> >>>  		__s32 value;
> >>>  		__s64 value64;
> >>> @@ -1294,6 +1294,10 @@ struct v4l2_ext_control {
> >>>  	};
> >>>  } __attribute__ ((packed));
> >>>  
> >>> +/* v4l2_ext_control flags */
> >>> +#define V4L2_EXT_CTRL_FL_IGN_STORE_AFTER_USE	0x00000001
> >>> +#define V4L2_EXT_CTRL_FL_IGN_STORE		0x00000002
> >>
> >> Do we need both? Aren't these mutually exclusive, and you must have either
> >> to be meaningful in the context of a store?
> > 
> > Ah. Now I think I understand what do these mean. Please ignore my previous
> > comment.
> > 
> > I might call them differently. What would you think of
> 
> I was never happy with the naming :-)

:-)

> > V4L2_EXT_CTRL_FL_STORE_IGNORE and V4L2_EXT_CTRL_FL_STORE_ONCE?
> 
> I will give this some more thought.
> 
> > V4L2_EXT_CTRL_FL_IGN_STORE_AFTER_USE is quite long IMO. Up to you.
> > 
> > I wonder if we need EXT in V4L2_EXT_CTRL_FL. It's logical but also
> > redundant since the old control interface won't have flags either.
> 
> True.

I think I'm inclined to keep EXT there. These values aren't used in that
many places in typical programs.

> > I'd assume that for cameras the vast majority of users will always want to
> > just apply the values once. How are the use cases in video decoding?
> 
> I am wondering whether 'apply once' shouldn't be the default and whether I
> really need to implement the 'apply always' (Hey, not bad names either!)
> functionality for this initial version.

After thinking more about it, I'm still leaning towards making the values
stick to a store by default. Forgetting the values after use is something on
top of the basic behaviour. Just my 5 euro cents. Pawel, others?

It could be nice to be able to forget an entire store. An application might
fill it, but only later figure out it will never be needed.

Do you think this could be a button control? :-) No need for this now,
though, we could see when someone needs that.

> I only used the 'apply always' functionality for a somewhat contrived test
> example where I changed the cropping rectangle (this is with the selection
> controls from patch 10/11) for each buffer so that while streaming I would
> get a continuous zoom-in/zoom-out effect. While nice for testing, it isn't
> really practical in reality.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
