Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:36030 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754483AbdGCPDg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 11:03:36 -0400
Received: by mail-io0-f169.google.com with SMTP id z62so58042720ioi.3
        for <linux-media@vger.kernel.org>; Mon, 03 Jul 2017 08:03:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJcDVWMUWFZwM3NyU=FD-LNQOU1C1YTLJUoJ-BXJp2TgyC36AA@mail.gmail.com>
References: <CAJcDVWMAq6QReuMWgA-X7n7CDqNreAOjdEHwt331gW41eDSo9w@mail.gmail.com>
 <CALzAhNV6UT5ybts5Z9xnCe3yz-dhdskT4=+dui74mn1Yb2MaqQ@mail.gmail.com> <CAJcDVWMUWFZwM3NyU=FD-LNQOU1C1YTLJUoJ-BXJp2TgyC36AA@mail.gmail.com>
From: Steven Toth <stoth@kernellabs.com>
Date: Mon, 3 Jul 2017 11:03:34 -0400
Message-ID: <CALzAhNVbCrtoNgZOi4Up_ZjSUTfg=ddZTEzLoBZCyTFxaQaXdw@mail.gmail.com>
Subject: Re: [PATCH] Hauppauge HVR-1975 support
To: =?UTF-8?Q?Bernhard_Rosenkr=C3=A4nzer?=
        <bernhard.rosenkranzer@linaro.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Yes - it's a 1:1 forward port of the patch Hauppauge released for 3.19
> (apparently with the goal to support as many of their devices as
> possible).

Agreed.

>
>> the patch also contains materials that I
>> suspect Silicon Labs would consider proprietary and confidential, its
>> definitely derived works from proprietary SILABS drivers.
>
> Does anyone know for sure what the legal situation is when a HW
> manufacturer releases a patch (as Hauppauge did) that is clearly
> derived from GPL code yet at the same time derived from non-free code?
> My interpretation is that by putting it out, they've released a GPL
> derived work, which they can legally do only if they agree to comply
> with the GPL, therefore any other license notice would be void.
> But as I pointed out before I'm not a lawyer...

You've raised a valid question, I don't know the answer. Others might.

I'm not a lawyer either, but if Hauppauge are not careful then they
may be violating an NDA, especially as the patch doesn't appear to
come with a sign-off, and leans very heavily on intellectual property
of Silicon Labs. I think in its current format the patch probably
wouldn't be acceptable for merge unless Hauppauge themselves provide a
sign-off.

Side note: obviously the fact it's such a large patch would require it
to be split into patches to each sub-system/card, but that's largely
beside the point of my larger concern.

Perhaps Hauppauge have legal approval to derive GPL drivers from
proprietary ,aterials, in which case I'm just making noise and a
sign-off will be soon to follow.

I'll reach out to them and ask.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
