Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3986 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab0D3QuC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Apr 2010 12:50:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Doing a stable v4l-utils release
Date: Fri, 30 Apr 2010 08:43:23 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4BD5423B.4040200@redhat.com> <4BD69B66.1090904@redhat.com> <201004280822.03571.hverkuil@xs4all.nl>
In-Reply-To: <201004280822.03571.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004300843.23675.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 28 April 2010 08:22:03 Hans Verkuil wrote:
> On Tuesday 27 April 2010 10:08:06 Hans de Goede wrote:
> > Hi,
> > 
> > On 04/26/2010 09:55 AM, Hans Verkuil wrote:
> > > On Monday 26 April 2010 09:35:23 Hans de Goede wrote:
> > >> Hi all,
> > >>
> > >> Currently v4l-utils is at version 0.7.91, which as the version
> > >> suggests is meant as a beta release.
> > >>
> > >> As this release seems to be working well I would like to do
> > >> a v4l-utils-0.8.0 release soon. This is a headsup, to give
> > >> people a chance to notify me of any bugs they would like to
> > >> see fixed first / any patches they would like to add first.
> > >
> > > This is a good opportunity to mention that I would like to run checkpatch
> > > over the libs and clean them up.
> > >
> > > I also know that there is a bug in the control handling code w.r.t.
> > > V4L2_CTRL_FLAG_NEXT_CTRL. I have a patch, but I'd like to do the clean up
> > > first.
> > >
> > > If no one else has major patch series that they need to apply, then I can
> > > start working on this. The clean up is just purely whitespace changes to
> > > improve readability, no functionality will be touched.
> > >
> > 
> > I've no big changes planned on the short term, so from my pov go ahead.
> 
> As you noticed I have cleaned up the includes, libv4l1 and libv4l2. libv4lconvert
> is a lot more work, so I will do that bit by bit, hopefully this week.

I just finished doing the checkpatch conversions (phew!). This weekend I will
push the control bug fix and I also have a v4l2-ctl enhancement pending that
I will try to upstream today.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
