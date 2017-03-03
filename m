Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36428 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752089AbdCCWsC (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 17:48:02 -0500
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-15-git-send-email-steve_longerbeam@mentor.com>
 <20170302160257.GK3220@valkosipuli.retiisi.org.uk>
 <141eb012-eb24-7558-2bc5-1fe82f6b7b4b@gmail.com>
 <fc8168ef-bf36-b2d9-627b-e4b8c6a5024e@gmail.com>
 <20170303191745.GQ3220@valkosipuli.retiisi.org.uk>
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
Message-ID: <e657f59e-6ac7-bad0-c35b-626b53946d01@gmail.com>
Date: Fri, 3 Mar 2017 14:47:24 -0800
MIME-Version: 1.0
In-Reply-To: <20170303191745.GQ3220@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/03/2017 11:17 AM, Sakari Ailus wrote:
> Hi Steve,
>
> On Thu, Mar 02, 2017 at 06:12:43PM -0800, Steve Longerbeam wrote:
>>
>>
>> On 03/02/2017 03:48 PM, Steve Longerbeam wrote:
>>>
>>>
>>> On 03/02/2017 08:02 AM, Sakari Ailus wrote:
>>>> Hi Steve,
>>>>
>>>> On Wed, Feb 15, 2017 at 06:19:16PM -0800, Steve Longerbeam wrote:
>>>>> v4l2_pipeline_inherit_controls() will add the v4l2 controls from
>>>>> all subdev entities in a pipeline to a given video device.
>>>>>
>>>>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>>>>> ---
>>>>> drivers/media/v4l2-core/v4l2-mc.c | 48
>>>>> +++++++++++++++++++++++++++++++++++++++
>>>>> include/media/v4l2-mc.h           | 25 ++++++++++++++++++++
>>>>> 2 files changed, 73 insertions(+)
>>>>>
>>>>> diff --git a/drivers/media/v4l2-core/v4l2-mc.c
>>>>> b/drivers/media/v4l2-core/v4l2-mc.c
>>>>> index 303980b..09d4d97 100644
>>>>> --- a/drivers/media/v4l2-core/v4l2-mc.c
>>>>> +++ b/drivers/media/v4l2-core/v4l2-mc.c
>>>>> @@ -22,6 +22,7 @@
>>>>> #include <linux/usb.h>
>>>>> #include <media/media-device.h>
>>>>> #include <media/media-entity.h>
>>>>> +#include <media/v4l2-ctrls.h>
>>>>> #include <media/v4l2-fh.h>
>>>>> #include <media/v4l2-mc.h>
>>>>> #include <media/v4l2-subdev.h>
>>>>> @@ -238,6 +239,53 @@ int v4l_vb2q_enable_media_source(struct
>>>>> vb2_queue *q)
>>>>> }
>>>>> EXPORT_SYMBOL_GPL(v4l_vb2q_enable_media_source);
>>>>>
>>>>> +int __v4l2_pipeline_inherit_controls(struct video_device *vfd,
>>>>> +                     struct media_entity *start_entity)
>>>>
>>>> I have a few concerns / questions:
>>>>
>>>> - What's the purpose of this patch? Why not to access the sub-device node
>>>>  directly?
>>>
>>>
>>> I don't really understand what you are trying to say.<snip>
>>>
>>
>> Actually I think I understand what you mean now. Yes, the user can
>> always access a subdev's control directly from its /dev/v4l-subdevXX.
>> I'm only providing this feature as a convenience to the user, so that
>> all controls in a pipeline can be accessed from one place, i.e. the
>> main capture device node.
>
> No other MC based V4L2 driver does this. You'd be creating device specific
> behaviour that differs from what the rest of the drivers do. The purpose of
> MC is to provide the user with knowledge of what devices are there, and the
> V4L2 sub-devices interface is used to access them in this case.

Well, again, I don't mind removing this. As I said it is only a
convenience (although quite a nice one in my opinion). I'd like
to hear from others whether this is worth keeping though.


>
> It does matter where a control is implemented, too. If the pipeline contains
> multiple sub-devices that implement the same control, only one of them may
> be accessed. The driver calling the function (or even less the function)
> would not know which one of them should be ignored.

Yes the pipeline should not have any duplicate controls. On imx-media no
pipelines that can be configured have duplicate controls.

Steve

>
> If you need such functionality, it should be implemented in the user space
> instead.
>
