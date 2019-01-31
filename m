Return-Path: <SRS0=gTyh=QH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DAB2C169C4
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 12:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05FEF2086C
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 12:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732978AbfAaMmi (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 31 Jan 2019 07:42:38 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:56181 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbfAaMmi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Jan 2019 07:42:38 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gpBfw-0005ah-IR; Thu, 31 Jan 2019 13:42:36 +0100
Message-ID: <1548938556.4585.1.camel@pengutronix.de>
Subject: Re: [PATCH 10/10] venus: dec: make decoder compliant with stateful
 codec API
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tomasz Figa <tfiga@chromium.org>
Cc:     Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>
Date:   Thu, 31 Jan 2019 13:42:36 +0100
In-Reply-To: <57419418d377f32d0e6978f4e4171c0da7357cbb.camel@ndufresne.ca>
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
         <20190117162008.25217-11-stanimir.varbanov@linaro.org>
         <CAAFQd5Cm1zyPzJnixwNmWzxn2zh=63YrA+ZzH-arW-VZ_x-Awg@mail.gmail.com>
         <28069a44-b188-6b89-2687-542fa762c00e@linaro.org>
         <CAAFQd5BevOV2r1tqmGPnVtdwirGMWU=ZJU85HjfnH-qMyQiyEg@mail.gmail.com>
         <affce842d4f015e13912b2c3941c9bf02e84d194.camel@ndufresne.ca>
         <CAAFQd5Ahg4Di+SBd+-kKo4PLVyvqLwcuG6MphU5Rz1PFXVuamQ@mail.gmail.com>
         <e8a90694c306fde24928a569b7bcb231b86ec73b.camel@ndufresne.ca>
         <CAAFQd5DFfQRd1VoN7itVXnWGKW_WBKU-sm6vo5CdgjkzjEEkFg@mail.gmail.com>
         <57419418d377f32d0e6978f4e4171c0da7357cbb.camel@ndufresne.ca>
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

Hi Nicolas,

On Wed, 2019-01-30 at 10:32 -0500, Nicolas Dufresne wrote:
> Le mercredi 30 janvier 2019 à 15:17 +0900, Tomasz Figa a écrit :
> > > I don't remember saying that, maybe I meant to say there might be a
> > > workaround ?
> > > 
> > > For the fact, here we queue the headers (or first frame):
> > > 
> > > https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/master/sys/v4l2/gstv4l2videodec.c#L624
> > > 
> > > Then few line below this helper does G_FMT internally:
> > > 
> > > https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/master/sys/v4l2/gstv4l2videodec.c#L634
> > > https://gitlab.freedesktop.org/gstreamer/gst-plugins-good/blob/master/sys/v4l2/gstv4l2object.c#L3907
> > > 
> > > And just plainly fails if G_FMT returns an error of any type. This was
> > > how Kamil designed it initially for MFC driver. There was no other
> > > alternative back then (no EAGAIN yet either).
> > 
> > Hmm, was that ffmpeg then?
> > 
> > So would it just set the OUTPUT width and height to 0? Does it mean
> > that gstreamer doesn't work with coda and mtk-vcodec, which don't have
> > such wait in their g_fmt implementations?
> 
> I don't know for MTK, I don't have the hardware and didn't integrate
> their vendor pixel format. For the CODA, I know it works, if there is
> no wait in the G_FMT, then I suppose we are being really lucky with the
> timing (it would be that the drivers process the SPS/PPS synchronously,
> and a simple lock in the G_FMT call is enough to wait). Adding Philipp
> in CC, he could explain how this works, I know they use GStreamer in
> production, and he would have fixed GStreamer already if that was
> causing important issue.

CODA predates the width/height=0 rule on the coded/OUTPUT queue.
It currently behaves more like a traditional mem2mem device.

When width/height is set via S_FMT(OUT) or output crop selection, the
driver will believe it and set the same (rounded up to macroblock
alignment) on the capture queue without ever having seen the SPS.

The source change event after SPS parsing that the spec requires isn't
even implemented yet.

regards
Philipp
