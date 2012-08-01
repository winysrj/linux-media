Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33759 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab2HANPl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2012 09:15:41 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bhupesh SHARMA <bhupesh.sharma@st.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Query regarding the support and testing of MJPEG frame type in the UVC webcam gadget
Date: Wed, 01 Aug 2012 15:15:47 +0200
Message-ID: <3577370.FUYPT1zGjj@avalon>
In-Reply-To: <D5ECB3C7A6F99444980976A8C6D896384FABF0D740@EAPEX1MAIL1.st.com>
References: <D5ECB3C7A6F99444980976A8C6D896384FABF0D740@EAPEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bhupesh,

On Wednesday 01 August 2012 14:26:33 Bhupesh SHARMA wrote:
> Hi Laurent,
> 
> I have a query for you regarding the support and testing of MJPEG frame type
> in the UVC webcam gadget.
> 
> I see that in the webcam.c gadget, the 720p and VGA MJPEG uvc formats are
> supported. I was trying the same out and got confused because the data
> arriving from a real video capture video supporting JPEG will have no fixed
> size. We will have the JPEG defined Start-of-Frame and End-of-Frame markers
> defining the boundary of the JPEG frame.
> 
> But for almost all JPEG video capture devices even if we have kept a frame
> size of VGA initially, the final frame size will be a compressed version
> (with the compression depending on the nature of the scene, so a flat scene
> will have high compression and hence less frame size) of VGA and will not
> be equal to 640 * 480.
> 
> So I couldn't exactly get why the dwMaxVideoFrameBufferSize is kept as
> 614400 in webcam.c (see [1]).

The dwMaxVideoFrameBufferSize value must be larger than or equal to the 
largest MJPEG frame size. As I have no idea what that value is, I've kept the 
same size as for uncompressed frames, which should be big enough (and most 
probably too big).

> Can you please let me know your opinions and how you tested the UVC gadget's
> MJPEG frame format.
> 
> [1] http://lxr.linux.no/linux+v3.5/drivers/usb/gadget/webcam.c#L232

-- 
Regards,

Laurent Pinchart

