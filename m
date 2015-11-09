Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45286 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbbKIVXk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 16:23:40 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] [media] uvcvideo: Remain runtime-suspended at sleeps
Date: Mon, 09 Nov 2015 23:23:52 +0200
Message-ID: <5182419.7mg9xmtEix@avalon>
In-Reply-To: <CAAObsKCP4dTvOPB=XrZexauHmdC99JYkc6cYKoaT-vZjnLaynw@mail.gmail.com>
References: <1429284290-25153-3-git-send-email-tomeu.vizoso@collabora.com> <Pine.LNX.4.44L0.1504171331050.1319-100000@iolanthe.rowland.org> <CAAObsKCP4dTvOPB=XrZexauHmdC99JYkc6cYKoaT-vZjnLaynw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomeu,

On Monday 20 April 2015 09:11:36 Tomeu Vizoso wrote:
> On 17 April 2015 at 19:32, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Fri, 17 Apr 2015, Tomeu Vizoso wrote:
> >> When the system goes to sleep and afterwards resumes, a significant
> >> amount of time is spent suspending and resuming devices that were
> >> already runtime-suspended.
> >> 
> >> By setting the power.force_direct_complete flag, the PM core will ignore
> >> the state of descendant devices and the device will be let in
> >> runtime-suspend.
> >> 
> >> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> >> ---
> >> 
> >>  drivers/media/usb/uvc/uvc_driver.c | 2 ++
> >>  1 file changed, 2 insertions(+)
> >> 
> >> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> >> b/drivers/media/usb/uvc/uvc_driver.c index 5970dd6..ae75a70 100644
> >> --- a/drivers/media/usb/uvc/uvc_driver.c
> >> +++ b/drivers/media/usb/uvc/uvc_driver.c
> >> @@ -1945,6 +1945,8 @@ static int uvc_probe(struct usb_interface *intf,
> >> 
> >>                       "supported.\n", ret);
> >>       
> >>       }
> >> 
> >> +     intf->dev.parent->power.force_direct_complete = true;
> > 
> > This seems wrong.  The uvc driver is bound to intf, not to intf's
> > parent.  So it would be okay for the driver to set
> > intf->dev.power.force_direct_complete, but it's wrong to set
> > intf->dev.parent->power.force_direct_complete.
> 
> Agreed.

Do you plan to resubmit this patch series with the above fix ? I know you've 
had a hard time trying to find an approach that could get accepted, but please 
rest assured that your work on the uvcvideo driver is appreciated.

-- 
Regards,

Laurent Pinchart

