Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:38700 "EHLO arroyo.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934347AbcIUO63 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Sep 2016 10:58:29 -0400
Date: Wed, 21 Sep 2016 09:58:25 -0500
From: Bin Liu <b-liu@ti.com>
To: Felipe Balbi <felipe.balbi@linux.intel.com>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: Re: g_webcam Isoch high bandwidth transfer
Message-ID: <20160921145825.GB18578@uda0271908>
References: <20160920170441.GA10705@uda0271908>
 <871t0d4r72.fsf@linux.intel.com>
 <20160921132702.GA18578@uda0271908>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20160921132702.GA18578@uda0271908>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 21, 2016 at 08:27:02AM -0500, Bin Liu wrote:
> On Wed, Sep 21, 2016 at 11:01:21AM +0300, Felipe Balbi wrote:
> > 
> > Hi,
> > 
> > Bin Liu <b-liu@ti.com> writes:
> > > Hi,
> > >
> > > I am trying to check Isoch high bandwidth transfer with g_webcam.ko in
> > >  high-speed connection.
> > >
> > > First I hacked webcam.c as follows to enable 640x480@30fps mode.
> > >
> > > diff --git a/drivers/usb/gadget/legacy/webcam.c b/drivers/usb/gadget/legacy/webcam.c
> > > index 72c976b..9eb315f 100644
> > > --- a/drivers/usb/gadget/legacy/webcam.c
> > > +++ b/drivers/usb/gadget/legacy/webcam.c
> > > @@ -191,15 +191,15 @@ static const struct UVC_FRAME_UNCOMPRESSED(3) uvc_frame_yuv_360p = {
> > >         .bFrameIndex            = 1,
> > >         .bmCapabilities         = 0,
> > >         .wWidth                 = cpu_to_le16(640),
> > > -       .wHeight                = cpu_to_le16(360),
> > > +       .wHeight                = cpu_to_le16(480),
> > >         .dwMinBitRate           = cpu_to_le32(18432000),
> > >         .dwMaxBitRate           = cpu_to_le32(55296000),
> > > -       .dwMaxVideoFrameBufferSize      = cpu_to_le32(460800),
> > > -       .dwDefaultFrameInterval = cpu_to_le32(666666),
> > > +       .dwMaxVideoFrameBufferSize      = cpu_to_le32(614400),
> > > +       .dwDefaultFrameInterval = cpu_to_le32(333333),
> > >         .bFrameIntervalType     = 3,
> > > -       .dwFrameInterval[0]     = cpu_to_le32(666666),
> > > -       .dwFrameInterval[1]     = cpu_to_le32(1000000),
> > > -       .dwFrameInterval[2]     = cpu_to_le32(5000000),
> > > +       .dwFrameInterval[0]     = cpu_to_le32(333333),
> > > +       .dwFrameInterval[1]     = cpu_to_le32(666666),
> > > +       .dwFrameInterval[2]     = cpu_to_le32(1000000),
> > >  };
> > >
> > > then loaded g_webcam.ko as
> > >
> > > # modprobe g_webcam streaming_maxpacket=3072
> > >
> > > The endpoint descriptor showing on the host is
> > >
> > >       Endpoint Descriptor:
> > >         bLength                 7
> > >         bDescriptorType         5
> > >         bEndpointAddress     0x8d  EP 13 IN
> > >         bmAttributes            5
> > >           Transfer Type            Isochronous
> > >           Synch Type               Asynchronous
> > >           Usage Type               Data
> > >         wMaxPacketSize     0x1400  3x 1024 bytes
> > >         bInterval               1
> > >
> > > However the usb bus trace shows only one transaction with 1024-bytes packet in
> > > every SOF. The host only sends one IN packet in every SOF, I am expecting 2~3
> > > 1024-bytes transactions, since this would be required to transfer 640x480@30fps
> > > YUV frames in high-speed.
> > >
> > > DId I miss anything in the setup?
> > 
> > MUSB or DWC3? This looks like a UDC bug to me. Can you show a screenshot
> 
> Happened on both MUSB and DWC3.

Indeed, it is MUSB gadget driver problem.

> 
> > of your bus analyzer? When host sends IN token, are you replying with
> 
> The trace screenshot on DWC3 is attached.
> 
> > DATA0, DATA1 or DATA2?
> 
> Good hint! It is DATA0!
> 
> > 
> > -- 
> > balbi
> 
> Regards,
> -Bin.


