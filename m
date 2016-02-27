Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:33365 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992523AbcB0RVz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 12:21:55 -0500
Received: by mail-lf0-f52.google.com with SMTP id m1so70172364lfg.0
        for <linux-media@vger.kernel.org>; Sat, 27 Feb 2016 09:21:55 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Sat, 27 Feb 2016 18:21:52 +0100
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	ulrich.hecht@gmail.com, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCHv2] [media] rcar-vin: add Renesas R-Car VIN driver
Message-ID: <20160227172152.GC27233@bigcity.dyn.berto.se>
References: <1456282709-13861-1-git-send-email-niklas.soderlund+renesas@ragnatech.se>
 <56D1893E.9070007@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <56D1893E.9070007@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 2016-02-27 12:32:14 +0100, Hans Verkuil wrote:
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
> >  - Do not interrogate the subdev using g_mbus_config.
> 
> A quick question: was this tested with the adv7180 only? Or do you also
> have access to a sensor to test with?

I'm not sure I understand your question. I have only tested on Koelsch 
with a adv7180 connected to the VIN. But I have had both a NTSC camera 
and a PAL Super Nintendo connected to the Koelsch (adv7180).

-- 
Regards,
Niklas Söderlund
