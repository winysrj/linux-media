Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42458 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248Ab2GERhl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2012 13:37:41 -0400
Received: by pbbrp8 with SMTP id rp8so13097651pbb.19
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2012 10:37:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FF5AD40.3070707@iki.fi>
References: <1341497792-6066-1-git-send-email-mchehab@redhat.com>
 <1341497792-6066-3-git-send-email-mchehab@redhat.com> <4FF5AD40.3070707@iki.fi>
From: Bert Massop <bert.massop@gmail.com>
Date: Thu, 5 Jul 2012 19:37:21 +0200
Message-ID: <CAKJOob9KBQRHXWTrOM_=hmF5OSoovhPWY4aGCbhhsbLKTk5NgQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] [media] tuner, xc2028: add support for get_afc()
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 5, 2012 at 5:05 PM, Antti Palosaari <crope@iki.fi> wrote:
>
> On 07/05/2012 05:16 PM, Mauro Carvalho Chehab wrote:
>>
>> Implement API support to return AFC frequency shift, as this device
>> supports it. The only other driver that implements it is tda9887,
>> and the frequency there is reported in Hz. So, use Hz also for this
>> tuner.
>
>
> What is AFC and why it is needed?
>

AFC is short for Automatic Frequency Control, by which a tuner
automatically fine-tunes the frequency for the best reception,
compensating for small offsets and oscillator frequency drift.
This is however done automatically on the tuner, so its configuration
is read-only. Aside from being a "nice to know" statistic, getting
hold of the AFC frequency shift does as far as I know not have any
practical uses related to properly operating the tuner.

Regards,
Bert
