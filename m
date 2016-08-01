Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:50613 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752047AbcHAI4h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Aug 2016 04:56:37 -0400
Subject: Re: [PATCH 3/3] soc-camera/sh_mobile_csi2: remove unused driver
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1470038065-30789-1-git-send-email-hverkuil@xs4all.nl>
 <1470038065-30789-4-git-send-email-hverkuil@xs4all.nl>
 <8220966.xMzG3XxcmY@avalon>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <4dafe85c-ec52-9460-1f1e-1d4ae8c456a4@xs4all.nl>
Date: Mon, 1 Aug 2016 10:56:21 +0200
MIME-Version: 1.0
In-Reply-To: <8220966.xMzG3XxcmY@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/01/2016 10:34 AM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Monday 01 Aug 2016 09:54:25 Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> The sh_mobile_csi2 isn't used anymore (was it ever?), so remove it.
>> Especially since the soc-camera framework is being deprecated.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
>> ---
>>  drivers/media/platform/soc_camera/Kconfig          |   7 -
>>  drivers/media/platform/soc_camera/Makefile         |   1 -
>>  .../platform/soc_camera/sh_mobile_ceu_camera.c     | 229 +-----------
>>  drivers/media/platform/soc_camera/sh_mobile_csi2.c | 400 ------------------
>>  include/media/drv-intf/sh_mobile_ceu.h             |   1 -
>>  include/media/drv-intf/sh_mobile_csi2.h            |  48 ---
>>  6 files changed, 10 insertions(+), 676 deletions(-)
>>  delete mode 100644 drivers/media/platform/soc_camera/sh_mobile_csi2.c
>>  delete mode 100644 include/media/drv-intf/sh_mobile_c
> 
> Any plan for the sh_mobile_ceu_camera driver by the way ?
> 

Yes.

The idea is to replace the remaining soc-camera drivers by 'proper' drivers
(Robert Jarzmik is working on that for the pxa_camera driver, and I am working
on the atmel-isi driver).

Once that's done the only soc-camera driver left is the sh_mobile_ceu_camera
driver.

At that moment the soc-camera framework will be folded into the sh_mobile_ceu_camera
driver and it will cease to exist as a framework. It's just a very complex
driver. I plan on refactoring it further, removing dead code etc.

My original plan was to replace the sh_mobile_ceu_camera driver by a 'proper'
driver as well, but it was next to impossible to do that. The fact that it
didn't use the device tree and the complexity with scaling and cropping and
the close dependency on soc-camera just made this a no go (at least not
something I was willing to spend more time on).

I think this alternative approach has the best chance of succeeding.

I'm not sure yet what we'll do with the soc-camera sensors. I experimented
a bit with extracting them from soc-camera, but for most it's not easy to
do so. Something to look at later.

Regards,

	Hans
