Return-path: <linux-media-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.185]:41717 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104AbZCaFTi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 01:19:38 -0400
Received: by ti-out-0910.google.com with SMTP id i7so1919291tid.23
        for <linux-media@vger.kernel.org>; Mon, 30 Mar 2009 22:19:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <412bdbff0903302154w5ddb3fc8m684bcb5092942561@mail.gmail.com>
References: <15ed362e0903170855k2ec1e5afm613de692c237e34d@mail.gmail.com>
	 <412bdbff0903302154w5ddb3fc8m684bcb5092942561@mail.gmail.com>
Date: Tue, 31 Mar 2009 13:19:35 +0800
Message-ID: <15ed362e0903302219o18915401w5fe9605c3028f832@mail.gmail.com>
Subject: Re: [PATCH] Support for Legend Silicon LGS8913/LGS8GL5/LGS8GXX China
	DMB-TH digital demodulator
From: David Wong <davidtlwong@gmail.com>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin

The unified LGS8GXX driver surely work on some DMB-TH devices I have.
They are:
TECHGEAR HDTVC USB (also for MagicPro ProHDTV USB as they are the same
hardware with same USB ID)
ASUS U3100 Mini DMB-TH USB

Timothy Lee tested with this unified driver for his MagicPro ProHDTV USB too.
ASUS patch is sent to Alan Knowles, don't know his result yet.

David

On Tue, Mar 31, 2009 at 12:54 PM, Devin Heitmueller
<devin.heitmueller@gmail.com> wrote:
> On Tue, Mar 17, 2009 at 11:55 AM, David Wong <davidtlwong@gmail.com> wrote:
>> This patch contains the unified driver for Legend Silicon LGS8913 and
>> LGS8GL5. It should replace lgs8gl5.c in media/dvb/frontends
>>
>> David T.L. Wong
>
> David,
>
> The questions you posed tonight on a separate thread about making the
> xc5000 work with this device prompts the question:
>
> Do you know that this driver you submitted actually works?  Have you
> successfully achieved lock with this driver and been able to view the
> stream?
>
> It is great to see the improvements and more generic support, but if
> you don't have it working in at least one device, then it probably
> shouldn't be submitted upstream yet, and it definitely should not be
> replacing an existing driver.
>
> Devin
>
> --
> Devin J. Heitmueller
> http://www.devinheitmueller.com
> AIM: devinheitmueller
>
