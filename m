Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:57115 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbbATJi5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jan 2015 04:38:57 -0500
Received: by mail-lb0-f180.google.com with SMTP id b6so6905989lbj.11
        for <linux-media@vger.kernel.org>; Tue, 20 Jan 2015 01:38:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1501192316550.1903@axis700.grange>
References: <Pine.LNX.4.64.1501192316550.1903@axis700.grange>
Date: Tue, 20 Jan 2015 10:38:56 +0100
Message-ID: <CAMuHMdXdcyGar+p+kFDUrdavoYfq9Wm6uJzK2jQcze0iyxk+7Q@mail.gmail.com>
Subject: Re: [PATCH] soc-camera: fix device capabilities in multiple camera
 host drivers
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Mon, Jan 19, 2015 at 11:19 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> The V4L2 API requires both .capabilities and .device_caps fields of
> struct v4l2_capability to be set. Otherwise the compliance checker
> complains and since commit "v4l2-ioctl: WARN_ON if querycap didn't fill
> device_caps" a compile-time warning is issued. Fix this non-compliance
> in several soc-camera camera host drivers.

Thanks, works fine on r8a7740/armadillo-legacy!

> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
