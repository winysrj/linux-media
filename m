Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:38087 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751925AbdHHL4P (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Aug 2017 07:56:15 -0400
Received: by mail-ua0-f177.google.com with SMTP id w45so13445224uac.5
        for <linux-media@vger.kernel.org>; Tue, 08 Aug 2017 04:56:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170808112406.gkr2jhedzjkdr2ww@valkosipuli.retiisi.org.uk>
References: <1500435259-5838-1-git-send-email-festevam@gmail.com> <20170808112406.gkr2jhedzjkdr2ww@valkosipuli.retiisi.org.uk>
From: Fabio Estevam <festevam@gmail.com>
Date: Tue, 8 Aug 2017 08:56:14 -0300
Message-ID: <CAOMZO5CDVNR563UD-na882hGijaxd6ob9hUt83K_ycqmSCSmgg@mail.gmail.com>
Subject: Re: [PATCH 1/2] [media] ov7670: Return the real error code
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Jonathan Corbet <corbet@lwn.net>,
        linux-media <linux-media@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Tue, Aug 8, 2017 at 8:24 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:

> I don't think -EPROBE_DEFER is returned by clk_get() if the clock can't be
> found. The clock providers often are e.g. ISP drivers that may well be

Yes, it is.

Please check:

commit a34cd4666f3da84228a82f70c94b8d9b692034ea
Author: Jean-Francois Moine <moinejf@free.fr>
Date:   Mon Nov 25 19:47:04 2013 +0100

    clk: return probe defer when DT clock not yet ready

    At probe time, a clock device may not be ready when some other device
    wants to use it.

    This patch lets the functions clk_get/devm_clk_get return a probe defer
    when the clock is defined in the DT but not yet available.

    Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
    Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
    Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
    Signed-off-by: Mike Turquette <mturquette@linaro.org>
