Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4014 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaCSHXD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Mar 2014 03:23:03 -0400
Message-ID: <532945D0.2020007@xs4all.nl>
Date: Wed, 19 Mar 2014 08:22:56 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: m silverstri <michael.j.silverstri@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: How can I feed more data to a stream after I stream on?
References: <CABMudhQzWS7P6uSq=tQQY85JLkj+qdZEg+AbCSwVYFevp6gy-w@mail.gmail.com>
In-Reply-To: <CABMudhQzWS7P6uSq=tQQY85JLkj+qdZEg+AbCSwVYFevp6gy-w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/19/2014 12:18 AM, m silverstri wrote:
> I am using v4l2 m2m framework to develop a resize driver. I have an
> image , pass it to the driver and it generated a resize output image.
> 
> My v4l2 sequence is
> 1. qbuf OUTPUT, CAPTURE
> 2. stream on OUTPUT, CAPTURE
> 3. dqbuf OUTPUT, CAPTURE
> 4. stream off OUTPUT, CAPTURE
> 
> this works if i have a full frame of image before i start streaming.
> 
> But what I only have partial buffers when I start streaming, how can I
> qbuf more buffer after I 'stream on' OUTPUT,

You can't. Each buffer passed to the driver must contain a full image.
So your application needs some logic to keep filling a buffer until it
is complete and only then do you issue the QBUF.

Regards,

	Hans

> 
> I try this, but this fail
> 1. qbuf OUTPUT, CAPTURE (I qbuf only partial OUTPUT)
> 2. stream on OUTPUT, CAPTURE
> 
> // do this in a loop:
> 3. dqbuf OUTPUT (I want to queue more OUTPUT as they become available)
> 4. qbuf OUTPUT
> 
> // now I am done, I want to dqbuf my output
> 5. dqbuf CAPTURE
> 6. stream off OUTPUT, CAPTURE
> 
> I try to do dqbuf/qbuf OUTPUT in step #3, #4 above, but it just stuck
> in dqbuf OUTPUT.
> 
> How can I queue more of my input data after I stream on?
> 
> Thank you.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

