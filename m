Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1414 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbZCRSjw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2009 14:39:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Subject: Re: soc-camera -> v4l2-device: possible API extension requirements
Date: Wed, 18 Mar 2009 19:40:04 +0100
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>
References: <52074.62.70.2.252.1237365718.squirrel@webmail.xs4all.nl>
In-Reply-To: <52074.62.70.2.252.1237365718.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903181940.04666.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 18 March 2009 09:41:58 Hans Verkuil wrote:
> Hi Guennadi,
>
> > 2. In a comment you write to v4l2_i2c_new_subdev():
> > /* Load an i2c sub-device. It assumes that i2c_get_adapdata(adapter)
> >    returns the v4l2_device and that i2c_get_clientdata(client)
> >    returns the v4l2_subdev. */
> > I don't think this is possible with generic SoC i2c adapters. On
> > soc-camera systems v4l2 subdevices are connected to generic i2c busses,
> > so, you cannot require, that "i2c_get_adapdata(adapter) returns the
> > v4l2_device."
>
> Good point, I'll look at this. I don't think it is difficult to change,
> although I will probably wait until several pending driver conversions
> are merged. Then I can fix this in one sweep.

The fix for this is simple: just add an extra struct v4l2_device to 
v4l2_i2c_new_(probed_)device and let those functions use that instead of 
calling i2c_get_adapdata(). It's the only place where it is currently used.

But I'm going to postpone implementing this until all outstanding conversion 
trees are merged. However, you can just do it yourself while working on the 
soc-camera conversion.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
