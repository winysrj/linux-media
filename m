Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38051 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab1BRK4H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Feb 2011 05:56:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Stephan Lachowsky <stephan.lachowsky@maxim-ic.com>
Subject: Re: [PATCH RFC] uvcvideo: Add support for MPEG-2 TS payload
Date: Fri, 18 Feb 2011 11:56:08 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-uvc-devel@lists.berlios.de" <linux-uvc-devel@lists.berlios.de>,
	"Hans Verkuil" <hverkuil@xs4all.nl>
References: <1296243305.17673.20.camel@svmlwks101> <201102171703.17164.laurent.pinchart@ideasonboard.com> <1297963118.2620.36.camel@svmlwks101>
In-Reply-To: <1297963118.2620.36.camel@svmlwks101>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102181156.09061.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Stephan,

On Thursday 17 February 2011 18:18:38 Stephan Lachowsky wrote:
> On Thu, 2011-02-17 at 08:03 -0800, Laurent Pinchart wrote:
> > On Friday 28 January 2011 20:35:05 Stephan Lachowsky wrote:
> > > Parse the UVC 1.0 and UVC 1.1 VS_FORMAT_MPEG2TS descriptors.
> > > This a stream based format, so we generate a dummy frame descriptor
> > > with a dummy frame interval range.
> > 
> > Thanks for the patch, and sorry for the late reply.
> 
> No worries, just glad to have the moss knocked off the stone.
> 
> > Don't you also need to implement support for the V4L2 MPEG CIDs ? I would
> > expect the driver to support at least the controls used to select the
> > MPEG format (MPEG2, TS), even if they're hardcoded to MPEG2-TS.
> 
> That would be possible, for the stream type there is your choice of
> MPEG2-TS so that is trivial. There are a very limited set of
> standardized controls that can be mapped: wKeyFrameRate, wPFrameRate,
> wCompQuality from the VS probe/commit (GOP size, B frames, bitrate).
> 
> Since these controls are optional in the spec, and an overly simplistic
> projection of the encoder's actual configuration space, device
> manufactures (typically) choose instead to use custom XUs that expose
> richer more representative ones.
> 
> Given this state of affairs, I think it would be prudent to blindly
> forward the data stream (Which is all, in essence, this patch enables)
> leaving the configuration to userspace.
> 
> I'm not suggesting we preclude adding XU -> MPEG2 CID mappings into
> uvcvideo later, just that as is this is a valuable step forward.

I agree with this, but I would still implement support for the 
V4L2_CID_MPEG_STREAM_TYPE control. MPEG applications expect it to be 
supported.

-- 
Regards,

Laurent Pinchart
