Return-path: <mchehab@gaivota>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4345 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab0LXS6q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Dec 2010 13:58:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: Removal of V4L1 drivers
Date: Fri, 24 Dec 2010 19:58:31 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
References: <201012241442.39702.hverkuil@xs4all.nl> <4D14B29D.3080002@redhat.com>
In-Reply-To: <4D14B29D.3080002@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012241958.31275.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Friday, December 24, 2010 15:47:57 Hans de Goede wrote:
> Hi,
> 
> On 12/24/2010 02:42 PM, Hans Verkuil wrote:
> > Hi Hans, Mauro,
> >
> > The se401, vicam, ibmcam and konicawc drivers are the only V4L1 drivers left in
> > 2.6.37. The others are either converted or moved to staging (stradis and cpia),
> > ready to be removed.
> >
> > Hans, what is the status of those four drivers?
> 
> se401:
> I have hardware I have taken a look at the driver, converting it is a bit
> of a pain because it uses a really ugly written statefull decompressor inside
> the kernel code. The cameras have an uncompressed mode too. I can start doing
> a conversion to / rewrite as gspca subdriver supporting only the uncompressed
> mode for now:
> 
> vicam:
> Devin Heitmueller (added to the CC) has one such a camera, which he still needs
> to get into my hands, once I have it I can convert the driver.

I think these two should be moved to staging for 2.6.38. And either removed or
converted for 2.6.39.

> ibmcam and konicawc:
> Both drivers were converted by me recently and the new gspca subdrivers for these
> have been pulled by Mauro for 2.6.37 .

So these two can be removed in 2.6.38, right?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
