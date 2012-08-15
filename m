Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:65176 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab2HOWCs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 18:02:48 -0400
MIME-Version: 1.0
In-Reply-To: <502C1A5F.7050308@redhat.com>
References: <20120814065948.GD4791@elgon.mountain>
	<CALF0-+WGaYErM5SrCGfOJFCS0yqjJ2Oa4+u3_GcHAXR3mwnBmQ@mail.gmail.com>
	<502C1A5F.7050308@redhat.com>
Date: Wed, 15 Aug 2012 19:02:45 -0300
Message-ID: <CALF0-+UYGrq01L63ekLPYc=2YLEAYP-2SGQUat-SEdFG2oFY3A@mail.gmail.com>
Subject: Re: [patch] [media] stk1160: unlock on error path stk1160_set_alternate()
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 15, 2012 at 6:53 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 14-08-2012 07:51, Ezequiel Garcia escreveu:
>> Hi Dan,
>>
>> On Tue, Aug 14, 2012 at 3:59 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>>> There are some unlocks missing on error.
>>>
>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>> ---
>>> Applies on top of linux-next.
>>>
>>> diff --git a/drivers/media/video/stk1160/stk1160-v4l.c b/drivers/media/video/stk1160/stk1160-v4l.c
>>> index 360bdbe..1ad4ac1 100644
>>> --- a/drivers/media/video/stk1160/stk1160-v4l.c
>>> +++ b/drivers/media/video/stk1160/stk1160-v4l.c
>>> @@ -159,8 +159,9 @@ static bool stk1160_set_alternate(struct stk1160 *dev)
>>>
>>>  static int stk1160_start_streaming(struct stk1160 *dev)
>>>  {
>>> -       int i, rc;
>>>         bool new_pkt_size;
>>> +       int rc = 0;
>>> +       int i;
>>>
>>>         /* Check device presence */
>>>         if (!dev->udev)
>>> @@ -183,7 +184,7 @@ static int stk1160_start_streaming(struct stk1160 *dev)
>>>         if (!dev->isoc_ctl.num_bufs || new_pkt_size) {
>>>                 rc = stk1160_alloc_isoc(dev);
>>>                 if (rc < 0)
>>> -                       return rc;
>>> +                       goto out_unlock;
>>>         }
>>>
>>>         /* submit urbs and enables IRQ */
>>> @@ -192,7 +193,7 @@ static int stk1160_start_streaming(struct stk1160 *dev)
>>>                 if (rc) {
>>>                         stk1160_err("cannot submit urb[%d] (%d)\n", i, rc);
>>>                         stk1160_uninit_isoc(dev);
>>> -                       return rc;
>>> +                       goto out_unlock;
>>>                 }
>>>         }
>>>
>>> @@ -205,9 +206,10 @@ static int stk1160_start_streaming(struct stk1160 *dev)
>>>
>>>         stk1160_dbg("streaming started\n");
>>>
>>> +out_unlock:
>>>         mutex_unlock(&dev->v4l_lock);
>>>
>>> -       return 0;
>>> +       return rc;
>>>  }
>>>
>>>  /* Must be called with v4l_lock hold */
>>
>> This and the other stk1160 patch looks good. I'll give them a test.
>
> Ok, I'll merge them both, with your ack.

That's fine.

Thanks,
Ezequiel.
