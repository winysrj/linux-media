Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53051 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab1LSKF7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Dec 2011 05:05:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: [PATCH] V4L: soc-camera: provide support for S_INPUT.
Date: Mon, 19 Dec 2011 11:06:00 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	saaguirre@ti.com, Mauro Carvalho Chehab <mchehab@infradead.org>
References: <1324022443-5967-1-git-send-email-javier.martin@vista-silicon.com> <201112190151.40165.laurent.pinchart@ideasonboard.com> <CACKLOr3rTsiPsYK-hQBMo0wfHRqTNO95jdhXivvx6KUdCJBnnA@mail.gmail.com>
In-Reply-To: <CACKLOr3rTsiPsYK-hQBMo0wfHRqTNO95jdhXivvx6KUdCJBnnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112191106.01276.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Monday 19 December 2011 08:44:58 javier Martin wrote:
> Hi,
> thank you for your comments.
> 
> Let me try to summarize the conclusions we've agreed here:
> 1.- soc-camera can support S_INPUT as long as I provide backwards
> compatibility in case subdev does not support s_routing (i.e. I must
> resend my patch returning input 0 in case s_routing is not supported).

Yes. As Guennadi pointed out, we also need to support input enumeration. One 
possible solution for that is pad support in the subdev.

> 2.- Board specific code must tell the subdevice which inputs are
> really connected and how through platform data.

That's right. Please make sure that platform data only use static data and no 
callback function if possible, to make the transition to the device tree 
easier.

> Is that OK?

-- 
Regards,

Laurent Pinchart
