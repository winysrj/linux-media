Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756011Ab0D0QJ5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Apr 2010 12:09:57 -0400
Message-ID: <4BD70C45.7030408@redhat.com>
Date: Tue, 27 Apr 2010 13:09:41 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Aguirre, Sergio" <saaguirre@ti.com>
CC: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] V4L: Events: Include slab.h explicitly
References: <1272380899-30398-1-git-send-email-saaguirre@ti.com> <A24693684029E5489D1D202277BE894454F77AEF@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894454F77AEF@dlee02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Aguirre, Sergio wrote:
> Sakari,
> 
> This patch is based on your event branch:
> 
> http://gitorious.org/omap3camera/mainline/commits/event
> 
> And is required on latest kernel to compile v4l2-event.c, to make use of kmalloc and other slab.h functions/defines.


True.

Sakari,

Please, add this patch on your series before any Makefile entries that would try to compile
the events interface (or just fold it to the patch that added v4l2-event.c).

Cheers,
Mauro.

> Regards,
> Sergio
> 
>> -----Original Message-----
>> From: Aguirre, Sergio
>> Sent: Tuesday, April 27, 2010 10:08 AM
>> To: Sakari Ailus
>> Cc: linux-media@vger.kernel.org; Aguirre, Sergio
>> Subject: [PATCH] V4L: Events: Include slab.h explicitly
>>
>> After commit ID:
>>
>>   commit de380b55f92986c1a84198149cb71b7228d15fbd
>>   Author: Tejun Heo <tj@kernel.org>
>>   Date:   Wed Mar 24 17:06:43 2010 +0900
>>
>>       percpu: don't implicitly include slab.h from percpu.h
>>
>> slab.h include was not longer implicitly included with sched.h.
>>
>> So, now we have to include slab.h explicitly.
>>
>> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
>> ---
>>  drivers/media/video/v4l2-event.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-
>> event.c
>> index aea4332..7f31cd2 100644
>> --- a/drivers/media/video/v4l2-event.c
>> +++ b/drivers/media/video/v4l2-event.c
>> @@ -26,6 +26,7 @@
>>  #include <media/v4l2-fh.h>
>>  #include <media/v4l2-event.h>
>>
>> +#include <linux/slab.h>
>>  #include <linux/sched.h>
>>
>>  int v4l2_event_init(struct v4l2_fh *fh)
>> --
>> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
