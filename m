Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:37987 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936720AbdCJMyj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 07:54:39 -0500
Subject: Re: [PATCH v4 14/36] [media] v4l2-mc: add a function to inherit
 controls from a pipeline
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
References: <1487211578-11360-1-git-send-email-steve_longerbeam@mentor.com>
 <1487211578-11360-15-git-send-email-steve_longerbeam@mentor.com>
 <20170302160257.GK3220@valkosipuli.retiisi.org.uk>
 <20170303230645.GR21222@n2100.armlinux.org.uk>
 <20170304131329.GV3220@valkosipuli.retiisi.org.uk>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, shawnguo@kernel.org, kernel@pengutronix.de,
        fabio.estevam@nxp.com, mchehab@kernel.org, nick@shmanahar.org,
        markus.heiser@darmarIT.de, p.zabel@pengutronix.de,
        laurent.pinchart+renesas@ideasonboard.com, bparrot@ti.com,
        geert@linux-m68k.org, arnd@arndb.de, sudipm.mukherjee@gmail.com,
        minghsiu.tsai@mediatek.com, tiffany.lin@mediatek.com,
        jean-christophe.trotin@st.com, horms+renesas@verge.net.au,
        niklas.soderlund+renesas@ragnatech.se, robert.jarzmik@free.fr,
        songjun.wu@microchip.com, andrew-ct.chen@mediatek.com,
        gregkh@linuxfoundation.org, shuah@kernel.org,
        sakari.ailus@linux.intel.com, pavel@ucw.cz,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a7b8e095-a95c-24bd-b1e9-e983f18061c4@xs4all.nl>
Date: Fri, 10 Mar 2017 13:54:28 +0100
MIME-Version: 1.0
In-Reply-To: <20170304131329.GV3220@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/03/17 14:13, Sakari Ailus wrote:
> Hi Russell,
> 
> On Fri, Mar 03, 2017 at 11:06:45PM +0000, Russell King - ARM Linux wrote:
>> On Thu, Mar 02, 2017 at 06:02:57PM +0200, Sakari Ailus wrote:
>>> Hi Steve,
>>>
>>> On Wed, Feb 15, 2017 at 06:19:16PM -0800, Steve Longerbeam wrote:
>>>> v4l2_pipeline_inherit_controls() will add the v4l2 controls from
>>>> all subdev entities in a pipeline to a given video device.
>>>>
>>>> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
>>>> ---
>>>>  drivers/media/v4l2-core/v4l2-mc.c | 48 +++++++++++++++++++++++++++++++++++++++
>>>>  include/media/v4l2-mc.h           | 25 ++++++++++++++++++++
>>>>  2 files changed, 73 insertions(+)
>>>>
>>>> diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
>>>> index 303980b..09d4d97 100644
>>>> --- a/drivers/media/v4l2-core/v4l2-mc.c
>>>> +++ b/drivers/media/v4l2-core/v4l2-mc.c
>>>> @@ -22,6 +22,7 @@
>>>>  #include <linux/usb.h>
>>>>  #include <media/media-device.h>
>>>>  #include <media/media-entity.h>
>>>> +#include <media/v4l2-ctrls.h>
>>>>  #include <media/v4l2-fh.h>
>>>>  #include <media/v4l2-mc.h>
>>>>  #include <media/v4l2-subdev.h>
>>>> @@ -238,6 +239,53 @@ int v4l_vb2q_enable_media_source(struct vb2_queue *q)
>>>>  }
>>>>  EXPORT_SYMBOL_GPL(v4l_vb2q_enable_media_source);
>>>>  
>>>> +int __v4l2_pipeline_inherit_controls(struct video_device *vfd,
>>>> +				     struct media_entity *start_entity)
>>>
>>> I have a few concerns / questions:
>>>
>>> - What's the purpose of this patch? Why not to access the sub-device node
>>>   directly?
>>
>> What tools are in existance _today_ to provide access to these controls
>> via the sub-device nodes?
> 
> yavta, for instance:
> 
> <URL:http://git.ideasonboard.org/yavta.git>
> 
> VIDIOC_QUERYCAP isn't supported on sub-devices and v4l2-ctl appears to be
> checking for that. That check should be removed (with possible other
> implications taken into account).

No, the subdev API should get a similar QUERYCAP ioctl. There isn't a single
ioctl that is guaranteed to be available for all subdev devices. I've made
proposals for this in the past, and those have all been shot down.

Add that, and I'll add support for subdevs in v4l2-ctl.

> 
>>
>> v4l-tools doesn't last time I looked - in fact, the only tool in v4l-tools
>> which is capable of accessing the subdevices is media-ctl, and that only
>> provides functionality for configuring the pipeline.
>>
>> So, pointing people at vapourware userspace is really quite rediculous.
> 
> Do bear in mind that there are other programs that can make use of these
> interfaces. It's not just the test programs, or a test program you attempted
> to use.
> 
>>
>> The established way to control video capture is through the main video
>> capture device, not through the sub-devices.  Yes, the controls are
>> exposed through sub-devices too, but that does not mean that is the
>> correct way to access them.
> 
> It is. That's the very purpose of the sub-devices: to provide access to the
> hardware independently of how the links are configured.
> 
>>
>> The v4l2 documentation (Documentation/media/kapi/v4l2-controls.rst)
>> even disagrees with your statements.  That talks about control
>> inheritence from sub-devices to the main video device, and the core
>> v4l2 code provides _automatic_ support for this - see
>> v4l2_device_register_subdev():
>>
>>         /* This just returns 0 if either of the two args is NULL */
>>         err = v4l2_ctrl_add_handler(v4l2_dev->ctrl_handler, sd->ctrl_handler, NULL);
>>
>> which merges the subdev's controls into the main device's control
>> handler.
> 
> That's done on different kind of devices: those that provide plain V4L2 API
> to control the entire device. V4L2 sub-device interface is used *in kernel*
> as an interface to control sub-devices that do not need to be exposed to the
> user space.
> 
> Devices that have complex pipeline that do essentially require using the
> Media controller interface to configure them are out of that scope.
> 

Way too much of how the MC devices should be used is in the minds of developers.
There is a major lack for good detailed documentation, utilities, compliance
test (really needed!) and libv4l plugins.

Russell's comments are spot on and it is a thorn in my side that this still
hasn't been addressed.

I want to see if I can get time from my boss to work on this this summer, but
there is no guarantee.

The main reason this hasn't been a much bigger problem is that most end-users
make custom applications for this hardware. It makes sense, if you need full
control over everything you make the application yourself, that's the whole point.

But there was always meant to be a layer (libv4l plugin) that could be used to
setup a 'default scenario' that existing applications could use, but that was
never enforced, sadly.

Anyway, regarding this specific patch and for this MC-aware driver: no, you
shouldn't inherit controls from subdevs. It defeats the purpose.

Regards,

	Hans
