Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:34718
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751989AbcLHOQQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 09:16:16 -0500
Date: Thu, 8 Dec 2016 12:16:08 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH] tvp5150: don't touch register TVP5150_CONF_SHARED_PIN
 if not needed
Message-ID: <20161208121608.1a95d3b6@vento.lan>
In-Reply-To: <3555863.PStTa0BX6X@avalon>
References: <b47a9d956d740d63334bf0f07e6cfddd7f60e98b.1481204310.git.mchehab@s-opensource.com>
        <3555863.PStTa0BX6X@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 08 Dec 2016 15:41:59 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Thursday 08 Dec 2016 11:38:34 Mauro Carvalho Chehab wrote:
> > changeset 460b6c0831cb ("[media] tvp5150: Add s_stream subdev operation
> > support") added a logic that overrides TVP5150_CONF_SHARED_PIN setting,
> > depending on the type of bus set via the .set_fmt() subdev callback.
> > 
> > This is known to cause trobules on devices that don't use a V4L2
> > subdev devnode, and a fix for it was made by changeset 47de9bf8931e
> > ("[media] tvp5150: Fix breakage for serial usage"). Unfortunately,
> > such fix doesn't consider the case of progressive video inputs,
> > causing chroma decoding issues on such videos, as it overrides not
> > only the type of video output, but also other unrelated bits.
> > 
> > So, instead of trying to guess, let's detect if the device is set
> > via Device Tree. If not, just ignore the bogus logic.  
> 
> If you add a big [HACK] tag to the subject line, sure. I thought this would 
> have been an occasion to fix the problem correctly :-(

No, this is not a hack.

It is a patch that restores the driver behavior that used to be
before adding DT support to the driver. Whatever DT-based drivers
need, it *should not* change the behavior for devices that don't
use DT.

I agree with you that the patch is incomplete, as it doesn't
add any OF var that would allow DT to specify the values
to be used for TVP5150_CONF_SHARED_PIN and TVP5150_MISC_CTL,
and assumes that tvp5150, tvp5151 and tvp5150am1 will all use
the same values for TVP5150_MISC_CTL.

In order to fix that, someone with a DT-based driver with tvp5150, 
tvp5150am1 and/or tvp5151 would need to spend some time and test
the hardware with both interlaced and progressive video inputs.

That's not me, as I don't have any hardware that meets such requirement.

If someone ships me such hardware, I could work on it on my spare time. 
Otherwise, then perhaps you could work on such patch - or we could ping 
Javier on Monday and see if has time/interest to work on it (afaikt, he's
OOT the rest of this week).

Anyway, with this patch applied, the one working on such fix won't need
to be concerned to cause new regressions on the non-DT drivers that use
this chip, with is, IMHO, a very good thing.

Also, this patch is simple enough to be backported to -stable.

What's missing here is a notice explaining what's left to be done,
like the one on the diff below.

Regards,
Mauro

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index eb43ac7002d6..c9fd36998ac7 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1057,6 +1057,17 @@ static int tvp5150_s_stream(struct v4l2_subdev *sd, int enable)
 	if (!decoder->has_dt)
 		return 0;
 
+	/*
+	 * FIXME: the logic below is hardcoded to work with some OMAP3
+	 * hardware with tvp5151. As such, it hardcodes values for
+	 * both TVP5150_CONF_SHARED_PIN and TVP5150_MISC_CTL, and ignores
+	 * what was set before at the driver. Ideally, we should have
+	 * DT nodes describing the setup, instead of hardcoding those
+	 * values, and doing a read before writing values to
+	 * TVP5150_MISC_CTL, but any patch adding support for it should
+	 * keep DT backward-compatible.
+	 */
+
 	/* Output format: 8-bit 4:2:2 YUV with discrete sync */
 	if (decoder->mbus_type == V4L2_MBUS_PARALLEL)
 		val = 0x0d;

