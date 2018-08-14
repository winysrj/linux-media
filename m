Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.intenta.de ([178.249.25.132]:29097 "EHLO mail.intenta.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730664AbeHNJ0s (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 05:26:48 -0400
Date: Tue, 14 Aug 2018 08:35:40 +0200
From: Helmut Grohne <h.grohne@intenta.de>
To: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        <linux-media@vger.kernel.org>
Subject: why does aptina_pll_calculate insist on exact division?
Message-ID: <20180814063538.qxgg6ua5z7ta6pwp@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I tried using the aptina_pll_calculate for a "new" imager and ran into
problems. After filling out aptina_pll_limits from the data sheet, I was
having a hard time finding a valid pix_clock. Most of the ones I tried
are rejected by aptina_pll_calculate for various reasons. In particular,
no pix_clock close to pix_clock_max is allowed.

Why does the calculation method insist on exact division and avoiding
fractional numbers?

I'm using an ext_clock of 50 MHz. This clock is derived from a 33 MHz
clock and the 50 MHz is not attained exactly. Rather it ends up being
more like 49.999976 Hz. This raises the question, what value I should
put into ext_clock (or the corresponding device tree property). Should I
use the requested frequency or the actual frequency? Worse, depending on
the precise value of the ext_clock, aptina_pll_calculate may or may not
be able to compute pll parameters.

On the other hand, the manufacturer provided configuration tool happily
computes pll parameters that result in close, but not exactly, the
requested pix_clock. In particular, the pll parameters do not
necessarily result in a whole number. It appears to merely approximate
the requested frequency.

Can you explain where the requirement to avoid fractional numbers comes
from? Would it be reasonable to use a different algorithm that avoids
this requirement?

Helmut
