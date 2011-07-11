Return-path: <mchehab@localhost>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45397 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab1GKKnh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2011 06:43:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ming Lei <ming.lei@canonical.com>
Subject: Re: [PATCH] uvcvideo: add fix suspend/resume quirk for Microdia camera
Date: Mon, 11 Jul 2011 12:44:20 +0200
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
	Jeremy Kerr <jeremy.kerr@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <20110711174811.3c383595@tom-ThinkPad-T410>
In-Reply-To: <20110711174811.3c383595@tom-ThinkPad-T410>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107111244.21360.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi,

On Monday 11 July 2011 11:48:11 Ming Lei wrote:
> From 989d894a2af7ceadf2574f455d9e68779f4ae674 Mon Sep 17 00:00:00 2001
> From: Ming Lei <ming.lei@canonical.com>
> Date: Mon, 11 Jul 2011 17:04:31 +0800
> Subject: [PATCH] uvcvideo: add fix suspend/resume quirk for Microdia camera
> 
> We found this type(0c45:6437) of Microdia camera does not
> work(no stream packets sent out from camera any longer) after
> resume from sleep, but unbind/bind driver will work again.
> 
> So introduce the quirk of UVC_QUIRK_FIX_SUSPEND_RESUME to
> fix the problem for this type of Microdia camera.

Thank you for the patch.

[snip]

> +	/* For some buggy cameras, they will not work after wakeup, so
> +	 * do unbind in .usb_suspend and do rebind in .usb_resume to
> +	 * make it work again.
> +	 * */
> +	if (dev->quirks & UVC_QUIRK_FIX_SUSPEND_RESUME) {
> +		uvc_driver.driver.suspend = NULL;
> +		uvc_driver.driver.resume = NULL;
> +	} else {
> +		uvc_driver.driver.suspend = uvc_suspend;
> +		uvc_driver.driver.resume = uvc_resume;
> +	}
> +

That's unfortunately not acceptable as-is. If two cameras are connected to the 
system, and only one of them doesn't support suspend/resume, the other will be 
affected by your patch.

Have you tried to investigate why suspend/resume fails for the above-mentioned 
camera, instead of working around the problem ?

-- 
Regards,

Laurent Pinchart
