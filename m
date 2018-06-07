Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:45458 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933086AbeFGRtn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2018 13:49:43 -0400
Received: by mail-qk0-f193.google.com with SMTP id c198-v6so7086574qkg.12
        for <linux-media@vger.kernel.org>; Thu, 07 Jun 2018 10:49:42 -0700 (PDT)
Message-ID: <d1f991320ad327dc952edd2b3a374bbf36e79efd.camel@ndufresne.ca>
Subject: Re: [RFC PATCH 1/2] media: docs-rst: Add decoder UAPI specification
 to Codec Interfaces
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Tomasz Figa <tfiga@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com,
        Tiffany Lin =?UTF-8?Q?=28=E6=9E=97=E6=85=A7=E7=8F=8A=29?=
        <tiffany.lin@mediatek.com>,
        Andrew-CT Chen =?UTF-8?Q?=28=E9=99=B3=E6=99=BA=E8=BF=AA=29?=
        <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        todor.tomov@linaro.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Thu, 07 Jun 2018 13:49:39 -0400
In-Reply-To: <CAAFQd5Bk2VVdPW2C9erQ-vgWDV5ySZH+WeWGyqtrzNug2F1SuQ@mail.gmail.com>
References: <20180605103328.176255-1-tfiga@chromium.org>
         <20180605103328.176255-2-tfiga@chromium.org>
         <1528198888.4074.13.camel@pengutronix.de>
         <CAAFQd5BKdqPWVREeuprWS43kPz7XZR5buiPUZY5UKhaaQCMOBg@mail.gmail.com>
         <1528281896.3438.6.camel@pengutronix.de>
         <CAAFQd5Bk2VVdPW2C9erQ-vgWDV5ySZH+WeWGyqtrzNug2F1SuQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le jeudi 07 juin 2018 à 16:27 +0900, Tomasz Figa a écrit :
> > > I'd say no, but I guess that would mean that the driver never
> > > encounters it, because hardware wouldn't report it.
> > > 
> > > I wonder would happen in such case, though. Obviously decoding of such
> > > stream couldn't continue without support in the driver.
> > 
> > GStreamer supports decoding of variable resolution streams without
> > driver support by just stopping and restarting streaming completely.
> 
> What about userspace that doesn't parse the stream on its own? Do we
> want to impose the requirement of full bitstream parsing even for
> hardware that can just do it itself?

We do it this way in GStreamer because we can and is more reliable with
existing drivers. I do think that the driver driven renegotiation is
superior as it allow a lot more optimization. Full reset is a just the
slowest possible method of renegotiating. It is not visually fantastic
with dynamic streams, like DASH and HLS. Though, we should think of a
way driver can signal that this renegotiation is supported.

Nicolas
