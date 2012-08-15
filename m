Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab2HOVxp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 17:53:45 -0400
Message-ID: <502C1A5F.7050308@redhat.com>
Date: Wed, 15 Aug 2012 18:53:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] stk1160: unlock on error path stk1160_set_alternate()
References: <20120814065948.GD4791@elgon.mountain> <CALF0-+WGaYErM5SrCGfOJFCS0yqjJ2Oa4+u3_GcHAXR3mwnBmQ@mail.gmail.com>
In-Reply-To: <CALF0-+WGaYErM5SrCGfOJFCS0yqjJ2Oa4+u3_GcHAXR3mwnBmQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-08-2012 07:51, Ezequiel Garcia escreveu:
> Hi Dan,
> 
> On Tue, Aug 14, 2012 at 3:59 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>> There are some unlocks missing on error.
>>
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>> ---
>> Applies on top of linux-next.
>>
>> diff --git a/drivers/media/video/stk1160/stk1160-v4l.c b/drivers/media/video/stk1160/stk1160-v4l.c
>> index 360bdbe..1ad4ac1 100644
>> --- a/drivers/media/video/stk1160/stk1160-v4l.c
>> +++ b/drivers/media/video/stk1160/stk1160-v4l.c
>> @@ -159,8 +159,9 @@ static bool stk1160_set_alternate(struct stk1160 *dev)
>>
>>  static int stk1160_start_streaming(struct stk1160 *dev)
>>  {
>> -       int i, rc;
>>         bool new_pkt_size;
>> +       int rc = 0;
>> +       int i;
>>
>>         /* Check device presence */
>>         if (!dev->udev)
>> @@ -183,7 +184,7 @@ static int stk1160_start_streaming(struct stk1160 *dev)
>>         if (!dev->isoc_ctl.num_bufs || new_pkt_size) {
>>                 rc = stk1160_alloc_isoc(dev);
>>                 if (rc < 0)
>> -                       return rc;
>> +                       goto out_unlock;
>>         }
>>
>>         /* submit urbs and enables IRQ */
>> @@ -192,7 +193,7 @@ static int stk1160_start_streaming(struct stk1160 *dev)
>>                 if (rc) {
>>                         stk1160_err("cannot submit urb[%d] (%d)\n", i, rc);
>>                         stk1160_uninit_isoc(dev);
>> -                       return rc;
>> +                       goto out_unlock;
>>                 }
>>         }
>>
>> @@ -205,9 +206,10 @@ static int stk1160_start_streaming(struct stk1160 *dev)
>>
>>         stk1160_dbg("streaming started\n");
>>
>> +out_unlock:
>>         mutex_unlock(&dev->v4l_lock);
>>
>> -       return 0;
>> +       return rc;
>>  }
>>
>>  /* Must be called with v4l_lock hold */
> 
> This and the other stk1160 patch looks good. I'll give them a test.

Ok, I'll merge them both, with your ack.

> 
> Thanks,
> Ezequiel.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

