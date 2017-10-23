Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f43.google.com ([209.85.214.43]:48703 "EHLO
        mail-it0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750861AbdJWIpZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Oct 2017 04:45:25 -0400
Received: by mail-it0-f43.google.com with SMTP id c3so5022634itc.3
        for <linux-media@vger.kernel.org>; Mon, 23 Oct 2017 01:45:24 -0700 (PDT)
Received: from mail-it0-f45.google.com (mail-it0-f45.google.com. [209.85.214.45])
        by smtp.gmail.com with ESMTPSA id 23sm2209489itj.15.2017.10.23.01.45.23
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 23 Oct 2017 01:45:23 -0700 (PDT)
Received: by mail-it0-f45.google.com with SMTP id n195so5037888itg.0
        for <linux-media@vger.kernel.org>; Mon, 23 Oct 2017 01:45:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171019144343.2j34twk6dvodan2o@valkosipuli.retiisi.org.uk>
References: <20170928095027.127173-1-acourbot@chromium.org> <20171019144343.2j34twk6dvodan2o@valkosipuli.retiisi.org.uk>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 23 Oct 2017 17:45:01 +0900
Message-ID: <CAPBb6MV01ir0bGut06P9qR84MTx6Zj9cB6yz42HRtRrw0v8e-g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/9] V4L2 Jobs API WIP
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari, thanks for the feedback!

On Thu, Oct 19, 2017 at 11:43 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> Hi Alexandre,
>
> On Thu, Sep 28, 2017 at 06:50:18PM +0900, Alexandre Courbot wrote:
>> Hi everyone,
>>
>> Here is a new attempt at the "request" (which I propose to rename "jobs") API
>> for V4L2, hopefully in a manner that can converge to something that will be
>> merged. The core ideas should be easy to grasp for those familiar with the
>> previous attemps, yet there are a few important differences.
>>
>> Most notably, user-space does not need to explicitly allocate and manage
>> requests/jobs (but still can if this makes sense). We noticed that only specific
>> use-cases require such an explicit management, and opted for a jobs queue that
>> controls the flow of work over a set of opened devices. This should simplify
>> user-space code quite a bit, while still retaining the ability to manage states
>> explicitly like the previous request API proposals allowed to do.
>>
>> The jobs API defines a few new concepts that user-space can use to control the
>> workflow on a set of opened V4L2 devices:
>>
>> A JOB QUEUE can be created from a set of opened FDs that are part of a pipeline
>> and need to cooperate (be it capture, m2m, or media controller devices).
>>
>> A JOB can then be set up with regular (if slightly modified) V4L2 ioctls, and
>> then submitted to the job queue. Once the job queue schedules the job, its
>> parameters (controls, etc) are applied to the devices of the queue, and itsd
>> buffers are processed. Immediately after a job is submitted, the next job is
>> ready to be set up without further user action.
>>
>> Once a job completes, it must be dequeued and user-space can then read back its
>> properties (notably controls) at completion time.
>>
>> Internally, the state of jobs is managed through STATE HANDLERS. Each driver
>> supporting the jobs API needs to specify an implementation of a state handler.
>> Fortunately, most drivers can rely on the generic state handler implementation
>> that simply records and replays a job's parameter using standard V4L2 functions.
>> Thanks to this, adding jobs API support to a driver relying on the control
>> framework and vb2 only requires a dozen lines of codes.
>>
>> Drivers with specific needs or opportunities for optimization can however
>> provide their own implementation of a state handler. This may in particular be
>> beneficial for hardware that supports configuration or command buffers (thinking
>> about VSP1 here).
>>
>> This is still very early work, and focus has been on the following points:
>>
>> * Provide something that anybody can test (currently using vim2m and vivid),
>> * Reuse the current V4L2 APIs as much as possible,
>> * Remain flexible enough to accomodate the inevitable changes that will be
>>   requested,
>> * Keep line count low, even if functionality is missing at the moment.
>>
>> Please keep this in mind while going through the patches. In particular, at the
>> moment the parameters of a job are limited to integer controls. I know that much
>> more is expected, but V4L2 has quite a learning curve and I preferred to focus
>> on the general concepts for now. More is coming though! :)
>>
>> I have written two small example programs that demonstrate the use of this API:
>>
>> - With a codec device (vim2m): https://gist.github.com/Gnurou/34c35f1f8e278dad454b51578d239a42
>>
>> - With a capture device (vivid): https://gist.github.com/Gnurou/5052e6ab41e7c55164b75d2970bc5a04
>>
>> Considering the history with the request API, I don't expect everything proposed
>> here to be welcome or understood immediately. In particular I apologize for not
>> reusing any of the previous attempts - I was just more comfortable laying down
>> my ideas from scratch.
>>
>> If this proposal is not dismissed as complete garbage I will also be happy to
>> discuss it in-person at the mini-summit in Prague. :)
>
> Thank you for the initiative and the patchset.
>
> While reviewing this patchset, I'm concentrating primarily on the approach
> taken and the design, not so much in the actual implementation which I
> don't think matters much at this moment.

