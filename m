Return-path: <mchehab@gaivota>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:2968 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab0LYJkW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Dec 2010 04:40:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: Removal of V4L1 drivers
Date: Sat, 25 Dec 2010 10:40:07 +0100
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
References: <201012241442.39702.hverkuil@xs4all.nl> <4D14FA97.50303@redhat.com> <4D15B6DC.1050303@redhat.com>
In-Reply-To: <4D15B6DC.1050303@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012251040.07176.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Saturday, December 25, 2010 10:18:20 Mauro Carvalho Chehab wrote:
> Em 24-12-2010 17:55, Hans de Goede escreveu:
> > Hi,
> > 
> > On 12/24/2010 07:58 PM, Hans Verkuil wrote:
> >> On Friday, December 24, 2010 15:47:57 Hans de Goede wrote:
> >>> Hi,
> >>>
> >>> On 12/24/2010 02:42 PM, Hans Verkuil wrote:
> >>>> Hi Hans, Mauro,
> >>>>
> >>>> The se401, vicam, ibmcam and konicawc drivers are the only V4L1 drivers left in
> >>>> 2.6.37. The others are either converted or moved to staging (stradis and cpia),
> >>>> ready to be removed.
> >>>>
> >>>> Hans, what is the status of those four drivers?
> >>>
> >>> se401:
> >>> I have hardware I have taken a look at the driver, converting it is a bit
> >>> of a pain because it uses a really ugly written statefull decompressor inside
> >>> the kernel code. The cameras have an uncompressed mode too. I can start doing
> >>> a conversion to / rewrite as gspca subdriver supporting only the uncompressed
> >>> mode for now:
> >>>
> >>> vicam:
> >>> Devin Heitmueller (added to the CC) has one such a camera, which he still needs
> >>> to get into my hands, once I have it I can convert the driver.
> >>
> >> I think these two should be moved to staging for 2.6.38. And either removed or
> >> converted for 2.6.39.
> >>
> > 
> > Ok.
> > 
> >>> ibmcam and konicawc:
> >>> Both drivers were converted by me recently and the new gspca subdrivers for these
> >>> have been pulled by Mauro for 2.6.37 .
> >>
> >> So these two can be removed in 2.6.38, right?
> > 
> > Right.
> 
> 
> OK, moving them to staging seems the best way to do it. Please, add a comment at
> Kconfig help that they use the legacy V4L1 API and may be removed from .39 if not
> converted to V4L2. Of course, the README file will also say that, maybe providing
> more details.

Thanks for your input! I'll work on this in the next few days.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
