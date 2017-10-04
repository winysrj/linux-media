Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56474 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751047AbdJDUJ0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Oct 2017 16:09:26 -0400
Message-ID: <1507147735.2981.54.camel@collabora.com>
Subject: Re: [PATCH v3 00/15] V4L2 Explicit Synchronization support
From: Gustavo Padovan <gustavo.padovan@collabora.com>
To: Brian Starkey <brian.starkey@arm.com>,
        Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        linux-kernel@vger.kernel.org, Jonathan.Chai@arm.com
Date: Wed, 04 Oct 2017 17:08:55 -0300
In-Reply-To: <20171002134116.GB22538@e107564-lin.cambridge.arm.com>
References: <20170907184226.27482-1-gustavo@padovan.org>
         <20171002134116.GB22538@e107564-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Brian,

On Mon, 2017-10-02 at 14:41 +0100, Brian Starkey wrote:
> Hi Gustavo,
> 
> On Thu, Sep 07, 2017 at 03:42:11PM -0300, Gustavo Padovan wrote:
> > From: Gustavo Padovan <gustavo.padovan@collabora.com>
> > 
> > Hi,
> > 
> > Refer to the documentation on the first patch for the details. The
> > previous
> > iteration is here: https://www.mail-archive.com/linux-media@vger.ke
> > rnel.org/msg118077.html
> > 
> > The 2nd patch proposes an userspace API for fences, then on patch 3
> > we
> > prepare to the addition of in-fences in patch 4, by introducing the
> > infrastructure on vb2 to wait on an in-fence signal before queueing
> > the
> > buffer in the driver.
> > 
> > Patch 5 fix uvc v4l2 event handling and patch 6 configure q->dev
> > for
> > vivid drivers to enable to subscribe and dequeue events on it.
> > 
> > Patches 7-9 enables support to notify BUF_QUEUED events, the event
> > send
> > to userspace the out-fence fd and the index of the buffer that was
> > queued.
> > 
> > Patches 10-11 add support to mark queues as ordered. Finally
> > patches 12
> > and 13 add more fence infrastructure to support out-fences, patch
> > 13 exposes
> > close_fd() and patch 14 adds support to out-fences.
> > 
> > It only works for ordered queues for now, see open question at the
> > end
> > of the letter.
> > 
> > Test tool can be found at:
> > https://git.collabora.com/cgit/user/padovan/v4l2-test.git/
> > 
> > Main Changes
> > ------------
> > 
> > * out-fences: change in behavior: the out-fence fd now comes out of
> > the
> > BUF_QUEUED event along with the buffer id.
> 
> The more I think about this, the more unfortunate it seems.
> Especially
> for our use-case (m2m engine which sits in front of the display
> processor to convert the format of some buffers), having to wait for
> the in-fence to signal before we can get an out-fence removes a lot
> of
> the advantages of having fences at all.

Does your m2m driver ensures ordering between the buffer queued to it?

> 
> Ideally, we'd like to queue up our m2m work (while the GPU is still
> rendering that buffer, holding the in-fence), immediately get the
> out-fence for the m2m work, and pass that to DRM as the in-fence for
> display. With the current behaviour we need to wait in userspace
> before we can pass the buffer to display.
> 
> Wouldn't it be possible to enforce that the buffers aren't queued
> out-of-order in VB2? An easy way might be to (in qbuf) set a buffer's
> ->in_fence to be a fence_array of all the ->in_fences from the
> buffers
> before it in the queue (and its own). That would then naturally order
> the enqueue-ing in the driver, and allow you to return the out-fence
> immediately.
> 
> This would also solve your output devices question from below - a
> buffer can never get queued in the driver until all of the buffers
> which were QBUF'd before it are queued in the driver.

What you say makes sense, what this proposal lacks the most now is
feedback regarding its usecases. We can create a control setting to
enforce ordering in the queue, if it's set we create the fence arrays.
For output devices this should be set by default.

Gustavo

-- 
Gustavo Padovan
Principal Software Engineer
Collabora Ltd.
