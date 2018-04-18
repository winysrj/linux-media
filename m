Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:43303 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751444AbeDRIuB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 04:50:01 -0400
Subject: Re: Regression: DVBSky S960 USB tuner doesn't work in 4.10 or newer
To: Olli Salonen <olli.salonen@iki.fi>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Nibble Max <nibble.max@gmail.com>,
        linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        wsa@the-dreams.de
References: <CAAZRmGz8iTDSZ6S=05V0JKDXBnS47e43MBBSvnGtrVv-QioirA@mail.gmail.com>
 <20180409091441.GX4043@hirez.programming.kicks-ass.net>
 <CAAZRmGw9DTHX65cYch6ozjGejMnDNQx_aNF-RYPRo+E4COEoRA@mail.gmail.com>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <18b9e776-3558-30ed-f616-a0ba8e4d177d@iki.fi>
Date: Wed, 18 Apr 2018 11:49:57 +0300
MIME-Version: 1.0
In-Reply-To: <CAAZRmGw9DTHX65cYch6ozjGejMnDNQx_aNF-RYPRo+E4COEoRA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 04/18/2018 07:49 AM, Olli Salonen wrote:
> Thank you for your response Peter!
> 
> Indeed, it seems strange. dvbsky.c driver seems to use mutex_lock in
> very much the same way as many other drivers. I've now confirmed that
> I can get a 4.10 kernel with working DVBSky S960 by reverting the
> following 4 patches:
> 
> 549bdd3 Revert "locking/mutex: Add lock handoff to avoid starvation"
> 3210f31 Revert "locking/mutex: Restructure wait loop"
> 418a170 Revert "locking/mutex: Simplify some ww_mutex code in
> __mutex_lock_common()"
> 0b1fb8f Revert "locking/mutex: Enable optimistic spinning of woken waiter"
> c470abd Linux 4.10

These kind of issues tend to be timing issues very often. Just add some 
sleeps to i2c adapter algo / usb control messages and test.

regards
Antti




-- 
http://palosaari.fi/
