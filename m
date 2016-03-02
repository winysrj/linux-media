Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:48974 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752321AbcCBLcg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Mar 2016 06:32:36 -0500
Subject: Re: [PATCH v2] media: platform: rcar_jpu, sh_vou, vsp1: Use
 ARCH_RENESAS
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Simon Horman <horms+renesas@verge.net.au>
References: <1456881291-1167-1-git-send-email-horms+renesas@verge.net.au>
 <1491869.T1zOZ4xfVB@avalon>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56D6CF57.2030507@xs4all.nl>
Date: Wed, 2 Mar 2016 12:32:39 +0100
MIME-Version: 1.0
In-Reply-To: <1491869.T1zOZ4xfVB@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

Note that the patch subject still mentions sh_vou.

Otherwise:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

On 03/02/16 12:00, Laurent Pinchart wrote:
> Hi Simon,
> 
> Thank you for the patch.
> 
> On Wednesday 02 March 2016 10:14:51 Simon Horman wrote:
>> Make use of ARCH_RENESAS in place of ARCH_SHMOBILE.
>>
>> This is part of an ongoing process to migrate from ARCH_SHMOBILE to
>> ARCH_RENESAS the motivation for which being that RENESAS seems to be a more
>> appropriate name than SHMOBILE for the majority of Renesas ARM based SoCs.
>>
>> Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
>> ---
>> Based on media-tree/master
>>
>> v2
>> * Do not update VIDEO_SH_VOU to use ARCH_RENESAS as this is
>>   used by some SH-based platforms and is not used by any ARM-based platforms
>> so a dependency on ARCH_SHMOBILE is correct for that driver
>> * Added Geert Uytterhoeven's Ack
>> ---
>>  drivers/media/platform/Kconfig | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
>> index 201f5c296a95..84e041c0a70e 100644
>> --- a/drivers/media/platform/Kconfig
>> +++ b/drivers/media/platform/Kconfig
>> @@ -238,7 +238,7 @@ config VIDEO_SH_VEU
>>  config VIDEO_RENESAS_JPU
>>  	tristate "Renesas JPEG Processing Unit"
>>  	depends on VIDEO_DEV && VIDEO_V4L2 && HAS_DMA
>> -	depends on ARCH_SHMOBILE || COMPILE_TEST
>> +	depends on ARCH_RENESAS || COMPILE_TEST
>>  	select VIDEOBUF2_DMA_CONTIG
>>  	select V4L2_MEM2MEM_DEV
>>  	---help---
>> @@ -250,7 +250,7 @@ config VIDEO_RENESAS_JPU
>>  config VIDEO_RENESAS_VSP1
>>  	tristate "Renesas VSP1 Video Processing Engine"
>>  	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && HAS_DMA
>> -	depends on (ARCH_SHMOBILE && OF) || COMPILE_TEST
>> +	depends on (ARCH_RENESAS && OF) || COMPILE_TEST
>>  	select VIDEOBUF2_DMA_CONTIG
>>  	---help---
>>  	  This is a V4L2 driver for the Renesas VSP1 video processing engine.
> 
