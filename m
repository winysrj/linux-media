Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:51200 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751817AbeE3Lw3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 07:52:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH] media: arch: sh: migor: Fix TW9910 PDN gpio
Date: Wed, 30 May 2018 14:52:31 +0300
Message-ID: <2981239.tGoCg7U0XF@avalon>
In-Reply-To: <CAMuHMdVsV9k0OjFMkQSiKCenxfEHgcZxrMU3a5eXRaCDdeA5-A@mail.gmail.com>
References: <1527671604-18768-1-git-send-email-jacopo+renesas@jmondi.org> <CAMuHMdVsV9k0OjFMkQSiKCenxfEHgcZxrMU3a5eXRaCDdeA5-A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

On Wednesday, 30 May 2018 12:30:49 EEST Geert Uytterhoeven wrote:
> Hi Jacopo,
> 
> On Wed, May 30, 2018 at 11:13 AM, Jacopo Mondi wrote:
> > The TW9910 PDN gpio (power down) is listed as active high in the chip
> > manual. It turns out it is actually active low as when set to physical
> > level 0 it actually turns the video decoder power off.
> 
> So the picture "Typical TW9910 External Circuitry" in the datasheet, which
> ties PDN to GND permanently, is wrong?

The SH PTT2 line is connected directory to the TW9910 PDN signal, without any 
inverter on the board. The PDN signal is clearly documented as active-high in 
the TW9910 datasheet. Something is thus weird.

Jacopo, is it possible to measure the PDN signal on the board as close as 
possible to the TW9910 to see if it works as expected ?

-- 
Regards,

Laurent Pinchart
