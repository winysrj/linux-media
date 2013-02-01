Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:37892 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463Ab3BAVDe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 16:03:34 -0500
Received: by mail-we0-f171.google.com with SMTP id u54so3381121wey.30
        for <linux-media@vger.kernel.org>; Fri, 01 Feb 2013 13:03:32 -0800 (PST)
Message-ID: <510C2DA2.7020000@googlemail.com>
Date: Fri, 01 Feb 2013 21:03:30 +0000
From: Chris Clayton <chris2553@googlemail.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: WinTV-HVR-1400: scandvb (and kaffeine) fails to find any channels
References: <510A9A1E.9090801@googlemail.com> <CAGoCfiwQNBv1r5KgCzYFf7X1hP--fyQpqvRHCDtKFcSxwbJWpA@mail.gmail.com> <510ADB2F.4080901@googlemail.com> <510AF800.2090607@googlemail.com> <510BACD5.2070406@googlemail.com> <510BCE2F.1070100@googlemail.com> <CAGoCfix8XDzcgtCiL39Qna_QBx_=ZEKyMknzbsS3iTXS04_a8A@mail.gmail.com>
In-Reply-To: <CAGoCfix8XDzcgtCiL39Qna_QBx_=ZEKyMknzbsS3iTXS04_a8A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

On 02/01/13 14:19, Devin Heitmueller wrote:
> On Fri, Feb 1, 2013 at 9:16 AM, Chris Clayton <chris2553@googlemail.com> wrote:
>> I've got some more diagnostics. I tuned on the 12c debugging in the cx23885
>> driver and ran the scan again. Surprisingly, the scan found 22 channels on a
>> single frequency (that carries the BBC channels). I've attached two files -
>> the output from dvbscan and the kernel log covering the loading of the
>> drivers and running the scan.
>>
>> I'm no kernel guru, but is it possible that the root cause of the scan
>> failures is a timing problem which is being partially offset by the time
>> taken to produce all the debug output?
>
> w_scan does have some arguments that let you increase the timeout for
> tuning.  You may wish to see if that has any effect.  Maybe the w_scan
> timeout is just too short for that device.
>

Yes, I noticed that but even with the tuning timeout set at medium or 
longest, I doesn't find any channels. However, I've been following the 
debug messages through the code and ended up at 
drivers/media/pci/cx23885/cx23885-i2c.c.

I've found that by amending I2C_WAIT_DELAY from 32 to 64, I get improved 
results from scanning. With that delay doubled, scandvb now finds 49 
channels over 3 frequencies. That's with all debugging turned off, so no 
extra delays provided by the production of debug messages.

I'll play around more tomorrow and update then.

Chris

> Devin
>
