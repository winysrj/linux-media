Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45330 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944Ab1EZIyp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 04:54:45 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCH FOR 2.6.40] uvcvideo patches
Date: Thu, 26 May 2011 10:54:59 +0200
Cc: linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
References: <201105150948.24956.laurent.pinchart@ideasonboard.com> <201105260143.35396.laurent.pinchart@ideasonboard.com> <4DDD95AF.4010004@redhat.com>
In-Reply-To: <4DDD95AF.4010004@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105261054.59914.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday 26 May 2011 01:50:07 Mauro Carvalho Chehab wrote:
> Em 25-05-2011 20:43, Laurent Pinchart escreveu:
> > Issues arise when devices have floating point registers. And yes, that
> > happens, I've learnt today about an I2C sensor with floating point
> > registers (in this specific case it should probably be put in the broken
> > design category, but it exists :-)).
> 
> Huh! Yeah, an I2C sensor with FP registers sound weird. We need more
> details in order to address those.

Fortunately for the sensor I'm talking about most of those registers are read-
only and contain large values that can be handled as integers, so all we need 
to do is convert the 32-bit IEEE float value into an integer. Other hardware 
might require more complex FP handling.

> >>> There's an industry trend there, and we need to think about solutions
> >>> now otherwise we will be left without any way forward when too many
> >>> devices will be impossible to support from kernelspace (OMAP4 is a
> >>> good example there, some device drivers require communication with
> >>> other cores, and the communication API is implemented in userspace).
> >> 
> >> Needing to go to userspace to allow inter-core communication seems very
> >> bad. I seriously doubt that this is a trend. It seems more like a
> >> broken-by-design type of architecture.
> > 
> > I'm inclined to agree with you, but we should address these issues now,
> > while we have relatively few devices impacted by them. I fear that
> > ignoring the problem and hoping it will go away by itself will bring us
> > to a difficult position in the future. We should show the industry in
> > which direction we would like it to go.
> 
> I'm all about showing the industry in with direction we would like it to
> go. We want that all Linux-supported architectures/sub-architectures
> support inter-core communications in kernelspace, in a more efficient way
> that it would happen if such communication would happen in userspace.

I agree with that. My concern is about things like

"Standardizing on the OpenMax media libraries and the GStreamer framework is 
the direction that Linaro is going." (David Rusling, Linaro CTO, quoted on 
lwn.net)

We need to address this now, otherwise it will be too late.

-- 
Regards,

Laurent Pinchart
