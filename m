Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50543 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751848AbeDLKEC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Apr 2018 06:04:02 -0400
Message-ID: <1523527441.3689.7.camel@pengutronix.de>
Subject: Re: [PATCH] media: imx: Skip every second frame in VDIC DIRECT mode
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Marek Vasut <marex@denx.de>, linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Thu, 12 Apr 2018 12:04:01 +0200
In-Reply-To: <20180407130440.24886-1-marex@denx.de>
References: <20180407130440.24886-1-marex@denx.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2018-04-07 at 15:04 +0200, Marek Vasut wrote:
> In VDIC direct mode, the VDIC applies combing filter during and
> doubles the framerate, that is, after the first two half-frames
> are received and the first frame is emitted by the VDIC, every
> subsequent half-frame is patched into the result and a full frame
> is produced. The half-frame order in the full frames is as follows
> 12 32 34 54 etc.

Is that true? We are only supporting full motion mode (VDI_MOT_SEL=2),
so I was under the impression that only data from the current field
makes it into the full frame. The missing lines should be purely
estimated from the available field using the di_vfilt 4-tap filter.

regards
Philipp
