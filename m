Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:52190 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaDOVpe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 17:45:34 -0400
Received: by mail-ob0-f173.google.com with SMTP id wn1so3943753obc.4
        for <linux-media@vger.kernel.org>; Tue, 15 Apr 2014 14:45:34 -0700 (PDT)
Date: Tue, 15 Apr 2014 16:45:28 -0500 (CDT)
From: Thomas Pugliese <thomas.pugliese@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Thomas Pugliese <thomas.pugliese@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] uvc: update uvc_endpoint_max_bpi to handle USB_SPEED_WIRELESS
 devices
In-Reply-To: <1483439.ESi3RcYlPK@avalon>
Message-ID: <alpine.DEB.2.10.1404151553310.8128@mint32-virtualbox>
References: <1390598248-343-1-git-send-email-thomas.pugliese@gmail.com> <14957224.mkfABmkaAb@avalon> <alpine.DEB.2.10.1404142054390.22542@bitbucket> <1483439.ESi3RcYlPK@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 15 Apr 2014, Laurent Pinchart wrote:

> Hi Thomas,
> 
> 
> Could you please send me a proper revert patch with the above description in 
> the commit message and CC Mauro Carvalho Chehab <m.chehab@samsung.com> ?
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> 

Hi Laurent, 
I can submit a patch to revert but I should make a correction first.  I 
had backported this change to an earlier kernel (2.6.39) which was before 
super speed support was added and the regression I described was based on 
that kernel.  It was actually the addition of super speed support that 
broke windows compatible devices.  My previous change fixed spec compliant 
devices but left windows compatible devices broken.

Basically, the timeline of changes is this:

1.  Prior to the addition of super speed support (commit 
6fd90db8df379e215): all WUSB devices were treated as HIGH_SPEED devices.  
This is how Windows works so Windows compatible devices would work.  For 
spec compliant WUSB devices, the max packet size would be incorrectly 
calculated which would result in high-bandwidth isoc streams being unable 
to find an alt setting that provided enough bandwidth.

2.  After super speed support: all WUSB devices fell through to the 
default case of uvc_endpoint_max_bpi which would mask off the upper bits 
of the max packet size.  This broke both WUSB spec compliant and non 
compliant devices because no endpoint with a large enough bpi would be 
found.

3.  After 79af67e77f86404e77e: Spec compliant devices are fixed but 
non-spec compliant (although Windows compatible) devices are broken.  
Basically, this is the opposite of how it worked prior to super speed 
support.

Given that, I can submit a patch to revert 79af67e77f86404e77e but that 
would go back to having all WUSB devices broken.  Alternatively, the 
change below will revert the behavior back to scenario 1 where Windows 
compatible devices work but strictly spec complaint devices may not.

I can send a proper patch for whichever scenario you prefer.

Thomas


diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 8d52baf..ed594d6 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1451,11 +1451,9 @@ static unsigned int uvc_endpoint_max_bpi(struct usb_device *dev,
 	case USB_SPEED_SUPER:
 		return ep->ss_ep_comp.wBytesPerInterval;
 	case USB_SPEED_HIGH:
-		psize = usb_endpoint_maxp(&ep->desc);
-		return (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
 	case USB_SPEED_WIRELESS:
 		psize = usb_endpoint_maxp(&ep->desc);
-		return psize;
+		return (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
 	default:
 		psize = usb_endpoint_maxp(&ep->desc);
 		return psize & 0x07ff;


