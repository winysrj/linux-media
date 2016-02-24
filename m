Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:54148 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753084AbcBXIql (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2016 03:46:41 -0500
Subject: Re: [PATCH] v4l2: remove MIPI CSI-2 driver for SH-Mobile platforms
To: Geert Uytterhoeven <geert@linux-m68k.org>
References: <1456279679-11342-1-git-send-email-horms+renesas@verge.net.au>
 <2212155.BHpL65I02t@avalon> <20160224061721.GK5435@verge.net.au>
 <56CD59C3.2030401@xs4all.nl>
 <CAMuHMdVeDOe7hQ0LRvdiiW1kKUCF44yOZg4E-FGjDfKenESFfQ@mail.gmail.com>
Cc: Simon Horman <horms@verge.net.au>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56CD6DEB.6050607@xs4all.nl>
Date: Wed, 24 Feb 2016 09:46:35 +0100
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVeDOe7hQ0LRvdiiW1kKUCF44yOZg4E-FGjDfKenESFfQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/24/16 09:39, Geert Uytterhoeven wrote:
> Hi Hans,
> 
> On Wed, Feb 24, 2016 at 8:20 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 02/24/2016 07:17 AM, Simon Horman wrote:
>>> On Wed, Feb 24, 2016 at 07:59:57AM +0200, Laurent Pinchart wrote:
>>>> Hi Simon,
>>>>
>>>> Thank you for the patch.
>>>>
>>>> On Wednesday 24 February 2016 11:07:59 Simon Horman wrote:
>>>>> This driver does not appear to have ever been used by any SoC's defconfig
>>>>> and does not appear to support DT. In sort it seems unused an unlikely
>>>>> to be used.
>>>>>
>>>>> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
>>>>> ---
>>>>>  drivers/media/platform/soc_camera/Kconfig          |   7 -
>>>>>  drivers/media/platform/soc_camera/Makefile         |   1 -
>>>>>  drivers/media/platform/soc_camera/sh_mobile_csi2.c | 400 ------------------
>>>>
>>>> Shouldn't you also remove include/media/drv-intf/sh_mobile_csi2.h ? You would
>>>> then need to update drivers/media/platform/soc_camera/sh_mobile_ceu.c
>>>> accordingly, or remove it altogether.
>>>
>>> Thanks.
>>>
>>> sh_mobile_ceu appears to be used by several SH boards so I'd rather
>>> not remove it, at least not for this reason.
>>>
>>> So I'd prefer to look into updating sh_mobile_ceu.c and removing
>>> sh_mobile_csi2.h.
>>
>> Last time I checked the ceu driver failed to work (missing clock). I'll test
>> again this weekend with the latest kernel. See what the status is of this driver.
> 
> I don't know when you tested last time, but as Simon postponed "[PATCH 3/4]
> drivers: sh: Stop using the legacy clock domain on ARM"
> (http://www.spinics.net/lists/arm-kernel/msg483561.html), clocks may still be
> broken.
> 
> I'll send a simple fix for the regression only.

Thanks! I'll test it this weekend.

Regards,

	Hans
