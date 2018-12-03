Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f196.google.com ([209.85.166.196]:52291 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbeLCJnH (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2018 04:43:07 -0500
Received: by mail-it1-f196.google.com with SMTP id i7so8221555iti.2
        for <linux-media@vger.kernel.org>; Mon, 03 Dec 2018 01:42:50 -0800 (PST)
MIME-Version: 1.0
References: <20181130075849.16941-1-wens@csie.org> <20181130075849.16941-3-wens@csie.org>
In-Reply-To: <20181130075849.16941-3-wens@csie.org>
From: Jagan Teki <jagan@amarulasolutions.com>
Date: Mon, 3 Dec 2018 15:12:39 +0530
Message-ID: <CAMty3ZBig1hJWgjF7LF52Z9vjJcqpNXLgdkru0S55fnrebT-ig@mail.gmail.com>
Subject: Re: [PATCH 2/6] media: sun6i: Add H3 compatible
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
> Add a compatible string entry for the H3.
>
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---

Reviewed-by: Jagan Teki <jagan@amarulasolutions.com>
