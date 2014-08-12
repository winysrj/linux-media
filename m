Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39596 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbaHLQeg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 12:34:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Udo van den Heuvel <udovdh@xs4all.nl>,
	USB list <linux-usb@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: Re: 3.15.6 USB issue with pwc cam
Date: Tue, 12 Aug 2014 18:35:16 +0200
Message-ID: <21335650.ENAaDBpIbk@avalon>
In-Reply-To: <53EA4057.4020103@xs4all.nl>
References: <53DCE329.4030106@xs4all.nl> <6676742.btapbsDqkp@avalon> <53EA4057.4020103@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 12 August 2014 18:27:03 Hans Verkuil wrote:
> On 08/12/2014 06:21 PM, Laurent Pinchart wrote:
> > Hi Hans,
> > 
> > On Tuesday 12 August 2014 17:38:55 Hans Verkuil wrote:
> >> On 08/12/2014 05:07 PM, Hans de Goede wrote:
> >>> On 08/07/2014 04:49 PM, Udo van den Heuvel wrote:
> >>>> On 2014-08-04 11:17, Laurent Pinchart wrote:
> >>>>> (CC'ing Hans de Goede, the pwc maintainer, and the linux-media mailing
> >>>>> list)
> >>> 
> >>> Thanks for the bug report. I've been looking into this, and there
> >>> seem to be 2 problems:
> >>> 
> >>> 1: xhci_hcd 0000:02:00.0: ERROR: unexpected command completion code
> >>> 0x11.
> >>> 
> >>> This seems to be what is causing things to not work with a usb-3 port
> >>> for you. Might be fixed by this commit:
> >>> https://git.kernel.org/cgit/linux/kernel/git/gregkh/usb.git/commit/drive
> >>> rs/usb/host?h=usb-next&id=3213b151387df0b95f4eada104f68eb1c1409cb3
> >>> 
> >>> Can you please do "lspci -nn", and then copy and paste the output here,
> >>> so that we can see what sort of xhci controller you've (and try to
> >>> reproduce the problem).
> >>> 
> >>> 2: The triggering of a WARN_ON in __vb2_queue_cancel() when called on
> >>> streamoff. I've been looking at the code and I cannot figure out why
> >>> this is triggering I'm afraid.
> >> 
> >> You can ignore this one.
> >> 
> >> The uvc driver is doing messy things with vb2 which causes this warning.
> >> That said, it will not break things for you. It is just a warning that
> >> the driver needs to be improved.
> > 
> > I can certainly take the blame when my code needs to be improved, but in
> > this case the webcam is supported by the pwc driver, not the uvc driver
> > :-)
>
> It was a bit confusing, but he has two problems: one pwc, one (the warning)
> for uvc.

Right, I've missed the second one, my bad. A similar issue was present with 
the pwc driver, which you have fixed in "[PATCH] pwc: fix WARN_ON" I believe.

I'll have a look at the uvcvideo issue. It can be ignored for now.

-- 
Regards,

Laurent Pinchart

