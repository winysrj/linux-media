Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:33571 "EHLO
        mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935134AbeEYHbT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 25 May 2018 03:31:19 -0400
Received: by mail-vk0-f68.google.com with SMTP id 200-v6so524015vkc.0
        for <linux-media@vger.kernel.org>; Fri, 25 May 2018 00:31:19 -0700 (PDT)
MIME-Version: 1.0
References: <1526886658-14417-1-git-send-email-bingbu.cao@intel.com>
 <1526963581-28655-1-git-send-email-bingbu.cao@intel.com> <20180522200848.GB15035@w540>
 <20180523073833.onxqj72hi23qkz42@paasikivi.fi.intel.com> <20180524200738.GD18369@w540>
 <20180524204733.s2ijd3t2izztvjnv@kekkonen.localdomain> <CAAFQd5CtOkGmGsixJg1XO-stwY=+DSGdQhR28SieHN-vHfPY9g@mail.gmail.com>
 <20180525071205.GH18369@w540>
In-Reply-To: <20180525071205.GH18369@w540>
From: Tomasz Figa <tfiga@google.com>
Date: Fri, 25 May 2018 16:31:07 +0900
Message-ID: <CAAFQd5Bo3NVNYU=Mbk26u_obiio7h+5avbaom-S5kyThW55uwA@mail.gmail.com>
Subject: Re: [PATCH v3] media: imx319: Add imx319 camera sensor driver
To: jacopo@jmondi.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Cao Bing Bu <bingbu.cao@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        bingbu.cao@linux.intel.com, tian.shu.qiu@linux.intel.com,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 25, 2018 at 4:12 PM jacopo mondi <jacopo@jmondi.org> wrote:

> Hi Tomasz,

> On Fri, May 25, 2018 at 03:18:38PM +0900, Tomasz Figa wrote:
> > On Fri, May 25, 2018 at 5:47 AM Sakari Ailus <
sakari.ailus@linux.intel.com>
> > wrote:
> >
> > > Hi Jacopo,
> >
> > > On Thu, May 24, 2018 at 10:07:38PM +0200, jacopo mondi wrote:
> > > ...
> > > > > > about that, but I wonder why setting controls should be enabled
only
> > > > > > when streaming. I would have expected runtime_pm_get/put in
> > subdevices
> > > > > > node open/close functions not only when streaming. Am I missing
> > something?
> > > > >
> > > > > You can do it either way. If powering on the sensor takes a long
> > time, then
> > > > > doing that in the open callback may be helpful as the user space
has
> > a way
> > > > > to keep the device powered.
> > > >
> > > > Ok, so I assume my comment could be ignored, assuming is fine not
> > > > being able to set control if the sensor is not streaming. Is it?
> >
> > > I'd say so. From the user's point of view, the sensor doesn't really
do
> > > anything when it's in software standby mode.
> >
> > Just to make sure we're on the same page, the code actually does nothing
> > when the sensor is not in streaming mode (i.e. powered off). When
stream is
> > being started, the V4L2 control framework will call s_ctrl for all the
> > controls in the handler to synchronize hardware state and this is when
all
> > the controls set before powering on will actually be programmed into the
> > hardware registers.

> Thanks, I had missed that part.

> I quickly tried searching for 's_ctrl' calls in the v4l2-core/ code
> and I've found nothing that invokes that in response to a streaming
> start operation. Just if you happen to have any reference handy, could
> you please point me to that part, just for my better understanding?

The driver does it itself by calling __v4l2_ctrl_handler_setup() from its
.start_streaming() callback.

Best regards,
Tomasz
