Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37099
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750872AbdISQti (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Sep 2017 12:49:38 -0400
Date: Tue, 19 Sep 2017 13:49:30 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Mats Randgaard <matrandg@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] [media] tc358743: Increase FIFO level to 300.
Message-ID: <20170919134930.6fa28562@recife.lan>
In-Reply-To: <1505834685.10076.5.camel@pengutronix.de>
References: <cover.1505826082.git.dave.stevenson@raspberrypi.org>
        <3e638375aff788b24f988e452214649d6100a596.1505826082.git.dave.stevenson@raspberrypi.org>
        <1505834685.10076.5.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 Sep 2017 17:24:45 +0200
Philipp Zabel <p.zabel@pengutronix.de> escreveu:

> Hi Dave,
> 
> On Tue, 2017-09-19 at 14:08 +0100, Dave Stevenson wrote:
> > The existing fixed value of 16 worked for UYVY 720P60 over
> > 2 lanes at 594MHz, or UYVY 1080P60 over 4 lanes. (RGB888
> > 1080P60 needs 6 lanes at 594MHz).
> > It doesn't allow for lower resolutions to work as the FIFO
> > underflows.
> > 
> > Using a value of 300 works for all resolutions down to VGA60,
> > and the increase in frame delay is <4usecs for 1080P60 UYVY
> > (2.55usecs for RGB888).
> > 
> > Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>  
> 
> Can we increase this to 320? This would also allow
> 720p60 at 594 Mbps / 4 lanes, according to the xls.

Hmm... if this is dependent on the resolution and frame rate, wouldn't
it be better to dynamically adjust it accordingly?

Regards,
Maur

Thanks,
Mauro
