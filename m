Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:32861 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212Ab3LFKyM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Dec 2013 05:54:12 -0500
Received: by mail-oa0-f41.google.com with SMTP id j17so574722oag.28
        for <linux-media@vger.kernel.org>; Fri, 06 Dec 2013 02:54:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52A1A76A.6070301@epfl.ch>
References: <CA+2YH7ueF46YA2ZpOT80w3jTzmw0aFWhfshry2k_mrXAmW=MXA@mail.gmail.com>
	<52A1A76A.6070301@epfl.ch>
Date: Fri, 6 Dec 2013 11:54:11 +0100
Message-ID: <CA+2YH7vDjCuTPwO9hDv-sM6ALAS_q-ZW2V=uq4MKG=75KD3xKg@mail.gmail.com>
Subject: Re: omap3isp device tree support
From: Enrico <ebutera@users.berlios.de>
To: florian.vaussard@epfl.ch
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Dec 6, 2013 at 11:31 AM, Florian Vaussard
<florian.vaussard@epfl.ch> wrote:
> Hello,
>
> On 12/06/2013 11:13 AM, Enrico wrote:
>> Hi,
>>
>> i know there is some work going on for omap3isp device tree support,
>> but right now is it possible to enable it in some other way in a DT
>> kernel?
>>
>
> The DT support is not yet ready, but an RFC binding has been proposed.
> It won't be ready for 3.14.
>
>> I've tried enabling it in board-generic.c (omap3_init_camera(...) with
>> proper platform data) but it hangs early at boot, do someone know if
>> it's possible and how to do it?
>>
>
> I did the same a few days ago, and went through several problems
> (panics, half DT support,...). Now I am able to probe the ISP, I still
> have one kernel panic to fix. Hope to send the patches in 1 or 2 days.
> We are still in a transition period, but things should calm down in the
> coming releases.
>
> Cheers,
>
> Florian
>
> [1] http://www.spinics.net/lists/linux-media/msg69424.html

Thanks Florian, i will gladly help in testing.

Enrico
