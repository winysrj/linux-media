Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:60292 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2ABIU7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 03:20:59 -0500
Date: Mon, 2 Jan 2012 09:20:55 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PULL] soc-camera for 3.3
In-Reply-To: <CACKLOr2xNtmAXX66H3RxbJdw6_QD1hBMSuXy5AjtCPUU+_qKkg@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1201020917190.13996@axis700.grange>
References: <Pine.LNX.4.64.1112290934500.15735@axis700.grange>
 <CACKLOr2xNtmAXX66H3RxbJdw6_QD1hBMSuXy5AjtCPUU+_qKkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier

On Mon, 2 Jan 2012, javier Martin wrote:

> Hi Guennadi,
> 
> On 29 December 2011 09:38, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > Hi Mauro
> >
> > Please pull a couple of soc-camera patches for 3.3. This is going to be a
> > _much_ quieter pull, than the previous one:-) I didn't have time to
> > continue the work on the soc-camera Media Controller conversion, so, that
> > will have to wait at least until 3.4.
> >
> > Interestingly, Javier Martin has fixed field_count handling in mx2_camera,
> > but, apparently, it also has to be fixed in other soc-camera drivers. So,
> > a patch for that might follow later in the 3.3 cycle.
> >
> > The following changes since commit 1a5cd29631a6b75e49e6ad8a770ab9d69cda0fa2:
> >
> >  [media] tda10021: Add support for DVB-C Annex C (2011-12-20 14:01:08 -0200)
> >
> > are available in the git repository at:
> >  git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.3
> >
> > Guennadi Liakhovetski (4):
> >      V4L: soc-camera: remove redundant parameter from the .set_bus_param() method
> >      V4L: mt9m111: cleanly separate register contexts
> >      V4L: mt9m111: power down most circuits when suspended
> >      V4L: mt9m111: properly implement .s_crop and .s_fmt(), reset on STREAMON
> >
> > Javier Martin (2):
> >      media i.MX27 camera: add support for YUV420 format.
> >      media i.MX27 camera: Fix field_count handling.
> 
> So, you already applied my patch related to "field_count" handling. I
> was preparing a v3 for that patch to fix the frame_count type issue
> and to really provide frame loss detection but I can prepare it on top
> of the old one if you want.

Yes, the type issue is not that severe. Matching a type of another 
variable or a struct field, with which this variable is connected, is a 
valid reason, so, we can keep u32, if you like. As for frame loss 
detection - yes, please, provide it as an incremental patch.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
