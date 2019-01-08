Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D975C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 16:00:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3404220663
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 16:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbfAHQAE (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 11:00:04 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:48079 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727840AbfAHQAE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 11:00:04 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1ggtnO-0003Rs-19; Tue, 08 Jan 2019 17:00:02 +0100
Message-ID: <1546963201.5406.8.camel@pengutronix.de>
Subject: Re: [PATCH v5] media: imx: add mem2mem device
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Date:   Tue, 08 Jan 2019 17:00:01 +0100
In-Reply-To: <73ba2b0c-2776-5aec-193d-408dfcae6ebf@gmail.com>
References: <20181203114804.17078-1-p.zabel@pengutronix.de>
         <a8d3a554-aef8-b8e0-b8ad-f9116bcc3f39@xs4all.nl>
         <73ba2b0c-2776-5aec-193d-408dfcae6ebf@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Steve,

On Tue, 2018-12-04 at 17:20 -0800, Steve Longerbeam wrote:
> Hi Hans, Philipp,
> 
> One comment on my side...
> 
> On 12/3/18 7:21 AM, Hans Verkuil wrote:
> > <snip>
> > > +void imx_media_mem2mem_device_unregister(struct imx_media_video_dev *vdev)
> > > +{
> > > +	struct mem2mem_priv *priv = to_mem2mem_priv(vdev);
> > > +	struct video_device *vfd = priv->vdev.vfd;
> > > +
> > > +	mutex_lock(&priv->mutex);
> > > +
> > > +	if (video_is_registered(vfd)) {
> > > +		video_unregister_device(vfd);
> > > +		media_entity_cleanup(&vfd->entity);
> > 
> > Is this needed?
> > 
> > If this is to be part of the media controller, then I expect to see a call
> > to v4l2_m2m_register_media_controller() somewhere.
> 
> Yes, I agree there should be a call to 
> v4l2_m2m_register_media_controller(). This driver does not connect with 
> any of the imx-media entities, but calling it will at least make the 
> mem2mem output/capture device entities (and processing entity) visible 
> in the media graph.
> 
> Philipp, can you pick/squash the following from my media-tree github fork?
> 
> 6fa05f5170 ("media: imx: mem2mem: Add missing media-device header")
> d355bf8b15 ("media: imx: Add missing unregister and remove of mem2mem 
> device")

Thank you. I have squashed those two.

> 6787a50cdc ("media: imx: mem2mem: Register with media control")

I've left this one out for now.

regards
Philipp
