Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:45835 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753471AbeFGLDB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2018 07:03:01 -0400
Message-ID: <1528369377.3308.10.camel@pengutronix.de>
Subject: Re: [RFC PATCH 2/2] media: docs-rst: Add encoder UAPI specification
 to Codec Interfaces
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>, Tomasz Figa <tfiga@chromium.org>
Cc: Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com,
        Tiffany Lin =?UTF-8?Q?=28=E6=9E=97=E6=85=A7=E7=8F=8A=29?=
        <tiffany.lin@mediatek.com>,
        Andrew-CT Chen =?UTF-8?Q?=28=E9=99=B3=E6=99=BA=E8=BF=AA=29?=
        <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        todor.tomov@linaro.org, nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Thu, 07 Jun 2018 13:02:57 +0200
In-Reply-To: <f5aab078-3e10-151b-c6f8-fb3fe6952d16@xs4all.nl>
References: <20180605103328.176255-1-tfiga@chromium.org>
         <20180605103328.176255-3-tfiga@chromium.org>
         <1528199628.4074.15.camel@pengutronix.de>
         <CAAFQd5DYu+Oehr1UUvvdmWk7toO0i_=NFgvZcAKQ8ZURKy51fA@mail.gmail.com>
         <1528208578.4074.19.camel@pengutronix.de>
         <CAAFQd5DqHj65AdzfYmvHWkqHnZntiiA2AhAfgHbLA3AuWvsOTQ@mail.gmail.com>
         <1528278003.3438.3.camel@pengutronix.de>
         <CAAFQd5A2hsgrmwJ3bgv6EDKqqy5Y86CnMcktrWa+YihWGjxtHg@mail.gmail.com>
         <41fd04f2-fc44-1792-81e6-a3d4d384adc5@xs4all.nl>
         <1528367543.3308.6.camel@pengutronix.de>
         <f5aab078-3e10-151b-c6f8-fb3fe6952d16@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2018-06-07 at 12:54 +0200, Hans Verkuil wrote:
[...]
> > > I have a patch to add a new v4l2_format flag for that since forever, but
> > > since we do not have any drivers that can do this in the kernel it has never
> > > been upstreamed.
> > 
> > Has this patch been posted some time? I think we could add a mem2mem
> > device to imx-media with support for linear transformations.
> 
> I don't believe it's ever been posted.
> 
> It's here:
> 
> https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=csc&id=d0e588c1a36604538e16f24cad3444c84f5da73e

Thanks!

regards
Philipp
