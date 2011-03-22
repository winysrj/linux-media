Return-path: <mchehab@pedra>
Received: from linux-sh.org ([111.68.239.195]:56863 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab1CVR6W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Mar 2011 13:58:22 -0400
Date: Wed, 23 Mar 2011 02:58:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mythri P K <mythripk@ti.com>, linux-fbdev@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH] HDMI:Support for EDID parsing in kernel.
Message-ID: <20110322175810.GA32416@linux-sh.org>
References: <1300815176-21206-1-git-send-email-mythripk@ti.com> <4D88E1FB.5070503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D88E1FB.5070503@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Mar 22, 2011 at 02:52:59PM -0300, Mauro Carvalho Chehab wrote:
> Em 22-03-2011 14:32, Mythri P K escreveu:
> > Adding support for common EDID parsing in kernel.
> > 
> > EDID - Extended display identification data is a data structure provided by
> > a digital display to describe its capabilities to a video source, This a 
> > standard supported by CEA and VESA.
> > 
> > There are several custom implementations for parsing EDID in kernel, some
> > of them are present in fbmon.c, drm_edid.c, sh_mobile_hdmi.c, Ideally
> > parsing of EDID should be done in a library, which is agnostic of the
> > framework (V4l2, DRM, FB)  which is using the functionality, just based on 
> > the raw EDID pointer with size/segment information.
> > 
> > With other RFC's such as the one below, which tries to standardize HDMI API's
> > It would be better to have a common EDID code in one place.It also helps to
> > provide better interoperability with variety of TV/Monitor may be even by
> > listing out quirks which might get missed with several custom implementation
> > of EDID.
> > http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/30401
> > 
> > This patch tries to add functions to parse some portion EDID (detailed timing,
> > monitor limits, AV delay information, deep color mode support, Audio and VSDB)
> > If we can align on this library approach i can enhance this library to parse
> > other blocks and probably we could also add quirks from other implementation
> > as well.
> > 
> > Signed-off-by: Mythri P K <mythripk@ti.com>
> > ---
> >  arch/arm/include/asm/edid.h |  243 ++++++++++++++++++++++++++++++
> >  drivers/video/edid.c        |  340 +++++++++++++++++++++++++++++++++++++++++++
> 
> Hmm... if you want this to be agnostic, the header file should not be inside
> arch/arm, but on some other place, like include/video/.
> 
Ironically this adds a drivers/video/edid.c but completely ignores
drivers/video/edid.h which already exists and already contains many of
these definitions.

I like the idea of a generalized library, but it would be nice to see the
existing edid.h evolved and its users updated incrementally.
