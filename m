Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60020 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932732AbZHDJbS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Aug 2009 05:31:18 -0400
Date: Tue, 4 Aug 2009 11:31:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Antonio Ospite <ospite@studenti.unina.it>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] soc-camera: fix recursive locking in .buf_queue()
In-Reply-To: <20090804111822.b7893079.ospite@studenti.unina.it>
Message-ID: <Pine.LNX.4.64.0908041129340.4627@axis700.grange>
References: <20090804020252.f33f481d.ospite@studenti.unina.it>
 <Pine.LNX.4.64.0908041023450.4627@axis700.grange>
 <20090804111822.b7893079.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 4 Aug 2009, Antonio Ospite wrote:

> On Tue, 4 Aug 2009 10:30:47 +0200 (CEST)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > On Tue, 4 Aug 2009, Antonio Ospite wrote:
> >
> > > verified to be present in linux-2.6.31-rc5, here's some info dumped
> > > from RAM, since the machine hangs, sorry if it is not complete but I
> > > couldn't get anything better for now, nothing is printed on
> > > the screen.
> > 
> > You're right, thanks for the report. Does the patch below fix the problem? 
> > It only gets a bit tricky in mx3_camera.c, will have to test.
> >
> 
> Yes, the patch fixes the problem. Many thanks.
> 
> The current patch applies with some fuzzes on vanilla kernels, and it
> even FAILS to apply for drivers/media/video/sh_mobile_ceu_camera.c in
> one hunk.

Yes, I'll produce one against vanilla for submission.

> I hope that this one and also http://patchwork.kernel.org/patch/33960/
> will hit mainline soon.

Yes, I pushed that one already:

http://linuxtv.org/hg/v4l-dvb/rev/ee62ab3076e1

Will push this one too.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
