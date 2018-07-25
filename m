Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:44769 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728358AbeGYOjx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 10:39:53 -0400
Message-ID: <1532525286.4879.5.camel@pengutronix.de>
Subject: Re: [PATCH 0/2] Document memory-to-memory video codec interfaces
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com,
        Tiffany Lin =?UTF-8?Q?=28=E6=9E=97=E6=85=A7=E7=8F=8A=29?=
        <tiffany.lin@mediatek.com>,
        Andrew-CT Chen =?UTF-8?Q?=28=E9=99=B3=E6=99=BA=E8=BF=AA=29?=
        <andrew-ct.chen@mediatek.com>, todor.tomov@linaro.org,
        nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dave Stevenson <dave.stevenson@raspberrypi.org>,
        ezequiel@collabora.com
Date: Wed, 25 Jul 2018 15:28:06 +0200
In-Reply-To: <20180724140621.59624-1-tfiga@chromium.org>
References: <20180724140621.59624-1-tfiga@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Tue, 2018-07-24 at 23:06 +0900, Tomasz Figa wrote:
> This series attempts to add the documentation of what was discussed
> during Media Workshops at LinuxCon Europe 2012 in Barcelona and then
> later Embedded Linux Conference Europe 2014 in Düsseldorf and then
> eventually written down by Pawel Osciak and tweaked a bit by Chrome OS
> video team (but mostly in a cosmetic way or making the document more
> precise), during the several years of Chrome OS using the APIs in
> production.
> 
> Note that most, if not all, of the API is already implemented in
> existing mainline drivers, such as s5p-mfc or mtk-vcodec. Intention of
> this series is just to formalize what we already have.
>
> It is an initial conversion from Google Docs to RST, so formatting is
> likely to need some further polishing. It is also the first time for me
> to create such long RST documention. I could not find any other instance
> of similar userspace sequence specifications among our Media documents,
> so I mostly followed what was there in the source. Feel free to suggest
> a better format.
> 
> Much of credits should go to Pawel Osciak, for writing most of the
> original text of the initial RFC.
> 
> Changes since RFC:
> (https://lore.kernel.org/patchwork/project/lkml/list/?series=348588)
>  - The number of changes is too big to list them all here. Thanks to
>    a huge number of very useful comments from everyone (Philipp, Hans,
>    Nicolas, Dave, Stanimir, Alexandre) we should have the interfaces much
>    more specified now. The issues collected since previous revisions and
>    answers leading to this revision are listed below.

Thanks a lot for the update, and especially for the nice Q&A summary of
the discussions so far.

[...]
> Decoder issues
> 
[...]
>   How should ENUM_FRAMESIZES be affected by profiles and levels?
> 
>   Answer: Not in current specification - the logic is too complicated and
>   it might make more sense to actually handle this in user space.  (In
>   theory, level implies supported frame sizes + other factors.)

For decoding I think it makes more sense to let the hardware decode them
from the stream and present them as read-only controls, such as:

42a68012e67c ("media: coda: add read-only h.264 decoder profile/level
controls")

if possible. For encoding, the coda firmware determines level from
bitrate and coded resolution, itself, so I agree not making this part of
the spec is a good idea for now.

regards
Philipp
