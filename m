Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58291 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388062AbeGWKms (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 06:42:48 -0400
Message-ID: <1532338947.3501.6.camel@pengutronix.de>
Subject: Re: [PATCH v2 00/16] i.MX media mem2mem scaler
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Nicolas Dufresne <nicolas@ndufresne.ca>
Date: Mon, 23 Jul 2018 11:42:27 +0200
In-Reply-To: <1532338170.3501.4.camel@pengutronix.de>
References: <20180719153042.533-1-p.zabel@pengutronix.de>
         <38565a74-7c79-1af6-6ed6-b44a20c9266c@gmail.com>
         <1532338170.3501.4.camel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-07-23 at 11:29 +0200, Philipp Zabel wrote:
[...]
> > Also, I'm trying to parse the functions find_best_seam() and 
> > find_seams(). Can
> > you provide some more background on the behavior of those functions?
> 
> The hardware limits us to restart linear sampling at zero with each
> tile, so find_seams() tries to find the (horizontal and vertical) output
> positions where the corresponding input sampling positions are closest
> to integer values.
> The distance between the ideal fractional input sampling position and
> the actual integer sampling position that can be achieved is the amount
> of distortion we have to introduce (by slightly stretching one input
> tile and slightly shrinking the other) to completely hide the visible
> seams.

Actually, this is not all of it. In addition to being an integer, the
input sampling position at seam start is still subject to alignment
restrictions, so the actual value that is minimized is the difference
between the ideal fractional input sampling position and the closest
aligned input position.

regards
Philipp
