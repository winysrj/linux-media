Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:60277 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbZA2GUZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 01:20:25 -0500
Date: Wed, 28 Jan 2009 22:19:30 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Hardik Shah <hardik.shah@ti.com>
cc: linux-media@vger.kernel.org, video4linux-list@redhat.com,
	Brijesh Jadav <brijesh.j@ti.com>,
	Hari Nagalla <hnagalla@ti.com>,
	Vaibhav Hiremath <hvaibhav@ti.com>
Subject: Re: [PATCHv2] New V4L2 ioctls for OMAP class of Devices
In-Reply-To: <1233206626-19157-1-git-send-email-hardik.shah@ti.com>
Message-ID: <Pine.LNX.4.58.0901282207050.17300@shell2.speakeasy.net>
References: <1233206626-19157-1-git-send-email-hardik.shah@ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 29 Jan 2009, Hardik Shah wrote:
> 1.  Control ID added for rotation.  Same as HFLIP.
> 2.  Control ID added for setting background color on
>     output device.
> 3.  New ioctl added for setting the color space conversion from
>     YUV to RGB.
> 4.  Updated the v4l2-common.c file according to comments.

Wasn't there supposed to be some documentation?

> +	case V4L2_CID_BG_COLOR:
> +		/* Max value is 2^24 as RGB888 is used for background color */
> +		return v4l2_ctrl_query_fill(qctrl, 0, 16777216, 1, 0);

Wouldn't it make more sense to set background in the same colorspace as the
selected format?
