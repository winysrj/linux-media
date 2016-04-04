Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:18841 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbcDDGU6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2016 02:20:58 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 0/2] pxa_camera transition to v4l2 standalone device
References: <1459607213-15774-1-git-send-email-robert.jarzmik@free.fr>
	<57015743.3080003@xs4all.nl>
Date: Mon, 04 Apr 2016 08:20:53 +0200
In-Reply-To: <57015743.3080003@xs4all.nl> (Hans Verkuil's message of "Sun, 3
	Apr 2016 10:47:47 -0700")
Message-ID: <87inzxvqre.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> Hi Robert,
>
> It's been a very busy time for me, and both Guennadi and myself are attending the
> ELC the coming week. Speaking for myself that means that it is unlikely I'll have
> time to review anything for the next two weeks.
>
> My own renesas driver conversion work is just as slow for the same reasons. I hope
> and expect that that situation will improve during April.
>
> Being able to ditch soc-camera is a fairly high-prio thing for me, but I just don't
> have much time right now.

Hi Hans,

No worry for me, that can wait for weeks/monthes now. I have other tasks in the
alsa area and the PXA maintainance I've been delaying for too long, so it's time
to switch over.

>> Streaming ioctls:
>> test read/write: OK (Not Supported)
>
> With vb2 this is easy to support by just using vb2_fop_read as the read function and
> setting the VB2_READ flag in the io_modes. It's free, so I see no reason not
> to use it.
Ok.

> Can you also test with 'v4l2-compliance -f'? This tests all format variations.
Will do.

Cheers.

--
Robert
