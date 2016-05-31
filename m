Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:36016 "EHLO
	mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398AbcEaJKq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 May 2016 05:10:46 -0400
MIME-Version: 1.0
In-Reply-To: <1464369565-12259-1-git-send-email-kieran@bingham.xyz>
References: <1464369565-12259-1-git-send-email-kieran@bingham.xyz>
Date: Tue, 31 May 2016 11:10:45 +0200
Message-ID: <CAMuHMdVW56-g8F9SqO8UP62Q9nvFawwL+GgHP2Wni-a8q5YMRw@mail.gmail.com>
Subject: Re: [PATCH 0/4] RCar r8a7795 FCPF support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Kieran Bingham <kieran@ksquared.org.uk>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-renesas-soc@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kieran,

On Fri, May 27, 2016 at 7:19 PM, Kieran Bingham <kieran@ksquared.org.uk> wrote:
> An RCar FCP driver is available with support for the FCPV module for VSP.
> This series updates that driver to support the FCPF and then provide the
> relevant nodes in the r8a7795 device tree.
>
> Checkpatch generates a warning on these DT references but they are
> documented under Documentation/devicetree/bindings/media/renesas,fcp.txt
>
> These patches are based on Geert's renesas-drivers tree, and are pushed
> to a branch at git@github.com:kbingham/linux.git renesas/fcpf for
> convenience.

As this is based on previous renesas-drivers release, which included the
Salvator-X HDMI prototype, I created a topic branch topic/fcpf-v1 just
containing your changes.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
