Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:48920 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756975Ab0D0Vr3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Apr 2010 17:47:29 -0400
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Tue, 27 Apr 2010 16:47:21 -0500
Subject: RE: Doing a stable v4l-utils release
Message-ID: <A24693684029E5489D1D202277BE894454F78141@dlee02.ent.ti.com>
References: <4BD5423B.4040200@redhat.com>
 <201004260955.13792.hverkuil@xs4all.nl> <4BD69B66.1090904@redhat.com>
In-Reply-To: <4BD69B66.1090904@redhat.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Hans de Goede
> Sent: Tuesday, April 27, 2010 3:08 AM
> To: Hans Verkuil
> Cc: Linux Media Mailing List
> Subject: Re: Doing a stable v4l-utils release
> 
> Hi,
> 
> On 04/26/2010 09:55 AM, Hans Verkuil wrote:
> > On Monday 26 April 2010 09:35:23 Hans de Goede wrote:
> >> Hi all,
> >>
> >> Currently v4l-utils is at version 0.7.91, which as the version
> >> suggests is meant as a beta release.
> >>
> >> As this release seems to be working well I would like to do
> >> a v4l-utils-0.8.0 release soon. This is a headsup, to give
> >> people a chance to notify me of any bugs they would like to
> >> see fixed first / any patches they would like to add first.
> >
> > This is a good opportunity to mention that I would like to run
> checkpatch
> > over the libs and clean them up.
> >
> > I also know that there is a bug in the control handling code w.r.t.
> > V4L2_CTRL_FLAG_NEXT_CTRL. I have a patch, but I'd like to do the clean
> up
> > first.
> >
> > If no one else has major patch series that they need to apply, then I
> can
> > start working on this. The clean up is just purely whitespace changes to
> > improve readability, no functionality will be touched.
> >
> 
> I've no big changes planned on the short term, so from my pov go ahead.

I have one question regarding this utils:

Is it meant to be platform agnostic v4l2 utilities?

I tried once to compile it for a ARM based CPU (OMAP3 to be specific) from my x86 using a Codesourcery cross compilation toolchain, but it required some changes, which I haven't done still...

Anyways, before proposing patches for this, I just wanted to know how much priority you're giving to multi-platform support.

Regards,
Sergio

> 
> Regards,
> 
> Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
