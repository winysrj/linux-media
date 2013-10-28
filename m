Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:60503 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab3J1Wq6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Oct 2013 18:46:58 -0400
Received: by mail-ob0-f169.google.com with SMTP id uz6so4435253obc.14
        for <linux-media@vger.kernel.org>; Mon, 28 Oct 2013 15:46:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5268F714.3090004@samsung.com>
References: <1380623614-26265-1-git-send-email-ricardo.ribalda@gmail.com> <5268F714.3090004@samsung.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 28 Oct 2013 23:46:37 +0100
Message-ID: <CAPybu_2p4AYxze-QMOZhMq+EYCEXN1KazZdQckWKub9kpAESfg@mail.gmail.com>
Subject: Re: [RFC v3] [RFC] v4l2: Support for multiple selections
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Tomasz

Sorry for the late reply, but I have been offline the last week due to
the conference.


On Thu, Oct 24, 2013 at 12:31 PM, Tomasz Stanislawski
<t.stanislaws@samsung.com> wrote:
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

It is not driver specific. There are many sensors out there that
supports multiple window of interest, but today we are ignoring them
just because we dont have an api.

The main application would be industrial imaging, where less data to
read means more fps and therefore the system can run faster.

>From my field I can tell you that it is a hard requirement for
computer vision. And it is a feature that we cannot model through v4l2
controls.


> Do you know other drivers that may need it? Sakari mentioned introduction
> of private targets for selections. I like this idea. Just define:
>
> #define V4L2_SEL_TGT_PRIVATE     0x80000000
>
> All targets that are >= V4L2_SEL_TGT_PRIVATE are driver-specific.
> Generic applications must not use them. Non-generic application
> must check out the driver of video node before using selections
> from private set. If some target becomes more useful and accepted
> by more then one driver then it can be moved to generic API.
> The good thing about private target is that enums from different
> drivers can collide so the target space is not going to be trashed.
>

If you read the previous RFCs you will see that the approach you are
mentioning has been rejected.

The main issue is that you cannot set atomically all the rectangles.
Lets say that the configuration formed by rectangle A, B and C is
legal, but the configuration A and B is not allowed by the sensor. How
could you set the rectangles one by one?

> I have an auxiliary question. Do you have to set all rectangles
> at once? can you set up them one by one?

Also if you tell the driver what exact configuration you will need, it
will provide you with the closest possible confuration, that cannot be
done if you provide rectangle by rectangle.

> But how to deal with multiple rectangles?

Multiple rectangles is a desired feature, please take a look to the
presentation on the workshop.

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

Lets say rectangle A + B + C +D is legal, and A +B is also legal. You
are in ABCD and you want to go to AB. How can you do it?

If yo dissable C or D, the configuration is ilegal and therefor the
driver will return -EINVAL. So once you are in ABCD you cannot go
back...


>
> The change of V4L2_SEL_TGT_XXX_SCANOUT0 would influence all consequtive
> rectangle by shifting them down or resetting them to height 0.
> Notice that as long as targets are driver specific you are free do define
> interaction between the targets.
>
> I hope that proposed solution is satisfactory.

As stated before, please follow the previous comments on the rfc,
specially the ones from Hans.

>
> BTW. I think that the HW trick you described is not cropping.
> By cropping you select which part of sensor area is going
> to be processed into compose rectangle in a buffer.

You are selecting part of the sensor, therefore you are cropping the image.

>
> So technicaly you still insert the whole sensor area into the buffer.

Only the lines/columns are read into the buffer.

> Only part of the buffer is actually updated. So there is no cropping
> (cropping area is equal to the whole array).
>
> Notice, that every 'cropping' area goes to different part of a buffer.
> So you would need also muliple targets for composing (!!!) and very long
> chapter in V4L2 doc describing interactions between muliple-rectangle
> crops and compositions. Good luck !!! :).

It is not that difficult to describe.

You need the same ammount of rectangles in cropping and in compossing.
Rectangle X in cropping will be mapped to rectangle X in compose.


> Currently it is a hell to understand and define interaction between
> single crop, and compose and unfamous VIDIOC_S_FMT and m2m madness.

On m2m devices we are only lacking a s_fmt on the first buffer, as we
have discussed on the workshop. I think we only lack a good reference
model in vivi.


>
> I strongly recommend to use private selections.
> It will be much simpler to define, implement, and modify if needed.

I think the private selections will lead to specific applications for
specific drivers and we cannot support all the configurations with
them. Also there is no way for an app to enumerate that capability.

>
> BTW2. I think that the mulitple scanout areas can be modelled using
> media device API. Sakari may know how to do this.

The areas are not read from the sensor. Therefore they can only be
proccessed on the sensor subdevice.

>
>
> Ad 2. Extended rectangles.
> It is a good idea because v4l2_rect lacks any place for extensions.
> But before adding it to V4L2 API, I would like to know the examples
> of actual applications. Please, point drivers that actually need it.

I have no need for it, but now that we are extending the selection API
it would be the perfect moment to add them.

They could describe properties of the sensor, like tracking ids.

>
> Other thing worth mentioning is reservation of few bits from
> v4l2_selection::flags to describe the type of data used for
> rectangle, v4l2_rect or v4l2_ext_rect. This way one can avoid
> introducting v4l2_selection::rectangles field.
>
> I hope you find this comments useful.


Regards

>
> Regards,
> Tomasz Stanislawski
>
>



-- 
Ricardo Ribalda
