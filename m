Return-path: <mchehab@pedra>
Received: from smtp-out.google.com ([74.125.121.67]:52936 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab1CKArQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 19:47:16 -0500
Received: from wpaz17.hot.corp.google.com (wpaz17.hot.corp.google.com [172.24.198.81])
	by smtp-out.google.com with ESMTP id p2B0lEd0001536
	for <linux-media@vger.kernel.org>; Thu, 10 Mar 2011 16:47:14 -0800
Received: from vxg33 (vxg33.prod.google.com [10.241.34.161])
	by wpaz17.hot.corp.google.com with ESMTP id p2B0lDWt026897
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-media@vger.kernel.org>; Thu, 10 Mar 2011 16:47:13 -0800
Received: by vxg33 with SMTP id 33so2537675vxg.31
        for <linux-media@vger.kernel.org>; Thu, 10 Mar 2011 16:47:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299803678.13462.14.camel@localhost>
References: <1299204400.2812.35.camel@localhost>
	<1299362366.2570.27.camel@localhost>
	<1299377017.2341.50.camel@localhost>
	<AANLkTimU9qV11p+wTDz4SCvaoYyxpja8tmJ5D7-ki==B@mail.gmail.com>
	<1299445446.2310.157.camel@localhost>
	<1299803678.13462.14.camel@localhost>
Date: Thu, 10 Mar 2011 16:47:11 -0800
Message-ID: <AANLkTikEr-1WU1=bOOZO6HpN_ej2OHoAXRhdyS06n4at@mail.gmail.com>
Subject: Re: BUG at mm/mmap.c:2309 when cx18.ko and cx18-alsa.ko loaded
From: Hugh Dickins <hughd@google.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	David Miller <davem@davemloft.net>,
	linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Mar 10, 2011 at 4:34 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Sun, 2011-03-06 at 16:04 -0500, Andy Walls wrote:
>> On Sun, 2011-03-06 at 10:37 -0800, Hugh Dickins wrote:
>
>> > I do expect the underlying problem to be somewhere down the driver
>> > end, given that nobody else has been reporting these issues.  I'm
>> > hoping that once the cx18 guys have time to try to reproduce it,
>> > they'll be better able to track it down.
>
> Hi Hugh,
>
> You were correct.  The mistake was in the cx18 driver, in the last thing
> that I touched, of course.  The code causing the bug isn't anywhere
> aside from my private repo.

Thanks a lot for reporting back, Andy: relief all round.

Hugh
