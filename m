Return-path: <hverkuil@xs4all.nl>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1493 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab0HIIFe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Aug 2010 04:05:34 -0400
Message-ID: <b003fbb16bb40c1d0dca94cdf77b89a9.squirrel@webmail.xs4all.nl>
In-Reply-To: <1281339235.2296.17.camel@masi.mnp.nokia.com>
References: <1280758003-16118-1-git-send-email-matti.j.aaltonen@nokia.com>
    <1281339235.2296.17.camel@masi.mnp.nokia.com>
Date: Mon, 9 Aug 2010 10:05:16 +0200
Subject: Re: [PATCH v7 0/5] TI WL1273 FM Radio driver.
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: matti.j.aaltonen@nokia.com
Cc: linux-media@vger.kernel.org,
	"Valentin Eduardo" <eduardo.valentin@nokia.com>, mchehab@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hello.
>
> It starts to look like the ALSA codec could be
> accepted on the ALSA list pretty soon.
> So I'd be very interested to hear from you if
> the rest of the driver still needs fixes...

Thanks for reminding me. I'll do a final review this evening.


> By the way, now the newest wl1273 firmware supports
> a special form of hardware seek,  they call it the
> 'bulk search' mode. It can be used to search for all
> stations that are available and at first the number of found
> stations is returned. Then the frequencies can be fetched
> one by one. Should we add a 'seek mode' field to hardware
> seek? Or do you have a vision of how it should be handled?

It sounds very hardware specific. We should postpone support for this
until we have support for subdev device nodes. That will make it possible
to create custom ioctls for hw specific features. This should be merged
if all goes well for 2.6.37.

Regards,

         Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

