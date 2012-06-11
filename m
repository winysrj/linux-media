Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:19223 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab2FKIdz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 04:33:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Subject: Re: extend v4l2_mbus_framefmt
Date: Mon, 11 Jun 2012 10:33:47 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	LMML <linux-media@vger.kernel.org>,
	uclinux-dist-devel@blackfin.uclinux.org
References: <CAHG8p1AW6577=oGPo3o8S0LgF2p8_cfmLLnvYbikk7kEaYdxzw@mail.gmail.com>
In-Reply-To: <CAHG8p1AW6577=oGPo3o8S0LgF2p8_cfmLLnvYbikk7kEaYdxzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206111033.47369.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon 11 June 2012 10:18:06 Scott Jiang wrote:
> Hi Guennadi and Hans,
> 
> We use v4l2_mbus_framefmt to get frame format on the media bus in
> bridge driver. It only contains width and height. It's not a big
> problem in SD. But we need more info like front porch, sync width and
> back porch (similar to disp_format_s in v4l2_formats.h) in HD. I want
> to add these fields in v4l2_mbus_framefmt or do you have any better
> solution?

Just a quick note for those who are wondering: disp_format_s was a custom
extension from a work-in-progress driver from Cisco. We are working hard on
upstreaming it, and the final version won't have that change.

Anyway, who exactly needs that information? Normally that information is set
or queried via VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS (ENUM and QUERY got merged
in 3.5, see http://hverkuil.home.xs4all.nl/spec/media.html for the latest
documentation on these new ioctls).

I would expect that the combination of v4l2_mbus_framefmt + v4l2_dv_timings
gives you the information you need.

Regards,

	Hans
