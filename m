Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40364 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422754AbbD2MCD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 08:02:03 -0400
Date: Wed, 29 Apr 2015 15:01:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Hans Verkuil <hansverk@cisco.com>,
	linux-media <linux-media@vger.kernel.org>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: S_CTRL must be called twice  to set volatile controls
Message-ID: <20150429120128.GJ3188@valkosipuli.retiisi.org.uk>
References: <5540895A.5060102@samsung.com>
 <55408DE7.3020906@cisco.com>
 <55409D2C.8050007@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55409D2C.8050007@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On Wed, Apr 29, 2015 at 10:58:20AM +0200, Jacek Anaszewski wrote:
> Hi Hans,
> 
> On 04/29/2015 09:53 AM, Hans Verkuil wrote:
> >Hi Jacek,
> >
> >On 04/29/15 09:33, Jacek Anaszewski wrote:
> >>Hi,
> >>
> >>After testing my v4l2-flash helpers patch [1] with the recent patches
> >>for v4l2-ctrl.c ([2] and [3]) s_ctrl op isn't called despite setting
> >>the value that should be aligned to the other step than default one.
> >>
> >>This happens for V4L2_CID_FLASH_TORCH_INTENSITY control with
> >>V4L2_CTRL_FLAG_VOLATILE flag.
> >>
> >>The situation improves after setting V4L2_CTRL_FLAG_EXECUTE_ON_WRITE
> >>flag for the control. Is this flag required now for volatile controls
> >>to be writable?
> >
> >Yes, you need that if you want to be able to write to a volatile control.
> >
> >It was added for exactly that purpose.
> 
> Thanks for the explanation.
> 
> >Why is V4L2_CID_FLASH_TORCH_INTENSITY volatile? Volatile typically only
> >makes sense if the hardware itself is modifying the value without the
> >software knowing about it.
> 
> This can be the case for the flash LED devices that can reduce torch
> current when battery voltage level falls below predefined threshold.

Can the LED flash actually tell about this, other than reading this through
the faults? I don't know of a LED flash that could do this, so I wonder if
we could make these controls non-volatile, as the reason I originally though
why they were volatile (the V4L2 control framework being more or less just a
front-end) was not a valid one.

I guess this could be done later on on top of the patch you currently have.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
