Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45103 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab2BDPi5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Feb 2012 10:38:57 -0500
Received: by eekc14 with SMTP id c14so1547199eek.19
        for <linux-media@vger.kernel.org>; Sat, 04 Feb 2012 07:38:56 -0800 (PST)
Message-ID: <4F2D510A.1040503@gmail.com>
Date: Sat, 04 Feb 2012 16:38:50 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [Q] Interleaved formats on the media bus
References: <4F27CF29.5090905@samsung.com> <4F2924F8.3040408@samsung.com> <4F2D14ED.8080105@iki.fi> <3142039.4Ht9bV5jFQ@avalon>
In-Reply-To: <3142039.4Ht9bV5jFQ@avalon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 02/04/2012 12:30 PM, Laurent Pinchart wrote:
>> I'd be much in favour or using a separate channel ID as Guennadi asked;
>> that way you could quite probably save one memory copy as well. But if
>> the hardware already exists and behaves badly there's usually not much
>> you can do about it.
> 
> If I'm not mistaken, the sensor doesn't send data in separate channels but

I suspect it might be sending data on separate virtual channels, but the
bridge won't understand that and will just return one data plane in memory.
The sensor might well send the data in one channel, I don't know myself yet.

In either case we end up with a mixed data in memory, that must be parsed,
which is likely best done in the user space.
Also please see my previous answer to Sakari, there is some more details
there.

> interleaves them in a single channel (possibly with headers or fixed-size
> packets - Sylwester, could you comment on that ?). That makes it pretty
> difficult to do anything else than pass-through capture.

I'm not entirely sure the sensor doesn't send the data in separate virtual
channels. Certainly the bridge cannot DMA each channel into separate memory
buffers.

--

Regards,
Sylwester
