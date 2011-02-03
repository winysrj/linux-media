Return-path: <mchehab@pedra>
Received: from mga14.intel.com ([143.182.124.37]:11963 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262Ab1BCAhx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Feb 2011 19:37:53 -0500
Date: Thu, 3 Feb 2011 01:37:49 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>,
	alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
	lrg@slimlogic.co.uk, hverkuil@xs4all.nl,
	linux-media@vger.kernel.org
Subject: Re: WL1273 FM Radio driver...
Message-ID: <20110203003748.GH25448@sortiz-mobl>
References: <1295363063.25951.67.camel@masi.mnp.nokia.com>
 <20110130232358.GD2565@sortiz-mobl>
 <4D4979A5.1020000@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D4979A5.1020000@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Wed, Feb 02, 2011 at 01:35:01PM -0200, Mauro Carvalho Chehab wrote:
> Em 30-01-2011 21:23, Samuel Ortiz escreveu:
> > Hi Matti,
> > 
> > On Tue, Jan 18, 2011 at 05:04:23PM +0200, Matti J. Aaltonen wrote:
> >> Hello
> >>
> >> I have been trying to get the WL1273 FM radio driver into the kernel for
> >> some time. It has been kind of difficult, one of the reasons is that I
> >> didn't realize I should have tried to involve all relevant maintainers
> >> to the discussion form the beginning (AsoC, Media and MFD). At Mark's
> >> suggestion I'm trying to reopen the discussion now.
> >>
> >> The driver consists of an MFD core and two child drivers (the audio
> >> codec and the V4L2 driver). And the question is mainly about the role of
> >> the MFD driver: the original design had the IO functions in the core.
> >> Currently the core is practically empty mainly because Mauro very
> >> strongly wanted to have “everything” in the V4L2 driver.
> > What was Mauro main concerns with having the IO part in the core ?
> > A lot of MFD drivers are going that path already.
> 
> My concerns is that the V4L2-specific part of the code should be at drivers/media.
> I prefer that the specific MFD I/O part to be at drivers/mfd, just like
> the other drivers.
Agreed, but it seems that's not the case currently. Would you be ok with Matti
refactoring those 2 drivers a bit so that the actual core I/O parts should be
handled by the MFD driver ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
