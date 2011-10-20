Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63088 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab1JTRpt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Oct 2011 13:45:49 -0400
Received: by ggnb1 with SMTP id b1so3038227ggn.19
        for <linux-media@vger.kernel.org>; Thu, 20 Oct 2011 10:45:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E96DF19.8080702@mlbassoc.com>
References: <4E9442A9.1060202@mlbassoc.com>
	<4E9609E3.3000902@mlbassoc.com>
	<CA+2YH7v+wV4Kz=gLkACiE0fRHu2BCLLvNj8q=ipLDVy_GztXjw@mail.gmail.com>
	<4E96CF04.7000100@mlbassoc.com>
	<CA+2YH7vaN5Q+AJZp8b9E=7Jumaz-cB191CnYDDXF6ZOt7mZocg@mail.gmail.com>
	<4E96DF19.8080702@mlbassoc.com>
Date: Thu, 20 Oct 2011 19:45:48 +0200
Message-ID: <CA+2YH7vTWcgjua4+Gfr5s72iOtar5zhDK_-BOBKXmwzTD9nDmw@mail.gmail.com>
Subject: Re: OMAP3 ISP ghosting
From: Enrico <ebutera@users.berlios.de>
To: Gary Thomas <gary@mlbassoc.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Enric Balletbo i Serra <eballetbo@iseebcn.com>,
	Javier Martinez Canillas <martinez.javier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 13, 2011 at 2:52 PM, Gary Thomas <gary@mlbassoc.com> wrote:
> On 2011-10-13 06:32, Enrico wrote:
>> Looking at the single images (top and bottom) i don't see ghosting
>> artifacts (not only in that image but in a sequence of 16 frames),
>> just a little blurry in moving parts but that's expected in an
>> interlaced video. So it seems to me that the images arrive correctly
>> at the isp and the deinterlacing causes ghosting.
>
> Is there any way to prove this by doing the de-interlacing in software?

I just tested software deinterlacing (with gstreamer) and i can
confirm it works very well, it removes ghosting completely.

It will cause other problems that have a big performance impact
(colorspace conversions, doubled framerates...) but that's another
story, and i don't know if this is the appropriate place to talk about
them.

So i don't think it's the tvp51xx to blame or the isp, you will have
to deinterlace with any analog decoder (unless it has integrated
deinterlacing).

Enrico
