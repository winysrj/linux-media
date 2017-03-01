Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f179.google.com ([74.125.82.179]:34096 "EHLO
        mail-ot0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754038AbdCBJf2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 04:35:28 -0500
Received: by mail-ot0-f179.google.com with SMTP id x10so48257580otb.1
        for <linux-media@vger.kernel.org>; Thu, 02 Mar 2017 01:35:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170301153625.16249-1-p.zabel@pengutronix.de>
References: <20170301153625.16249-1-p.zabel@pengutronix.de>
From: Fabio Estevam <festevam@gmail.com>
Date: Wed, 1 Mar 2017 15:20:08 -0300
Message-ID: <CAOMZO5Ab4U=BJDpVmxBB1V_WUtZBHs7XeDBMTeEtZfmrXfm0MA@mail.gmail.com>
Subject: Re: [PATCH] [media] coda: restore original firmware locations
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media <linux-media@vger.kernel.org>,
        Baruch Siach <baruch@tkos.co.il>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 1, 2017 at 12:36 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Recently, an unfinished patch was merged that added a third entry to the
> beginning of the array of firmware locations without changing the code
> to also look at the third element, thus pushing an old firmware location
> off the list.
>
> Fixes: 8af7779f3cbc ("[media] coda: add Freescale firmware compatibility location")
> Cc: Baruch Siach <baruch@tkos.co.il>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Reviewed-by: Fabio Estevam <fabio.estevam@nxp.com>
