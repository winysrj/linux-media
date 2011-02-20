Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1284 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab1BTIr2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 Feb 2011 03:47:28 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: David Cohen <dacohen@gmail.com>
Subject: Re: [RFC/PATCH 0/1] Get rid of V4L2 internal device interface usage
Date: Sun, 20 Feb 2011 09:47:19 +0100
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi
References: <1298133347-26796-1-git-send-email-dacohen@gmail.com>
In-Reply-To: <1298133347-26796-1-git-send-email-dacohen@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201102200947.19706.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi David,

On Saturday, February 19, 2011 17:35:46 David Cohen wrote:
> Hi,
> 
> This is the first patch (set) version to remove V4L2 internal device interface.
> I have converted tcm825x VGA sensor to V4L2 sub device interface. I removed
> also some workarounds in the driver which doesn't fit anymore in its new
> interface.

Very nice! It looks good. I noticed that you didn't convert it to the control
framework yet, but after looking at the controls I think that it is probably
better if I do that anyway. There are several private controls in this driver,
and I will need to take a good look at those.

> TODO:
>  - Remove V4L2 int device interface from omap24xxcam driver.
>  - Define a new interface to handle xclk. OMAP3 ISP could be used as base.
>  - Use some base platform (probably N8X0) to add board code and test them.
>  - Remove V4L2 int device. :)

It would be so nice to have that API removed :-)

Regards,

	Hans

> 
> Br,
> 
> David
> ---
> 
> David Cohen (1):
>   tcm825x: convert driver to V4L2 sub device interface
> 
>  drivers/media/video/tcm825x.c |  369 ++++++++++++-----------------------------
>  drivers/media/video/tcm825x.h |    6 +-
>  2 files changed, 109 insertions(+), 266 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
