Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:4921 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab1IZK0U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Sep 2011 06:26:20 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 3/4] V4L: soc-camera: make (almost) all client drivers re-usable outside of the framework
Date: Mon, 26 Sep 2011 12:26:15 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.1109091917260.915@axis700.grange> <Pine.LNX.4.64.1109091921590.915@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109091921590.915@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109261226.15796.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, September 09, 2011 19:43:35 Guennadi Liakhovetski wrote:
> The most important change in this patch is direct linking to struct
> soc_camera_link via the client->dev.platform_data pointer. This makes most
> of the soc-camera client drivers also usable outside of the soc-camera
> framework. After this change all what is needed for these drivers to
> function are inclusions of soc-camera headers for some convenience macros,
> suitably configured platform data, which is anyway always required, and
> loaded soc-camera core module for library functions. If desired, these
> library functions can be made generic in the future and moved to a more
> neutral location.
> 
> The only two client drivers, that still depend on soc-camera are:
> 
> mt9t031: it uses struct video_device for its PM. Since no hardware is
> available, alternative methods cannot be tested.
> 
> ov6650: it uses struct soc_camera_device to pass its sense data back to
> the bridge driver. A generic v4l2-subdevice approach should be developed
> to perform this.

Subdevs can call a notify function in struct v4l2_device to pass information
to the bridge. Can that be used here?

Regards,

	Hans
