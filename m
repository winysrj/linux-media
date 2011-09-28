Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:4789 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1I1ILE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Sep 2011 04:11:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 2/2] as3645a: Add driver for LED flash controller
Date: Wed, 28 Sep 2011 10:10:55 +0200
Cc: linux-media@vger.kernel.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Nayden Kanchev <nkanchev@mm-sol.com>,
	Tuukka Toivonen <tuukkat76@gmail.com>,
	Antti Koskipaa <antti.koskipaa@gmail.com>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	Vimarsh Zutshi <vimarsh.zutshi@gmail.com>,
	"Ivan T. Ivanov" <iivanov@mm-sol.com>,
	Mika Westerberg <ext-mika.1.westerberg@nokia.com>,
	David Cohen <dacohen@gmail.com>
References: <1315583569-22727-1-git-send-email-laurent.pinchart@ideasonboard.com> <201109261221.12068.hverkuil@xs4all.nl> <201109271959.48499.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201109271959.48499.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281010.55593.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, September 27, 2011 19:59:47 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thanks for the review.
> 
> On Monday 26 September 2011 12:21:11 Hans Verkuil wrote:
> > On Friday, September 09, 2011 17:52:49 Laurent Pinchart wrote:
> 
> [snip]
> 
> > > +/* Register definitions */
> > > +
> > > +/* Read-only Design info register: Reset state: xxxx 0001 - for Senna */
> > 
> > What's 'Senna'? I see this at several places in this driver. It's probably
> > a code name of some sort, but this needs some explanation.
> > 
> > <...cut...>
> 
> My bad. I'll fix it.
> 
> > > +
> > > +	/* V4L2_CID_FLASH_INDICATOR_INTENSITY */
> > > +	v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
> > > +			  V4L2_CID_FLASH_INDICATOR_INTENSITY,
> > > +			  AS3645A_INDICATOR_INTENSITY_MIN,
> > > +			  AS3645A_INDICATOR_INTENSITY_MAX,
> > > +			  AS3645A_INDICATOR_INTENSITY_STEP,
> > > +			  AS3645A_INDICATOR_INTENSITY_MIN);
> > > +
> > > +	flash->indicator_current = 0;
> > > +
> > > +	/* V4L2_CID_FLASH_FAULT */
> > > +	ctrl = v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
> > > +				 V4L2_CID_FLASH_FAULT, 0,
> > > +				 V4L2_FLASH_FAULT_OVER_VOLTAGE |
> > > +				 V4L2_FLASH_FAULT_TIMEOUT |
> > > +				 V4L2_FLASH_FAULT_OVER_TEMPERATURE |
> > > +				 V4L2_FLASH_FAULT_SHORT_CIRCUIT, 0, 0);
> > > +	if (ctrl != NULL)
> > > +		ctrl->is_volatile = 1;
> > > +
> > > +	/* V4L2_CID_FLASH_READY */
> > > +	ctrl = v4l2_ctrl_new_std(&flash->ctrls, &as3645a_ctrl_ops,
> > > +				 V4L2_CID_FLASH_READY, 0, 1, 1, 1);
> > > +	if (ctrl != NULL)
> > > +		ctrl->is_volatile = 1;
> > 
> > Note that 'is_volatile' is now replaced by the new V4L2_CTRL_FLAG_VOLATILE
> > flag for ctrl->flags. You'll need to redo your patch.
> 
> In which kernel version will that be included ?

3.2. It was merged 1 or 2 weeks ago.

Regards,

	Hans
