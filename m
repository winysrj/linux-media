Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:59934 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbcCUIOG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 04:14:06 -0400
Subject: Re: [PATCH RFC 0/2] pxa_camera transition to v4l2 standalone device
To: Robert Jarzmik <robert.jarzmik@free.fr>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1458421288-22094-1-git-send-email-robert.jarzmik@free.fr>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56EFAD47.8010403@xs4all.nl>
Date: Mon, 21 Mar 2016 09:13:59 +0100
MIME-Version: 1.0
In-Reply-To: <1458421288-22094-1-git-send-email-robert.jarzmik@free.fr>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/19/2016 10:01 PM, Robert Jarzmik wrote:
> Hi Hans and Guennadi,
> 
> As Hans is converting sh_mobile_ceu_camera.c,

That's not going as fast as I hoped. This driver is quite complex and extracting
it from soc-camera isn't easy. I also can't spend as much time as I'd like on this.

> let's see how close our ports are
> to see if there are things we could either reuse of change.
> 
> The port is assuming :
>  - the formation translation is transferred into soc_mediabus, so that it can be
>    reused across all v4l2 devices

At best this will be a temporary helper source. I never liked soc_mediabus, I don't
believe it is the right approach. But I have no problem if it is used for now to
simplify the soc-camera dependency removal.

>  - pxa_camera is ported
> 
> This sets a ground of discussion for soc_camera adherence removal from
> pxa_camera. I'd like to have a comment from Hans if this is what he has in mind,
> and Guennadi if he agrees to transfer the soc xlate stuff to soc_mediabus.

Can you provide the output of 'v4l2-compliance -s' with your new pxa driver?
I would be curious to see the result of that.

Regards,

	Hans
