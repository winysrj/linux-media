Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:38695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab0LXOmG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Dec 2010 09:42:06 -0500
Message-ID: <4D14B29D.3080002@redhat.com>
Date: Fri, 24 Dec 2010 15:47:57 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: Removal of V4L1 drivers
References: <201012241442.39702.hverkuil@xs4all.nl>
In-Reply-To: <201012241442.39702.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

On 12/24/2010 02:42 PM, Hans Verkuil wrote:
> Hi Hans, Mauro,
>
> The se401, vicam, ibmcam and konicawc drivers are the only V4L1 drivers left in
> 2.6.37. The others are either converted or moved to staging (stradis and cpia),
> ready to be removed.
>
> Hans, what is the status of those four drivers?

se401:
I have hardware I have taken a look at the driver, converting it is a bit
of a pain because it uses a really ugly written statefull decompressor inside
the kernel code. The cameras have an uncompressed mode too. I can start doing
a conversion to / rewrite as gspca subdriver supporting only the uncompressed
mode for now:

vicam:
Devin Heitmueller (added to the CC) has one such a camera, which he still needs
to get into my hands, once I have it I can convert the driver.

ibmcam and konicawc:
Both drivers were converted by me recently and the new gspca subdrivers for these
have been pulled by Mauro for 2.6.37 .

<snip>

> There are two drivers that need more work: stk-webcam has some controls under sysfs
> that are enabled when CONFIG_VIDEO_V4L1_COMPAT is set. These controls should be
> rewritten as V4L2 controls. Hans, didn't you have hardware to test this driver?

No I don't have any Syntek DC1125 based webcams.

<snip>

Regards,

Hans
