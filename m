Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:45104 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750923AbeEUIPV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 04:15:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kelly Huang <kinghuangdk17@gmail.com>
Cc: Felipe Balbi <felipe.balbi@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        Paul Elder <paul.elder@pitt.edu>
Subject: Re: Some questions about the UVC gadget
Date: Mon, 21 May 2018 11:15:44 +0300
Message-ID: <1888439.YyroKcJ4jt@avalon>
In-Reply-To: <CAEjubf1oP162SEJjF6KgSheeJyvWMH3aSA5hND18Bh4SjQTvTw@mail.gmail.com>
References: <CAEjubf29Ne0XkJoZTqYfbt5xjw2iDw9hsHRuYzCvz9nYJtLpcQ@mail.gmail.com> <17074466.0QZEqxoWO3@avalon> <CAEjubf1oP162SEJjF6KgSheeJyvWMH3aSA5hND18Bh4SjQTvTw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Kelly,

Sorry for the late reply, your e-mail got buried in my inbox :-/

On Friday, 23 February 2018 05:36:55 EEST Kelly Huang wrote:
> Dear Mr.Pinchart,
> 
> > I'm afraid the Linux UVC gadget driver doesn't support H.264. While H.264
> > support could be implemented using UVC 1.1, I wouldn't recommend this as
> > the UVC 1.1 H.264 specification is a hack that is not and will not be
> > supported in the Linux UVC host driver. UVC 1.5 is the way to go for
> > H.264.
> 
> I have a  Logitech C920 usb camera which claims H.264 support. When I used
> it under my usb protocol analyzer, I found that one of the CS_INTERFACE
> descriptor had a VS_FORMAT_FRAME_BASED subtype, and the guidFormat is
> '48323634-1000-800000AA-389B71', including the 'H264' symbols.
> 
> I don't know if that is the way you talked about implementing H.264 using
> UVC 1.1? It seems that I need to rename some descriptors of the UVC gadget
> driver and write a userspace application to fill /dev/videoX with H.264
> streams. If so, can it work correctly?

I spoke a bit too fast in my previous e-mail. H.264 support with UVC 1.1 
should be OK, as long as you don't use the H.264 UVC 1.1 stream multiplexing 
method that allows transmitting multiple video streams over a single endpoint.

The support H.264 with UVC 1.1 you will need to create the corresponding 
descriptors, and to implement support in the userspace helper application for 
the H.264 extension unit (XU) defined in the UVC 1.1 specification.

-- 
Regards,

Laurent Pinchart
