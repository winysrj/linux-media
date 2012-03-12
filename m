Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:41116 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752167Ab2CLKOD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Mar 2012 06:14:03 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	spear-devel <spear-devel@list.st.com>
Date: Mon, 12 Mar 2012 18:13:18 +0800
Subject: RE: [PATCH 1/1] V4L/v4l2-dev: Make 'videodev_init' as a subsys
 initcall
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384FA2BA211E@EAPEX1MAIL1.st.com>
References: <bbe7861cb38c036d3c24df908ffbfc125274ea99.1331543025.git.bhupesh.sharma@st.com>
 <2051000.HEIejvjnKb@avalon>
In-Reply-To: <2051000.HEIejvjnKb@avalon>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your review comments.

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Monday, March 12, 2012 3:35 PM
> To: Bhupesh SHARMA
> Cc: linux-media@vger.kernel.org; spear-devel
> Subject: Re: [PATCH 1/1] V4L/v4l2-dev: Make 'videodev_init' as a subsys
> initcall
> 
> Hi Bhupesh,
> 
> Thanks for the patch.
> 
> On Monday 12 March 2012 14:39:02 Bhupesh Sharma wrote:
> > As the V4L2 based UVC webcam gadget (g_webcam) expects the
> > 'videodev' to present when the 'webcam_bind' routine is called,
> > so 'videodev' should be available as early as possible.
> >
> > Now, when 'g_webcam' is built as a module (i.e. not a part of
> > kernel) the late availability of 'videodev' is OK, but if
> > 'g_webcam' is built statically as a part of the kernel,
> > the kernel crashes (a sample crash dump using Designware 2.0 UDC
> > is provided below).
> >
> > To solve the same, this patch makes 'videodev_init' as a subsys
> initcall.
> >
> > Kernel Crash Dump:
> > ------------------
> 
> [snip]
> 
> > Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
> > ---
> >  drivers/media/video/v4l2-dev.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/media/video/v4l2-dev.c
> b/drivers/media/video/v4l2-dev.c
> > index 96e9615..041804b 100644
> > --- a/drivers/media/video/v4l2-dev.c
> > +++ b/drivers/media/video/v4l2-dev.c
> > @@ -788,7 +788,7 @@ static void __exit videodev_exit(void)
> >  	unregister_chrdev_region(dev, VIDEO_NUM_DEVICES);
> >  }
> >
> > -module_init(videodev_init)
> > +subsys_initcall(videodev_init);
> >  module_exit(videodev_exit)
> >
> >  MODULE_AUTHOR("Alan Cox, Mauro Carvalho Chehab
> <mchehab@infradead.org>");
> 
> Shouldn't drivers/media/media-devnode.c then use subsys_initcall() as
> well ?
> 

Yes, it should. Do you want me to send a patch for the same also?

But I have no platform to check whether the Media Controller changes
for g_webcam work on a real platform (i.e. omap3isp), so can you
kindly test the patch I send for the same on your setup?

Regards,
Bhupesh
