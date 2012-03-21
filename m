Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46151 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab2CUS7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 14:59:09 -0400
Received: by vcqp1 with SMTP id p1so1324179vcq.19
        for <linux-media@vger.kernel.org>; Wed, 21 Mar 2012 11:59:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+Wz9Gn0PUqDyeFkK36QGu9HNVm3SUfaGrpvsit==BKvkA@mail.gmail.com>
References: <CALF0-+U+H=mycbcWYP8J9+5TsGCA8NdBWC7Ge7xJ11F3Q6=j=g@mail.gmail.com>
	<1332291909.26972.3.camel@palomino.walls.org>
	<CALF0-+Wz9Gn0PUqDyeFkK36QGu9HNVm3SUfaGrpvsit==BKvkA@mail.gmail.com>
Date: Wed, 21 Mar 2012 14:59:09 -0400
Message-ID: <CAGoCfiz1RmNwYBsHnXr5__qTy58k2BTp-P3d_sqSdWt9tS7TjQ@mail.gmail.com>
Subject: Re: [Q] v4l buffer format inside isoc
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
Cc: Andy Walls <awalls@md.metrocast.net>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/3/21 Ezequiel García <elezegarcia@gmail.com>:
> 2012/3/20 Andy Walls <awalls@md.metrocast.net>:
>
>>
>> Section 8.10 of the SAA7113 data sheet shows 16 "data formats".  The
>> interesting one for video is #15 Y:U:V 4:2:2.

Every USB bridge provides their raw video over isoc in a slightly
different format (not just in terms of the colorspace but also how to
read the isoc header to detect the start of video frame, which field
is being sent, etc).  Regarding the colorspace, in many cases it's
simply 16-bit YUYV, so I would probably start there.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
