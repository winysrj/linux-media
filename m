Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:51976 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752195AbdHQINX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Aug 2017 04:13:23 -0400
Date: Thu, 17 Aug 2017 10:13:20 +0200
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Archit Taneja <architt@codeaurora.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 3/4] arm: dts: renesas: add cec clock for Koelsch board
Message-ID: <20170817081320.GD26170@verge.net.au>
References: <20170730130743.19681-1-hverkuil@xs4all.nl>
 <20170730130743.19681-4-hverkuil@xs4all.nl>
 <CAMuHMdXSHz2vKNOfJGM3ByzTankzd66Hj_Q_KewmHSWhSmV1Sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXSHz2vKNOfJGM3ByzTankzd66Hj_Q_KewmHSWhSmV1Sg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 14, 2017 at 05:34:41PM +0200, Geert Uytterhoeven wrote:
> On Sun, Jul 30, 2017 at 3:07 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Probably the one-line summary should be
> 
>     ARM: dts: koelsch: Add CEC clock  for HDMI transmitter
> 
> > The adv7511 on the Koelsch board has a 12 MHz fixed clock
> > for the CEC block. Specify this in the dts to enable CEC support.
> >
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Thanks, I have applied this patch with the updated one-line summary.
