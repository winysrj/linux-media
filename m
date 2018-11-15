Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f67.google.com ([209.85.208.67]:45864 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388019AbeKPB7r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 20:59:47 -0500
MIME-Version: 1.0
References: <20181115145013.3378-1-paul.kocialkowski@bootlin.com> <20181115145013.3378-4-paul.kocialkowski@bootlin.com>
In-Reply-To: <20181115145013.3378-4-paul.kocialkowski@bootlin.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Thu, 15 Nov 2018 23:51:12 +0800
Message-ID: <CAGb2v66jEqqYA8-96GzguE_=PZribEDaMXxrYupTQdwjPkmBRQ@mail.gmail.com>
Subject: Re: [PATCH 03/15] ARM: dts: sun8i-h3: Fix the system-control register range
To: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-sunxi@googlegroups.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 15, 2018 at 10:50 PM Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
>
> Unlike in previous generations, the system-control register range is not
> limited to a size of 0x30 on the H3. In particular, the EMAC clock
> configuration register (accessed through syscon) is at offset 0x30 in
> that range.
>
> Extend the register size to its full range (0x1000) as a result.
>
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Other than the subject format,

Acked-by: Chen-Yu Tsai <wens@csie.org>
