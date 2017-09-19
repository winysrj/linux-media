Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:49791 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751370AbdISPYw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 11:24:52 -0400
Message-ID: <1505834685.10076.5.camel@pengutronix.de>
Subject: Re: [PATCH 2/3] [media] tc358743: Increase FIFO level to 300.
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Date: Tue, 19 Sep 2017 17:24:45 +0200
In-Reply-To: <3e638375aff788b24f988e452214649d6100a596.1505826082.git.dave.stevenson@raspberrypi.org>
References: <cover.1505826082.git.dave.stevenson@raspberrypi.org>
         <3e638375aff788b24f988e452214649d6100a596.1505826082.git.dave.stevenson@raspberrypi.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dave,

On Tue, 2017-09-19 at 14:08 +0100, Dave Stevenson wrote:
> The existing fixed value of 16 worked for UYVY 720P60 over
> 2 lanes at 594MHz, or UYVY 1080P60 over 4 lanes. (RGB888
> 1080P60 needs 6 lanes at 594MHz).
> It doesn't allow for lower resolutions to work as the FIFO
> underflows.
> 
> Using a value of 300 works for all resolutions down to VGA60,
> and the increase in frame delay is <4usecs for 1080P60 UYVY
> (2.55usecs for RGB888).
> 
> Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>

Can we increase this to 320? This would also allow
720p60 at 594 Mbps / 4 lanes, according to the xls.

regards
Philipp
