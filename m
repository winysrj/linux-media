Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34558 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932171AbeBVOwa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 09:52:30 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kelly Huang <kinghuangdk17@gmail.com>
Cc: Felipe Balbi <felipe.balbi@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        Paul Elder <paul.elder@pitt.edu>
Subject: Re: Some questions about the UVC gadget
Date: Thu, 22 Feb 2018 16:53:13 +0200
Message-ID: <17074466.0QZEqxoWO3@avalon>
In-Reply-To: <878tbl75w1.fsf@linux.intel.com>
References: <CAEjubf29Ne0XkJoZTqYfbt5xjw2iDw9hsHRuYzCvz9nYJtLpcQ@mail.gmail.com> <878tbl75w1.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Kelly,

(CC'ing Paul Elder)

On Thursday, 22 February 2018 11:03:42 EET Felipe Balbi wrote:
> Kelly Huang writes:
> >  Dear Mr.Balbi,
> > 
> > I am a college student from China. Recently, I am doing some research on
> > the UVC gadget. After reading the source code, I found that the uvc gadget
> > framework only supports two types of video streaming format, the
> > UNCOMPRESSED and the MJPEG.
> > 
> > Now, I am trying to add H.264 support. I wonder if the Linux kernel has
> > already support it or not. It will be appreciated if you can give me some
> > advice.
> > 
> > Thank you for your time.
> 
> It's a good idea to add mailing lists and other relevant people to the
> loop.

I'm afraid the Linux UVC gadget driver doesn't support H.264. While H.264 
support could be implemented using UVC 1.1, I wouldn't recommend this as the 
UVC 1.1 H.264 specification is a hack that is not and will not be supported in 
the Linux UVC host driver. UVC 1.5 is the way to go for H.264. This shouldn't 
be too difficult to implement on the gadget side, but the host UVC driver also 
misses UVC 1.5 support.

Paul has recently started working on the UVC gadget driver to revive it along 
with the userspace helper application. Further down on his to-do list he told 
me he would like to implement UVC 1.5 support on the host side, but that won't 
be for the near future (no pressure Paul :-)).

-- 
Regards,

Laurent Pinchart
