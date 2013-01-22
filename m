Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52153 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab3AVP3T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jan 2013 10:29:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Adriano Martins <adrianomatosmartins@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: yavta - Broken pipe
Date: Tue, 22 Jan 2013 16:31:04 +0100
Message-ID: <2391937.KLGgbijk6r@avalon>
In-Reply-To: <CAJRKTVqnB6-8itbr3Cu-jnJo-zz3dYQeJ98sLnD-Eo9hvNS5iQ@mail.gmail.com>
References: <CAJRKTVqnB6-8itbr3Cu-jnJo-zz3dYQeJ98sLnD-Eo9hvNS5iQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Adriano,

On Tuesday 22 January 2013 09:31:58 Adriano Martins wrote:
> Hello Laurent and all.
> 
> Can you explain me what means the message in yavta output:
> 
> "Unable to start streaming: Broken pipe (32)."

This means that the ISP hardware pipeline hasn't been properly configured. 
Unlike most V4L2 devices, the OMAP3 ISP requires userspace to configure the 
hardware pipeline before starting the video stream. You can do so with the 
media-ctl utility (available at http://git.ideasonboard.org/media-ctl.git). 
Plenty of examples should be available online.

> I'm using omap3isp driver on DM3730 processor and a ov5640 sensor. I
> configured it as parallel mode, but I can't get data from /dev/video6
> (OMAP3 ISP resizer output)

-- 
Regards,

Laurent Pinchart

