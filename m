Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:35792 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755538Ab1BHWr7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Feb 2011 17:47:59 -0500
Subject: Re: [PATCH/RFC 0/5] HDMI driver for Samsung S5PV310 platform
From: Andy Walls <awalls@md.metrocast.net>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Hans Verkuil <hansverk@cisco.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com
In-Reply-To: <AANLkTi=A=HiAvHojWP8HcFXpjXbZpq6UdHjOnWq-8jww@mail.gmail.com>
References: <1297157427-14560-1-git-send-email-t.stanislaws@samsung.com>
	 <201102081047.17840.hansverk@cisco.com>
	 <AANLkTi=A=HiAvHojWP8HcFXpjXbZpq6UdHjOnWq-8jww@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Feb 2011 17:47:47 -0500
Message-ID: <1297205267.2423.24.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 2011-02-08 at 10:28 -0500, Alex Deucher wrote:
> On Tue, Feb 8, 2011 at 4:47 AM, Hans Verkuil <hansverk@cisco.com> wrote:
> > Just two quick notes. I'll try to do a full review this weekend.
> >
> > On Tuesday, February 08, 2011 10:30:22 Tomasz Stanislawski wrote:
> >> ==============
> >>  Introduction
> >> ==============
> >>
> >> The purpose of this RFC is to discuss the driver for a TV output interface
> >> available in upcoming Samsung SoC. The HW is able to generate digital and
> >> analog signals. Current version of the driver supports only digital output.
> >>
> >> Internally the driver uses videobuf2 framework, and CMA memory allocator.
> > Not
> >> all of them are merged by now, but I decided to post the sources to start
> >> discussion driver's design.

> >
> > Cisco (i.e. a few colleagues and myself) are working on this. We hope to post
> > an RFC by the end of this month. We also have a proposal for CEC support in
> > the pipeline.
> 
> Any reason to not use the drm kms APIs for modesetting, display
> configuration, and hotplug support?  We already have the
> infrastructure in place for complex display configurations and
> generating events for hotplug interrupts.  It would seem to make more
> sense to me to fix any deficiencies in the KMS APIs than to spin a new
> API.  Things like CEC would be a natural fit since a lot of desktop
> GPUs support hdmi audio/3d/etc. and are already using kms.
> 
> Alex

I'll toss one out: lack of API documentation for driver or application
developers to use.


When I last looked at converting ivtvfb to use DRM, KMS, TTM, etc. (to
possibly get rid of reliance on the ivtv X video driver
http://dl.ivtvdriver.org/xf86-video-ivtv/ ), I found the documentation
was really sparse.

DRM had the most documentation under Documentation/DocBook/drm.tmpl, but
the userland API wasn't fleshed out.  GEM was talked about a bit in
there as well, IIRC.

TTM documentation was essentially non-existant.

I can't find any KMS documentation either.

I recall having to read much of the drm code, and having to look at the
radeon driver, just to tease out what the DRM ioctls needed to do.

Am I missing a Documentation source for the APIs?



For V4L2 and DVB on ther other hand, one can point to pretty verbose
documentation that application developers can use:

	http://linuxtv.org/downloads/v4l-dvb-apis/



Regards,
Andy


