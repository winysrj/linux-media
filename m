Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:64922 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933574AbaCSQG4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Mar 2014 12:06:56 -0400
Received: by mail-ob0-f170.google.com with SMTP id uz6so8297508obc.15
        for <linux-media@vger.kernel.org>; Wed, 19 Mar 2014 09:06:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <532945D0.2020007@xs4all.nl>
References: <CABMudhQzWS7P6uSq=tQQY85JLkj+qdZEg+AbCSwVYFevp6gy-w@mail.gmail.com>
	<532945D0.2020007@xs4all.nl>
Date: Wed, 19 Mar 2014 09:06:41 -0700
Message-ID: <CABMudhQMzHaxVEWCegEFYuuxg5Lbdvm-eLwOJd79r9V6rVG4WA@mail.gmail.com>
Subject: Re: How can I feed more data to a stream after I stream on?
From: m silverstri <michael.j.silverstri@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you.

If I am working on both the user side and the driver itself, why the
buffer must contain a full image? Is that a limitation of v4l2 m2m
framework?



On Wed, Mar 19, 2014 at 12:22 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 03/19/2014 12:18 AM, m silverstri wrote:
>> I am using v4l2 m2m framework to develop a resize driver. I have an
>> image , pass it to the driver and it generated a resize output image.
>>
>> My v4l2 sequence is
>> 1. qbuf OUTPUT, CAPTURE
>> 2. stream on OUTPUT, CAPTURE
>> 3. dqbuf OUTPUT, CAPTURE
>> 4. stream off OUTPUT, CAPTURE
>>
>> this works if i have a full frame of image before i start streaming.
>>
>> But what I only have partial buffers when I start streaming, how can I
>> qbuf more buffer after I 'stream on' OUTPUT,
>
> You can't. Each buffer passed to the driver must contain a full image.
> So your application needs some logic to keep filling a buffer until it
> is complete and only then do you issue the QBUF.
>
> Regards,
>
>         Hans
>
>>
>> I try this, but this fail
>> 1. qbuf OUTPUT, CAPTURE (I qbuf only partial OUTPUT)
>> 2. stream on OUTPUT, CAPTURE
>>
>> // do this in a loop:
>> 3. dqbuf OUTPUT (I want to queue more OUTPUT as they become available)
>> 4. qbuf OUTPUT
>>
>> // now I am done, I want to dqbuf my output
>> 5. dqbuf CAPTURE
>> 6. stream off OUTPUT, CAPTURE
>>
>> I try to do dqbuf/qbuf OUTPUT in step #3, #4 above, but it just stuck
>> in dqbuf OUTPUT.
>>
>> How can I queue more of my input data after I stream on?
>>
>> Thank you.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
