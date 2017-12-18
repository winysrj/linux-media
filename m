Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f171.google.com ([74.125.82.171]:44590 "EHLO
        mail-ot0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758038AbdLRLDk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 06:03:40 -0500
MIME-Version: 1.0
In-Reply-To: <20171218101629.31395-2-p.zabel@pengutronix.de>
References: <20171218101629.31395-1-p.zabel@pengutronix.de> <20171218101629.31395-2-p.zabel@pengutronix.de>
From: Fabio Estevam <festevam@gmail.com>
Date: Mon, 18 Dec 2017 09:03:39 -0200
Message-ID: <CAOMZO5BucRG0zo0YsnEsCpGPT+PKQNM1vLPxFrm5cK0PeD3LgQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] media: coda: Add i.MX51 (CodaHx4) support
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Chris Healy <Chris.Healy@zii.aero>, devicetree@vger.kernel.org,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 18, 2017 at 8:16 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Add support for the CodaHx4 VPU used on i.MX51.
>
> Decoding h.264, MPEG-4, and MPEG-2 video works, as well as encoding
> h.264. MPEG-4 encoding is not enabled, it currently produces visual
> artifacts.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Reviewed-by: Fabio Estevam <fabio.estevam@nxp.com>
