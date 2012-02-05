Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:48367 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab2BEJET (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Feb 2012 04:04:19 -0500
Date: Sun, 5 Feb 2012 11:04:14 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	dacohen@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com
Subject: Re: [PATCH v2 04/31] v4l: VIDIOC_SUBDEV_S_SELECTION and
 VIDIOC_SUBDEV_G_SELECTION IOCTLs
Message-ID: <20120205090414.GB7784@valkosipuli.localdomain>
References: <20120202235231.GC841@valkosipuli.localdomain>
 <1328226891-8968-4-git-send-email-sakari.ailus@iki.fi>
 <4F2D80C1.2050808@gmail.com>
 <4F2D9581.1040809@iki.fi>
 <4F2DB332.9020106@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2DB332.9020106@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sat, Feb 04, 2012 at 11:37:38PM +0100, Sylwester Nawrocki wrote:
> On 02/04/2012 09:30 PM, Sakari Ailus wrote:
> >>> +#define V4L2_SUBDEV_SEL_FLAG_SIZE_GE			(1<<   0)
> >>> +#define V4L2_SUBDEV_SEL_FLAG_SIZE_LE			(1<<   1)
> >>> +#define V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG		(1<<   2)
> >>> +
> >>> +/* active cropping area */
> >>> +#define V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE			0
> >>> +/* cropping bounds */
> >>> +#define V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS			2
> >>
> >> You've dropped the DEFAULT targets but the target numbers stayed
> >> unchanged. How about using hex numbers ? e.g.
> >>
> >> #define V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTIVE		0x0100
> >> #define V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS		0x0101
> > 
> > Fine for me. Changed for the next revision.
> > 
> > I wanted to keep the target numbers the same since we're still using
> > exactly the same as the V4L2.
> 
> You're right, keeping the numbers same for subdevs and regular video
> nodes may be important. I'm wondering whether we should use same
> definitions for subdevs, rather than inventing new ones ? In case we 
> associate the selection targets with controls some target identifiers
> must not actually be different. Whether the control belongs directly 
> to a video node control handler or is inherited from a sub-device the
> selection target would have to be same. I'm referring here to an auto
> focus rectangle selection target base for instance.
> I guess including videodev2.h from v4l2-subdev.h is not an option, if
> at all necessary ?

I think you're right; there would be advantages of using the same
definitions. On the other hand, there may be subtle and not so subtle
differences what these rectangles actually mean between the two interfaces.

The interface is quite similar to controls but the purpose it is used for is
quite different: not many interdependencies are expected with controls
whereas selections have many. The reason for this is we're using them to
control various kinds of image processing functionality which might not be
even similar on V4L2 subdev nodes and V4L2 nodes: the former is a superset
of the latter.

I'd like to have Laurent's opinion on this.

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
