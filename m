Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44328 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727434AbeKPB6n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 20:58:43 -0500
MIME-Version: 1.0
References: <20181115145013.3378-1-paul.kocialkowski@bootlin.com> <20181115145013.3378-2-paul.kocialkowski@bootlin.com>
In-Reply-To: <20181115145013.3378-2-paul.kocialkowski@bootlin.com>
From: Chen-Yu Tsai <wens@csie.org>
Date: Thu, 15 Nov 2018 23:50:09 +0800
Message-ID: <CAGb2v679sG+KqmkGway8E-CdgQa8ybBv8K2RdNwfB7zWAJkaXQ@mail.gmail.com>
Subject: Re: [PATCH 01/15] ARM: dts: sun8i-a33: Remove heading 0 in
 video-codec unit address
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
> This cosmetic change removes the heading 0 in the video-codec unit
> address, as it's done for other nodes.
>
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

Nit: I'd prefer the subject prefix format be "<family>: <soc>: ... ",
or "sun8i: a33:" in this case. This format seems to be used more often
than your alternative format.

I can fix it up when applying.

Acked-by: Chen-Yu Tsai <wens@csie.org>

ChenYu
