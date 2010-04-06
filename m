Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1429 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757428Ab0DFTMr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Apr 2010 15:12:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Douglas Schilling Landgraf <dougsland@gmail.com>
Subject: Re: [PATCH] Fix Warning ISO C90 forbids mixed declarations and code - cx88-dvb
Date: Tue, 6 Apr 2010 21:12:42 +0200
Cc: Ricardo Maraschini <xrmarsx@gmail.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com
References: <499b283a1003231342h6fcbe74di2aa67eb91b18cf0c@mail.gmail.com> <499b283a1003240627p4e97bd73v594f031e3f7b5726@mail.gmail.com> <68cac7521003240645l336c2829m4b25718fd573dc73@mail.gmail.com>
In-Reply-To: <68cac7521003240645l336c2829m4b25718fd573dc73@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004062112.42813.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 24 March 2010 14:45:50 Douglas Schilling Landgraf wrote:
> Hello Ricardo,
> 
> On Wed, Mar 24, 2010 at 10:27 AM, Ricardo Maraschini <xrmarsx@gmail.com> wrote:
> > Signed-off-by: Ricardo Maraschini <ricardo.maraschini@gmail.com>
> >
> > --- a/linux/drivers/media/video/cx88/cx88-dvb.c Tue Mar 23 17:52:23 2010 -0300
> > +++ b/linux/drivers/media/video/cx88/cx88-dvb.c Wed Mar 24 09:57:06 2010 -0300
> > @@ -1401,8 +1401,6 @@
> >        case CX88_BOARD_SAMSUNG_SMT_7020:
> >                dev->ts_gen_cntrl = 0x08;
> >
> > -               struct cx88_core *core = dev->core;
> > -
> >                cx_set(MO_GP0_IO, 0x0101);
> >
> >                cx_clear(MO_GP0_IO, 0x01);
> >
> 
> This version seems ok to my eyes.

And also to my eyes.

Mauro, can you please merge this? This patch didn't turn up in patchwork for
some reason.

This will fix an annoying compile warning.

Regards,

	Hans

> 
> Thanks
> Douglas
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
