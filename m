Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35288 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbeKMHA7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 02:00:59 -0500
Received: by mail-pl1-f194.google.com with SMTP id n4-v6so4900835plp.2
        for <linux-media@vger.kernel.org>; Mon, 12 Nov 2018 13:06:02 -0800 (PST)
MIME-Version: 1.0
References: <20181018180224.3392-1-ezequiel@collabora.com> <2ef1f827b032d1a03f7fb010346ec7ae2ff75b7b.camel@collabora.com>
 <c799ec2cf938e06a0ecbba770ed3344cd49d3af8.camel@bootlin.com>
In-Reply-To: <c799ec2cf938e06a0ecbba770ed3344cd49d3af8.camel@bootlin.com>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Mon, 12 Nov 2018 18:05:50 -0300
Message-ID: <CAAEAJfBMinxkUxzROq1zxmaBeemhRREHG4nH9BDLMFbh=ambwA@mail.gmail.com>
Subject: Re: [PATCH v5 0/5] Make sure .device_run is always called in
 non-atomic context
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 12 Nov 2018 at 13:52, Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
>
> Hi,
>
> On Sun, 2018-11-11 at 18:26 -0300, Ezequiel Garcia wrote:
> > On Thu, 2018-10-18 at 15:02 -0300, Ezequiel Garcia wrote:
> > > This series goal is to avoid drivers from having ad-hoc code
> > > to call .device_run in non-atomic context. Currently, .device_run
> > > can be called via v4l2_m2m_job_finish(), not only running
> > > in interrupt context, but also creating a nasty re-entrant
> > > path into mem2mem drivers.
> > >
> > > The proposed solution is to add a per-device worker that is scheduled
> > > by v4l2_m2m_job_finish, which replaces drivers having a threaded inte=
rrupt
> > > or similar.
> > >
> > > This change allows v4l2_m2m_job_finish() to be called in interrupt
> > > context, separating .device_run and v4l2_m2m_job_finish() contexts.
> > >
> > > It's worth mentioning that v4l2_m2m_cancel_job() doesn't need
> > > to flush or cancel the new worker, because the job_spinlock
> > > synchronizes both and also because the core prevents simultaneous
> > > jobs. Either v4l2_m2m_cancel_job() will wait for the worker, or the
> > > worker will be unable to run a new job.
> > >
> > > Patches apply on top of Request API and the Cedrus VPU
> > > driver.
> > >
> > > Tested with cedrus driver using v4l2-request-test and
> > > vicodec driver using gstreamer.
> > >
> > > Ezequiel Garcia (4):
> > >   mem2mem: Require capture and output mutexes to match
> > >   v4l2-ioctl.c: Simplify locking for m2m devices
> > >   v4l2-mem2mem: Avoid calling .device_run in v4l2_m2m_job_finish
> > >   media: cedrus: Get rid of interrupt bottom-half
> > >
> > > Sakari Ailus (1):
> > >   v4l2-mem2mem: Simplify exiting the function in __v4l2_m2m_try_sched=
ule
> > >
> > >  drivers/media/v4l2-core/v4l2-ioctl.c          | 47 +------------
> > >  drivers/media/v4l2-core/v4l2-mem2mem.c        | 66 ++++++++++++-----=
--
> > >  .../staging/media/sunxi/cedrus/cedrus_hw.c    | 26 ++------
> > >  3 files changed, 51 insertions(+), 88 deletions(-)
> > >
> >
> > Hans, Maxime:
> >
> > Any feedback for this?
>
> I just tested the whole series with the cedrus driver and everything
> looks good!
>

Good! So this means we can add a Tested-by for the entire series?

> Removing the interrupt bottom-half in favor of a workqueue in the core
> seems like a good way to simplify m2m driver development by avoiding
> per-driver workqueues or threaded irqs.
>

Thanks for the test!
--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
