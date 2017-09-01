Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:36179 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751511AbdIAIka (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 04:40:30 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1504222628.git.mchehab@s-opensource.com>
References: <cover.1504222628.git.mchehab@s-opensource.com>
From: =?UTF-8?Q?Honza_Petrou=C5=A1?= <jpetrous@gmail.com>
Date: Fri, 1 Sep 2017 10:40:28 +0200
Message-ID: <CAJbz7-0QaB3Hpi23pZZ_DLFQyqQ7kynRiP6J0a8UUj9RzooLCA@mail.gmail.com>
Subject: Re: [PATCH 00/15] Improve DVB documentation and reduce its gap
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Shuah Khan <shuah@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Colin Ian King <colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-09-01 1:46 GMT+02:00 Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> The DVB documentation was negligected for a long time, with
> resulted on several gaps between the API description and its
> documentation.
>
> I'm doing a new reading at the documentation. As result of it,
> this series:
>
> - improves the introductory chapter, making it more generic;
> - Do some adjustments at the frontend API, using kernel-doc
>   when possible.
> - Remove unused APIs at DVB demux. I suspect that the drivers
>   implementing such APIs were either never merged upstream,
>   or the API itself  were never used or was deprecated a long
>   time ago. In any case, it doesn't make any sense to carry
>   on APIs that aren't properly documented, nor are used on the
>   upstream Kernel.
>
> With this patch series, the gap between documentation and
> code is solved for 3 DVB APIs:
>
>   - Frontend API;
>   - Demux API;
>   - Net API.
>
> There is still a gap at the CA API that I'll try to address when I
> have some time[1].
>
> [1] There's a gap also on the legacy audio, video and OSD APIs,
>     but, as those are used only by a single very old deprecated
>     hardware (av7110), it is probably not worth the efforts.
>

I agree that av7110 is very very old piece of hw (but it is already
in my hall of fame because of its Skystar 1 incarnation as
first implementation of DVB in Linux) and it is sad that we still
don't have at least one driver for any SoC with embedded DVB
devices.

I understand that the main issue is that no any DVB-enabled
SoC vendor is interested in upstreaming theirs code, but I still hope
it will change in near future(*)

Without having full-featured DVB device in vanilla, we surely don't
get some parts of DVB API covered. I can imagine that  when
somebody comes with such full-featured device he wants to reinvent
just removed bits.

It's my 5 cents
/Honza

(*) My favourite is HiSilicon with very nice Hi3798 4K chip
with announced support from Linaro and already available
devboard for reasonable price.

PS: I'm in no any way connected with HiSilicon nor
any other DVB-enabled SoC vendor.
