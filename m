Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53904 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753497AbdGJUdp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 16:33:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Hugues FRUCHET <hugues.fruchet@st.com>
Subject: Re: RFC: Selecting which sensor discrete frame size to use
Date: Mon, 10 Jul 2017 23:33:47 +0300
Message-ID: <2704939.3NU0AUPruZ@avalon>
In-Reply-To: <8ef53598-842b-227b-aae6-e437d9c1886a@xs4all.nl>
References: <8ef53598-842b-227b-aae6-e437d9c1886a@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 07 Jul 2017 11:03:07 Hans Verkuil wrote:
> Hi all,
> 
> Hugues wants to add cropping support to the stm32-dcmi driver. The problem
> he encountered is that the sensor driver has a list of discrete framesizes
> and that causes problems with the API.
> 
> Currently S_FMT is used to select which framesize to use. Which works fine
> as long as there is no crop or compose support. With that in the mix it is
> no longer clear whether S_FMT should change the crop rectangle or select
> the framesize.
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
> 
> This is only needed for sensors that have multiple frame sizes and support
> cropping, composing and/or scaling. If it doesn't support any of this,
> then there is no need for this selection target since S_FMT is unambiguous
> in that case.
> 
> All the ingredients are already in place, all that is needed is to update
> the documentation and v4l2-compliance.
> 
> I looked at some of the sensors that appear to support both multiple
> framesizes and cropping and those that I looked at are at best dubious
> implementations. It is totally unclear which rectangle is cropped.
> 
> Comments are welcome.

We've discussed this on IRC on Friday, here's a summary of (my understanding 
of) the solution we agreed with.

First of all, I believe there was a general consensus that sensor drivers 
supporting a restricted list of discrete resolutions (also known as "register 
lists" for the large list of register address and value pairs hardcoded in the 
driver for each resolution) are suboptimal. A sensor driver should expose the 
full extent of the sensor cropping and scaling capabilities. The most common 
excuse for not doing so is lack of documentation from the sensor vendor, but 
in many cases that's hardly more than an excuse.

Then, the behaviour of the frame size enumeration, selection and format 
operations is not well-defined in the V4L2 specification. For subdevs with 
sink and source pads, section 4.15.3.4 (https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/dev-subdev.html) defines how the selection rectangles and 
formats relate to each other and how they can be used to configure cropping, 
composing and scaling. For subdevs with source pads only (such as sensors), 
the specification isn't that clear.

Sensor drivers have historically applied cropping,through the selection API, 
before scaling, through the format API. This behaviour is not aligned with 
section 4.15.3.4, but can't be changed at the moment and should thus be 
implemented by all sensor drivers. This means that the crop rectangle set 
through S_SELECTION(V4L2_SEL_TGT_CROP) is applied on the full pixel array 
(reported through V4L2_SEL_TGT_NATIVE_SIZE) first, and then scaling is 
performed from the cropped size to the output size set with S_FMT.

The V4L2 subdev API also includes an operation (enum_frame_size) to enumerate 
possible frame sizes. This is aimed at supporting drivers that hardcode a 
discrete list of resolutions, but is also used by other drivers to report 
discrete scaling ratios. The operation should be replaced by a cleaner way to 
report scaling capabilities (assuming userspace needs to query scaling 
capabilities at all, which we're not sure of). In the meantime, drivers can 
keep using the operation to report scaling ratios, and the frame sizes should 
correspond to the scaled full pixel array without any cropping applied. Other 
uses of the operation should not be allowed.

(On a personal side note, we also have a enum_frame_interval operation which 
is even worse)

-- 
Regards,

Laurent Pinchart
