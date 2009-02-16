Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4702 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbZBPMCH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2009 07:02:07 -0500
Message-ID: <62591.62.70.2.252.1234785726.squirrel@webmail.xs4all.nl>
Date: Mon, 16 Feb 2009 13:02:06 +0100 (CET)
Subject: Re: Adding a control for Sensor Orientation
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Jean-Francois Moine" <moinejf@free.fr>
Cc: "Hans de Goede" <hdegoede@redhat.com>,
	"Trent Piepho" <xyzzy@speakeasy.org>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	kilgota@banach.math.auburn.edu,
	"Adam Baker" <linux@baker-net.org.uk>, linux-media@vger.kernel.org,
	"Olivier Lorin" <o.lorin@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Mon, 16 Feb 2009 12:01:14 +0100 (CET)
> "Hans Verkuil" <hverkuil@xs4all.nl> wrote:
>
>> Anyone can add an API in 5 seconds. It's modifying or removing a bad
>> API that worries me as that can take years. If you want to add two
>> bits with mount information, feel free. But don't abuse them for
>> pivot information. If you want that, then add another two bits for
>> the rotation:
>>
>> #define V4L2_BUF_FLAG_VFLIP     0x0400
>> #define V4L2_BUF_FLAG_HFLIP     0x0800
>>
>> #define V4L2_BUF_FLAG_PIVOT_0   0x0000
>> #define V4L2_BUF_FLAG_PIVOT_90  0x1000
>> #define V4L2_BUF_FLAG_PIVOT_180 0x2000
>> #define V4L2_BUF_FLAG_PIVOT_270 0x3000
>> #define V4L2_BUF_FLAG_PIVOT_MSK 0x3000
>
> Hi,
>
> HFLIP + VFLIP = PIVOT_180
>
> then
>
> #define V4L2_BUF_FLAG_PIVOT_180 0x0c00

This makes it impossible for an application to see the difference between
an upside-down mounted sensor and a 180-degrees pivoted camera. In
addition, there may be sensors that are not upside-down, but only
V-flipped (or only H-flipped).

All this seems so simple, but it really isn't. This is something for an
RFC, posted and discussed both here and at least the linux-omap list, as
the input from the people who are working on those embedded systems will
be very valuable.

And what about output devices? E.g. LCDs? These too can be mounted
upside-down or rotated. You won't encounter this situation on a PC, but it
is another matter in the embedded space. Any API should by preference be
usable both for capture and output.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

