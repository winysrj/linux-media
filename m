Return-Path: <SRS0=gjtM=PQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49981C43387
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 16:03:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22846206BB
	for <linux-media@archiver.kernel.org>; Tue,  8 Jan 2019 16:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbfAHQC7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 8 Jan 2019 11:02:59 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49439 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729181AbfAHQC7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2019 11:02:59 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1ggtqD-0003yL-KJ; Tue, 08 Jan 2019 17:02:57 +0100
Message-ID: <1546963376.5406.10.camel@pengutronix.de>
Subject: Re: [PATCH v5] media: imx: add mem2mem device
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Date:   Tue, 08 Jan 2019 17:02:56 +0100
In-Reply-To: <1e246083-7e97-646c-8602-c36507879b2d@xs4all.nl>
References: <20181203114804.17078-1-p.zabel@pengutronix.de>
         <a8d3a554-aef8-b8e0-b8ad-f9116bcc3f39@xs4all.nl>
         <73ba2b0c-2776-5aec-193d-408dfcae6ebf@gmail.com>
         <1e246083-7e97-646c-8602-c36507879b2d@xs4all.nl>
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

Hi Hans,

On Wed, 2018-12-05 at 19:50 +0100, Hans Verkuil wrote:
> On 12/05/2018 02:20 AM, Steve Longerbeam wrote:
> > Hi Hans, Philipp,
> > 
> > One comment on my side...
> > 
> > On 12/3/18 7:21 AM, Hans Verkuil wrote:
> > > <snip>
> > > > +void imx_media_mem2mem_device_unregister(struct imx_media_video_dev *vdev)
> > > > +{
> > > > +	struct mem2mem_priv *priv = to_mem2mem_priv(vdev);
> > > > +	struct video_device *vfd = priv->vdev.vfd;
> > > > +
> > > > +	mutex_lock(&priv->mutex);
> > > > +
> > > > +	if (video_is_registered(vfd)) {
> > > > +		video_unregister_device(vfd);
> > > > +		media_entity_cleanup(&vfd->entity);
> > > 
> > > Is this needed?
> > > 
> > > If this is to be part of the media controller, then I expect to see a call
> > > to v4l2_m2m_register_media_controller() somewhere.
> > > 
> > 
> > Yes, I agree there should be a call to 
> > v4l2_m2m_register_media_controller(). This driver does not connect with 
> > any of the imx-media entities, but calling it will at least make the 
> > mem2mem output/capture device entities (and processing entity) visible 
> > in the media graph.
> > 
> > Philipp, can you pick/squash the following from my media-tree github fork?
> > 
> > 6fa05f5170 ("media: imx: mem2mem: Add missing media-device header")
> > d355bf8b15 ("media: imx: Add missing unregister and remove of mem2mem 
> > device")
> > 6787a50cdc ("media: imx: mem2mem: Register with media control")
> > 
> > Steve
> > 
> 
> Why is this driver part of the imx driver? Since it doesn't connect with
> any of the imx-media entities, doesn't that mean that this is really a
> stand-alone driver?

It is part of the same hardware unit. The mem2mem tasks are scheduled to
the same IC that is also used for scaling in the capture path.

Since the mem2mem driver is at a higher abstraction level, it would be
possible to split it out into a separate platform device, but that felt
a bit artificial, and it would have to be registered from imx-media-dev
anyway.

regards
Philipp
