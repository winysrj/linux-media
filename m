Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39617 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab1KYM53 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 07:57:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC 1/2] v4l: Add a global color alpha control
Date: Fri, 25 Nov 2011 13:57:29 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	mchehab@redhat.com, m.szyprowski@samsung.com,
	jonghun.han@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
References: <1322131997-26195-1-git-send-email-s.nawrocki@samsung.com> <201111241500.23204.laurent.pinchart@ideasonboard.com> <4ECE6868.8000503@samsung.com>
In-Reply-To: <4ECE6868.8000503@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111251357.30605.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thursday 24 November 2011 16:53:12 Sylwester Nawrocki wrote:
> On 11/24/2011 03:00 PM, Laurent Pinchart wrote:
> > On Thursday 24 November 2011 13:22:10 Hans Verkuil wrote:
> >> On Thursday, November 24, 2011 13:06:09 Laurent Pinchart wrote:
> >>> On Thursday 24 November 2011 12:49:00 Hans Verkuil wrote:
> >>>> On Thursday, November 24, 2011 12:39:54 Sylwester Nawrocki wrote:
> >>>>> On 11/24/2011 12:09 PM, Laurent Pinchart wrote:
> >>>>>> On Thursday 24 November 2011 12:00:45 Hans Verkuil wrote:
> >>>>>>> On Thursday, November 24, 2011 11:53:16 Sylwester Nawrocki wrote:
> >> Well, if that's the case, then we already have an API for that
> >> (http://hverkuil.home.xs4all.nl/spec/media.html#v4l2-window, field
> >> global_alpha).
> >> 
> >> It was my understanding that this is used with a mem2mem device where
> >> you just want to fill in the alpha channel to the desired value. It's
> >> not used inside the device at all (that happens later in the pipeline).
> > 
> > OK, now I understand. Maybe the documentation should describe this a bit
> > more explicitly ?
> 
> I've modified the control description so now it is:
> 
> V4L2_CID_ALPHA_COMPONENT
> integer
> 

What about clarifying it further with something like

"When a mem-to-mem device produces a frame format that includes an alpha 
component (e.g. _packed RGB image_ formats), the alpha value is not defined by 
the mem-to-mem input data. This control lets you select the alpha component 
value of all pixels in such a case. It is applicable to any pixel format that 
contains an alpha component."

> And the part below Table 2.6
> 
> Bit 7 is the most significant bit. The value of a = alpha bits is undefined
> when reading from the driver, ignored when writing to the driver, except
> when alpha blending has been negotiated for a Video Overlay or Video
> Output Overlay or when alpha component has been configured for a Video
> Capture by means of V4L2_CID_ALPHA_COMPONENT control.

-- 
Regards,

Laurent Pinchart
