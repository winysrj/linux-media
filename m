Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:33846 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932116AbdGCNkF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 09:40:05 -0400
Received: by mail-ua0-f171.google.com with SMTP id z22so109638913uah.1
        for <linux-media@vger.kernel.org>; Mon, 03 Jul 2017 06:40:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALzAhNV6UT5ybts5Z9xnCe3yz-dhdskT4=+dui74mn1Yb2MaqQ@mail.gmail.com>
References: <CAJcDVWMAq6QReuMWgA-X7n7CDqNreAOjdEHwt331gW41eDSo9w@mail.gmail.com>
 <CALzAhNV6UT5ybts5Z9xnCe3yz-dhdskT4=+dui74mn1Yb2MaqQ@mail.gmail.com>
From: =?UTF-8?Q?Bernhard_Rosenkr=C3=A4nzer?=
        <bernhard.rosenkranzer@linaro.org>
Date: Mon, 3 Jul 2017 15:39:38 +0200
Message-ID: <CAJcDVWMUWFZwM3NyU=FD-LNQOU1C1YTLJUoJ-BXJp2TgyC36AA@mail.gmail.com>
Subject: Re: [PATCH] Hauppauge HVR-1975 support
To: Steven Toth <stoth@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 3 July 2017 at 14:56, Steven Toth <stoth@kernellabs.com> wrote:
> Bernhard, thank you for sharing.
>
> Mauro,
>
> I've reviewed this patch, it has a host of problems.

Yes - it's a 1:1 forward port of the patch Hauppauge released for 3.19
(apparently with the goal to support as many of their devices as
possible).

> the patch also contains materials that I
> suspect Silicon Labs would consider proprietary and confidential, its
> definitely derived works from proprietary SILABS drivers.

Does anyone know for sure what the legal situation is when a HW
manufacturer releases a patch (as Hauppauge did) that is clearly
derived from GPL code yet at the same time derived from non-free code?
My interpretation is that by putting it out, they've released a GPL
derived work, which they can legally do only if they agree to comply
with the GPL, therefore any other license notice would be void.
But as I pointed out before I'm not a lawyer...

ttyl
bero
