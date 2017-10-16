Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:50770 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752075AbdJPLGf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Oct 2017 07:06:35 -0400
Subject: Re: [RFC PATCH 0/9] V4L2 Jobs API WIP
To: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20170928095027.127173-1-acourbot@chromium.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0442082f-f176-2be7-89c0-ccf6f563917a@xs4all.nl>
Date: Mon, 16 Oct 2017 13:06:30 +0200
MIME-Version: 1.0
In-Reply-To: <20170928095027.127173-1-acourbot@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexandre,

Thank you very much for working on this. Much appreciated!

I only did a very high-level review of the patch series: there is not much
point IMHO of doing a detailed review given the upcoming discussions in
Prague. It's better to wait until we agree with the high-level API.

Regarding the public API: the ioctls seem sane. It's all very similar to the
other implementations we've seen.

I'm still not sure about the name 'job', but this is 'just' a naming issue.

The part where I have more doubts is the need to create a new device node.

For the upcoming meeting I would like to discuss whether this cannot be added
to the media API.

Originally the plan was that the media API would be subsystem-agnostic and could
also be used by ALSA/DRM/etc. This never happened and I also am not aware of any
movement in that area.

I am wondering whether we should just be realistic and abandon the 'subsystem
agnostic' part and be willing to add e.g. the job support to the media API.

We can also consider controlling sub-devices via the media device node instead
of creating separate v4l-subdev device nodes.

This does not necessarily preclude the use of the media device by other
subsystems, but it certainly ties it much closer to the media subsystem. On the
other hand, it does make life easier for us (and I like easy!).

This is just a brainstorm at the moment, but I am interested what others think
of making /dev/mediaX specific to the media subsystem (at least we chose the
right name for that device node!).

Obviously, if we go into that direction, then that will have an obvious impact
on the jobs API, especially if we want to be able to control subdevs through the
media device instead of through the v4l-subdev devices.

Regards,

	Hans

On 09/28/2017 11:50 AM, Alexandre Courbot wrote:
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
> 
> Cheers,
> Alex.
> 
> Alexandre Courbot (9):
>   [media] v4l2-core: add v4l2_is_v4l2_file function
>   [media] v4l2-core: add core jobs API support
>   [media] videobuf2: add support for jobs API
>   [media] v4l2-ctrls: add support for jobs API
>   [media] v4l2-job: add generic jobs ops
>   [media] m2m: add generic support for jobs API
>   [media] vim2m: add jobs API support
>   [media] vivid: add jobs API support for capture device
>   [media] document jobs API
> 
>  Documentation/media/intro.rst                      |   2 +
>  Documentation/media/media_uapi.rst                 |   1 +
>  Documentation/media/uapi/jobs/jobs-api.rst         |  23 +
>  Documentation/media/uapi/jobs/jobs-example.rst     |  69 ++
>  Documentation/media/uapi/jobs/jobs-intro.rst       |  61 ++
>  Documentation/media/uapi/jobs/jobs-queue.rst       |  73 ++
>  Documentation/media/uapi/jobs/jobs-queue.svg       | 192 ++++++
>  .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          |   6 +
>  drivers/media/platform/vim2m.c                     |  24 +
>  drivers/media/platform/vivid/vivid-core.c          |  16 +
>  drivers/media/platform/vivid/vivid-core.h          |   2 +
>  drivers/media/platform/vivid/vivid-kthread-cap.c   |   5 +
>  drivers/media/v4l2-core/Makefile                   |   4 +-
>  drivers/media/v4l2-core/v4l2-ctrls.c               |  50 +-
>  drivers/media/v4l2-core/v4l2-dev.c                 |  12 +
>  drivers/media/v4l2-core/v4l2-job-generic.c         | 394 +++++++++++
>  drivers/media/v4l2-core/v4l2-jobqueue-dev.c        | 173 +++++
>  drivers/media/v4l2-core/v4l2-jobqueue.c            | 764 +++++++++++++++++++++
>  drivers/media/v4l2-core/v4l2-mem2mem.c             |  19 +
>  drivers/media/v4l2-core/videobuf2-core.c           |  33 +-
>  include/media/v4l2-ctrls.h                         |   6 +
>  include/media/v4l2-dev.h                           |  13 +
>  include/media/v4l2-fh.h                            |   4 +
>  include/media/v4l2-job-generic.h                   |  47 ++
>  include/media/v4l2-job-state.h                     |  75 ++
>  include/media/v4l2-jobqueue-dev.h                  |  24 +
>  include/media/v4l2-jobqueue.h                      |  54 ++
>  include/media/v4l2-mem2mem.h                       |  11 +
>  include/media/videobuf2-core.h                     |  16 +
>  include/uapi/linux/v4l2-jobs.h                     |  40 ++
>  include/uapi/linux/videodev2.h                     |   2 +
>  31 files changed, 2205 insertions(+), 10 deletions(-)
>  create mode 100644 Documentation/media/uapi/jobs/jobs-api.rst
>  create mode 100644 Documentation/media/uapi/jobs/jobs-example.rst
>  create mode 100644 Documentation/media/uapi/jobs/jobs-intro.rst
>  create mode 100644 Documentation/media/uapi/jobs/jobs-queue.rst
>  create mode 100644 Documentation/media/uapi/jobs/jobs-queue.svg
>  create mode 100644 drivers/media/v4l2-core/v4l2-job-generic.c
>  create mode 100644 drivers/media/v4l2-core/v4l2-jobqueue-dev.c
>  create mode 100644 drivers/media/v4l2-core/v4l2-jobqueue.c
>  create mode 100644 include/media/v4l2-job-generic.h
>  create mode 100644 include/media/v4l2-job-state.h
>  create mode 100644 include/media/v4l2-jobqueue-dev.h
>  create mode 100644 include/media/v4l2-jobqueue.h
>  create mode 100644 include/uapi/linux/v4l2-jobs.h
> 
