Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:34267 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbdCCFOi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 00:14:38 -0500
Received: by mail-pf0-f196.google.com with SMTP id x66so8772370pfb.1
        for <linux-media@vger.kernel.org>; Thu, 02 Mar 2017 21:14:29 -0800 (PST)
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-15-git-send-email-steve_longerbeam@mentor.com>
 <20170302160257.GK3220@valkosipuli.retiisi.org.uk>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com,
        linux@armlinux.org.uk, mchehab@kernel.org, hverkuil@xs4all.nl,
        nick@shmanahar.org, markus.heiser@darmarIT.de,
        p.zabel@pengutronix.de, laurent.pinchart+renesas@ideasonboard.com,
        bparrot@ti.com, geert@linux-m68k.org, arnd@arndb.de,
        sudipm.mukherjee@gmail.com, minghsiu.tsai@mediatek.com,
        tiffany.lin@mediatek.com, jean-christophe.trotin@st.com,
        horms+renesas@verge.net.au, niklas.soderlund+renesas@ragnatech.se,
        robert.jarzmik@free.fr, songjun.wu@microchip.com,
        andrew-ct.chen@mediatek.com, gregkh@linuxfoundation.org,
        shuah@kernel.org, sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <141eb012-eb24-7558-2bc5-1fe82f6b7b4b@gmail.com>
Date: Thu, 2 Mar 2017 15:48:39 -0800
MIME-Version: 1.0
In-Reply-To: <20170302160257.GK3220@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/02/2017 08:02 AM, Sakari Ailus wrote:
> Hi Steve,
>
> On Wed, Feb 15, 2017 at 06:19:16PM -0800, Steve Longerbeam wrote:
>> v4l2_pipeline_inherit_controls() will add the v4l2 controls from
>> all subdev entities in a pipeline to a given video device.
>>
>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>> ---
>>  drivers/media/v4l2-core/v4l2-mc.c | 48 +++++++++++++++++++++++++++++++++++++++
>>  include/media/v4l2-mc.h           | 25 ++++++++++++++++++++
>>  2 files changed, 73 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
>> index 303980b..09d4d97 100644
>> --- a/drivers/media/v4l2-core/v4l2-mc.c
>> +++ b/drivers/media/v4l2-core/v4l2-mc.c
>> @@ -22,6 +22,7 @@
>>  #include <linux/usb.h>
>>  #include <media/media-device.h>
>>  #include <media/media-entity.h>
>> +#include <media/v4l2-ctrls.h>
>>  #include <media/v4l2-fh.h>
>>  #include <media/v4l2-mc.h>
>>  #include <media/v4l2-subdev.h>
>> @@ -238,6 +239,53 @@ int v4l_vb2q_enable_media_source(struct vb2_queue *q)
>>  }
>>  EXPORT_SYMBOL_GPL(v4l_vb2q_enable_media_source);
>>
>> +int __v4l2_pipeline_inherit_controls(struct video_device *vfd,
>> +				     struct media_entity *start_entity)
>
> I have a few concerns / questions:
>
> - What's the purpose of this patch? Why not to access the sub-device node
>   directly?


I don't really understand what you are trying to say. That's exactly
what this function is doing, accessing every subdevice in a pipeline
directly, in one convenient function call.


>
> - This implementation is only workable as long as you do not modify the
>   pipeline. Once you disable a link along the pipeline, a device where the
>   control was inherited from may no longer be a part of the pipeline.

That's correct. It's up to the media driver to clear the video device's
inherited controls whenever the pipeline is modified, and then call this
function again if need be.

In imx-media driver, the function is called in link_setup when the link 
from a source pad that is attached to a capture video node is enabled.
This is the last link that must be made to define the pipeline, so it
is at this time that a complete list of subdevice controls can be
gathered by walking the pipeline.


>   Depending on the hardware, it could be a part of another pipeline, in
>   which case it certainly must not be accessible through an unrelated video
>   node. As the function is added to the framework, I would expect it to
>   handle such a case correctly.

The function will not inherit controls from a device that is not
reachable from the given starting subdevice, so I don't understand
you're point here.


>
> - I assume it is the responsibility of the caller of this function to ensure
>   the device in question will not be powered off whilst the video node is
>   used as another user space interface to such a sub-device. If the driver
>   uses the generic PM functions in the same file, this works, but it still
>   has to be documented.

I guess I'm missing something. Why are you bringing up the subject of
power? What does this function have to do with whether a subdevice is
powered or not? The function makes use of v4l2_ctrl_add_handler(), and
the latter has no requirements about whether the device's owning the
control handlers are powered or not.


Steve
