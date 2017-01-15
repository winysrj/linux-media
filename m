Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f173.google.com ([74.125.82.173]:35518 "EHLO
        mail-ot0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750944AbdAONRo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 15 Jan 2017 08:17:44 -0500
Received: by mail-ot0-f173.google.com with SMTP id 65so30054333otq.2
        for <linux-media@vger.kernel.org>; Sun, 15 Jan 2017 05:17:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <9828a30b479e1d96698402a38db2fb63e73374f0.1484476433.git.baruch@tkos.co.il>
References: <9828a30b479e1d96698402a38db2fb63e73374f0.1484476433.git.baruch@tkos.co.il>
From: Fabio Estevam <festevam@gmail.com>
Date: Sun, 15 Jan 2017 11:17:43 -0200
Message-ID: <CAOMZO5Cn_-WA1rEw+cbeBTVuFjqgdF9dZtUehsHnpkVgp=EoYA@mail.gmail.com>
Subject: Re: [PATCH v3] [media] coda: add Freescale firmware compatibility location
To: Baruch Siach <baruch@tkos.co.il>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jan 15, 2017 at 8:33 AM, Baruch Siach <baruch@tkos.co.il> wrote:
> The Freescale provided imx-vpu looks for firmware files under /lib/firmware/vpu
> by default. Make coda look there for firmware files to ease the update path.
>
> Cc: Fabio Estevam <festevam@gmail.com>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Reviewed-by: Fabio Estevam <fabio.estevam@nxp.com>
