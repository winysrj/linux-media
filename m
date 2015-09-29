Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44411 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933513AbbI2Jjk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Sep 2015 05:39:40 -0400
Date: Tue, 29 Sep 2015 11:39:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
	sakari.ailus@linux.intel.com, andrew@lunn.ch, rpurdie@rpsys.net,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 12/12] media: flash: use led_set_brightness_sync for
 torch brightness
Message-ID: <20150929093937.GB9293@amd>
References: <1443445641-9529-1-git-send-email-j.anaszewski@samsung.com>
 <1443445641-9529-13-git-send-email-j.anaszewski@samsung.com>
 <20150928203747.GA19666@amd>
 <560A3D23.4010606@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <560A3D23.4010606@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue 2015-09-29 09:26:27, Jacek Anaszewski wrote:
> Hi Pavel,
> 
> Thanks for the review.
> 
> On 09/28/2015 10:37 PM, Pavel Machek wrote:
> >On Mon 2015-09-28 15:07:21, Jacek Anaszewski wrote:
> >>LED subsystem shifted responsibility for choosing between SYNC or ASYNC
> >>way of setting brightness from drivers to the caller. Adapt the wrapper
> >>to those changes.
> >
> >Umm. Maybe right patch, but wrong position in the queue, no?
> >
> >If I understand changelog correctly, LED flashes will be subtly broken
> >before this patch is applied.
> >
> >I guess this patch should be moved sooner so everything works at each
> >position in bisect...?
> 
> Moving it wouldn't improve anything. It would have to be merged with
> patch 7/12 [1]. However, as you mentioned, LED flashes before this
> patch will be broken only subtly, i.e. torch brightness will be set
> from a work queue task and not synchronously. It would be barely
> noticeable. Nonetheless, I can merge the patches in the next
> version of the patch set.

Ok, flash firing a tiny bit later is probably not huge problem. I
guess it is best to leave the patches as is.

Best regards,
								Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
