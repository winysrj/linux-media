Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:51634 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab1EYKLc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 06:11:32 -0400
Date: Wed, 25 May 2011 12:11:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Scott Jiang <scott.jiang.linux@gmail.com>
cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	linux-media@vger.kernel.org
Subject: Re: v4l2_mbus_framefmt and v4l2_pix_format
In-Reply-To: <BANLkTikPGEgWH-ExjnSuH8-n0f2q54EJGQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1105251202530.13724@axis700.grange>
References: <BANLkTikPGEgWH-ExjnSuH8-n0f2q54EJGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Scott

On Wed, 25 May 2011, Scott Jiang wrote:

> Hi Hans and Laurent,
> 
> I got fmt info from a video data source subdev, I thought there should
> be a helper function to convert these two format enums.
> However, v4l2_fill_pix_format didn't do this, why? Should I do this in
> bridge driver one by one?

Because various camera hosts (bridges) can produce different pixel formats 
in memory from the same mediabus code. However, there is a very common way 
to handle such video data in the bridge: store it in RAM in a "natural" 
way. This mode is called in soc-camera the pass-through mode and there is 
an API to handle this mode in drivers/media/video/soc_mediabus.c. If this 
functionality is considered useful also outside of soc-camera, that API 
can easily be made generic.

> I think these codes are common use, I prefer adding them in
> v4l2_fill_pix_format.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
