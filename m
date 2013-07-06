Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:64595 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab3GFVyY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jul 2013 17:54:24 -0400
Received: by mail-bk0-f53.google.com with SMTP id e11so1400172bkh.12
        for <linux-media@vger.kernel.org>; Sat, 06 Jul 2013 14:54:23 -0700 (PDT)
Message-ID: <51D8920C.8020306@gmail.com>
Date: Sat, 06 Jul 2013 23:54:20 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC] Support for events with a large payload
References: <201305131414.43685.hverkuil@xs4all.nl> <201306241540.14469.hverkuil@xs4all.nl> <20130702230159.GO2064@valkosipuli.retiisi.org.uk> <3981855.thaXQaXO7C@avalon>
In-Reply-To: <3981855.thaXQaXO7C@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/03/2013 09:34 PM, Laurent Pinchart wrote:
> On Wednesday 03 July 2013 02:01:59 Sakari Ailus wrote:
>> On Mon, Jun 24, 2013 at 03:40:14PM +0200, Hans Verkuil wrote:
>> ...
>>
>>> Since the payloads are larger I am less concerned about speed. There is
>>> one problem, though: if you dequeue the event and the buffer that should
>>> receive the payload is too small, then you have lost that payload. You
>>> can't allocate a new, larger, buffer and retry. So this approach can only
>>> work if you really know the maximum payload size.
>>>
>>> The advantage is also that you won't lose payloads.
>>
>> Forgot to answer this one --- I think it's fair to assume the user knows the
>> maximum size of the payload. What we also could do in such a case is to
>> return the error (e.g. ENOSPC) and put the required size to the large event
>> size field. But first someone must come up with a variable size event
>> without well defined maximum size for this to make much sense.
>
> And while we're discussing use cases, Hans, what are you current use cases for
> 64 bytes event payloads ?

One of the use cases could be face detection events. A face marker would
contain at least 4 rectangle data structures (face, left/right eye, 
mouth,...),
which is itself 64 bytes. Plus Euler angle information, confidence, 
smile/blink
level etc. We could add an object detection specific ioctl(s) (I'm not sure
if such won't be needed anyway), but the event API looks like a good
infrastructure to handle this kind of data.

--
Regards,
Sylwester
