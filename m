Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36979
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754709AbcLOMnN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 07:43:13 -0500
Subject: Re: [PATCH RFC] omap3isp: prevent releasing MC too early
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <20161214151406.20380-1-mchehab@s-opensource.com>
 <3043978.ViByGAdkJL@avalon> <20161215103734.716a0619@vento.lan>
Cc: Shuah Khan <shuahkh@osg.samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg KH <greg@kroah.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <e4f884d2-9746-a728-3f75-1aa211721f5e@osg.samsung.com>
Date: Thu, 15 Dec 2016 09:42:35 -0300
MIME-Version: 1.0
In-Reply-To: <20161215103734.716a0619@vento.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On 12/15/2016 09:37 AM, Mauro Carvalho Chehab wrote:

[snip]

> 
> What happens is that omap3isp driver calls media_device_unregister()
> too early. Right now, it is called at omap3isp_video_device_release(),
> with happens when a driver unbind is ordered by userspace, and not after
> the last usage of all /dev/video?? devices.
> 
> There are two possible fixes:
> 
> 1) at omap3isp_video_device_release(), streamoff all streams and mark
> that the media device will be gone.
> 
> 2) instead of using video_device_release_empty for the video->video.release,
> create a omap3isp_video_device_release() that will call
> media_device_unregister() when destroying the last /dev/video?? devnode.
>

There's also option (3), to have a proper refcounting to make sure that
the media device node is not freed until all references to it are gone.

I understand that's what Sakari's RFC patches do. I'll try to make some
time tomorrow to test and review his patches.
 
Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
