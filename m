Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48604 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab1EYXnV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 19:43:21 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCH FOR 2.6.40] uvcvideo patches
Date: Thu, 26 May 2011 01:43:35 +0200
Cc: linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
References: <201105150948.24956.laurent.pinchart@ideasonboard.com> <201105260120.54392.laurent.pinchart@ideasonboard.com> <4DDD91F2.5070801@redhat.com>
In-Reply-To: <4DDD91F2.5070801@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105260143.35396.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Thursday 26 May 2011 01:34:10 Mauro Carvalho Chehab wrote:
> Em 25-05-2011 20:20, Laurent Pinchart escreveu:
> > Hi Mauro,
> > 
> > Thanks for applying the patches. For the record, the compromise was to
> > implement XU controls filtering to make sure that userspace applications
> > won't have access to potentially dangerous controls, and to push vendors
> > to properly document their XUs.
> 
> Ok, thanks!
> 
> >>> Some XU controls are variable-size binary chunks of data. We can't
> >>> expose that as V4L2 controls, which is why I expose them using a
> >>> documented UVC API.
> >> 
> >> The V4L2 API allows string controls.
> > 
> > Hans was very much against using string controls to pass raw binary data.
> 
> Pass raw binary data is bad when we know nothing about what's passing
> there. A "firmware update" control-type however, is a different thing, as
> we really don't care about what's there. Yet, I agree that this may not be
> the best way of doing it.
> 
> >>> Why would there be no applications using it ? The UVC H.264 XUs are
> >>> documented in the above spec, so application can use them.
> >> 
> >> The Linux kernel were designed to abstract hardware differences. We
> >> should not move this task to userspace.
> > 
> > I agree in principle, but we will have to rethink this at some point in
> > the future. I don't think it will always be possible to handle all
> > hardware abstractions in the kernel. Some hardware require floating
> > point operations in their drivers for instance.
> 
> I talked with Linus some years ago about float point ops in Kernel. He said
> he was not against that, but there are some issues, as float point
> processors are arch-dependent, and kernel doesn't save FP registers. So,
> if a driver really needs to use it, extra care should be taken. That's
> said, some drivers use fixed point operations for some specific usages.

Issues arise when devices have floating point registers. And yes, that 
happens, I've learnt today about an I2C sensor with floating point registers 
(in this specific case it should probably be put in the broken design 
category, but it exists :-)).

> > There's an industry trend there, and we need to think about solutions now
> > otherwise we will be left without any way forward when too many devices
> > will be impossible to support from kernelspace (OMAP4 is a good example
> > there, some device drivers require communication with other cores, and
> > the communication API is implemented in userspace).
> 
> Needing to go to userspace to allow inter-core communication seems very
> bad. I seriously doubt that this is a trend. It seems more like a
> broken-by-design type of architecture.

I'm inclined to agree with you, but we should address these issues now, while 
we have relatively few devices impacted by them. I fear that ignoring the 
problem and hoping it will go away by itself will bring us to a difficult 
position in the future. We should show the industry in which direction we 
would like it to go.

-- 
Regards,

Laurent Pinchart
