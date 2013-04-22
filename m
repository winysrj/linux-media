Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1871 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab3DVJGj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 05:06:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Subject: Re: [PATCH v2 1/5] V4L2: I2C: ML86V7667 video decoder driver
Date: Mon, 22 Apr 2013 11:06:20 +0200
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	mchehab@redhat.com, linux-media@vger.kernel.org,
	linux-sh@vger.kernel.org, matsu@igel.co.jp
References: <201304212240.30949.sergei.shtylyov@cogentembedded.com> <201304220848.04870.hverkuil@xs4all.nl> <5174F74E.9030707@cogentembedded.com>
In-Reply-To: <5174F74E.9030707@cogentembedded.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304221106.20598.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon April 22 2013 10:39:42 Vladimir Barinov wrote:
> Hi Hans,
> 
> Thank you for the review.
> 
> Hans Verkuil wrote:
> >> +#include <media/v4l2-chip-ident.h>
> >>     
> >
> > This include should be removed as well.
> >   
> ok
> >   
> >> +
> >> +static int ml86v7667_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
> >> +{
> >> +	struct ml86v7667_priv *priv = to_ml86v7667(sd);
> >> +
> >> +	*std = priv->std;
> >>     
> >
> > That's not right. querystd should attempt to detect the standard, that's
> > what it is for. It should just return the detected standard, not actually
> > change it.
> >   
> Ok.
> I've mixed the things up with your review on removing the autoselection 
> feature and detection.
> Thx for pointing on this.
> >   
> >> +	 */
> >> +	val = i2c_smbus_read_byte_data(client, STATUS_REG);
> >> +	if (val < 0)
> >> +		return val;
> >> +
> >> +	priv->std = val & STATUS_NTSCPAL ? V4L2_STD_PAL : V4L2_STD_NTSC;
> >>     
> >
> > Shouldn't this be 50 Hz vs 60 Hz formats? There are 60 Hz PAL standards
> > and usually these devices detect 50 Hz vs 60 Hz, not NTSC vs PAL.
> >   
> In the reference manual it is not mentioned about 50/60Hz input format 
> selection/detection but it mentioned just PAL/NTSC.
> The 50hz formats can be ether PAL and NTSC formats variants. The same is 
> applied to 60Hz.
> 
> In the ML86V7667 datasheet the description for STATUS register detection 
> bit is just PAL/NTSC:
> " $2C/STATUS [2] NTSC/PAL identification 0: NTSC /1: PAL "
> 
> If you assure me that I must judge their description as 50 vs 60Hz 
> formats and not PAL/NTSC then I will make the change.

I can't judge that. Are there no status bits anywhere that tell you something
about the number of lines per frame or the framerate?

Are you able to test with a PAL-M or PAL-N(c) input?

Can you ask the manufacturer for more information?

If the answer to all of these is 'no', then stick to STD_PAL/NTSC.

Regards,

	Hans
