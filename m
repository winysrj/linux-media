Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55066 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750974Ab3J2WOp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Oct 2013 18:14:45 -0400
Message-ID: <52703368.7020501@iki.fi>
Date: Wed, 30 Oct 2013 00:15:04 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC v3] [RFC] v4l2: Support for multiple selections
References: <1380623614-26265-1-git-send-email-ricardo.ribalda@gmail.com> <5268F714.3090004@samsung.com>
In-Reply-To: <5268F714.3090004@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

(Please also see the notes from the Media summit Hans posted.)

Tomasz Stanislawski wrote:
> Hi Ricardo,
> I am the designer of selection API. I hope I can help you a little.
> I think that there are two issues mixed in 'Mulitple selections' topic.
> 
> Firstly, you described that you program a piece of hardware that is
> capable of selecting 8 areas for scanning. Now you
> are looking for userspace API to support such a feature.
> The feature of posting multiple rectangle was proposed in this RFC.
> 
> Secondly, You introduced struct v4l2_ext_rect which is a future-proof
> version of v4l2_rect.
> 
> 
> I think that both issues should be solved in two separate patchsets.
> 
> Ad 1.
> The selection of multiple scanning areas is a very driver-specific
> feature, isn't it? I think that you do not need to introduce any abstract
> interface. What would be other applications of the proposed interface?
> Do you know other drivers that may need it? Sakari mentioned introduction
> of private targets for selections. I like this idea. Just define:
> 
> #define V4L2_SEL_TGT_PRIVATE     0x80000000

I think a private target would definitely make sense if this was
functionality that was present on a single sensor or two --- that's what
I actually proposed for this originally. But as far as I understand, it
is more common but just not present on sensors used in mobile devices.
So standardising this makes sense.

> All targets that are >= V4L2_SEL_TGT_PRIVATE are driver-specific.
> Generic applications must not use them. Non-generic application
> must check out the driver of video node before using selections
> from private set. If some target becomes more useful and accepted
> by more then one driver then it can be moved to generic API.
> The good thing about private target is that enums from different
> drivers can collide so the target space is not going to be trashed.
> 
> But how to deal with multiple rectangles?
> I have an auxiliary question. Do you have to set all rectangles
> at once? can you set up them one by one?
> 
> Anyway, first try to define something like this:
> 
> #define V4L2_SEL_TGT_XXX_SCANOUT0  V4L2_SEL_TGT_PRIVATE
> #define V4L2_SEL_TGT_XXX_SCANOUT0_DEFAULT  (V4L2_SEL_TGT_XXX_SCANOUT0 + 1)
> #define V4L2_SEL_TGT_XXX_SCANOUT0_BOUNDS  (V4L2_SEL_TGT_XXX_SCANOUT0 + 2)
> 
> #define V4L2_SEL_TGT_XXX_SCANOUT0  (V4L2_SEL_TGT_PRIVATE + 16)
> ...
> 
> -- OR-- parametrized macros similar to one below:
> 
> #define V4L2_SEL_TGT_XXX_SCANOUT(n) (V4L2_SEL_TGT_PRIVATE + 16 * (n))
> 
> The application could setup all scanout areas one-by-one.
> By default V4L2_SEL_TGT_XXX_SCANOUT0 would be equal to the whole array.
> The height of all consecutive area would be 0. This means disabling
> them effectively.
> 
> The change of V4L2_SEL_TGT_XXX_SCANOUT0 would influence all consequtive
> rectangle by shifting them down or resetting them to height 0.
> Notice that as long as targets are driver specific you are free do define
> interaction between the targets.
> 
> I hope that proposed solution is satisfactory.
> 
> BTW. I think that the HW trick you described is not cropping.
> By cropping you select which part of sensor area is going
> to be processed into compose rectangle in a buffer.
> 
> So technicaly you still insert the whole sensor area into the buffer.
> Only part of the buffer is actually updated. So there is no cropping
> (cropping area is equal to the whole array).
> 
> Notice, that every 'cropping' area goes to different part of a buffer.
> So you would need also muliple targets for composing (!!!) and very long
> chapter in V4L2 doc describing interactions between muliple-rectangle
> crops and compositions. Good luck !!! :).

Multiple crop rectangles shouldn't make that more difficult than it was
since for the next step the image size is still a rectangle (it is just
composed of several smaller ones). Drivers supporting this will suffer,
though, but others shouldn't need to care.

The documentation must thus also be changed to say that the crop
rectangles must together form a rectangle if multiple rectangle support
is added.

I reckon Ricardo is looking forward to using this on V4L2 interface, but
I think support should also be added to the V4L2 sub-device interface.

> Currently it is a hell to understand and define interaction between
> single crop, and compose and unfamous VIDIOC_S_FMT and m2m madness.
> 
> I strongly recommend to use private selections.
> It will be much simpler to define, implement, and modify if needed.
> 
> BTW2. I think that the mulitple scanout areas can be modelled using
> media device API. Sakari may know how to do this.

The media device plays no part in subsystem specific matters such as
formats. This is relevant in the scope of V4L2 only, IMHO.

-- 
Kind regards,

Sakari Ailus
sakari.ailus@iki.fi
