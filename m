Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44153 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725732AbeKRLoY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Nov 2018 06:44:24 -0500
Received: by mail-qk1-f196.google.com with SMTP id n12so43545404qkh.11
        for <linux-media@vger.kernel.org>; Sat, 17 Nov 2018 17:25:47 -0800 (PST)
Message-ID: <d118bf3edaa6916c3a8138f248661ef5304883d7.camel@ndufresne.ca>
Subject: Re: [PATCH v2 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
From: Nicolas Dufresne <nicolas@ndufresne.ca>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?Q?Pawe=C5=82_O=C5=9Bciak?= <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Jourdan <maxi.jourdan@wanadoo.fr>
Date: Sat, 17 Nov 2018 20:25:43 -0500
In-Reply-To: <dd83d36b-c8a1-6f84-a4a2-103607897a64@xs4all.nl>
References: <20181022144901.113852-1-tfiga@chromium.org>
         <20181022144901.113852-2-tfiga@chromium.org>
         <45f6797a-5e9c-e2f9-2606-a5bb81d12f11@xs4all.nl>
         <8620b9ae8ba94bf24788def5775d559c1b5b0666.camel@ndufresne.ca>
         <dd83d36b-c8a1-6f84-a4a2-103607897a64@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le samedi 17 novembre 2018 à 12:43 +0100, Hans Verkuil a écrit :
> > > As far as I know all codecs have resolution/metadata in the stream.
> > 
> > Was this comment about what we currently support in V4L2 interface ? In
> 
> Yes, I was talking about all V4L2 codecs.
> 
> > real life, there is CODEC that works only with out-of-band codec data.
> > A well known one is AVC1 (and HVC1). In this mode, the AVC H264 does
> > not have start code, and the headers are not allowed in the bitstream
> > itself. This format is much more efficient to process then AVC Annex B,
> > since you can just read the NAL size and jump over instead of scanning
> > for start code. This is the format used in the very popular ISOMP4
> > container.
> 
> How would such a codec handle resolution changes? Or is that not allowed?

That's a good question. It is of course allowed, but you'd need the
request API if you want to queue this change (i.e. if you want a
resolution change using the events). Meanwhile, one can always  do
CMD_STOP, wait for the decoder to be drained, pass the new codec data,
push frames / restart streaming.

The former is the only mode implemented in GStreamer, so I'll let
Tomasz comment more on his thought how this could work.

One of the main issue with the resolution change mechanism (even
without codec data) is that you have no guaranty that the input buffer
(buffers on V4L2 OUTPUT queue) are large enough to fit a full encoded
frame of the new resolution. So userspace should have some formula to
calculate the required size, and use the CMD_STOP / drain method to be
able to re-allocate these buffers. So the newest resolution change
method, to be implemented correctly require more work (but is all
doable).

Nicolas
