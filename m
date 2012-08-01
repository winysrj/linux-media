Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:39208 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681Ab2HAN3m convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Aug 2012 09:29:42 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 1 Aug 2012 21:29:30 +0800
Subject: RE: Query regarding the support and testing of MJPEG frame type in
 the UVC webcam gadget
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384FABF0D865@EAPEX1MAIL1.st.com>
References: <D5ECB3C7A6F99444980976A8C6D896384FABF0D740@EAPEX1MAIL1.st.com>
 <3577370.FUYPT1zGjj@avalon>
In-Reply-To: <3577370.FUYPT1zGjj@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for clearing this doubt..

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Wednesday, August 01, 2012 6:46 PM
> To: Bhupesh SHARMA
> Cc: linux-usb@vger.kernel.org; linux-media@vger.kernel.org
> Subject: Re: Query regarding the support and testing of MJPEG frame
> type in the UVC webcam gadget
> 
> Hi Bhupesh,
> 
> On Wednesday 01 August 2012 14:26:33 Bhupesh SHARMA wrote:
> > Hi Laurent,
> >
> > I have a query for you regarding the support and testing of MJPEG
> frame type
> > in the UVC webcam gadget.
> >
> > I see that in the webcam.c gadget, the 720p and VGA MJPEG uvc formats
> are
> > supported. I was trying the same out and got confused because the
> data
> > arriving from a real video capture video supporting JPEG will have no
> fixed
> > size. We will have the JPEG defined Start-of-Frame and End-of-Frame
> markers
> > defining the boundary of the JPEG frame.
> >
> > But for almost all JPEG video capture devices even if we have kept a
> frame
> > size of VGA initially, the final frame size will be a compressed
> version
> > (with the compression depending on the nature of the scene, so a flat
> scene
> > will have high compression and hence less frame size) of VGA and will
> not
> > be equal to 640 * 480.
> >
> > So I couldn't exactly get why the dwMaxVideoFrameBufferSize is kept
> as
> > 614400 in webcam.c (see [1]).
> 
> The dwMaxVideoFrameBufferSize value must be larger than or equal to the
> largest MJPEG frame size. As I have no idea what that value is, I've
> kept the
> same size as for uncompressed frames, which should be big enough (and
> most
> probably too big).

.. Yes, so that means that the user-space application should set the length
of the buffer being queued at the UVC side equal to the length of the buffer
dequeued from the V4L2 side, to ensure that varying length JPEG frames are
correctly handled.

I will try with these changes in the user-space daemon.

Thanks for your help,
Regards,
Bhupesh

> > Can you please let me know your opinions and how you tested the UVC
> gadget's
> > MJPEG frame format.
> >
> > [1] http://lxr.linux.no/linux+v3.5/drivers/usb/gadget/webcam.c#L232
> 
> --
> Regards,
> 
> Laurent Pinchart

