Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:49950 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaFAIuV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Jun 2014 04:50:21 -0400
MIME-Version: 1.0
In-Reply-To: <1401593977-30660-12-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1401593977-30660-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1401593977-30660-12-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Sun, 1 Jun 2014 10:50:20 +0200
Message-ID: <CAMuHMdUCT1rSQWn+B9zQ3a-BPJsBePK9K5NszR==AriaRm8BjQ@mail.gmail.com>
Subject: Re: [PATCH 11/18] v4l: vsp1: wpf: Simplify cast to pipeline structure
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 1, 2014 at 5:39 AM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> USe the subdev pointer directly to_vsp1_pipeline() macro instead of

Use

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
