Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f194.google.com ([209.85.166.194]:37764 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbeLCJor (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2018 04:44:47 -0500
Received: by mail-it1-f194.google.com with SMTP id b5so7605261iti.2
        for <linux-media@vger.kernel.org>; Mon, 03 Dec 2018 01:44:30 -0800 (PST)
MIME-Version: 1.0
References: <20181130075849.16941-1-wens@csie.org> <20181130075849.16941-4-wens@csie.org>
In-Reply-To: <20181130075849.16941-4-wens@csie.org>
From: Jagan Teki <jagan@amarulasolutions.com>
Date: Mon, 3 Dec 2018 15:14:19 +0530
Message-ID: <CAMty3ZBFVStHNbYaBxT+Rmy6+g4jtm0cFKk8BL5BDid3c5VW-Q@mail.gmail.com>
Subject: Re: [PATCH 3/6] ARM: dts: sunxi: h3/h5: Drop A31 fallback compatible
 for CSI controller
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
> Drop the A31 fallback compatible.
>
> Fixes: f89120b6f554 ("ARM: dts: sun8i: Add the H3/H5 CSI controller")
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---

Reviewed-by: Jagan Teki <jagan@amarulasolutions.com>
