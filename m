Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58876
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751545AbdHKJAU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 Aug 2017 05:00:20 -0400
Date: Fri, 11 Aug 2017 06:00:07 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Daniel Mentz <danielmentz@google.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH RESEND 0/3] v4l2-compat-ioctl32.c: better detect pointer
 controls
Message-ID: <20170811060007.5849ad37@vento.lan>
In-Reply-To: <173e50c4-77ae-a718-46bd-01963e07785f@xs4all.nl>
References: <f7340d67-cf7c-3407-e59a-aa0261185e82@xs4all.nl>
        <cover.1502409182.git.mchehab@s-opensource.com>
        <173e50c4-77ae-a718-46bd-01963e07785f@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 11 Aug 2017 08:05:03 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 11/08/17 02:16, Mauro Carvalho Chehab wrote:
> > In the past, only string controls were pointers. That changed when compounded
> > types got added, but the compat32 code was not updated.
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

What two modules? both v4l2-ctrl and compat32 belong to the *same* module.
See the Makefile:

videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-clk.o \
			v4l2-async.o
ifeq ($(CONFIG_COMPAT),y)
  videodev-objs += v4l2-compat-ioctl32.o
endif

Both belong to videodev module. IMHO, the best is to move whatever
control check logic it might need to v4l2-ctrls.

> - it doesn't handle driver-custom controls (the old code didn't either). For
>   example vivid has custom pointer controls.

True.

> - it replaces a list of control IDs with a list of type IDs, which also has to
>   be kept up to date.

True, but at least after the patch, the ancillary function is together
with the code that handles the controls. Also, we don't introduce new
types too often.

> 
> I thought this over and I have a better and much simpler idea. I'll post a
> patch for that.

OK.

> 
> Regards,
> 
> 	Hans
> 
> > 
> > ---
> > 
> > Re-sending this patch series, as it was c/c to the linux-doc ML by mistake.
> > 
> > Mauro Carvalho Chehab (3):
> >   media: v4l2-ctrls.h: better document the arguments for v4l2_ctrl_fill
> >   media: v4l2-ctrls: prepare the function to be used by compat32 code
> >   media: compat32: reimplement ctrl_is_pointer()
> > 
> >  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 18 +---------
> >  drivers/media/v4l2-core/v4l2-ctrls.c          | 49 +++++++++++++++++++++++++--
> >  include/media/v4l2-ctrls.h                    | 28 ++++++++++-----
> >  3 files changed, 67 insertions(+), 28 deletions(-)
> >   
> 



Thanks,
Mauro
