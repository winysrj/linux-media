Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:33228 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab1E1Kst (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 May 2011 06:48:49 -0400
Date: Sat, 28 May 2011 13:48:45 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 07/11] v4l2-ctrls: add control events.
Message-ID: <20110528104845.GB4991@valkosipuli.localdomain>
References: <6cea502820c1684f34b9e862a64be2972afb718f.1306329390.git.hans.verkuil@cisco.com>
 <2c6e1531f7f9ab33b60e8c7f972f58a0dd6fbbd1.1306329390.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c6e1531f7f9ab33b60e8c7f972f58a0dd6fbbd1.1306329390.git.hans.verkuil@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Wed, May 25, 2011 at 03:33:51PM +0200, Hans Verkuil wrote:
> @@ -1800,21 +1801,45 @@ struct v4l2_event_vsync {
>  	__u8 field;
>  } __attribute__ ((packed));
>  
> +/* Payload for V4L2_EVENT_CTRL */
> +#define V4L2_EVENT_CTRL_CH_VALUE		(1 << 0)
> +#define V4L2_EVENT_CTRL_CH_FLAGS		(1 << 1)
> +
> +struct v4l2_event_ctrl {
> +	__u32 changes;
> +	__u32 type;
> +	union {
> +		__s32 value;
> +		__s64 value64;
> +	};
> +	__u32 flags;
> +	__s32 minimum;
> +	__s32 maximum;
> +	__s32 step;
> +	__s32 default_value;
> +} __attribute__ ((packed));
> +

One more comment.

Do we really need type and default_value in the event? They are static, and
on the other hand, the type should be already defined by the control so
that's static, as I'd expect default_value would be.

It just looks like this attempts to reimplement what QUERYCTRL does. :-)
Step, min and max values may change, so they are good.

More fields can be added later on. User space libraries / applications using
this structure might have different views of its size, though, depending
which definition they used at compile time. So in principle also this
structure should have reserved fields, although not having such and still
changing it might not have any adverse effects at all.

Btw. why __attribute__ ((packed))?

Regards,

-- 
Sakari Ailus
sakari dot ailus at iki dot fi
