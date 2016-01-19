Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:36041 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbcASNtb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jan 2016 08:49:31 -0500
MIME-Version: 1.0
In-Reply-To: <1453211112-3686-1-git-send-email-javier@osg.samsung.com>
References: <1453211112-3686-1-git-send-email-javier@osg.samsung.com>
Date: Tue, 19 Jan 2016 14:49:30 +0100
Message-ID: <CAMuHMdUzkVoC+jjtXVsPf0e7eS31cHp4ZNP32+18wg2GsxMywA@mail.gmail.com>
Subject: Re: [PATCH] [media] v4l: vsp1: Fix wrong entities links creation
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	=?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Tue, Jan 19, 2016 at 2:45 PM, Javier Martinez Canillas
<javier@osg.samsung.com> wrote:
> The Media Control framework now requires entities to be registered with
> the media device before creating links so commit c7621b3044f7 ("[media]
> v4l: vsp1: separate links creation from entities init") separated link
> creation from entities init.
>
> But unfortunately that patch introduced a regression since wrong links
> were created causing a boot failure on Renesas boards.
>
> This patch fixes the boot issue and also the media graph was compared
> by Geert Uytterhoeven to make sure that the driver changes required by
> the Media Control framework next generation did not affect the graph.

Thank you!

> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
