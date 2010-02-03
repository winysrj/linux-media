Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21817 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932276Ab0BCKSZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 05:18:25 -0500
Message-ID: <4B694D69.1090201@redhat.com>
Date: Wed, 03 Feb 2010 08:18:17 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Samuel Ortiz <samuel.ortiz@intel.com>
CC: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] mfd: Add support for the timberdale FPGA.
References: <4B66C36A.4000005@pelagicore.com> <4B693ED7.4060401@redhat.com> <20100203100326.GA3460@sortiz.org>
In-Reply-To: <20100203100326.GA3460@sortiz.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Samuel Ortiz wrote:

>> I'm not sure how to deal with this patch. It doesn't contain anything related
>> to V4L2 inside it, nor it applies to drivers/media, but it depends on the radio-timb
>> driver that you submitted us.
> Actually, there are no build dependencies between those 2 drivers, which is
> very good.

Yes, it is great.

>> As this patch will be committed at mfd tree, the better is if Samuel can review
>> this patch and give his ack. I'll add it together with the V4L2 driver and submit them
>> via my tree.

> I'm going to review this patch right now. Typically, mfd core drivers and
> their subdevices are submitted as a patchset via my tree, because the
> subdevices drivers have dependencies with the core. The mfd core driver is
> submitted without any dependencies, and then when the subdevices drivers are
> submitted, we add relevant code to the mfd driver. This way we prevent any
> build breakage or bisection mess.

The drivers at media are generally very complex with dependencies on several other
subsystems. In general, almost all depends on i2c, alsa and input, and an increasing
number of drivers has also dependencies with platform_data added at arch-dependent
includes/drivers. Yet, this specific driver is simple.

I generally tend to add those drivers via my tree, since it is generally simpler to
prevent breakage/bisection troubles, but it is also ok for me if you want to add
them via your tree, after I get my ack.

> The timberdale chip right now doesnt depend on anything, but will soon depend
> on the radio driver that's on your tree, but also on a sound and on a network
> driver. You'd have to take all those if Richard wants to push them right now.

There were one or two minor changes requested on radio-timb patchset. After that
changes, we're ready to merge it.

> So, what I propose is to take the timberdale mfd core driver and the radio
> one, with your SOB. Then when Richard wants to submit additional subdevices
> drivers I'll be able to take them and we'll avoid polluting your tree with non
> media related drivers. Does that make sense to you ?

Yes, it does. I don't think Richard is urging with those patches, so my idea is
to keep them for linux-next. It would equally work for me if you add the patches
on your tree after my ack. The only merge conflicts we may expect from V4L side
are related to Kconfig/Makefile, and those will be easy to fix during the merge
period.

-- 

Cheers,
Mauro
