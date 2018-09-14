Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37543 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727416AbeIOCQC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Sep 2018 22:16:02 -0400
Received: by mail-wm1-f65.google.com with SMTP id n11-v6so3289316wmc.2
        for <linux-media@vger.kernel.org>; Fri, 14 Sep 2018 13:59:51 -0700 (PDT)
Subject: Re: [PATCH v2 0/4] media: soc_camera: ov9640: switch driver to
 v4l2_async
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: hans.verkuil@cisco.com, jacopo@jmondi.org, mchehab@kernel.org,
        marek.vasut@gmail.com, linux-media@vger.kernel.org,
        robert.jarzmik@free.fr, slapin@ossfans.org, philipp.zabel@gmail.com
References: <cover.1534339750.git.petrcvekcz@gmail.com>
 <20180914125932.gepe4g7idwyjd2t4@valkosipuli.retiisi.org.uk>
From: Petr Cvek <petrcvekcz@gmail.com>
Message-ID: <68f3e0bf-ffd7-09cd-b612-0dd1fb7ff078@gmail.com>
Date: Fri, 14 Sep 2018 23:00:07 +0200
MIME-Version: 1.0
In-Reply-To: <20180914125932.gepe4g7idwyjd2t4@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: cs
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dne 14.9.2018 v 14:59 Sakari Ailus napsal(a):
> Hi Petr,
> 
> On Wed, Aug 15, 2018 at 03:30:23PM +0200, petrcvekcz@gmail.com wrote:
>> From: Petr Cvek <petrcvekcz@gmail.com>
>>
>> This patch series transfer the ov9640 driver from the soc_camera subsystem
>> into a standalone v4l2 driver. There is no changes except the required
>> v4l2_async calls, GPIO allocation, deletion of now unused variables,
>> a change from mdelay() to msleep() and an addition of SPDX identifiers
>> (as suggested in the v1 version RFC).
>>
>> The config symbol has been changed from CONFIG_SOC_CAMERA_OV9640 to
>> CONFIG_VIDEO_OV9640.
>>
>> Also as the drivers of the soc_camera seems to be orphaned I'm volunteering
>> as a maintainer of the driver (I own the hardware).
> 
> Thanks for the set. The patches seem good to me as such but there's some
> more work to do there. For one, the depedency to v4l2_clk should be
> removed; the common clock framework has supported clocks from random
> devices for many, many years now.
> 
> The PXA camera driver does still depend on v4l2_clk so I guess this is
> better to do later on in a different patchset.
> 

Yeah I too would like to remove the v4l2_clk from both of them. We've
had the discussion about clock dependency around v1 patch set:
"[BUG, RFC] media: Wrong module gets acquired"

cheers,
Petr
