Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:36190 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755056AbcHXSST (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 14:18:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAJs94EYBROS3WiUOrjsx8rDHK27w4Q6z=kH4=Obua8jM9_6AmQ@mail.gmail.com>
References: <CAJs94EYxbF5HT35pCNa7LT_AQMj=hVz8L826W-uzdLeQwzYXYQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1608211759290.425-100000@netrider.rowland.org> <CAJs94EYBROS3WiUOrjsx8rDHK27w4Q6z=kH4=Obua8jM9_6AmQ@mail.gmail.com>
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Wed, 24 Aug 2016 21:17:56 +0300
Message-ID: <CAJs94EbNiMbAvGZjLF4V-KY80gp=QkC1=MYkuJCFRa--NC+OJQ@mail.gmail.com>
Subject: Re: pwc over musb: 100% frame drop (lost) on high resolution stream
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Bin Liu <b-liu@ti.com>, hdegoede@redhat.com,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-08-22 11:32 GMT+03:00 Matwey V. Kornilov <matwey@sai.msu.ru>:
> 2016-08-22 1:00 GMT+03:00 Alan Stern <stern@rowland.harvard.edu>:
>> On Sun, 21 Aug 2016, Matwey V. Kornilov wrote:
>>
>>> In both cases (with or without HCD_BH), usb_hcd_giveback_urb is called
>>> every 0.01 sec. It is not clear why behavior is so different.
>>
>> What behavior are you asking about?  The difference between HCD_BH set
>> and not set?
>>
>
> The difference between HCD_BH set and not set is that when it is not
> set then usb_hcd_giveback_urb() receive zero-length URBs. And this
> breaks my pwc webcam. And the question is how to fix it.
> As far as I can see, usb_hcd_giveback_urb is being called with the
> same rate in both cases, so zero-length URBs are probably supposed to
> be data-carrying.
>

I can't understand what makes the difference. What I found to this
moment is the following:

1) isoc transfer works in two empirical modes or regimes. I called
them 'normal' one and 'broken'.
1a) In the 'normal' mode, every package is 956 bytes long and
c->desc->pd2 (see cppi41_irq) is 1400009a
1b) In the 'broken' mode, every package is 0 bytes long and
c->desc->pd2 (see cppi41_irq) is 1408009a
2) In each mode cppi41_irq is invoked every 1 ms.
2a) When the time lag between two subsequent calls of cppi41_irq is
greater (up to 2 ms) or less (0.3 ms) than 1 ms then the mode is
switched. It can happen inside single URB without calling complete().
So, the data are flowing in large bulks of either empty or full packages.
3) When HCD_BH is not set, then this two regimes are being flipped
constantly breaking internal pwc logic. When HCD_BH is set, then first
dozens packages are empty, then there is a pause between cppi41_irq
and the rest packages are fine.


>> Alan Stern
>>
>
>
>
> --
> With best regards,
> Matwey V. Kornilov.
> Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
> 119991, Moscow, Universitetsky pr-k 13, +7 (495) 9392382



-- 
With best regards,
Matwey V. Kornilov.
Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
119991, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
