Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33473 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab1FTNhy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 09:37:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Bug: media_build always compiles with '-DDEBUG'
Date: Mon, 20 Jun 2011 15:38:14 +0200
Cc: Helmut Auer <helmut@helmutauer.de>, linux-media@vger.kernel.org,
	Oliver Endriss <o.endriss@gmx.de>
References: <201106182246.03051@orion.escape-edv.de> <201106201435.11432.laurent.pinchart@ideasonboard.com> <4DFF4214.2030205@redhat.com>
In-Reply-To: <4DFF4214.2030205@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106201538.15214.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Monday 20 June 2011 14:50:28 Mauro Carvalho Chehab wrote:
> Em 20-06-2011 09:35, Laurent Pinchart escreveu:
> > On Sunday 19 June 2011 13:47:16 Mauro Carvalho Chehab wrote:
> >> Em 19-06-2011 02:00, Helmut Auer escreveu:
> >>> Am 18.06.2011 23:38, schrieb Oliver Endriss:
> >>>> On Saturday 18 June 2011 23:11:21 Helmut Auer wrote:
> >>>>> Hi
> >>>>> 
> >>>>>> Replacing
> >>>>>> 
> >>>>>>       ifdef CONFIG_VIDEO_OMAP3_DEBUG
> >>>>>> 
> >>>>>> by
> >>>>>> 
> >>>>>>       ifeq ($(CONFIG_VIDEO_OMAP3_DEBUG),y)
> >>>>>> 
> >>>>>> would do the trick.
> >>>>> 
> >>>>> I guess that would not ive the intended result.
> >>>>> Setting CONFIG_VIDEO_OMAP3_DEBUG to yes should not lead to debug
> >>>>> messages in all media modules,
> >>>> 
> >>>> True, but it will happen only if you manually enable
> >>>> CONFIG_VIDEO_OMAP3_DEBUG in Kconfig.
> >>>> 
> >>>> You cannot avoid this without major changes of the
> >>>> media_build system - imho not worth the effort.
> >>> 
> >>> Then imho it would be better to drop the  CONFIG_VIDEO_OMAP3_DEBUG
> >>> variable completely, you can set CONFIG_DEBUG which would give the same
> >>> results.
> >> 
> >> Good catch!
> >> 
> >> Yes, I agree that the better is to just drop CONFIG_VIDEO_OMAP3_DEBUG
> >> variable completely. If someone wants to build with -DDEBUG, he can just
> >> use CONFIG_DEBUG.
> >> 
> >> Laurent,
> >> 
> >> Any comments?
> > 
> > CONFIG_VIDEO_OMAP3_DEBUG is used to build the OMAP3 ISP driver in debug
> > mode, without having to compile the whole kernel with debugging enabled.
> > I'd like to keep that feature if possible.
> 
> If you want that, build it using media_build. I don't care of having such
> hacks there, but having it upstream is not the right thing to do.

It's not a hack. Lots of drivers have debugging Kconfig options.

$ find linux-2.6 -type f -name Kconfig* -exec grep '^config.*DEBUG' {} \; | wc
    243     486    5826

-- 
Regards,

Laurent Pinchart
