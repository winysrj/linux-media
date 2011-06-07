Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:50980 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab1FGIK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 04:10:57 -0400
Date: Tue, 7 Jun 2011 10:10:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kassey Lee <kassey1216@gmail.com>
cc: Kassey Lee <ygli@marvell.com>, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl, qingx@marvell.com, ytang5@marvell.com,
	leiwen@marvell.com, jwan@marvell.com, hzhuang1@marvell.com,
	njun@marvell.com
Subject: Re: [PATCH V2] V4L/DVB: v4l: Add driver for Marvell PXA910 CCIC
In-Reply-To: <BANLkTim6Jp6Uh7Fnb4rNgHQNNhsuyBQWvA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1106071008470.31635@axis700.grange>
References: <1306934205-15154-1-git-send-email-ygli@marvell.com>
 <Pine.LNX.4.64.1106012219350.29934@axis700.grange>
 <BANLkTim6Jp6Uh7Fnb4rNgHQNNhsuyBQWvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 7 Jun 2011, Kassey Lee wrote:

> Guennadi
> 
>           thanks for your comments very much! I will update the V3 patch  later.
> 
> 
> On Fri, Jun 3, 2011 at 6:22 PM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > Ok, this will be converted to use a common "cafe" code, but I'll comment
> > on this version anyway, for your future reference.
> >
> > On Wed, 1 Jun 2011, Kassey Lee wrote:

[snip]

> >
> > Did you remove your pass-through code here on purpose or because you
> > misunderstood my comment? I meant, that in your original code
> >
> Sorry, I misunderstood your comment, do you mean remove the wrong comment only ?

Yes.

>  > +       /* Generic pass-through */
> > +       formats++;
> > +       if (xlate) {
> > +               xlate->host_fmt = fmt;
> > +               xlate->code = code;
> > +               xlate++;
> > +       }
> >
> > the comment "generic" was wrong, because in generic case you run on
> > default case above and bail out. However, that block allowed you to use
> > the "standard" V4L2_MBUS_FMT_YUYV8_2X8 -> V4L2_PIX_FMT_YUYV conversion, or
> > is it not supported by your hardware / driver?
> >
> it is supported.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
