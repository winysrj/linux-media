Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1211 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbZEUNdj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2009 09:33:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC 09/10 v2] v4l2-subdev: re-add s_standby to v4l2_subdev_core_ops
Date: Thu, 21 May 2009 15:33:34 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
References: <Pine.LNX.4.64.0905151817070.4658@axis700.grange> <Pine.LNX.4.64.0905151907460.4658@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0905151907460.4658@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905211533.34827.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 15 May 2009 19:20:18 Guennadi Liakhovetski wrote:
> NOT FOR SUBMISSION. Probably, another solution has to be found.
> soc-camera drivers need an .init() (marked as "don't use") and a .halt()
> methods.
>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>
> Hans, you moved s_standby to tuner_ops, and init is not recommended for
> new drivers. Suggestions?

Usual question: why do you need an init and halt? What do they do? One valid 
use case for init is to pass config data to the driver. I am considering to  
make it possible to setup the board_info data instead for an i2c subdev, so 
one can use the platform data to pass such info to the subdev driver. The 
disadvantage is that it cannot be used for pre-2.6.26 kernels.

An alternative might be a s_config ops that serves a similar purpose.

I want to leave s_standby in the tuner_ops: it's currently only used 
together with a tuner. It's also poorly designed.

A new halt or standby core ops should be better designed and it should be 
clear what the relationship is to the suspend and resume i2c driver ops 
(see e.g. msp3400-driver.c).

Regards,

	Hans

>  include/media/v4l2-subdev.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 1785608..ba907be 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -97,6 +97,7 @@ struct v4l2_subdev_core_ops {
>  	int (*g_chip_ident)(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident
> *chip); int (*log_status)(struct v4l2_subdev *sd);
>  	int (*init)(struct v4l2_subdev *sd, u32 val);
> +	int (*s_standby)(struct v4l2_subdev *sd, u32 standby);
>  	int (*load_fw)(struct v4l2_subdev *sd);
>  	int (*reset)(struct v4l2_subdev *sd, u32 val);
>  	int (*s_gpio)(struct v4l2_subdev *sd, u32 val);



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
