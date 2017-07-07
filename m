Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:37656 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750892AbdGGKae (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 06:30:34 -0400
Subject: Re: RFC: Selecting which sensor discrete frame size to use
To: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <8ef53598-842b-227b-aae6-e437d9c1886a@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hugues FRUCHET <hugues.fruchet@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1bb4936f-56cb-5972-20c3-0bbab9729b35@xs4all.nl>
Date: Fri, 7 Jul 2017 12:30:29 +0200
MIME-Version: 1.0
In-Reply-To: <8ef53598-842b-227b-aae6-e437d9c1886a@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/07/17 11:03, Hans Verkuil wrote:
> Hi all,
> 
> Hugues wants to add cropping support to the stm32-dcmi driver. The problem he
> encountered is that the sensor driver has a list of discrete framesizes and
> that causes problems with the API.
> 
> Currently S_FMT is used to select which framesize to use. Which works fine as
> long as there is no crop or compose support. With that in the mix it is no
> longer clear whether S_FMT should change the crop rectangle or select the
> framesize.
> 
> This is not a new problem, it's been discussed before 4 years (!) ago:
> 
> http://www.spinics.net/lists/linux-media/msg65381.html
> 
> But apparently it has never been an issue until now.
> 
> Note that v4l2-compliance detects this specific case and complains about it.
> 
> I propose that we close this API hole by requiring that such sensors support
> the V4L2_SEL_TGT_NATIVE_SIZE selection target:
> 
> https://hverkuil.home.xs4all.nl/spec/uapi/v4l/v4l2-selection-targets.html
> 
> and set the V4L2_IN_CAP_NATIVE_SIZE input capability:
> 
> https://hverkuil.home.xs4all.nl/spec/uapi/v4l/vidioc-enuminput.html
> 
> The application called S_SELECTION(V4L2_SEL_TGT_NATIVE_SIZE) to select
> which frame size to use. It will act the same as S_STD and S_DV_TIMINGS
> for video receivers: it resets the format and crop/compose rectangles to
> the native size. After that everything works normally.

To be a bit more precise since the list of framesizes is specific to the
pixelformat or mediabus code: S_SELECTION(V4L2_SEL_TGT_NATIVE_SIZE) will
map it to the closest frame size available for the current pixelformat or
mediabus code. If the pixelformat/mbus code is changed then that driver will
map the current frame size to whatever is the closest frame size for the
new pixelformat/mbus code. Since it is quite rare to have different framesizes
for different pixelformat/codes this will in almost all cases just keep the
current frame size.

Regards,

	Hans

> 
> This is only needed for sensors that have multiple frame sizes and support
> cropping, composing and/or scaling. If it doesn't support any of this,
> then there is no need for this selection target since S_FMT is unambiguous
> in that case.
> 
> All the ingredients are already in place, all that is needed is to update
> the documentation and v4l2-compliance.
> 
> I looked at some of the sensors that appear to support both multiple framesizes
> and cropping and those that I looked at are at best dubious implementations.
> It is totally unclear which rectangle is cropped.
> 
> Comments are welcome.
> 
> Regards,
> 
> 	Hans
> 
