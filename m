Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:58603 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754591AbeDTMte (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Apr 2018 08:49:34 -0400
Subject: Re: [PATCH v8 2/2] media: video-i2c: add video-i2c driver
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Matt Ranostay <matt.ranostay@konsulko.com>
Cc: linux-media@vger.kernel.org
References: <20180406225231.13831-1-matt.ranostay@konsulko.com>
 <20180406225231.13831-3-matt.ranostay@konsulko.com>
 <20180418080355.7lla2nzododk74bv@valkosipuli.retiisi.org.uk>
 <CAJCx=gnhTi2jOakbnw5DKoeRc=MnOGt1Es2JiBX44FxfGEnffA@mail.gmail.com>
 <20180418103030.pp5vgmg5npc6buxl@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5ad38de4-8778-adac-316a-d276ff189172@xs4all.nl>
Date: Fri, 20 Apr 2018 14:49:29 +0200
MIME-Version: 1.0
In-Reply-To: <20180418103030.pp5vgmg5npc6buxl@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/18/18 12:30, Sakari Ailus wrote:
> On Wed, Apr 18, 2018 at 01:46:08AM -0700, Matt Ranostay wrote:
> 
> ...
> 
>> On Wed, Apr 18, 2018 at 1:03 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>>>> +             if (vid_cap_buf) {
>>>> +                     struct vb2_buffer *vb2_buf = &vid_cap_buf->vb.vb2_buf;
>>>> +                     void *vbuf = vb2_plane_vaddr(vb2_buf, 0);
>>>> +                     int ret = data->chip->xfer(data, vbuf);
>>>
>>> As the assignment in variable declaration does more than just initialise a
>>> variable, it'd be nice to make the assignment separately from the variable
>>> declaration.
>>
>> Guessing you mean it is that initialization here is getting pushed and
>> popped off the stack if the data isn't in a register?
> 
> No, just that functionality is placed where variables are declared. The
> code is easier to read if you separate the two. I.e.
> 
> int ret;
> 
> ret = ...->xfer();

Matt, I'm making a pull request for this v8. I've split up this line myself,
so no need to post a v9.

Regards,

	Hans

> 
>>
>>>
>>>> +
>>>> +                     vb2_buf->timestamp = ktime_get_ns();
>>>> +                     vid_cap_buf->vb.sequence = data->sequence++;
>>>> +                     vb2_buffer_done(vb2_buf, ret ?
>>>> +                             VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
>>>> +             }
>>>> +
>>>> +             schedule_delay = delay - (jiffies - start_jiffies);
>>>> +
>>>> +             if (time_after(jiffies, start_jiffies + delay))
>>>> +                     schedule_delay = delay;
>>>> +
>>>> +             schedule_timeout_interruptible(schedule_delay);
>>>> +     } while (!kthread_should_stop());
>>>> +
>>>> +     return 0;
>>>> +}
> 
