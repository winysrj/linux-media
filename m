Return-Path: <SRS0=gTyh=QH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCFAFC169C4
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 12:44:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A04A2086C
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 12:44:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733014AbfAaMoP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 31 Jan 2019 07:44:15 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:34425 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbfAaMoO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Jan 2019 07:44:14 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gpBhV-0005db-2h; Thu, 31 Jan 2019 13:44:13 +0100
Message-ID: <1548938648.4585.3.camel@pengutronix.de>
Subject: Re: [PATCH v3 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Kamil Debski <kamil@wypas.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Tiffany Lin =?UTF-8?Q?=28=E6=9E=97=E6=85=A7=E7=8F=8A=29?= 
        <tiffany.lin@mediatek.com>,
        Andrew-CT Chen =?UTF-8?Q?=28=E9=99=B3=E6=99=BA=E8=BF=AA=29?= 
        <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Todor Tomov <todor.tomov@linaro.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Jourdan <maxi.jourdan@wanadoo.fr>
Date:   Thu, 31 Jan 2019 13:44:08 +0100
In-Reply-To: <54430438-33a3-2c52-b6c8-4000a4088906@xs4all.nl>
References: <20190124100419.26492-1-tfiga@chromium.org>
         <20190124100419.26492-2-tfiga@chromium.org>
         <a3b1b650-94d7-bb84-41ef-dc4cab0cdae1@xs4all.nl>
         <54430438-33a3-2c52-b6c8-4000a4088906@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, 2019-01-31 at 13:30 +0100, Hans Verkuil wrote:
> On 1/31/19 11:45 AM, Hans Verkuil wrote:
> > On 1/24/19 11:04 AM, Tomasz Figa wrote:
> > > Due to complexity of the video decoding process, the V4L2 drivers of
> > > stateful decoder hardware require specific sequences of V4L2 API calls
> > > to be followed. These include capability enumeration, initialization,
> > > decoding, seek, pause, dynamic resolution change, drain and end of
> > > stream.
> > > 
> > > Specifics of the above have been discussed during Media Workshops at
> > > LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
> > > Conference Europe 2014 in Düsseldorf. The de facto Codec API that
> > > originated at those events was later implemented by the drivers we already
> > > have merged in mainline, such as s5p-mfc or coda.
> > > 
> > > The only thing missing was the real specification included as a part of
> > > Linux Media documentation. Fix it now and document the decoder part of
> > > the Codec API.
> > > 
> > > Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> > > ---
> > >  Documentation/media/uapi/v4l/dev-decoder.rst  | 1076 +++++++++++++++++
> > >  Documentation/media/uapi/v4l/dev-mem2mem.rst  |    5 +
> > >  Documentation/media/uapi/v4l/pixfmt-v4l2.rst  |    5 +
> > >  Documentation/media/uapi/v4l/v4l2.rst         |   10 +-
> > >  .../media/uapi/v4l/vidioc-decoder-cmd.rst     |   40 +-
> > >  Documentation/media/uapi/v4l/vidioc-g-fmt.rst |   14 +
> > >  6 files changed, 1135 insertions(+), 15 deletions(-)
> > >  create mode 100644 Documentation/media/uapi/v4l/dev-decoder.rst
> > > 
> > 
> > <snip>
> > 
> > > +4.  **This step only applies to coded formats that contain resolution information
> > > +    in the stream.** Continue queuing/dequeuing bitstream buffers to/from the
> > > +    ``OUTPUT`` queue via :c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`. The
> > > +    buffers will be processed and returned to the client in order, until
> > > +    required metadata to configure the ``CAPTURE`` queue are found. This is
> > > +    indicated by the decoder sending a ``V4L2_EVENT_SOURCE_CHANGE`` event with
> > > +    ``V4L2_EVENT_SRC_CH_RESOLUTION`` source change type.
> > > +
> > > +    * It is not an error if the first buffer does not contain enough data for
> > > +      this to occur. Processing of the buffers will continue as long as more
> > > +      data is needed.
> > > +
> > > +    * If data in a buffer that triggers the event is required to decode the
> > > +      first frame, it will not be returned to the client, until the
> > > +      initialization sequence completes and the frame is decoded.
> > > +
> > > +    * If the client sets width and height of the ``OUTPUT`` format to 0,
> > > +      calling :c:func:`VIDIOC_G_FMT`, :c:func:`VIDIOC_S_FMT`,
> > > +      :c:func:`VIDIOC_TRY_FMT` or :c:func:`VIDIOC_REQBUFS` on the ``CAPTURE``
> > > +      queue will return the ``-EACCES`` error code, until the decoder
> > > +      configures ``CAPTURE`` format according to stream metadata.
> > 
> > I think this should also include the G/S_SELECTION ioctls, right?
> 
> I've started work on adding compliance tests for codecs to v4l2-compliance and
> I quickly discovered that this 'EACCES' error code is not nice at all.
> 
> The problem is that it is really inconsistent with V4L2 behavior: the basic
> rule is that there always is a format defined, i.e. G_FMT will always return
> a format.
> 
> Suddenly returning an error is actually quite painful to handle because it is
> a weird exception just for the capture queue of a stateful decoder if no
> output resolution is known.
> 
> Just writing that sentence is painful.
> 
> Why not just return some default driver defined format? It will automatically
> be updated once the decoder parsed the bitstream and knows the new resolution.
> 
> It really is just the same behavior as with a resolution change.
> 
> It is also perfectly fine to request buffers for the capture queue for that
> default format. It's pointless, but not a bug.
> 
> Unless I am missing something I strongly recommend changing this behavior.

I just wrote the same in my reply to Nicolas, the CODA driver currently
sets the capture queue width/height to the output queue's crop rectangle
(rounded to macroblock size) without ever having seen the SPS.

regards
Philipp
