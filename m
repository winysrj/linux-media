Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:59959 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949Ab2FYObi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 10:31:38 -0400
Date: Mon, 25 Jun 2012 16:31:34 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sergio Aguirre <sergio.a.aguirre@gmail.com>
cc: Sriram V <vshrirama@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [ANNOUNCEMENT] (tentative) Android generic V4L2 camera HAL
In-Reply-To: <CAKnK67Rdxfjvk25uy5cLhVmpK3bWyyN_P5nCAnHeZZw9UAHWVQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1206251628580.29019@axis700.grange>
References: <CAH9_wRP4+hzFpCdcZWmyyTZpTTFi+9wyTJxX2vPd+3r0QNhLkA@mail.gmail.com>
 <CAKnK67Qdte8qJ9L18OL2ft=YaF4YEAD-5rTP_bk7+_nQAn4u+A@mail.gmail.com>
 <Pine.LNX.4.64.1205072321530.3564@axis700.grange>
 <CAKnK67SpO-roU_d_5DV4bq4J5URX0Niw=hCjXY3N=GUAumZLig@mail.gmail.com>
 <Pine.LNX.4.64.1206251540490.29019@axis700.grange>
 <CAKnK67Rdxfjvk25uy5cLhVmpK3bWyyN_P5nCAnHeZZw9UAHWVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio

On Mon, 25 Jun 2012, Aguirre, Sergio wrote:

> (+ My gmail address, please start using that address from next week
> on, since I'm leaving TI)
> 
> Hi Guennadi,
> 
> Thanks a lot for sharing these! Nice job.
> 
> I immediately noticed you have changes on hardware/ti/omap4xxx/
> subproject. So, Which devices did you used for testing this?
> 
> I got confused since you had changes for the Samsung Nexus S, which
> has an Exynos chip...
> 
> And you also have this Renesas Mackerel, which seems to use a SuperH 7372.
> 
> Or maybe you just patched the omap4xxx related file to fix a build :)

Right, I only used the sh7372 based mackerel board from Renesas, as 
lightly hinted in the README, not all patches in that directory are really 
related to the camera library, some are unrelated fixes and improvements, 
others are build fixes to compensate for a changed API.

Thanks
Guennadi

> Regards,
> Sergio
> 
> On Mon, Jun 25, 2012 at 8:55 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > Hi all
> >
> > It's been a while since I've actually done this work. We have been waiting
> > for various formalities to be resolved to be able to publish this work
> > upstream. There are still a couple of formal issues to sort out before we
> > can begin the submission process, but at least it has been decided to
> > release patches for independent review and testing.
> >
> > For now I've uploaded a development snapshot to
> >
> > http://download.open-technology.de/android/20120625/
> >
> > In the future we probably will provide git trees at least for the
> > system/media/v4l_camera development.
> >
> > Enjoy:-) Any comments welcome.
> >
> > Thanks
> > Guennadi
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