Thanks, that is exactly how I hoped things would go for the moment.

>
> It's difficult to avoid seeing many similarities with the Request API
> patches posted earlier on. And not only that, rather you have to start
> looking for the differences in what I could call details, while important
> design decisions could sometimes be only visible in what appear details at
> this point.

I was not quite sure whether I should base this work on one of the
existing patchsets (and in this case, which one) or start from
scratch. This being my first contribution to a new area of the kernel
for me, I decided to start from scratch as it would yield more
educative value.

>
> Both request and jobs APIs have the concept of a request, or a job, which
> is created by the user and then different buffers or controls can be bound
> to that request. (Other configuration isn't really excluded but it's
> non-trivial to implement in practice.) This is common for both.

Yes, the main difference being that the current proposal manages the
jobs flow implicitly by default, to ease the most common uses of this
API (codecs & camera). It still maintains the ability to control them
more finely similarly to the previous request API proposals.

>
> The differences begin however how the functionality within the scope is
> actieved, in particular:
>
> - A new user space interface (character device) is created for the jobs API
>   whereas requests use existing Media controller interface. Therefore the
>   jobs API is specific to V4L2. Consequently, the V4L2 jobs API may not
>   support Media controller link state changes through requests.

It is not clear to me why that is the case - could you elaborate on that a bit?

>
>   I don't see a reason why it should be this way, and I also see no reason
>   why there should be yet another user space interface for this purpose
>   alone: this is a clear drawback compared to handling this through the
>   Media device.

Yeah, as I discussed in my reply to Hans, this node is mostly here for
convenience reasons and I don't feel too strongly about it.

>
> - Controls and buffers are always bound to requests explicitly whereas for
>   jobs, this seems to be implicit based on associating the file handle
>   related to the relevant video device with the request.
>
>   There are advantages in the approach, but currently I'd see that they're
>   primarily related to not having to change the existing IOCTL argument
>   structs.

For controls, this is definitely not the case (see the newly
introduced V4L2_CTRL_WHICH_CURJOB_VAL flag for instance). Even when
using the jobs API, you can change controls on-the-fly without waiting
for the current job to be processed.

For other parameters, we need to decide whether it can make sense to
decouple them from jobs. In particular, allowing buffers to be
processed both from and out of the jobs queue seems difficult to
achieve in a consistent way, and may not make any sense semantically
speaking. This is why the meaning of QBUF/QDBUF depends on whether the
jobs API is in use for a particular opened node.

>
>   There lie problems, too, because of this: with requests (or jobs) it is
>   vitally important that the user will always have the information if a
>   buffer, control event etc. was related to a request (or not), and in
>   particular which request it was.
>
>   You could say that the user must keep track of this information but I'd
>   suppose it won't make it easier for the user no having an important piece
>   of information. Having this information as part of the IOCTL argument
>   struct is mandatory for e.g. events that the user doesn't have an ID to
>   compare with in order to find the related request.

When queuing buffers, it is quite obvious which job they will be
linked too, as it is the current one. We can return a job ID as an
output argument of the QJOB ioctl to make this easier to handle.

I need to look at the ioctl structures too see what is possible, but I
also see no drawbacks to associating a job ID to dequeued buffers if
there is space remaining.

>
>   Also --- when an association with a video devnode file descriptor and a
>   job with a request is made, when does it cease to exist? When the job is
>   released? When the job is done?

Association is made between a job queue (to which an undefined number
of jobs can be queued) and a set of device nodes. A job queue remains
active as long as its file descriptor is not closed. So the short
answer to your question is that the devnode remains part of the queue
until the file descriptor obtained by opening /dev/v4l2_jobqueue (and
initialized using VIDIOC_JOBQUEUE_INIT) is opened. This is of course
subject to change if /dev/v4l2_jobqueue disappears, but I would like
to retain the idea of managing the jobs queue via its own file
descriptor.

