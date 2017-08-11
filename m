Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34201 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751521AbdHKJqU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Aug 2017 05:46:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH RESEND 0/3] v4l2-compat-ioctl32.c: better detect pointer controls
Date: Fri, 11 Aug 2017 12:46:37 +0300
Message-ID: <4610701.cORc3TMU1z@avalon>
In-Reply-To: <173e50c4-77ae-a718-46bd-01963e07785f@xs4all.nl>
References: <f7340d67-cf7c-3407-e59a-aa0261185e82@xs4all.nl> <cover.1502409182.git.mchehab@s-opensource.com> <173e50c4-77ae-a718-46bd-01963e07785f@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Friday 11 Aug 2017 08:05:03 Hans Verkuil wrote:
> On 11/08/17 02:16, Mauro Carvalho Chehab wrote:
> > In the past, only string controls were pointers. That changed when
> > compounded types got added, but the compat32 code was not updated.
> > 
> > We could just add those controls there, but maintaining it is flaw, as we
> > often forget about the compat code. So, instead, rely on the control type,
> > as this is always updated when new controls are added.
> > 
> > As both v4l2-ctrl and compat32 code are at videodev.ko module, we can
> > move the ctrl_is_pointer() helper function to v4l2-ctrl.c.
> 
> This series doesn't really solve anything:
> 
> - it introduces a circular dependency between two modules
> - it doesn't handle driver-custom controls (the old code didn't either). For
> example vivid has custom pointer controls.
> - it replaces a list of control IDs with a list of type IDs, which also has
> to be kept up to date.
> 
> I thought this over and I have a better and much simpler idea. I'll post a
> patch for that.

Wouldn't it be time to replace the large switch/case with an array of control 
information ? Maybe that was your better idea already :-)

> > ---
> > 
> > Re-sending this patch series, as it was c/c to the linux-doc ML by
> > mistake.
> > 
> > Mauro Carvalho Chehab (3):
> >   media: v4l2-ctrls.h: better document the arguments for v4l2_ctrl_fill
> >   media: v4l2-ctrls: prepare the function to be used by compat32 code
> >   media: compat32: reimplement ctrl_is_pointer()
> >  
> >  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 18 +---------
> >  drivers/media/v4l2-core/v4l2-ctrls.c          | 49 ++++++++++++++++++++--
> >  include/media/v4l2-ctrls.h                    | 28 ++++++++++-----
> >  3 files changed, 67 insertions(+), 28 deletions(-)

-- 
Regards,

Laurent Pinchart
