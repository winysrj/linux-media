Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:35302 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbZDBSZN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2009 14:25:13 -0400
Received: by bwz17 with SMTP id 17so643962bwz.37
        for <linux-media@vger.kernel.org>; Thu, 02 Apr 2009 11:25:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200904020929.22359.hverkuil@xs4all.nl>
References: <1238619656.3986.88.camel@tux.localhost>
	 <200904020929.22359.hverkuil@xs4all.nl>
Date: Thu, 2 Apr 2009 22:25:10 +0400
Message-ID: <208cbae30904021125y4597a04crc3b201b6c88ae79c@mail.gmail.com>
Subject: Re: [RFC] BKL in open functions in drivers
From: Alexey Klimov <klimov.linux@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Alessio Igor Bogani <abogani@texware.it>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 2, 2009 at 11:29 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:

[...]

>> So, questions are:
>>
>> 1) What for is lock/unlock_kernel() used in open?
>
> It's pointless. Just remove it.

Actually, i can see lock/unlock_kernel() in open in other V4L drivers too.
What for is it used in other drivers?

>> 2) Can it be replaced by mutex, for example?
>
> No need.

Good, so we can remove it.

>> Please, comments, explanations are more than welcome.
>
> But what is really wrong is the way the 'users' field is used: that should
> be an atomic counter: on the first-time-open you set up the device, and
> when the last user goes away you can close it down.
>
> Currently if you open the device a second time and then close that second
> fh, the first gets muted by that close. Not what you want!
>
> Actually, I don't see why this stuff is in the open/close at all, unless
> this saves some measurable amount of power consumption. I'd just move the
> setup code in the open() to the probe() and after that both the open() and
> close() functions become no-ops.
>
> Regards,
>
>        Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG

Agreed, thanks for explanations and suggestions.

-- 
Best regards, Klimov Alexey
