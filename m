Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47958 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab2DUPWW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Apr 2012 11:22:22 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: s5p-fimc VIDIOC_STREAMOFF bug
Date: Sat, 21 Apr 2012 17:22:07 +0200
Message-ID: <1671013.6k1K925o3Y@flatron>
In-Reply-To: <4F91A9E6.3060402@samsung.com>
References: <6126533.0OoG4qIlQU@flatron> <4F91A9E6.3060402@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Thanks for your response.

On Friday 20 of April 2012 20:24:38 Sylwester Nawrocki wrote:
> Hi Tomasz,
> 
> On 04/19/2012 11:45 PM, Tomasz Figa wrote:
> > Hi,
> > 
> > I have been working on adapting s5p-fimc driver for s3c6410 and
> > everything seems to be working just fine after some minor changes
> > (except minor loss of functionality - only codec path is supported,
> > but for most use cases it does not matter).
> > 
> > However I think that I have spotted a bug in capture stop / capture
> > suspend handling. In fimc_capture_state_cleanup() the
> > ST_CAPT_SUSPENDED status bit of fimc->state field is being set
> > regardless of suspend parameter, which confuses the driver that FIMC
> > is suspended and might not accept buffers into active queue and so
> > the driver will never start the capture process unless the device
> > gets closed and reopened (because of the condition checking the
> > count of active buffers).
> > 
> > In my fork for s3c6410 I have moved the set_bit call into
> > fimc_capture_suspend(), so the bit gets set only when the device gets
> > suspended. This seems to solve the problem and I do not see any
> > issues that this could introduce, so it might be a good solution.
> > 
> > Let me know if I am wrong in anything I have written.
> 
> Your conclusions are correct, there was indeed a bug like that.
> There is already a patch fixing this [1], but it is going to be available
> just from v3.4. I'm considering sending it to Greg for inclusion in the
> stable releases, after it gets upstream.

OK, I must have missed the patch. Good that it has been already noticed and 
fixed.

> Once I did some preliminary work for the s3c-fimc driver, but dropped
> this due to lack of time. If you ever decide you want to mainline your
> work, just send the patches to linux-media@vger.kernel.org (and perhaps
> also to samsung-soc and ARM Linux) for review.

I am not sure sure if there is any interest for more advanced support of 
S3C6410 going into mainline, but if such shows up I am ready to cooperate.

> 
> > Best regards,
> > Tomasz Figa
> 
> [1] http://patchwork.linuxtv.org/patch/10417
> 
> 
> Thanks,
