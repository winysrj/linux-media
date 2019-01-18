Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C1E9C43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 13:42:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D94E62146F
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 13:42:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbfARNmL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 08:42:11 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:36115 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbfARNmL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 08:42:11 -0500
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtp (Exim 4.89)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1gkUPR-00078i-S0; Fri, 18 Jan 2019 14:42:09 +0100
Message-ID: <1547818928.3375.10.camel@pengutronix.de>
Subject: Re: [PATCH v7] media: imx: add mem2mem device
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Date:   Fri, 18 Jan 2019 14:42:08 +0100
In-Reply-To: <377d7120-14b5-274d-d4d8-c6d21fba9f3b@xs4all.nl>
References: <20190117155032.3317-1-p.zabel@pengutronix.de>
         <e68a4de5-a499-ea02-20e7-79e4d175708c@xs4all.nl>
         <1547810284.3375.6.camel@pengutronix.de>
         <377d7120-14b5-274d-d4d8-c6d21fba9f3b@xs4all.nl>
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

On Fri, 2019-01-18 at 13:41 +0100, Hans Verkuil wrote:
[...]
> > I can do that, but what would be the purpose of it showing up in the
> > media controller?
> > There is nothing to be configured, no interaction with the rest of the
> > graph, and the processing subdevice wouldn't even correspond to an
> > actual hardware unit. I assumed this would clutter the media controller
> > for no good reason.
> 
> Just because you can't change routing doesn't mean you can't expose it in the
> media controller topology. It makes sense to show in the topology that you
> have this block.
> 
> That said, I can't decide whether or not to add this. For a standalone m2m
> device I would not require it, but in this case you already have a media
> device.
> 
> I guess it is easy enough to add later, so leave this for now.

Ok.

[...]
> > > How did you test the rotate control?

Just FTR, I used GStreamer for most of my testing, something like
(simplified):

gst-launch-1.0 videotestsrc ! v4l2video14convert extra-controls=cid,rotate=90 ! autovideosink

> > > I'm asking because I would expect to see code
> > > that checks this control in the *_fmt ioctls:

In a way this does happen, since _try_fmt calls ipu_image_convert_adjust
with a ctx->rot_mode parameter. It only has an influence on the
alignment though.

[...]
> > The V4L2_CID_ROTATE documentation [1] states:
> > 
> >     Rotates the image by specified angle. Common angles are 90, 270 and
> >     180. Rotating the image to 90 and 270 will reverse the height and
> >     width of the display window. It is necessary to set the new height
> >     and width of the picture using the VIDIOC_S_FMT ioctl according to
> >     the rotation angle selected.
> > 
> > [1] https://linuxtv.org/downloads/v4l-dvb-apis-new/uapi/v4l/control.html#control-ids
> > 
> > I didn't understand what the "display window" is in the context of a
> > mem2mem scaler/rotator/CSC converter. Is this intended to mean that
> > aspect ratio should be kept as intact as possible, and that every time
> > V4L2_CID_ROTATE changes between 0/180 and 90/270, an automatic S_FMT
> > should be issued on the capture queue with width and height switched
> > compared to the currently set value? This might still slightly modify
> > width and height due to alignment restrictions.
> 
> Most drivers that implement rotate do not have a scaler, so rotating a
> 640x480 image would result in a 480x640 result. Hence for an m2m device
> the output queue would have format 640x480 and the capture queue 480x640.
> 
> So the question becomes: what if you can both rotate and scale, what
> do you do when you change the rotate control?
>
> I would expect as a user of this API that if I first scale 640x480 to
> 320x240, then rotate 90 degrees, that the capture format is now 240x320.
> 
> In other words, rotating comes after scaling.

Ok, that makes sense. I had always thought of the rotation property
being set first.

> But even if you keep the current behavior I suspect you still need to
> update the format due to alignment restriction. Either due to 4:2:2
> formats or due to the 'resizer cannot downsize more than 4:1' limitation.
> 
> E.g. in the latter case it is fine to downscale 640x480 to 640x120,
> but if you now rotate 90 degrees, then you can no longer downscale
> 480x640 to 640x120 (640 / 120 > 4).
> 
> At least, if I understand the code correctly.

Oh. Worse, the output queue's width alignment restrictions also depend
on the rotation mode.

Are we allowed to change the output queue format to meet alignment
restrictions when changing the ROTATE property? The same is true
for HFLIP.

regards
Philipp
