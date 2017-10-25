Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:53090 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932156AbdJYQTf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Oct 2017 12:19:35 -0400
Subject: Re: [RFC PATCH 0/9] V4L2 Jobs API WIP
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alexandre Courbot <acourbot@chromium.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <20170928095027.127173-1-acourbot@chromium.org>
 <20171019144343.2j34twk6dvodan2o@valkosipuli.retiisi.org.uk>
 <CAPBb6MV01ir0bGut06P9qR84MTx6Zj9cB6yz42HRtRrw0v8e-g@mail.gmail.com>
 <1554579.1lm2f1VjhL@avalon>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9546e2fa-3f6e-ccc2-58e6-785eb9361901@xs4all.nl>
Date: Wed, 25 Oct 2017 18:19:27 +0200
MIME-Version: 1.0
In-Reply-To: <1554579.1lm2f1VjhL@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/25/2017 05:48 PM, Laurent Pinchart wrote:
> Hello,
> 
> On Monday, 23 October 2017 11:45:01 EEST Alexandre Courbot wrote:
>> On Thu, Oct 19, 2017 at 11:43 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>>> On Thu, Sep 28, 2017 at 06:50:18PM +0900, Alexandre Courbot wrote:
>>>> Hi everyone,
>>>>
>>>> Here is a new attempt at the "request" (which I propose to rename "jobs")
>>>> API for V4L2, hopefully in a manner that can converge to something that
>>>> will be merged. The core ideas should be easy to grasp for those
>>>> familiar with the previous attemps, yet there are a few important
>>>> differences.
>>>>
>>>> Most notably, user-space does not need to explicitly allocate and manage
>>>> requests/jobs (but still can if this makes sense). We noticed that only
>>>> specific use-cases require such an explicit management, and opted for a
>>>> jobs queue that controls the flow of work over a set of opened devices.
>>>> This should simplify user-space code quite a bit, while still retaining
>>>> the ability to manage states explicitly like the previous request API
>>>> proposals allowed to do.
>>>>
>>>> The jobs API defines a few new concepts that user-space can use to
>>>> control the workflow on a set of opened V4L2 devices:
>>>>
>>>> A JOB QUEUE can be created from a set of opened FDs that are part of a
>>>> pipeline and need to cooperate (be it capture, m2m, or media controller
>>>> devices).
>>>>
>>>> A JOB can then be set up with regular (if slightly modified) V4L2 ioctls,
>>>> and then submitted to the job queue. Once the job queue schedules the
>>>> job, its parameters (controls, etc) are applied to the devices of the
>>>> queue, and itsd buffers are processed. Immediately after a job is
>>>> submitted, the next job is ready to be set up without further user
>>>> action.
>>>>
>>>> Once a job completes, it must be dequeued and user-space can then read
>>>> back its properties (notably controls) at completion time.
>>>>
>>>> Internally, the state of jobs is managed through STATE HANDLERS. Each
>>>> driver supporting the jobs API needs to specify an implementation of a
>>>> state handler. Fortunately, most drivers can rely on the generic state
>>>> handler implementation that simply records and replays a job's parameter
>>>> using standard V4L2 functions. Thanks to this, adding jobs API support
>>>> to a driver relying on the control framework and vb2 only requires a
>>>> dozen lines of codes.
>>>>
>>>> Drivers with specific needs or opportunities for optimization can however
>>>> provide their own implementation of a state handler. This may in
>>>> particular be beneficial for hardware that supports configuration or
>>>> command buffers (thinking about VSP1 here).
>>>>
>>>> This is still very early work, and focus has been on the following
>>>> points:
>>>>
>>>> * Provide something that anybody can test (currently using vim2m and
>>>> vivid),
>>>> * Reuse the current V4L2 APIs as much as possible,
>>>> * Remain flexible enough to accomodate the inevitable changes that will
>>>> be requested,
>>>> * Keep line count low, even if functionality is missing at the moment.
>>>>
>>>> Please keep this in mind while going through the patches. In particular,
>>>> at the moment the parameters of a job are limited to integer controls. I
>>>> know that much more is expected, but V4L2 has quite a learning curve and
>>>> I preferred to focus on the general concepts for now. More is coming
>>>> though! :)
>>>>
>>>> I have written two small example programs that demonstrate the use of
>>>> this API:
>>>>
>>>> - With a codec device (vim2m):
>>>> https://gist.github.com/Gnurou/34c35f1f8e278dad454b51578d239a42
>>>>
>>>> - With a capture device (vivid):
>>>> https://gist.github.com/Gnurou/5052e6ab41e7c55164b75d2970bc5a04
>>>>
>>>> Considering the history with the request API, I don't expect everything
>>>> proposed here to be welcome or understood immediately. In particular I
>>>> apologize for not reusing any of the previous attempts - I was just more
>>>> comfortable laying down my ideas from scratch.
>>>>
>>>> If this proposal is not dismissed as complete garbage I will also be
>>>> happy to discuss it in-person at the mini-summit in Prague. :)
>>>
>>> Thank you for the initiative and the patchset.
>>>
>>> While reviewing this patchset, I'm concentrating primarily on the approach
>>> taken and the design, not so much in the actual implementation which I
>>> don't think matters much at this moment.
>>
>> Thanks, that is exactly how I hoped things would go for the moment.
>>
>>> It's difficult to avoid seeing many similarities with the Request API
>>> patches posted earlier on. And not only that, rather you have to start
>>> looking for the differences in what I could call details, while important
>>> design decisions could sometimes be only visible in what appear details at
>>> this point.
>>
>> I was not quite sure whether I should base this work on one of the
>> existing patchsets (and in this case, which one) or start from
>> scratch. This being my first contribution to a new area of the kernel
>> for me, I decided to start from scratch as it would yield more
>> educative value.
> 
> What bothers me here is that we had a full day face to face meeting in Tokyo 
> back in June about this, where you presented this idea of how the userspace 
> API could look like. We went through the proposal point by point to discuss 
> potential issues, and for most points I recall agreeing that the changes 
> proposed compared to the previous request API RFC were introducing problems 
> that couldn't be easily solved. I walked out of the meeting understanding we 
> had an agreement to go back to an API quite similar to the previous RFC, in 
> particular with explicit request object management from userspace, and I now 
> see several months later an RFC that ignores all the conclusions of our 
> meeting.

Laurent, can you give a link to that RFC? Just so we all refer to the same
request API RFC. That will help with the discussion tomorrow.

Two notes: my hope is that by the end of Friday we have a public API that is
good enough for the codec use case and can be extended for the more generic
use case. We have codec drivers waiting to be mainlined for years now that are
blocked because of this. It's getting ridiculous. That also means that I don't
care all that much about the kernel API: ideally it will be suitable or
extensible for the generic use case, but if it isn't and needs to be reworked
substantially for the generic use case, then so be it. Obviously this is something
I hope we can avoid, but it would be much worse if the codec vendors would move
away from V4L2 and start using other suboptimal solutions just because we
can't reach an agreement.

As I said in the beginning: we don't have that option for the public API: that
does need some careful thought as we cannot change that later, we can only extend it.

Second note (just to throw it in the discussion): I've always thought that
controls are a good way to store state, including things like formats.

Having a single framework taking care of that would simplify things substantially.
With VIDIOC_S_EXT_CTRLS you can already set a large number of controls in one
ioctl.

This does require some (or a lot?) refactoring of the control framework as you rightly
mentioned in your email, but I'm willing to do that work.

Regards,

	Hans
