Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34748 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753890AbcHSIoR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 04:44:17 -0400
MIME-Version: 1.0
In-Reply-To: <1471595974-28960-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1471595974-28960-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1471595974-28960-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 19 Aug 2016 10:44:16 +0200
Message-ID: <CAMuHMdUAi+Zm1fDiTKzZ+HLM1ZqZ=LKmBehC8YNkQoVe53et8Q@mail.gmail.com>
Subject: Re: [PATCH 3/6] v4l: rcar-fcp: Don't get/put module reference
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 19, 2016 at 10:39 AM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> Direct callers of the FCP API hold a reference to the FCP module due to
> module linkage, there's no need to take another one manually. Take a
> reference to the device instead to ensure that it won't disappear being

... behind

> the caller's back.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
