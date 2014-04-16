Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58574 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376AbaDPLGC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 07:06:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Thomas Pugliese <thomas.pugliese@gmail.com>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] uvc: update uvc_endpoint_max_bpi to handle USB_SPEED_WIRELESS devices
Date: Wed, 16 Apr 2014 13:06:04 +0200
Message-ID: <1482714.CWOKDIksaK@avalon>
In-Reply-To: <alpine.DEB.2.10.1404151553310.8128@mint32-virtualbox>
References: <1390598248-343-1-git-send-email-thomas.pugliese@gmail.com> <1483439.ESi3RcYlPK@avalon> <alpine.DEB.2.10.1404151553310.8128@mint32-virtualbox>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

(CC'ing the linux-usb mailing list)

On Tuesday 15 April 2014 16:45:28 Thomas Pugliese wrote:
> On Tue, 15 Apr 2014, Laurent Pinchart wrote:
> > Hi Thomas,
> > 
> > Could you please send me a proper revert patch with the above description
> > in the commit message and CC Mauro Carvalho Chehab <m.chehab@samsung.com>
> > ?
>
> Hi Laurent,
> I can submit a patch to revert but I should make a correction first.  I
> had backported this change to an earlier kernel (2.6.39) which was before
> super speed support was added and the regression I described was based on
> that kernel.  It was actually the addition of super speed support that
> broke windows compatible devices.  My previous change fixed spec compliant
> devices but left windows compatible devices broken.
> 
> Basically, the timeline of changes is this:
> 
> 1.  Prior to the addition of super speed support (commit
> 6fd90db8df379e215): all WUSB devices were treated as HIGH_SPEED devices.
> This is how Windows works so Windows compatible devices would work.  For
> spec compliant WUSB devices, the max packet size would be incorrectly
> calculated which would result in high-bandwidth isoc streams being unable
> to find an alt setting that provided enough bandwidth.
> 
> 2.  After super speed support: all WUSB devices fell through to the
> default case of uvc_endpoint_max_bpi which would mask off the upper bits
> of the max packet size.  This broke both WUSB spec compliant and non
> compliant devices because no endpoint with a large enough bpi would be
> found.
> 
> 3.  After 79af67e77f86404e77e: Spec compliant devices are fixed but
> non-spec compliant (although Windows compatible) devices are broken.
> Basically, this is the opposite of how it worked prior to super speed
> support.
> 
> Given that, I can submit a patch to revert 79af67e77f86404e77e but that
> would go back to having all WUSB devices broken.  Alternatively, the
> change below will revert the behavior back to scenario 1 where Windows
> compatible devices work but strictly spec complaint devices may not.
> 
> I can send a proper patch for whichever scenario you prefer.

Thank you for the explanation.

Reverting 79af67e77f86404e77e doesn't seem like a very good idea, given that 
all WUSB devices will be broken. We thus have two options:

- leaving the code as-is, with support for spec-compliant WUSB devices but not 
for microsoft-specific devices 

- applying the patch below, with support for microsoft-specific USB devices 
but not for spec-compliant devices

This isn't the first time this kind of situation occurs. Microsoft didn't 
support multiple configurations before Windows 8, making vendors come up with 
lots of "creative" MS-specific solutions. I consider those devices non USB 
compliant, and they should not be allowed to use the USB logo, but that would 
require a strong political move from the USB Implementers Forum which is more 
or less controlled by Microsoft... Welcome to the USB mafia.

Anyway, I have no experience with WUSB devices, so I don't know what's more 
common in the wild. What would you suggest ? Would there be a way to support 
both categories of devices ?

> diff --git a/drivers/media/usb/uvc/uvc_video.c
> b/drivers/media/usb/uvc/uvc_video.c index 8d52baf..ed594d6 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -1451,11 +1451,9 @@ static unsigned int uvc_endpoint_max_bpi(struct
> usb_device *dev, case USB_SPEED_SUPER:
>  		return ep->ss_ep_comp.wBytesPerInterval;
>  	case USB_SPEED_HIGH:
> -		psize = usb_endpoint_maxp(&ep->desc);
> -		return (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
>  	case USB_SPEED_WIRELESS:
>  		psize = usb_endpoint_maxp(&ep->desc);
> -		return psize;
> +		return (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
>  	default:
>  		psize = usb_endpoint_maxp(&ep->desc);
>  		return psize & 0x07ff;

-- 
Regards,

Laurent Pinchart

