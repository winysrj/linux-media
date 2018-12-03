Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io1-f68.google.com ([209.85.166.68]:37116 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbeLCJmN (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2018 04:42:13 -0500
Received: by mail-io1-f68.google.com with SMTP id f14so4407994iol.4
        for <linux-media@vger.kernel.org>; Mon, 03 Dec 2018 01:41:57 -0800 (PST)
MIME-Version: 1.0
References: <20181130075849.16941-1-wens@csie.org> <20181130075849.16941-2-wens@csie.org>
In-Reply-To: <20181130075849.16941-2-wens@csie.org>
From: Jagan Teki <jagan@amarulasolutions.com>
Date: Mon, 3 Dec 2018 15:11:45 +0530
Message-ID: <CAMty3ZC-4hnVOx9AYhm7uUCUHF=n_NoH3xV-3SyUXWxb_X8TGg@mail.gmail.com>
Subject: Re: [PATCH 1/6] media: dt-bindings: media: sun6i: Separate H3
 compatible from A31
To: Chen-Yu Tsai <wens@csie.org>
Cc: Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media <linux-media@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 30, 2018 at 1:29 PM Chen-Yu Tsai <wens@csie.org> wrote:
>
> The CSI controller found on the H3 (and H5) is a reduced version of the
> one found on the A31. It only has 1 channel, instead of 4 channels for
> time-multiplexed BT.656. Since the H3 is a reduced version, it cannot
> "fallback" to a compatible that implements more features than it
> supports.
>
> Split out the H3 compatible as a separate entry, with no fallback.
>
> Fixes: b7eadaa3a02a ("media: dt-bindings: media: sun6i: Add A31 and H3
>                       compatibles")
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

"media" text appear two times on commit head.

Reviewed-by: Jagan Teki <jagan@amarulasolutions.com>
