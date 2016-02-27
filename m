Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:37967 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756340AbcB0RRo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 12:17:44 -0500
Subject: Re: [PATCH] v4l2: remove MIPI CSI-2 driver for SH-Mobile platforms
To: Simon Horman <horms@verge.net.au>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1456279679-11342-1-git-send-email-horms+renesas@verge.net.au>
 <2212155.BHpL65I02t@avalon> <20160224061721.GK5435@verge.net.au>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56D1DA30.3040207@xs4all.nl>
Date: Sat, 27 Feb 2016 18:17:36 +0100
MIME-Version: 1.0
In-Reply-To: <20160224061721.GK5435@verge.net.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

On 02/24/2016 07:17 AM, Simon Horman wrote:
> On Wed, Feb 24, 2016 at 07:59:57AM +0200, Laurent Pinchart wrote:
>> Hi Simon,
>>
>> Thank you for the patch.
>>
>> On Wednesday 24 February 2016 11:07:59 Simon Horman wrote:
>>> This driver does not appear to have ever been used by any SoC's defconfig
>>> and does not appear to support DT. In sort it seems unused an unlikely
>>> to be used.
>>>
>>> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
>>> ---
>>>  drivers/media/platform/soc_camera/Kconfig          |   7 -
>>>  drivers/media/platform/soc_camera/Makefile         |   1 -
>>>  drivers/media/platform/soc_camera/sh_mobile_csi2.c | 400 ------------------
>>
>> Shouldn't you also remove include/media/drv-intf/sh_mobile_csi2.h ? You would 
>> then need to update drivers/media/platform/soc_camera/sh_mobile_ceu.c 
>> accordingly, or remove it altogether.
> 
> Thanks.
> 
> sh_mobile_ceu appears to be used by several SH boards so I'd rather
> not remove it, at least not for this reason.
> 
> So I'd prefer to look into updating sh_mobile_ceu.c and removing
> sh_mobile_csi2.h.

I did some testing which was rather painful due to this bug that I hit:

https://bugzilla.kernel.org/show_bug.cgi?id=113321

Unrelated to this driver but a sign that nobody used kernels >= 4.2 with
this hardware, since that's how long support for this board (and probably
sh4 in general) has been broken.

The ceu driver itself seems to work with the composite input. I can't test
with a sensor board since the sensor is no longer recognized on the i2c bus.
I suspect that the cable between the sh4 board and the camera board has a
fault. So unless someone has a replacement cable for me (or knows where to
get one) I won't be able to test it.

I will see if I can do a simple conversion tomorrow or Monday, for now without
cropping support. Just a simple capture driver.

Regards,

	Hans
