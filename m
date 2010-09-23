Return-path: <mchehab@pedra>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4045 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab0IWKAL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Sep 2010 06:00:11 -0400
Message-ID: <a7c1e59279e4144dc224cc7978d3708c.squirrel@webmail.xs4all.nl>
In-Reply-To: <20100923114420.746a605f@endymion.delvare>
References: <201009152200.27132.hverkuil@xs4all.nl>
    <4C9AD51D.2010400@redhat.com> <201009230814.43504.hverkuil@xs4all.nl>
    <20100923114420.746a605f@endymion.delvare>
Date: Thu, 23 Sep 2010 11:59:55 +0200
Subject: Re: [GIT PATCHES FOR 2.6.37] Remove v4l2-i2c-drv.h and most of
 i2c-id.h
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Jean Delvare" <khali@linux-fr.org>
Cc: "Mauro Carvalho Chehab" <mchehab@redhat.com>,
	linux-media@vger.kernel.org, "Janne Grunau" <j@jannau.net>,
	"Jarod Wilson" <jarod@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> Hi Hans,
>
> On Thu, 23 Sep 2010 08:14:43 +0200, Hans Verkuil wrote:
>> Jean, I did a grep of who is still including i2c-id.h (excluding media
>> drivers):
>>
>> drivers/gpu/drm/nouveau/nouveau_i2c.h:#include <linux/i2c-id.h>
>> drivers/gpu/drm/radeon/radeon_mode.h:#include <linux/i2c-id.h>
>> drivers/gpu/drm/i915/intel_drv.h:#include <linux/i2c-id.h>
>> drivers/gpu/drm/i915/intel_i2c.c:#include <linux/i2c-id.h>
>> drivers/video/i810/i810.h:#include <linux/i2c-id.h>
>> drivers/video/intelfb/intelfb_i2c.c:#include <linux/i2c-id.h>
>> drivers/video/savage/savagefb.h:#include <linux/i2c-id.h>
>> drivers/video/aty/radeon_i2c.c:#include <linux/i2c-id.h>
>> drivers/i2c/busses/i2c-s3c2410.c:#include <linux/i2c-id.h>
>> drivers/i2c/busses/i2c-pxa.c:#include <linux/i2c-id.h>
>> drivers/i2c/busses/i2c-ibm_iic.c:#include <linux/i2c-id.h>
>
> I additionally have drivers/i2c/busses/i2c-nuc900.c.
>
>> AFAIK none of these actually need this include. It's probably a good
>> idea for
>> you to remove together with
>
> Will do, thanks for suggesting.
>
>> this obsolete I2C_HW_B_RIVA:
>>
>> drivers/video/riva/rivafb-i2c.c:        chan->adapter.id
>> = I2C_HW_B_RIVA;
>
> I'll have to wait for your cleanup to hit upstream before I can remove
> that one.

No need to wait. All that happens if this is removed is that the bogus
initialization function in tvaudio is no longer doing anything. And when
my patch is merged, then that function is removed completely.

Regards,

        Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

