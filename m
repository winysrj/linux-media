Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:33817 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbcDBSBX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Apr 2016 14:01:23 -0400
Received: by mail-lb0-f172.google.com with SMTP id vo2so103896238lbb.1
        for <linux-media@vger.kernel.org>; Sat, 02 Apr 2016 11:01:22 -0700 (PDT)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Sat, 2 Apr 2016 20:01:20 +0200
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	ulrich.hecht@gmail.com, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCHv2] [media] rcar-vin: add Renesas R-Car VIN driver
Message-ID: <20160402180120.GA30485@bigcity.dyn.berto.se>
References: <1456282709-13861-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
 <56D414D9.4090303@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <56D414D9.4090303@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks again for your review! I have addressed your comments in v3 which 
I just posted but there where a few things I just wanted to answer in 
this thread.

On 2016-02-29 10:52:25 +0100, Hans Verkuil wrote:
> Hi Niklas,
> 
> Thanks for your patch! Much appreciated.
> 
> I have more comments for the v2, but nothing really big :-)
> 
> One high-level comment I have is that you should create an rcar-v4l2.c (or video.c)
> source where all the v4l2 ioctls and file ops reside.
> 
> Most of what is in rcar-dma has nothing to do with dma. That's only the vb2
> ops and the interrupt handler.
> 
> I think that should make the driver code a lot easier to navigate.
> 
> On 02/24/2016 03:58 AM, Niklas Söderlund wrote:
> > A V4L2 driver for Renesas R-Car VIN driver that do not depend on
> > soc_camera. The driver is heavily based on its predecessor and aims to
> > replace it.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> > 
> > The driver is tested on Koelsch and can do streaming using qv4l2 and
> > grab frames using yavta. It passes a v4l2-compliance (git master) run
> > without failures, see bellow for output. Some issues I know about but
> > will have to wait for future work in other patches.
> >  - The soc_camera driver provides some pixel formats that do not display
> >    properly for me in qv4l2 or yavta. I have ported these formats as is
> >    (not working correctly?) to the new driver.
> >  - One can not bind/unbind the subdevice and continue using the driver.
> > 
> > As stated in commit message the driver is based on its soc_camera
> > version but some features have been drooped (for now?).
> >  - The driver no longer try to use the subdev for cropping (using
> >    cropcrop/s_crop).
> 
> The vin driver now does the cropping, right? Which makes perfect sense
> to me. The feature is still there, just done differently.
> 
> >  - Do not interrogate the subdev using g_mbus_config.
> 
> And that's because we can now rely on what the device tree gives us, right?

Yes only device tree is used now.

<snip>

> > +void rvin_set_slot_addr(struct rvin_dev *vin, int slot, dma_addr_t 
> > addr)
> > +{
> > +	const struct rvin_video_format *fmt;
> > +	int offsetx, offsety;
> > +	dma_addr_t offset;
> > +
> > +	fmt = rvin_format_from_pixel(vin->format.pixelformat);
> > +
> > +	/*
> > +	 * There is no HW support for composition do the beast we can
> > +	 * by modifying the buffer offset
> > +	 */
> > +	offsetx = vin->compose.left * fmt->bpp;
> > +	offsety = vin->compose.top * vin->format.bytesperline;
> 
> Does this work for a planar format like NV16? Just wondering.

On this SoC is dose since the CbCr plane starts from a set offset (we 
can control this offset also but there is need to to anything special 
with it for this to work). So if we inject a offset here the CbCr plane 
will use the same offset.

> 
> > +	offset = addr + offsetx + offsety;
> > +
> > +	/*
> > +	 * The address needs to be 128 bytes aligned. Driver should never accept
> > +	 * settings that do not satisfy this in the first place...
> > +	 */
> > +	if (WARN_ON((offsetx | offsety | offset) & HW_BUFFER_MASK))
> > +		return;
> > +
> > +	rvin_write(vin, offset, VNMB_REG(slot));
> > +}

<snip>

-- 
Regards,
Niklas Söderlund
