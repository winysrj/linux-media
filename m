Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:33750 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab0BXFkf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 00:40:35 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Muralidharan Karicheri <mkaricheri@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>
Date: Wed, 24 Feb 2010 11:10:29 +0530
Subject: RE: [PATCH 3/9] tvp514x: add YUYV format support
Message-ID: <19F8576C6E063C45BE387C64729E7394044DA99713@dbde02.ent.ti.com>
References: <hvaibhav@ti.com>
	 <1262613782-20463-4-git-send-email-hvaibhav@ti.com>
 <55a3e0ce1002231544o36a63a07if76501bff7967b45@mail.gmail.com>
In-Reply-To: <55a3e0ce1002231544o36a63a07if76501bff7967b45@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> -----Original Message-----
> From: Muralidharan Karicheri [mailto:mkaricheri@gmail.com]
> Sent: Wednesday, February 24, 2010 5:15 AM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org; linux-omap@vger.kernel.org;
> hverkuil@xs4all.nl; davinci-linux-open-source@linux.davincidsp.com;
> Karicheri, Muralidharan
> Subject: Re: [PATCH 3/9] tvp514x: add YUYV format support
> 
> Vaibhav,
> 
> 
> On Mon, Jan 4, 2010 at 9:02 AM,  <hvaibhav@ti.com> wrote:
> > From: Vaibhav Hiremath <hvaibhav@ti.com>
> >
> >
> > Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> > ---
> >  drivers/media/video/tvp514x.c |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
> > index 4cf3593..b344b58 100644
> > --- a/drivers/media/video/tvp514x.c
> > +++ b/drivers/media/video/tvp514x.c
> > @@ -212,6 +212,13 @@ static const struct v4l2_fmtdesc tvp514x_fmt_list[] =
> {
> >         .description = "8-bit UYVY 4:2:2 Format",
> >         .pixelformat = V4L2_PIX_FMT_UYVY,
> >        },
> > +       {
> > +        .index = 1,
> > +        .type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> > +        .flags = 0,
> > +        .description = "8-bit YUYV 4:2:2 Format",
> > +        .pixelformat = V4L2_PIX_FMT_YUYV,
> > +       },
> >  };
> 
> As per data sheet I can see only CbYCrY format output from the tvp5146
> which translate to UYVY. How are you configuring tvp to output YUYV? I
> don;t see any change to the code to configure this format.
> 
[Hiremath, Vaibhav] Yes you are right, actually this is dummy format created to support YUYV.
> CCDC can switch the CbCr order and also can swap Y/C order. So if you
> are achieving
> this via ccdc configuration, there is no need to add this format to tvp5146
> IMO.
> 
[Hiremath, Vaibhav] I think it makes sense to handle this is master driver, since we are handling this in CCDC. It could possible in the future TVP5146 might get used with SoC which don't have this capability. 

Thanks,
Vaibhav

> -Murali
> 
> >
> >  /**
> > --
> > 1.6.2.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> 
> --
> Murali Karicheri
> mkaricheri@gmail.com
