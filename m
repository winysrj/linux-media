Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40625 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388084AbeKPBnp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 20:43:45 -0500
MIME-Version: 1.0
References: <20181115145013.3378-1-paul.kocialkowski@bootlin.com> <20181115145013.3378-15-paul.kocialkowski@bootlin.com>
In-Reply-To: <20181115145013.3378-15-paul.kocialkowski@bootlin.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Thu, 15 Nov 2018 23:35:14 +0800
Message-ID: <CAGb2v64pVKG4mSAF48xR54yj00rQ6iTvgYQB9Bf-XWmH2FhVqQ@mail.gmail.com>
Subject: Re: [linux-sunxi] [PATCH 14/15] arm64: dts: allwinner: h5: Add Video
 Engine and reserved memory node
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

On Thu, Nov 15, 2018 at 10:51 PM Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
>
> This adds nodes for the Video Engine and the associated reserved memory
> for the H5. Up to 96 MiB of memory are dedicated to the CMA pool.
>
> The pool is located at the end of the first 256 MiB of RAM so that the
> VPU can access it. It is unclear whether this is still a hard
> requirement for this platform, but it seems safer that way.

I think we can actually test this. You could move the reserved memory
pool beyond 256 MiB, and have cedrus decode stuff, and try to display
the results. If it's gibberish, or the system crashes, it's likely the
memory access wrapped around at 256 MiB.

What do you think?

ChenYu
