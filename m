Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3190 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab1B1SDy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 13:03:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: V4L2 'brainstorming' meeting in Warsaw, March 2011
Date: Mon, 28 Feb 2011 19:03:39 +0100
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF36190F532AF3@bssrvexch01>
In-Reply-To: <ADF13DA15EB3FE4FBA487CCC7BEFDF36190F532AF3@bssrvexch01>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102281903.39708.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, February 28, 2011 18:11:47 Marek Szyprowski wrote:
> Hello everyone!
> 
> The idea of v4l2 'brainstorming' session came out after a few discussions on #v4l
> IRC channel about various RFCs and proposals that have been posted recently. I
> would like to announce that Samsung Poland R&D Center (SPRC) agreed to take an
> opportunity to organize this meeting. I've got a reservation for a conference
> room for 16-18 March 2011 in our office.
> 
> I would like to invite all of You for this V4L2 'brainstorming' session.
> 
> I hope that this initial meeting date I've selected will fit us. We have 2 only
> weeks for the preparation, but I hope we will manage. I'm open for another date
> and if required I will change the reservation.
> 
> The meeting will last 3 days what gives us a lot of possibility to present the
> issues and proposals, discuss them further and work out a solution that will be
> accepted by others.
> 
> From SPRC 4 developers will attend this meeting: Sylwester Nawrocki (s5p-fimc
> author), Kamil Debski (s5p-mfc author), Tomasz Stanislawski (s5p-tv author) and me
> (videobuf2 co-author and kernel lead developer in SPRC).
> 
> A quick summary of the above:
> 
> 1. Type of the meeting:
>         V4L2 'brainstorming' mini-summit :)
> 
> 2. Place:
>         Samsung Poland R&D Center
>         Polna 11 Street
>         00-633 Warsaw, Poland
> 
> 3. Date:
>         16-18 March 2011
> 
> 4. Agenda
>         TBD, everyone is welcomed to put his items here :)

In no particular order:

1) pipeline configuration, cropping and scaling:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg27956.html
http://www.mail-archive.com/linux-media@vger.kernel.org/msg26630.html

2) HDMI API support

Some hotplug/CEC code can be found here:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg28549.html

but Cisco will soon post RFCs on this topic as well.

3) Snapshot functionality.

http://www.mail-archive.com/linux-media@vger.kernel.org/msg28192.html
http://www.mail-archive.com/linux-media@vger.kernel.org/msg28490.html

If we finish quicker than expected, then we can also look at this:

- use of V4L2 as a frontend for SW/DSP codecs

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
