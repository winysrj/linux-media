Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47337 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab1KYN2l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 08:28:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC 1/2] v4l: Add a global color alpha control
Date: Fri, 25 Nov 2011 14:28:43 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	mchehab@redhat.com, m.szyprowski@samsung.com,
	jonghun.han@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
References: <1322131997-26195-1-git-send-email-s.nawrocki@samsung.com> <201111251357.30605.laurent.pinchart@ideasonboard.com> <4ECF971F.2030602@samsung.com>
In-Reply-To: <4ECF971F.2030602@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111251428.43609.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Friday 25 November 2011 14:24:47 Sylwester Nawrocki wrote:
> On 11/25/2011 01:57 PM, Laurent Pinchart wrote:
> > On Thursday 24 November 2011 16:53:12 Sylwester Nawrocki wrote:
> >> On 11/24/2011 03:00 PM, Laurent Pinchart wrote:
> >>> On Thursday 24 November 2011 13:22:10 Hans Verkuil wrote:
> >>>> On Thursday, November 24, 2011 13:06:09 Laurent Pinchart wrote:
> >>>>> On Thursday 24 November 2011 12:49:00 Hans Verkuil wrote:
> >>>>>> On Thursday, November 24, 2011 12:39:54 Sylwester Nawrocki wrote:
> >>>>>>> On 11/24/2011 12:09 PM, Laurent Pinchart wrote:
> >>>>>>>> On Thursday 24 November 2011 12:00:45 Hans Verkuil wrote:
> >>>>>>>>> On Thursday, November 24, 2011 11:53:16 Sylwester Nawrocki wrote:
> >>>> Well, if that's the case, then we already have an API for that
> >>>> (http://hverkuil.home.xs4all.nl/spec/media.html#v4l2-window, field
> >>>> global_alpha).
> >>>> 
> >>>> It was my understanding that this is used with a mem2mem device where
> >>>> you just want to fill in the alpha channel to the desired value. It's
> >>>> not used inside the device at all (that happens later in the
> >>>> pipeline).
> >>> 
> >>> OK, now I understand. Maybe the documentation should describe this a
> >>> bit more explicitly ?
> >> 
> >> I've modified the control description so now it is:
> >> 
> >> V4L2_CID_ALPHA_COMPONENT
> >> integer
> > 
> > What about clarifying it further with something like
> > 
> > "When a mem-to-mem device produces a frame format that includes an alpha
> > component (e.g. _packed RGB image_ formats), the alpha value is not
> > defined by the mem-to-mem input data. This control lets you select the
> > alpha component value of all pixels in such a case. It is applicable to
> > any pixel format that contains an alpha component."
> 
> Thanks for the help. Since there are also mem-to-mem devices that account
> an input alpha when producing an output frame (e.g. S5P SoC G2D IP block
> supports alpha blending), I would change that to:
> 
> 
>  "When a mem-to-mem device produces a frame format that includes an alpha
>  component (e.g. _packed RGB image_ formats) and the alpha value is not
> defined by the mem-to-mem input data this control lets you select the
> alpha component value of all pixels. It is applicable to any pixel format
> that contains an alpha component."

That sounds good to me.

> 
> OR
> 
>  "When data format of a frame produced by a mem-to-mem device includes an
> alpha component (e.g. _packed RGB image_ formats) and the alpha value is
> not defined by the mem-to-mem input data this control lets you select the
> alpha component value of all pixels. The control is applicable to any
> pixel format that contains an alpha component."
> 
> How do you think ?
> 
> >> And the part below Table 2.6
> >> 
> >> Bit 7 is the most significant bit. The value of a = alpha bits is
> >> undefined when reading from the driver, ignored when writing to the
> >> driver, except when alpha blending has been negotiated for a Video
> >> Overlay or Video Output Overlay or when alpha component has been
> >> configured for a Video Capture by means of V4L2_CID_ALPHA_COMPONENT
> >> control.

-- 
Regards,

Laurent Pinchart
