Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:36490 "EHLO
	mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbcHQNtq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2016 09:49:46 -0400
MIME-Version: 1.0
In-Reply-To: <1471440728-16931-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1471440728-16931-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 17 Aug 2016 15:34:55 +0200
Message-ID: <CAMuHMdW6G_X+CiYrWn1H6YBvMNxK4iz7-KWLFYjxocn8eRLkoA@mail.gmail.com>
Subject: Re: [PATCH] v4l: rcar-fcp: Don't force users to check for disabled
 FCP support
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 17, 2016 at 3:32 PM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> The rcar_fcp_enable() function immediately returns successfully when the
> FCP device pointer is NULL to avoid forcing the users to check the FCP
> device manually before every call. However, the stub version of the
> function used when the FCP driver is disabled returns -ENOSYS
> unconditionally, resulting in a different API contract for the two
> versions of the function.
>
> As a user that requires FCP support will fail at probe time when calling
> rcar_fcp_get() if the FCP driver is disabled, the stub version of the
> rcar_fcp_enable() function will only be called with a NULL FCP device.
> We can thus return 0 unconditionally to align the behaviour with the
> normal version of the function.
>
> Reported-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
