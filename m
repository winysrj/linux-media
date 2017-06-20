Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:35025 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbdFTMzl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 08:55:41 -0400
Received: by mail-ua0-f196.google.com with SMTP id j53so2328278uaa.2
        for <linux-media@vger.kernel.org>; Tue, 20 Jun 2017 05:55:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170609161026.7582-1-khilman@baylibre.com>
References: <20170609161026.7582-1-khilman@baylibre.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Tue, 20 Jun 2017 13:55:09 +0100
Message-ID: <CA+V-a8u49iwtp9G-J5i6omnrS9WGAcXjMsYFas7c0ECw5yOntw@mail.gmail.com>
Subject: Re: [PATCH v2] [media] davinci: vpif: adaptions for DT support
To: Kevin Hilman <khilman@baylibre.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        linux-media <linux-media@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>,
        David Lechner <david@lechnology.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        LAK <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 9, 2017 at 5:10 PM, Kevin Hilman <khilman@baylibre.com> wrote:
> The davinci VPIF is a single hardware block, but the existing driver
> is broken up into a common library (vpif.c), output (vpif_display.c) and
> intput (vpif_capture.c).
>
> When migrating to DT, to better model the hardware, and because
> registers, interrupts, etc. are all common,it was decided to
> have a single VPIF hardware node[1].
>
> Because davinci uses legacy, non-DT boot on several SoCs still, the
> platform_drivers need to remain.  But they are also needed in DT boot.
> Since there are no DT nodes for the display/capture parts in DT
> boot (there is a single node for the parent/common device) we need to
> create platform_devices somewhere to instansiate the platform_drivers.
>
> When VPIF display/capture are needed for a DT boot, the VPIF node
> will have endpoints defined for its subdevs.  Therefore, vpif_probe()
> checks for the presence of endpoints, and if detected manually creates
> the platform_devices for the display and capture platform_drivers.
>
> [1] Documentation/devicetree/bindings/media/ti,da850-vpif.txt
>
> Signed-off-by: Kevin Hilman <khilman@baylibre.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad
