Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:41448 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab3GYHrh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 03:47:37 -0400
Received: by mail-ob0-f172.google.com with SMTP id f8so801824obp.17
        for <linux-media@vger.kernel.org>; Thu, 25 Jul 2013 00:47:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130724155538.GF12281@valkosipuli.retiisi.org.uk>
References: <1374679278-9856-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<20130724154536.GE12281@valkosipuli.retiisi.org.uk>
	<CAHp75Vdp43x=SMYwpxWLoS0f7ku+qmZoAhW8Pao1p7DDGXcCPg@mail.gmail.com>
	<20130724155538.GF12281@valkosipuli.retiisi.org.uk>
Date: Thu, 25 Jul 2013 10:47:36 +0300
Message-ID: <CAHp75VeGYW5GKXRzg1dtPnmV+xwpBNU7RO_+5Uhi8iW07Hr62Q@mail.gmail.com>
Subject: Re: [PATCH] smiapp: re-use clamp_t instead of min(..., max(...))
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 24, 2013 at 6:55 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> On Wed, Jul 24, 2013 at 06:49:24PM +0300, Andy Shevchenko wrote:
>> On Wed, Jul 24, 2013 at 6:45 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>>
>> []
>>
>> >> +     max_m = clamp_t(u32, max_m, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN],
>> >> +                     sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX]);
>> >
>> > Do you need clamp_t()? Wouldn't plain clamp() do?
>>
>> The *_t variants are preferred due to they are faster (no type checking).
>>
>> > I can change it if you're ok with that.
>>
>> I don't know why you may choose clamp instead of clamp_t here. Are you
>> going to change variable types?
>
> Probably not. But clamp() would serve as a sanity check vs. clamp_t() which
> just does the thing. I'd prefer clamp()

You may adjust original patch if you want.

--
With Best Regards,
Andy Shevchenko
