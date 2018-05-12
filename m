Return-path: <linux-media-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:45758 "EHLO
        hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbeELNUs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 May 2018 09:20:48 -0400
Received: from homiemail-a78.g.dreamhost.com (sub5.mail.dreamhost.com [208.113.200.129])
        by hapkido.dreamhost.com (Postfix) with ESMTP id 0D61C8A3F8
        for <linux-media@vger.kernel.org>; Sat, 12 May 2018 06:20:48 -0700 (PDT)
Subject: Re: [PATCH 2/7] Disable additional drivers requiring gpio/consumer.h
To: "Jasmin J." <jasmin@anw.at>, Brad Love <brad@nextdimension.cc>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>
References: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
 <1524763162-4865-3-git-send-email-brad@nextdimension.cc>
 <e8d69388-3e47-eeaf-840d-5464fc6c8dc5@anw.at>
From: Brad Love <brad@b-rad.cc>
Message-ID: <ca407df1-64be-6180-0e5d-7f055418eddf@b-rad.cc>
Date: Sat, 12 May 2018 08:20:46 -0500
MIME-Version: 1.0
In-Reply-To: <e8d69388-3e47-eeaf-840d-5464fc6c8dc5@anw.at>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jasmin,


On 2018-05-12 04:31, Jasmin J. wrote:
> Hello Brad!
>
> Tonight build broke due to patch 95ee4c285022!
> You enabled VIDEO_OV2685 for 3.13., which doesn't
> compile for Kernels older than 3.17. When you look
> to the Kernel 3.17 section a lot of the drivers you
> enabled for 3.13 with your patch should be enabled
> for 3.17 only.
>
> So please test this and provide a follow up patch.
> I will not revert 95ee4c285022 now, except you can't
> fix it in a reasonable time frame.
>
> If you like and you have time you can improve
> scripts/make_kconfig.pl to detect such an issue to
> avoid future problems like this. I also had such a
> situation with enabling a driver twice in the past.
>
> BR,
>    Jasmin

Apologies. Interesting though, as I was working against 3.10 while
submitting this. I will verify and submit a correction today.

Cheers,

Brad
