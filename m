Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:32934 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752132AbbCZQqy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2015 12:46:54 -0400
Message-ID: <551437F6.6010202@xs4all.nl>
Date: Thu, 26 Mar 2015 09:46:46 -0700
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: RFC: New format V4L2_PIX_FMT_Y16_BE ?
References: <CAPybu_1vgJ3t8GnKDk02SH0KkuEQH-Q-6Ym6gNX7a5H5OekAuA@mail.gmail.com>
In-Reply-To: <CAPybu_1vgJ3t8GnKDk02SH0KkuEQH-Q-6Ym6gNX7a5H5OekAuA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/26/2015 09:23 AM, Ricardo Ribalda Delgado wrote:
> Hello
> 
> While debugging a v4l2<->gstreamer interaction problem, I have
> realized that we were implementing Y16 wrong in our cameras :S. What
> we were implementing was a big endian version of the format.
> 
> If I want to add support for our Y16_BE format to the kernel, would it
> be enough to change videodev2.h, add the documentation for the format
> and update libv4lconvert?

Yes, but you might want to wait 1-2 weeks: I'm going to make a patch
that moves the ENUMFMT description into the v4l2 core. So you want to be on
top of that patch. I posted an RFC patch for that earlier (last week I
think).

Regards,

	Hans
