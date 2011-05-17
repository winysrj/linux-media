Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58172 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932457Ab1EQWo2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 18:44:28 -0400
MIME-Version: 1.0
In-Reply-To: <201105180007.21173.laurent.pinchart@ideasonboard.com>
References: <201105180007.21173.laurent.pinchart@ideasonboard.com>
Date: Wed, 18 May 2011 01:44:26 +0300
Message-ID: <BANLkTi=mRYkJL-R63K+pvZGvtetJo3oJaQ@mail.gmail.com>
Subject: Re: [RFC] Standardize YUV support in the fbdev API
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-fbdev@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, May 18, 2011 at 1:07 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> I need to implement support for a YUV frame buffer in an fbdev driver. As the
> fbdev API doesn't support this out of the box, I've spent a couple of days
> reading fbdev (and KMS) code and thinking about how we could cleanly add YUV
> support to the API. I'd like to share my findings and thoughts, and hopefully
> receive some comments back.
>
> The terms 'format', 'pixel format', 'frame buffer format' and 'data format'
> will be used interchangeably in this e-mail. They all refer to the way pixels
> are stored in memory, including both the representation of a pixel as integer
> values and the layout of those integer values in memory.

This is a great proposal. It was about time!

> The third solution has my preference. Comments and feedback will be
> appreciated. I will then work on a proof of concept and submit patches.

I also would prefer the third solution. I don't think there's much
difference from the user-space point of view, and a new ioctl would be
cleaner. Also the v4l2 fourcc's should do.

Cheers.

-- 
Felipe Contreras
