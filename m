Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:36546 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750961AbcHVIca (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 04:32:30 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1608211759290.425-100000@netrider.rowland.org>
References: <CAJs94EYxbF5HT35pCNa7LT_AQMj=hVz8L826W-uzdLeQwzYXYQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1608211759290.425-100000@netrider.rowland.org>
From: "Matwey V. Kornilov" <matwey@sai.msu.ru>
Date: Mon, 22 Aug 2016 11:32:07 +0300
Message-ID: <CAJs94EYBROS3WiUOrjsx8rDHK27w4Q6z=kH4=Obua8jM9_6AmQ@mail.gmail.com>
Subject: Re: pwc over musb: 100% frame drop (lost) on high resolution stream
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Bin Liu <b-liu@ti.com>, hdegoede@redhat.com,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2016-08-22 1:00 GMT+03:00 Alan Stern <stern@rowland.harvard.edu>:
> On Sun, 21 Aug 2016, Matwey V. Kornilov wrote:
>
>> In both cases (with or without HCD_BH), usb_hcd_giveback_urb is called
>> every 0.01 sec. It is not clear why behavior is so different.
>
> What behavior are you asking about?  The difference between HCD_BH set
> and not set?
>

The difference between HCD_BH set and not set is that when it is not
set then usb_hcd_giveback_urb() receive zero-length URBs. And this
breaks my pwc webcam. And the question is how to fix it.
As far as I can see, usb_hcd_giveback_urb is being called with the
same rate in both cases, so zero-length URBs are probably supposed to
be data-carrying.

> Alan Stern
>



-- 
With best regards,
Matwey V. Kornilov.
Sternberg Astronomical Institute, Lomonosov Moscow State University, Russia
119991, Moscow, Universitetsky pr-k 13, +7 (495) 9392382
