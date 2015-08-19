Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:56530 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751524AbbHSG2L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2015 02:28:11 -0400
Message-ID: <55D421CF.9090109@xs4all.nl>
Date: Wed, 19 Aug 2015 08:27:27 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
	linux-media <linux-media@vger.kernel.org>,
	Ramakrishnan Muthukrishnan <ram@rkrishnan.org>,
	Mikhail Khelik <mkhelik@cisco.com>,
	Mats Randgaard <matrandg@cisco.com>
Subject: Re: linux-next: Tree for Aug 18 (drivers/media/i2c/tc358743.c)
References: <20150818214003.73bd846a@canb.auug.org.au> <55D34EA5.1010705@infradead.org>
In-Reply-To: <55D34EA5.1010705@infradead.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/18/2015 05:26 PM, Randy Dunlap wrote:
> On 08/18/15 04:40, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20150817:
>>
> 
> on i386:
> 
> when CONFIG_MEDIA_CONTROLLER is not enabled:
> 
> ../drivers/media/i2c/tc358743.c: In function 'tc358743_probe':
> ../drivers/media/i2c/tc358743.c:1890:29: error: 'struct v4l2_subdev' has no member named 'entity'
>   err = media_entity_init(&sd->entity, 1, &state->pad, 0);
>                              ^
> ../drivers/media/i2c/tc358743.c:1940:26: error: 'struct v4l2_subdev' has no member named 'entity'
>   media_entity_cleanup(&sd->entity);
>                           ^
> ../drivers/media/i2c/tc358743.c: In function 'tc358743_remove':
> ../drivers/media/i2c/tc358743.c:1955:26: error: 'struct v4l2_subdev' has no member named 'entity'
>   media_entity_cleanup(&sd->entity);
>                           ^
> 
> 
> 

tc358743: add missing Kconfig dependency/select

This driver depends on VIDEO_V4L2_SUBDEV_API and needs to select HDMI.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index d669547..521bbf1 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -289,7 +289,8 @@ config VIDEO_SAA711X
 
 config VIDEO_TC358743
 	tristate "Toshiba TC358743 decoder"
-	depends on VIDEO_V4L2 && I2C
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
+	select HDMI
 	---help---
 	  Support for the Toshiba TC358743 HDMI to MIPI CSI-2 bridge.
 

