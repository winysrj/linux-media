Return-path: <mchehab@gaivota>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1067 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab0L1Sgr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Dec 2010 13:36:47 -0500
From: "Shuzhen Wang" <shuzhenw@codeaurora.org>
To: "'Mauro Carvalho Chehab'" <mchehab@redhat.com>,
	"'Hans Verkuil'" <hverkuil@xs4all.nl>
Cc: <linux-media@vger.kernel.org>, <hzhong@codeaurora.org>,
	"Yan, Yupeng" <yyan@quicinc.com>
References: <000601cba2d8$eaedcdc0$c0c96940$@org> <201012241219.31754.hverkuil@xs4all.nl> <4D188285.8090603@redhat.com>
In-Reply-To: <4D188285.8090603@redhat.com>
Subject: RE: RFC: V4L2 driver for Qualcomm MSM camera.
Date: Tue, 28 Dec 2010 10:35:05 -0800
Message-ID: <000001cba6bd$f2c94ea0$d85bebe0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-language: en-us
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

> -----Original Message-----
> From: Mauro Carvalho Chehab [mailto:mchehab@redhat.com]
> Sent: Monday, December 27, 2010 4:12 AM
> To: Hans Verkuil
> Cc: Shuzhen Wang; linux-media@vger.kernel.org; hzhong@codeaurora.org
> Subject: Re: RFC: V4L2 driver for Qualcomm MSM camera.
> 
> Em 24-12-2010 09:19, Hans Verkuil escreveu:
> >> MSM_CAM_IOCTL_SENSOR_IO_CFG
> >>         Get or set sensor configurations: fps, line_pf, pixels_pl,
> >>         exposure and gain, etc. The setting is stored in
> sensor_cfg_data
> >>         structure.
> 
> This doesn't make much sense to me as-is. The V4L2 API can set fps,
> exposure,
> gain and other things. Please only use private ioctl's for those things
> that
> aren't provided elsewhere and can't be mapped into some CTRL.
> 

In our design, all these private ioctls are only called from the service
daemon, so they are transparent to the application. For example, when a
standard V4L2 API is called from the app to change fps, it gets translated
to MSM_CAM_IOCTL_SENSOR_IO_CFG in the daemon, and sent to the sensor
hardware.

> >> MSM_CAM_IOCTL_CONFIG_VFE
> >>         Change settings of different components of VFE hardware.
> 
> Hard to analyze it, as you didn't provide any details ;)
> 
> Maybe the media controller API will be the right place for it. As Hans
> pointed,
> the hardware should be able to work without private ioctl's and/or
> media
> controller stuff.
> 

Because all the private ioctl's are only called from daemon, they are not
very big concern here IMHO. The fact that a lot of stuff is done in daemon
does make it harder to decouple. 

MSM_CAM_IOCTL_CONFIG_VFE ioctl calls pass in a structure like this:
struct msm_vfe_cfg_cmd {
        int cmd_type;
        uint16_t length;
        void *value;
};
Where cmd_type indicates what component of the VFE pipeline to configure,
For example, enable/disable stats, VFE buffers configuration, demosaic,
color conversion/correction, etc. The value field will contain the
appropriate data for the said cmd_type.

> >> MSM_CAM_IOCTL_CTRL_CMD_DONE
> >>         Notify the driver that the ctrl command is finished.
> 
> Just looking at the ioctl name, this doesn't make much sense. If you
> open a
> device on normal way, the ioctl it will block until the operation is
> completed.
> 
> Could you please provide more details about it?

The idea is that the kernel driver delegates the control command to the
service daemon ( by means of v4l2_event ). The V4L2 control command call
from the app is blocked until the service daemon is done with operation.

For example, for a VIDIOC_S_CTRL, the driver wraps the v4l2_ctrl structure
in a v4l2_event, publishes it to the daemon, and blocks. The daemon then
calls either MSM_CAM_IOCTL_CONFIG_VFE or MSM_CAM_IOCTL_SENSOR_IO_CFG or
both to configure the hardware. Once thoese ioctls return, it then call 
MSM_CAM_IOCTL_CTRL_CMD_DONE to notify the driver so that it can wake up
the application.

> >> MSM_CAM_IOCTL_AXI_CONFIG
> >>         Configure AXI bus parameters (frame buffer addresses,
> offsets) to
> >>         the VFE hardware.
> 
> Hard to analyze it, as you didn't provide any details ;)
> 
> The same comments I did for MSM_CAM_IOCTL_CONFIG_VFE apply here.

This registers buffers with VFE hardware. Like all other private ioctls, 
It's called from the daemon. 


Thanks!
-Shuzhen

