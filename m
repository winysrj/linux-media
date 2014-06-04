Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:27778 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaFDSkT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jun 2014 14:40:19 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N6N002DCQJ43120@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 04 Jun 2014 14:40:16 -0400 (EDT)
Date: Wed, 04 Jun 2014 15:40:12 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC ATTN] Cropping, composing, scaling and S_FMT
Message-id: <20140604154012.13ddd6a9.m.chehab@samsung.com>
In-reply-to: <538C35A2.8030307@xs4all.nl>
References: <538C35A2.8030307@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 02 Jun 2014 10:28:18 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> During the media mini-summit I went through all 8 combinations of cropping,
> composing and scaling (i.e. none of these features is present, or only cropping,
> only composing, etc.).
> 
> In particular I showed what I thought should happen if you change a crop rectangle,
> compose rectangle or the format rectangle (VIDIOC_S_FMT).
> 
> In my proposal the format rectangle would increase in size if you attempt to set
> the compose rectangle wholly or partially outside the current format rectangle.
> Most (all?) of the developers present didn't like that and I was asked to take
> another look at that.
> 
> After looking at this some more I realized that there was no need for this and
> it is OK to constrain a compose rectangle to the current format rectangle. All
> you need to do if you want to place the compose rectangle outside of the format
> rectangle is to just change the format rectangle first. If the driver supports
> composition then increasing the format rectangle will not change anything else,
> so that is a safe operation without side-effects.

Good!

> However, changing the crop rectangle *can* change the format rectangle. In the
> simple case of hardware that just supports cropping this is obvious, since
> the crop and format rectangles must always be of the same size, so changing
> one will change the other.

True, but, in such case, I'm in doubt if it is worth to implement crop API
support, as just format API support is enough. The drawback is that
userspace won't know how to differentiate between:

1) scaler, no-crop, where changing the format changes the scaler;
2) crop, no scaler, where changing the format changes the crop region.

That could easily be fixed with a new caps flag, to announce if a device 
has scaler or not.

> But if you throw in a scaler as well, you usually
> still have such constraints based on the scaler capabilities.
> 
> So assuming a scaler that can only scale 4 times (or less) up or down in each
> direction, then setting a crop rectangle of 240x160 will require that the
> format rectangle has a width in the range of 240/4 - 240*4 (60-960) and a
> height in the range of 160/4 - 160*4 (40-640). Anything outside of that will
> have to be corrected.

This can be done on two directions, e. g. rounding the crop area or
rounding the scaler area.

I is not obvious at all (nor backward compat) to change the format
rectangle when the crop rea is changed.

So, the best approach in this case is to round the crop rectangle to fit
into the scaler limits, preserving the format rectangle.

> 
> In my opinion this is valid behavior, and the specification also clearly
> specifies in the VIDIOC_S_CROP and VIDIOC_S_SELECTION documentation that the
> format may change after changing the crop rectangle.
> 
> Note that for output streams the role of crop and compose is swapped. So for
> output streams it is the crop rectangle that will always be constrained by
> the format rectangle, and it is the compose rectangle that might change the
> format rectangle based on scaler constraints.
> 
> I think this makes sense and unless there are comments this is what I plan
> to implement in my vivi rewrite which supports all these crop/compose/scale
> combinations.
> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
