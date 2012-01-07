Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:51956 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab2AGN70 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Jan 2012 08:59:26 -0500
Message-ID: <4F084FB0.8010607@infradead.org>
Date: Sat, 07 Jan 2012 11:59:12 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] v4l2: v4l2-fh: v4l2_fh_is_singular should use list head
 to test
References: <1324481454-30066-1-git-send-email-scott.jiang.linux@gmail.com> <20120104155413.GH9323@valkosipuli.localdomain> <CAHG8p1C6-gi045OeapO=uqnhRR-j5Lh5SFfYF-Q0uF3L_XBzEQ@mail.gmail.com> <20120105075739.GL9323@valkosipuli.localdomain>
In-Reply-To: <20120105075739.GL9323@valkosipuli.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05-01-2012 05:57, Sakari Ailus wrote:
> On Thu, Jan 05, 2012 at 10:52:02AM +0800, Scott Jiang wrote:
>> 2012/1/4 Sakari Ailus <sakari.ailus@iki.fi>:
>>> Hi Scott,
>>>
>>> Thanks for the patch.
>>>
>>> On Wed, Dec 21, 2011 at 10:30:54AM -0500, Scott Jiang wrote:
>>>> list_is_singular accepts a list head to test whether a list has just one entry.
>>>> fh->list is the entry, fh->vdev->fh_list is the list head.
>>>>
>>>> Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
>>>> ---
>>>>  drivers/media/video/v4l2-fh.c |    2 +-
>>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/drivers/media/video/v4l2-fh.c b/drivers/media/video/v4l2-fh.c
>>>> index 9e3fc04..8292c4a 100644
>>>> --- a/drivers/media/video/v4l2-fh.c
>>>> +++ b/drivers/media/video/v4l2-fh.c
>>>> @@ -113,7 +113,7 @@ int v4l2_fh_is_singular(struct v4l2_fh *fh)
>>>>       if (fh == NULL || fh->vdev == NULL)
>>>>               return 0;
>>>>       spin_lock_irqsave(&fh->vdev->fh_lock, flags);
>>>> -     is_singular = list_is_singular(&fh->list);
>>>> +     is_singular = list_is_singular(&fh->vdev->fh_list);
>>>>       spin_unlock_irqrestore(&fh->vdev->fh_lock, flags);
>>>>       return is_singular;
>>>>  }
>>>
>>> Is there an issue that this patch resolves, or am I missing something? As
>>> far as I can see, the list_is_singular() test returns the same result
>>> whether you are testing a list item which is part of the list, or its head
>>> in struct video_device.
>>>
>> Yes, the result is the same. But I don't think it's a good example
>> because it may abuse this api.
>> Can anybody figure out what this api needs you to pass in?  I confess
>> I am not sure about that.
> 
> That's true; it's more correct (and intuitive as well) to use the real list
> head for the purpose. But if the implementation really changed I bet a huge
> number of other things would break as well.
> 
> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> Hans: you wrote the patch adding this code (dfddb244); what do you think?

All those list functions can operate on any node of the list, since the
list is circular. So, there's not a real "head" for the list.

The function implementation shows that:

static inline void INIT_LIST_HEAD(struct list_head *list)
{
        list->next = list;
        list->prev = list;
}

...

static inline int list_is_singular(const struct list_head *head)
{
        return !list_empty(head) && (head->next == head->prev);
}

So, I prefer to not change it, _unless_ for some reason, you hit
a bug on it (for example, by not having one of the list pointers
filled).

Regards,
Mauro
> 
> Regards,
> 

