Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:56391 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750838AbeCFQe6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Mar 2018 11:34:58 -0500
Date: Tue, 6 Mar 2018 13:34:51 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Bhumika Goyal <bhumirks@gmail.com>
Subject: Re: [PATCH] media: ov772x: constify ov772x_frame_intervals
Message-ID: <20180306133451.4be117e6@vento.lan>
In-Reply-To: <20180306160526.GC19648@w540>
References: <7b69f2cb91319abdacf37be501db2eae45112a09.1520350517.git.mchehab@s-opensource.com>
        <20180306160526.GC19648@w540>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 6 Mar 2018 17:05:26 +0100
jacopo mondi <jacopo@jmondi.org> escreveu:

> Hi Mauro,
> 
> On Tue, Mar 06, 2018 at 10:35:22AM -0500, Mauro Carvalho Chehab wrote:
> > The values on this array never changes. Make it const.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>  
> 
> Acked-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> 
> Since I'm sure there will be more cleanup/fixes on tw9910 and ov772x,
> could you please take into account my series:
> [PATCH v2 00/11] media: ov772x/tw9910 cleanup
> before any additional change to these 2 drivers?

That is the next on my patch queue :-)

Reviewing them right now.

Regards,
Mauro
