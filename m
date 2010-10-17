Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4957 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab0JQJKK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 05:10:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: Bisected MSP34xx PVR-250/PVR-350 no audio in 2.6.36
Date: Sun, 17 Oct 2010 11:09:19 +0200
Cc: linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org,
	Shane Shrybman <shrybman@teksavvy.com>
References: <1287285781.2267.5.camel@morgan.silverblock.net>
In-Reply-To: <1287285781.2267.5.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010171109.19488.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday, October 17, 2010 05:23:01 Andy Walls wrote:
> Hans,
> 
> Shane Shrybman reported that in the 2.6.36 kernel, after the first
> capture on his PVR-250, TV audio from the RF input no longer works.
> 
> I verified that RF TV audio never works with a PVR-350.
> 
> I bisected the problem to this change to the msp3400 driver:
> 
> http://git.linuxtv.org/media_tree.git?a=commit;h=ebc3bba5833e7021336f09767347a52448a60bc5
> 
> 
> $ git bisect bad
> ebc3bba5833e7021336f09767347a52448a60bc5 is the first bad commit
> commit ebc3bba5833e7021336f09767347a52448a60bc5
> Author: Hans Verkuil <hverkuil@xs4all.nl>
> Date:   Mon May 24 10:01:58 2010 -0300
> 
>     V4L/DVB: msp3400: convert to the new control framework
>     
>     Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> :040000 040000 fabcfdd08fe2835d9a146666c891b274b6546428 2199dcba591213638336d254b3a57d38bd068de4 M	drivers
> 
> 
> I don't have time to fix it this weekend, but there it is before I
> forget.

Since it is my code that broke it I took a quick look and I found the problem.

I'm trying to find the shortest fix possible since this is a regression for
2.6.36.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
