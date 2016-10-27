Return-path: <linux-media-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:36938 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S940018AbcJ0Nzj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 09:55:39 -0400
Date: Thu, 27 Oct 2016 11:18:47 +0100
From: Brian Starkey <brian.starkey@arm.com>
To: Gustavo Padovan <gustavo@padovan.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v2 9/9] drm: mali-dp: Add writeback out-fence support
Message-ID: <20161027101847.GC18708@e106950-lin.cambridge.arm.com>
References: <1477472108-27222-1-git-send-email-brian.starkey@arm.com>
 <1477472108-27222-10-git-send-email-brian.starkey@arm.com>
 <20161026214357.GH12629@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20161026214357.GH12629@joana>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 26, 2016 at 07:43:57PM -0200, Gustavo Padovan wrote:
>2016-10-26 Brian Starkey <brian.starkey@arm.com>:
>
>> If userspace has asked for an out-fence for the writeback, we add a
>> fence to malidp_mw_job, to be signaled when the writeback job has
>> completed.
>>
>> Signed-off-by: Brian Starkey <brian.starkey@arm.com>
>> ---
>>  drivers/gpu/drm/arm/malidp_hw.c |    5 ++++-
>>  drivers/gpu/drm/arm/malidp_mw.c |   18 +++++++++++++++++-
>>  drivers/gpu/drm/arm/malidp_mw.h |    3 +++
>>  3 files changed, 24 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/arm/malidp_hw.c b/drivers/gpu/drm/arm/malidp_hw.c
>> index 1689547..3032226 100644
>> --- a/drivers/gpu/drm/arm/malidp_hw.c
>> +++ b/drivers/gpu/drm/arm/malidp_hw.c
>> @@ -707,8 +707,11 @@ static irqreturn_t malidp_se_irq(int irq, void *arg)
>>  		unsigned long irqflags;
>>  		/*
>>  		 * We can't unreference the framebuffer here, so we queue it
>> -		 * up on our threaded handler.
>> +		 * up on our threaded handler. However, signal the fence
>> +		 * as soon as possible
>>  		 */
>> +		malidp_mw_job_signal(drm, malidp->current_mw, 0);
>
>Drivers should not deal with fences directly. We need some sort of
>drm_writeback_finished() that will do the signalling for you.
>

With a signature like this?
	drm_writeback_finished(struct drm_connector_state *state);

I'll have to think about how to achieve that. The state isn't
refcounted and the driver isn't in charge of it's lifetime. I'm not
sure how/where to ensure the state doesn't get destroyed before its
been signaled.

-Brian

>Gustavo
>
