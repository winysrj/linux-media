Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44104 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751087AbdJSOnr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Oct 2017 10:43:47 -0400
Date: Thu, 19 Oct 2017 17:43:43 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Alexandre Courbot <acourbot@chromium.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/9] V4L2 Jobs API WIP
Message-ID: <20171019144343.2j34twk6dvodan2o@valkosipuli.retiisi.org.uk>
References: <20170928095027.127173-1-acourbot@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170928095027.127173-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexandre,

On Thu, Sep 28, 2017 at 06:50:18PM +0900, Alexandre Courbot wrote:
> Hi everyone,
> 
> Here is a new attempt at the "request" (which I propose to rename "jobs") API
> for V4L2, hopefully in a manner that can converge to something that will be
> merged. The core ideas should be easy to grasp for those familiar with the
> previous attemps, yet there are a few important differences.
> 
> Most notably, user-space does not need to explicitly allocate and manage
> requests/jobs (but still can if this makes sense). We noticed that only specific
> use-cases require such an explicit management, and opted for a jobs queue that
> controls the flow of work over a set of opened devices. This should simplify
> user-space code quite a bit, while still retaining the ability to manage states
> explicitly like the previous request API proposals allowed to do.
> 
> The jobs API defines a few new concepts that user-space can use to control the
> workflow on a set of opened V4L2 devices:
> 
> A JOB QUEUE can be created from a set of opened FDs that are part of a pipeline
> and need to cooperate (be it capture, m2m, or media controller devices).
> 
> A JOB can then be set up with regular (if slightly modified) V4L2 ioctls, and
> then submitted to the job queue. Once the job queue schedules the job, its
> parameters (controls, etc) are applied to the devices of the queue, and itsd
> buffers are processed. Immediately after a job is submitted, the next job is
> ready to be set up without further user action.
> 
> Once a job completes, it must be dequeued and user-space can then read back its
> properties (notably controls) at completion time.
> 
> Internally, the state of jobs is managed through STATE HANDLERS. Each driver
> supporting the jobs API needs to specify an implementation of a state handler.
> Fortunately, most drivers can rely on the generic state handler implementation
> that simply records and replays a job's parameter using standard V4L2 functions.
> Thanks to this, adding jobs API support to a driver relying on the control
> framework and vb2 only requires a dozen lines of codes.
> 
> Drivers with specific needs or opportunities for optimization can however
> provide their own implementation of a state handler. This may in particular be
> beneficial for hardware that supports configuration or command buffers (thinking
> about VSP1 here).
> 
> This is still very early work, and focus has been on the following points:
> 
> * Provide something that anybody can test (currently using vim2m and vivid),
> * Reuse the current V4L2 APIs as much as possible,
> * Remain flexible enough to accomodate the inevitable changes that will be
>   requested,
> * Keep line count low, even if functionality is missing at the moment.
> 
> Please keep this in mind while going through the patches. In particular, at the
> moment the parameters of a job are limited to integer controls. I know that much
> more is expected, but V4L2 has quite a learning curve and I preferred to focus
> on the general concepts for now. More is coming though! :)
> 
> I have written two small example programs that demonstrate the use of this API:
> 
> - With a codec device (vim2m): https://gist.github.com/Gnurou/34c35f1f8e278dad454b51578d239a42
> 
> - With a capture device (vivid): https://gist.github.com/Gnurou/5052e6ab41e7c55164b75d2970bc5a04
> 
> Considering the history with the request API, I don't expect everything proposed
> here to be welcome or understood immediately. In particular I apologize for not
> reusing any of the previous attempts - I was just more comfortable laying down
> my ideas from scratch.
> 
> If this proposal is not dismissed as complete garbage I will also be happy to
> discuss it in-person at the mini-summit in Prague. :)

Thank you for the initiative and the patchset.

While reviewing this patchset, I'm concentrating primarily on the approach
taken and the design, not so much in the actual implementation which I
don't think matters much at this moment.

