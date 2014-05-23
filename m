Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1043 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbaEWHB4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 May 2014 03:01:56 -0400
Message-ID: <537EF246.8000005@xs4all.nl>
Date: Fri, 23 May 2014 09:01:26 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Krzysztof Czarnowski <khczarnowski@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: V4L2 control API - choosing base CID for private controls
References: <CAHqFTYpRQ1=S8tVb5-Mgc79p_DNCecyoUnpj77zQeiiJP2Z6rA@mail.gmail.com>
In-Reply-To: <CAHqFTYpRQ1=S8tVb5-Mgc79p_DNCecyoUnpj77zQeiiJP2Z6rA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/22/2014 01:33 PM, Krzysztof Czarnowski wrote:
> Hi,
> 
> I got completely confused while trying to create private controls with
> control API and when I finally got down to sanity checks in
> v4l2_ctrl_new() in v4l2-ctrls.c...
> 
> It would be nice if the following explanation by Hans (archive msg69922)
> or maybe some more elaborate version could somehow make its way to
> Documentation/video4linux/v4l2-controls.txt
> :-)

Yeah, I need to improve that.

But basically you add a 'driver base' to include/uapi/linux/v4l2-controls.h
(see e.g. V4L2_CID_USER_SAA7134_BASE) where you reserve a range of private
controls for your driver and you use that base to define your controls. See
drivers/media/pci/saa7134/saa7134.h how that's done for the saa7134.

You probably tried to use V4L2_CID_PRIVATE_BASE which is not allowed in
combination with the control framework. The control framework will emulate
V4L2_CID_PRIVATE_BASE internally so old applications still work, but it's
not how they should be defined in the drivers.

Regards,

	Hans
