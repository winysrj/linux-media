Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:42394 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296AbcBPJJo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2016 04:09:44 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: Re: [PATCH 0/12] TW686x driver
References: <m337tif6om.fsf@t19.piap.pl> <56B872C0.1050200@xs4all.nl>
Date: Tue, 16 Feb 2016 10:09:41 +0100
In-Reply-To: <56B872C0.1050200@xs4all.nl> (Hans Verkuil's message of "Mon, 8
	Feb 2016 11:49:36 +0100")
Message-ID: <m3h9h9qawa.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil <hverkuil@xs4all.nl> writes:

> Now, I am not planning to merge that, but I will compare it to what Ezequiel has
> and use that comparison as a starting point for further discussions.

I'm not opposed to Ezequiel's changes in general - I only want him to
present them as changes, and not as a "rewritten driver". Unless they
are considered a rewritten driver, of course.

> As I mentioned before, my preference is to merge a driver that supports both
> frame and field modes (or whatever they are called).

Well, I don't know about his, but my version presently only support
frame mode (V4L2_FIELD_SEQ_*). It specifically doesn't support
INTERLACED frame mode (SG DMA hw limitation) and it doesn't support
field mode, except for FIELD_TOP and FIELD_BOTTOM (only specific fields)
which I use to get a lower resolution image.

I also plan to use an INTERLACED frame mode with a DMA (non-SG to CMA,
it turned out it works well on my systems), but I would rather like to
have the driver in the tree before submitting further (non-essential)
patches.

Field modes are of course possible, though I've never seen any interest
for them, so I haven't bothered. Can add, it's a simple thing and it
works fine (apart from increased QBUF/DQBUF rate).

There is also a specific YUV420 mode (with a custom encoding) which
I'd like to add (unfortunately unavailable in V4L2_FIELD_SEQ_*, but
usable in INTERLACED and FIELD_*). This mode requires two separate line
lengths - odd lines contain YUV data and are twice as long as even lines
which only contain Y.
How do I set up such a mode (fmt.pix.bytesperline)?
This mode is useful on low-performance machines, e.g. feeding data to
H.264 encoders.
-- 
Krzysztof Halasa

Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
