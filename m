Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:42669 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039Ab0IWJpT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 05:45:19 -0400
Date: Thu, 23 Sep 2010 11:44:20 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Janne Grunau <j@jannau.net>,
	Jarod Wilson <jarod@redhat.com>
Subject: Re: [GIT PATCHES FOR 2.6.37] Remove v4l2-i2c-drv.h and most of
 i2c-id.h
Message-ID: <20100923114420.746a605f@endymion.delvare>
In-Reply-To: <201009230814.43504.hverkuil@xs4all.nl>
References: <201009152200.27132.hverkuil@xs4all.nl>
	<4C9AD51D.2010400@redhat.com>
	<201009230814.43504.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Thu, 23 Sep 2010 08:14:43 +0200, Hans Verkuil wrote:
> Jean, I did a grep of who is still including i2c-id.h (excluding media drivers):
> 
> drivers/gpu/drm/nouveau/nouveau_i2c.h:#include <linux/i2c-id.h>
> drivers/gpu/drm/radeon/radeon_mode.h:#include <linux/i2c-id.h>
> drivers/gpu/drm/i915/intel_drv.h:#include <linux/i2c-id.h>
> drivers/gpu/drm/i915/intel_i2c.c:#include <linux/i2c-id.h>
> drivers/video/i810/i810.h:#include <linux/i2c-id.h>
> drivers/video/intelfb/intelfb_i2c.c:#include <linux/i2c-id.h>
> drivers/video/savage/savagefb.h:#include <linux/i2c-id.h>
> drivers/video/aty/radeon_i2c.c:#include <linux/i2c-id.h>
> drivers/i2c/busses/i2c-s3c2410.c:#include <linux/i2c-id.h>
> drivers/i2c/busses/i2c-pxa.c:#include <linux/i2c-id.h>
> drivers/i2c/busses/i2c-ibm_iic.c:#include <linux/i2c-id.h>

I additionally have drivers/i2c/busses/i2c-nuc900.c.

> AFAIK none of these actually need this include. It's probably a good idea for
> you to remove together with

Will do, thanks for suggesting.

> this obsolete I2C_HW_B_RIVA:
> 
> drivers/video/riva/rivafb-i2c.c:        chan->adapter.id                = I2C_HW_B_RIVA;

I'll have to wait for your cleanup to hit upstream before I can remove
that one.

-- 
Jean Delvare