It's difficult to avoid seeing many similarities with the Request API
patches posted earlier on. And not only that, rather you have to start
looking for the differences in what I could call details, while important
design decisions could sometimes be only visible in what appear details at
this point.

Both request and jobs APIs have the concept of a request, or a job, which
is created by the user and then different buffers or controls can be bound
to that request. (Other configuration isn't really excluded but it's
non-trivial to implement in practice.) This is common for both.

The differences begin however how the functionality within the scope is
actieved, in particular:

- A new user space interface (character device) is created for the jobs API
  whereas requests use existing Media controller interface. Therefore the
  jobs API is specific to V4L2. Consequently, the V4L2 jobs API may not
  support Media controller link state changes through requests.
  
  I don't see a reason why it should be this way, and I also see no reason
  why there should be yet another user space interface for this purpose
  alone: this is a clear drawback compared to handling this through the
  Media device.

- Controls and buffers are always bound to requests explicitly whereas for
  jobs, this seems to be implicit based on associating the file handle
  related to the relevant video device with the request.

  There are advantages in the approach, but currently I'd see that they're
  primarily related to not having to change the existing IOCTL argument
  structs.
  
  There lie problems, too, because of this: with requests (or jobs) it is
  vitally important that the user will always have the information if a
  buffer, control event etc. was related to a request (or not), and in
  particular which request it was.

  You could say that the user must keep track of this information but I'd
  suppose it won't make it easier for the user no having an important piece
  of information. Having this information as part of the IOCTL argument
  struct is mandatory for e.g. events that the user doesn't have an ID to
  compare with in order to find the related request.

  Also --- when an association with a video devnode file descriptor and a
  job with a request is made, when does it cease to exist? When the job is
  released? When the job is done?

There are smaller differences, not very important IMO:

- Requests are removed once complete. This was done to simplify the
  implementation and it could be added if it is seen reasonable to
  implement and useful, neither of which is known.

These are differences, I'd say, in the parts that are somewhat manageable
in any way they're designed, and with rather easily understandable
consequences from these design decisions. I still prefer the design choices
made for the Request API (regarding device nodes and request association
especially).

The hard stuff, e.g. how do you implement including non-buffer and
non-control configuration into the request in a meaningful way in an actual
driver I haven't seen yet. We'd need one driver to implement that, and in
general case it likely requires locking scheme changes in MC, for instance.
There are still use cases where this all isn't needed so there is a
motivation to have less than full implementation in the mainline kernel.

Another matter is making videobuf2 helpful here: we should have, if not in
the videobuf2 framework itself, then around it helper function(s) to manage
the submission of buffers to a driver. You can get things working pretty
easily but the error handling is very painful: what do you do, for
instance, with buffers queued with a request if queueing the request itself
fails, possibly because the user hasn't provided enough buffers with the
request? Mark the buffers errorneous and return them to the user? Probably
so, but that requires the user to dequeue the buffers and gather the
request again. I presume this would only happen in special circumstances
though, and not typically in an application using requests. This, and many
other special cases still must be handled by the kernel.

Finally, I want to say that I like some aspects of the patchset, such as
moving more things to the V4L2 framework from the driver. This would be
very useful in helping driver implementation: V4L2 is very stream-centric
and the configurations and buffers across device nodes have been
essentially independent from API point of view. Associating the pieces of
information together in requests would be painful to do in drivers. What
the framework can do, still controlled by drivers, could help a lot here.
This aspect wasn't much considered where the Request API work was left.

Still it shouldn't be forgotten that if the framework is geared towards
helping drivers "running one job at a time" the scope will be limited to
memory-to-memory devices; streaming devices, e.g. all kinds of cameras have
multiple requests being processed simultaneously (or frames are bound to be
lost, something we can't allow to happen due to framework design). And I
believe the memory-to-memory devices are generally the easy case. That
could be one option to start with, but at the same time we have to make it
absolutely certain we will not paint ourselves to the corner: the V4L2 UAPI
(or even KAPI) paint will take much longer to dry than the regular one.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
