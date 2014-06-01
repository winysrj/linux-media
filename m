Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:33532 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaFAI42 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Jun 2014 04:56:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdX4nG942paYrZ1Nqm2scK8k_3YphbqeFqn8hksdfF9ivg@mail.gmail.com>
References: <1401593977-30660-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<CAMuHMdX4nG942paYrZ1Nqm2scK8k_3YphbqeFqn8hksdfF9ivg@mail.gmail.com>
Date: Sun, 1 Jun 2014 10:56:27 +0200
Message-ID: <CAMuHMdURhVeY_PCgiJREzwqjdTfpqfm8O+N-oR0M2hA7v5TuAg@mail.gmail.com>
Subject: Re: [PATCH 00/18] Renesas VSP1: alpha support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux-sh list <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 1, 2014 at 10:51 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Sun, Jun 1, 2014 at 5:39 AM, Laurent Pinchart
> <laurent.pinchart+renesas@ideasonboard.com> wrote:
>> The first two patch add new pixel formats for alpha and non-alpha RGB, and
>> extend usage of the ALPHA_COMPONENT control to output devices. They have
>> already been posted separately, for the rationale please see
>> https://www.mail-archive.com/linux-media@vger.kernel.org/msg75449.html.
>
> mail-archive.com seems to be down.
> Do you have a link to another archiver?

I assume www.spinics.net/lists/linux-media/msg76846.html ?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
