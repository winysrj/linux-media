Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58448 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758133Ab2CTPhX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 11:37:23 -0400
Received: by dajr28 with SMTP id r28so168071daj.19
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2012 08:37:23 -0700 (PDT)
Date: Tue, 20 Mar 2012 08:37:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: volokh <volokh@telros.ru>
Cc: linux-media@vger.kernel.org, devel@linuxdriverproject.org
Subject: Re: [PATCH] go7007 patch for 3.2.x
Message-ID: <20120320153717.GB4458@kroah.com>
References: <1332257451.6182.60.camel@VPir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332257451.6182.60.camel@VPir>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 20, 2012 at 07:30:51PM +0400, volokh wrote:
> please reply this at linux-media@vger.kernel.org I`ve some trouble
> 
> - add new tuning option for card(
>     V4L2_MPEG_VIDEO_ENCODING_H263
>     ,V4L2_CID_MPEG_VIDEO_B_FRAMES)
> - add framesizes&frameintervals control
> - tested&realize motion detector control(
>     GO7007IOC_REGION_NUMBER
>     ,GO7007IOC_PIXEL_THRESOLD
>     ,GO7007IOC_MOTION_THRESOLD
>     ,GO7007IOC_TRIGGER
>     ,GO7007IOC_REGION_CONTROL
>     ,GO7007IOC_CLIP_LEFT
>     ,GO7007IOC_CLIP_TOP
>     ,GO7007IOC_CLIP_WIDTH
>     ,GO7007IOC_CLIP_HEIGHT)
> 
> Tested with  Angelo PCI-MPG24(Adlink) with go7007&tw2804 onboard
> Regards Volokh
> 
> diff -uprN -X linux-3.2.11-vanilla/Documentation/dontdiff linux-3.2.11-vanilla/drivers/staging/media/go7007/go7007.h linux-3.2.11/drivers/staging/media/go7007/go7007.h

You would need to make this at least against the 3.3 kernel, preferably
against the linux-next branch.

Also, you didn't read the Documentation/SubmittingPatches file, please
follow it properly, otherwise there is nothing we can do with your patch :(