>
> There are smaller differences, not very important IMO:
>
> - Requests are removed once complete. This was done to simplify the
>   implementation and it could be added if it is seen reasonable to
>   implement and useful, neither of which is known.
>
> These are differences, I'd say, in the parts that are somewhat manageable
> in any way they're designed, and with rather easily understandable
> consequences from these design decisions. I still prefer the design choices
> made for the Request API (regarding device nodes and request association
> especially).

I suppose this is something we need to discuss thoroughly in Prague to
make sure we understand why we made different design decisions. I am
rather fond of the idea of associating a set of opened devices into a
jobs queue and think that this is necessary for some advanced cases
(MIPI camera notably).

>
> The hard stuff, e.g. how do you implement including non-buffer and
> non-control configuration into the request in a meaningful way in an actual
> driver I haven't seen yet. We'd need one driver to implement that, and in
> general case it likely requires locking scheme changes in MC, for instance.
> There are still use cases where this all isn't needed so there is a
> motivation to have less than full implementation in the mainline kernel.

You're right - I wanted to give a go at the easiest part first and
receive feedback on this. Also it is easiest for us (Google) to
evaluate this first step as it allows us to replace the config store
currently used in Chrome OS.

>
> Another matter is making videobuf2 helpful here: we should have, if not in
> the videobuf2 framework itself, then around it helper function(s) to manage
> the submission of buffers to a driver. You can get things working pretty
> easily but the error handling is very painful: what do you do, for
> instance, with buffers queued with a request if queueing the request itself
> fails, possibly because the user hasn't provided enough buffers with the
> request? Mark the buffers errorneous and return them to the user? Probably
> so, but that requires the user to dequeue the buffers and gather the
> request again. I presume this would only happen in special circumstances
> though, and not typically in an application using requests. This, and many
> other special cases still must be handled by the kernel.

Error handling is still pretty weak in that version. I would like to
get an overall agreement on the general direction before looking at
this more closely though, as I suppose getting things right will take
some time.

>
> Finally, I want to say that I like some aspects of the patchset, such as
> moving more things to the V4L2 framework from the driver. This would be
> very useful in helping driver implementation: V4L2 is very stream-centric
> and the configurations and buffers across device nodes have been
> essentially independent from API point of view. Associating the pieces of
> information together in requests would be painful to do in drivers. What
> the framework can do, still controlled by drivers, could help a lot here.
> This aspect wasn't much considered where the Request API work was left.

I am not sure whether this is obvious in this patchset, but the idea
is that while there is a default implementation that can easily be
used as-is by most drivers (which allows to keep the lines count in
vivid and vim2m low), a driver with more specific needs could still
write its own state handler, tailored to its needs. I am especially
thinking of VSP1 here, Laurent's implementation was designed with the
perspective of writing and reusing command buffers, and the same
result should be attainable with a custom state handler (while still
benefiting from some of the framework code).

But whether you write a custom state handler or use the generic one,
the current implementation still depends on VB2/control framework,
which means that older drivers (and notably uvc) could not make use of
the jobs API. I am not sure whether this would be considered a
problem.

>
> Still it shouldn't be forgotten that if the framework is geared towards
> helping drivers "running one job at a time" the scope will be limited to
> memory-to-memory devices; streaming devices, e.g. all kinds of cameras have
> multiple requests being processed simultaneously (or frames are bound to be
> lost, something we can't allow to happen due to framework design). And I
> believe the memory-to-memory devices are generally the easy case. That
> could be one option to start with, but at the same time we have to make it
> absolutely certain we will not paint ourselves to the corner: the V4L2 UAPI
> (or even KAPI) paint will take much longer to dry than the regular one.

There are several reasons why the current patchset is focused on m2m
devices (although vivid can be considered a regular camera case):
- As you said, it is the easiest use-case to implement,
- It is also the use-case we are the most interested in for Chrome OS,
so I am clearly biased towards it, :)
- My exposure to V4L2 is still limited, so I may not be able to see
the whole picture yet.

It is important though, that we consider all the cases that need to be
supported by the jobs API and I want to make it very clear that I am
not attempting to direct it towards our specific use. It is not clear
to me why some cameras would need multiple requests to be processed
simultaneously (neither is it clear how I could implement that using
the current design), so we definitely need to discuss this in Prague.
The current patchset is just to try and validate the general
direction, and get confidence that this scheme can support all that
needs to be supported.

Oh, I have also updated it to complete controls support, and now all
kinds of controls should work. Besides that the other changes are
minor improvements on things that were very clumsy, so not resending
another patchset here, but in case someone wants to have a look it is
on https://github.com/Gnurou/linux/commits/v4l2_jobs.

Thanks and see you all in Prague! I should be there from Thursday.

Alex.
