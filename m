Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33446 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752087AbdCDAgq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 19:36:46 -0500
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
To: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Sakari Ailus <sakari.ailus@iki.fi>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-15-git-send-email-steve_longerbeam@mentor.com>
 <20170302160257.GK3220@valkosipuli.retiisi.org.uk>
 <20170303230645.GR21222@n2100.armlinux.org.uk>
Cc: robh+dt@kernel.org, mark.rutland@arm.com, shawnguo@kernel.org,
        kernel@pengutronix.de, fabio.estevam@nxp.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, nick@shmanahar.org, markus.heiser@darmarIT.de,
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
Message-ID: <c4108ed3-5ad7-900d-1a9b-cded4f763db6@gmail.com>
Date: Fri, 3 Mar 2017 16:36:40 -0800
MIME-Version: 1.0
In-Reply-To: <20170303230645.GR21222@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 03/03/2017 03:06 PM, Russell King - ARM Linux wrote:
> On Thu, Mar 02, 2017 at 06:02:57PM +0200, Sakari Ailus wrote:
>> Hi Steve,
>>
>> On Wed, Feb 15, 2017 at 06:19:16PM -0800, Steve Longerbeam wrote:
>>> v4l2_pipeline_inherit_controls() will add the v4l2 controls from
>>> all subdev entities in a pipeline to a given video device.
>>>
>>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>>> ---
>>>  drivers/media/v4l2-core/v4l2-mc.c | 48 +++++++++++++++++++++++++++++++++++++++
>>>  include/media/v4l2-mc.h           | 25 ++++++++++++++++++++
>>>  2 files changed, 73 insertions(+)
>>>
>>> diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
>>> index 303980b..09d4d97 100644
>>> --- a/drivers/media/v4l2-core/v4l2-mc.c
>>> +++ b/drivers/media/v4l2-core/v4l2-mc.c
>>> @@ -22,6 +22,7 @@
>>>  #include <linux/usb.h>
>>>  #include <media/media-device.h>
>>>  #include <media/media-entity.h>
>>> +#include <media/v4l2-ctrls.h>
>>>  #include <media/v4l2-fh.h>
>>>  #include <media/v4l2-mc.h>
>>>  #include <media/v4l2-subdev.h>
>>> @@ -238,6 +239,53 @@ int v4l_vb2q_enable_media_source(struct vb2_queue *q)
>>>  }
>>>  EXPORT_SYMBOL_GPL(v4l_vb2q_enable_media_source);
>>>
>>> +int __v4l2_pipeline_inherit_controls(struct video_device *vfd,
>>> +				     struct media_entity *start_entity)
>>
>> I have a few concerns / questions:
>>
>> - What's the purpose of this patch? Why not to access the sub-device node
>>   directly?
>
> What tools are in existance _today_ to provide access to these controls
> via the sub-device nodes?
>
> v4l-tools doesn't last time I looked - in fact, the only tool in v4l-tools
> which is capable of accessing the subdevices is media-ctl, and that only
> provides functionality for configuring the pipeline.
>
> So, pointing people at vapourware userspace is really quite rediculous.


Hi Russell,

Yes, that's a big reason why I added this capability. The v4l2-ctl
tool won't accept subdev nodes, although Philipp Zabel has a quick hack
to get around this (ignore return code from VIDIOC_QUERYCAP).


>
> The established way to control video capture is through the main video
> capture device, not through the sub-devices.  Yes, the controls are
> exposed through sub-devices too, but that does not mean that is the
> correct way to access them.
>
> The v4l2 documentation (Documentation/media/kapi/v4l2-controls.rst)
> even disagrees with your statements.  That talks about control
> inheritence from sub-devices to the main video device, and the core
> v4l2 code provides _automatic_ support for this - see
> v4l2_device_register_subdev():
>
>         /* This just returns 0 if either of the two args is NULL */
>         err = v4l2_ctrl_add_handler(v4l2_dev->ctrl_handler, sd->ctrl_handler, NULL);
>
> which merges the subdev's controls into the main device's control
> handler.

Actually v4l2_dev->ctrl_handler is not of much use to me. This will
compose a list of controls from all registered subdevs, i.e. _all
possible controls_.

What v4l2_pipeline_inherit_controls() does is compose a list of
controls that are reachable and available in the currently configured
pipeline.

Steve

>
> So, (a) I don't think Steve needs to add this code, and (b) I think
> your statements about not inheriting controls goes against the
> documentation and API compatibility with _existing_ applications,
> and ultimately hurts the user experience, since there's nothing
> existing today to support what you're suggesting in userspace.
>
