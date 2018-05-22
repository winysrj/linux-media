Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:44736 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751240AbeEVLE6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 07:04:58 -0400
MIME-Version: 1.0
In-Reply-To: <20180522090519.ghezen56unsjix62@verge.net.au>
References: <20180520072437.9686-1-laurent.pinchart+renesas@ideasonboard.com> <20180522090519.ghezen56unsjix62@verge.net.au>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 22 May 2018 13:04:56 +0200
Message-ID: <CAMuHMdUbjkcWsuocU-ox0y2etTsy7=WhKFKj3HDEoqyif_CtMw@mail.gmail.com>
Subject: Re: [PATCH v2] v4l: vsp1: Fix vsp1_regs.h license header
To: Simon Horman <horms@verge.net.au>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Nobuhiro Iwamatsu <iwamatsu@debian.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

On Tue, May 22, 2018 at 11:05 AM, Simon Horman <horms@verge.net.au> wrote:
>> --- a/drivers/media/platform/vsp1/vsp1_regs.h
>> +++ b/drivers/media/platform/vsp1/vsp1_regs.h
>> @@ -1,4 +1,4 @@
>> -/* SPDX-License-Identifier: GPL-2.0 */
>> +/* SPDX-License-Identifier: GPL-2.0+ */
>
> While you are changing this line, I believe the correct format is
> to use a '//' comment.
>
> i.e.:
>
> // SPDX-License-Identifier: GPL-2.0+

Not for C header files, only for C source files.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
