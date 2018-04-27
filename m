Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:34229 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935189AbeD0OZL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Apr 2018 10:25:11 -0400
Received: by mail-qt0-f195.google.com with SMTP id m5-v6so2474802qti.1
        for <linux-media@vger.kernel.org>; Fri, 27 Apr 2018 07:25:10 -0700 (PDT)
Received: from mail-qk0-f170.google.com (mail-qk0-f170.google.com. [209.85.220.170])
        by smtp.gmail.com with ESMTPSA id l1sm1083899qki.32.2018.04.27.07.25.09
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Apr 2018 07:25:09 -0700 (PDT)
Received: by mail-qk0-f170.google.com with SMTP id a202so1509448qkg.3
        for <linux-media@vger.kernel.org>; Fri, 27 Apr 2018 07:25:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <18b9e776-3558-30ed-f616-a0ba8e4d177d@iki.fi>
References: <CAAZRmGz8iTDSZ6S=05V0JKDXBnS47e43MBBSvnGtrVv-QioirA@mail.gmail.com>
 <20180409091441.GX4043@hirez.programming.kicks-ass.net> <CAAZRmGw9DTHX65cYch6ozjGejMnDNQx_aNF-RYPRo+E4COEoRA@mail.gmail.com>
 <18b9e776-3558-30ed-f616-a0ba8e4d177d@iki.fi>
From: Olli Salonen <olli.salonen@iki.fi>
Date: Fri, 27 Apr 2018 16:25:08 +0200
Message-ID: <CAAZRmGzvh_R_JPkD6sNC_qQddTrv0zCi3TEdGd-Si9qTc2HrLg@mail.gmail.com>
Subject: Re: Regression: DVBSky S960 USB tuner doesn't work in 4.10 or newer
To: Antti Palosaari <crope@iki.fi>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Nibble Max <nibble.max@gmail.com>,
        linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        wsa@the-dreams.de
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the suggestion Antti.

I've tried to add a delay in various places, but haven't seen any
improvement. However, what I did saw was that if I added an msleep
after the lock:

static int dvbsky_usb_generic_rw(struct dvb_usb_device *d,
                u8 *wbuf, u16 wlen, u8 *rbuf, u16 rlen)
{
        int ret;
        struct dvbsky_state *state = d_to_priv(d);

        mutex_lock(&d->usb_mutex);
        msleep(20);

The error was seen very within a minute. If I increased the msleep to
50, it failed within seconds. This doesn't seem to make sense to me.
This is the only function where usb_mutex is used. If the mutex is
held for a longer time, the next attempt to lock the mutex should just
be delayed a bit, no?

Cheers,
-olli

On 18 April 2018 at 10:49, Antti Palosaari <crope@iki.fi> wrote:
>
> On 04/18/2018 07:49 AM, Olli Salonen wrote:
>>
>> Thank you for your response Peter!
>>
>> Indeed, it seems strange. dvbsky.c driver seems to use mutex_lock in
>> very much the same way as many other drivers. I've now confirmed that
>> I can get a 4.10 kernel with working DVBSky S960 by reverting the
>> following 4 patches:
>>
>> 549bdd3 Revert "locking/mutex: Add lock handoff to avoid starvation"
>> 3210f31 Revert "locking/mutex: Restructure wait loop"
>> 418a170 Revert "locking/mutex: Simplify some ww_mutex code in
>> __mutex_lock_common()"
>> 0b1fb8f Revert "locking/mutex: Enable optimistic spinning of woken waiter"
>> c470abd Linux 4.10
>
>
> These kind of issues tend to be timing issues very often. Just add some
> sleeps to i2c adapter algo / usb control messages and test.
>
> regards
> Antti
>
>
>
>
> --
> http://palosaari.fi/
