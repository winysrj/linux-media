Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58594 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757595AbbBEO5Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Feb 2015 09:57:16 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Francesco Marletta <francesco.marletta@movia.biz>
Cc: Francesco Marletta <fmarletta@movia.biz>,
	Carlos =?ISO-8859-1?Q?Sanmart=EDn?= Bustos <carsanbu@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: Help required for TVP5151 on Overo
Date: Thu, 05 Feb 2015 16:57:57 +0200
Message-ID: <8229059.JSIBoG9XF0@avalon>
In-Reply-To: <54D37E67.6030103@movia.biz>
References: <20141119094656.5459258b@crow> <5213550.zrY0P2Gc9u@avalon> <54D37E67.6030103@movia.biz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Francesco,

On Thursday 05 February 2015 15:29:59 Francesco Marletta wrote:
> Hi Laurent,
> I'm trying to use the kernel of the linuxtv repository, omap3isp/tvp5151
> branch,but the kernel don't starts... can you, please, send me the
> kernel command line that you have used?

I'm afraid I haven't kept the .config file around. I might also have rebased 
the working branch without testing the result, so it might just not work on 
3.18-rc4. I'm sorry not to be able to help you for now.

> Also, have you used device tree ?

No, I was using legacy boot. The OMAP3 ISP driver doesn't support DT yet.

-- 
Regards,

Laurent Pinchart

