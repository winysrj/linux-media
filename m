Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:54706 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310AbZKRBaC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 20:30:02 -0500
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
	"mchehab@infradead.org" <mchehab@infradead.org>,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
Date: Tue, 17 Nov 2009 19:31:23 -0600
Subject: RE: [PATCH/RFC] V4L core cleanups
Message-ID: <A24693684029E5489D1D202277BE89444D9BCA5A@dlee02.ent.ti.com>
References: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1258504731-8430-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent, 

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org 
> [mailto:linux-media-owner@vger.kernel.org] On Behalf Of 
> Laurent Pinchart
> Sent: Tuesday, November 17, 2009 6:39 PM
> To: linux-media@vger.kernel.org
> Cc: hverkuil@xs4all.nl; mchehab@infradead.org; 
> sakari.ailus@maxwell.research.nokia.com
> Subject: [PATCH/RFC] V4L core cleanups
> 
> Hi everybody,
> 
> this patch sets attemp to clean up the V4L core to remove the
> video_device::minor and video_device::num references in most drivers.

I think you're missing usual subject prefix: [PATCH #/total]

Unless all patches are independent from eachother, which is something
I'll hardly believe.

Regards,
Sergio

> 
> There are two reasons for this. The first one is that drivers really
> shouldn't care about those fields, especially the minor number. This
> doesn't mean a driver can't request a specific device number, that
> remains a perfectly valid use case, but most use cases of those fields
> after device registration shouldn't be needed.
> 
> The second reason is that most drivers use those fields in bogus ways,
> making it obvious they shouldn't have cared about them in the first
> place :-) We've had a video_drvdata function for a long time, but many
> drivers still have their own private minor -> data mapping lists for
> historical reasons. That code is error prone and completely unneeded.
> 
> So this patch sets tries to clean up the V4L core by porting 
> drivers to
> the most "recent" APIs (which are actually quite old) and 
> introducing a
> new helper function.
> 
> The first two patches add and use the video_device_node_name function.
> The function returns a const pointer to the video device name. On
> systems using udev, the name is passed as a hint to udev and 
> will likely
> become the /dev device node name, unless overwritten by udev 
> rules (I've
> heard that some distributions put the V4L device nodes in /dev/v4l).
> Some drivers erroneously created the name from the video_device::minor
> field instead of video_device::num, which is fixed by the 
> second patch.
> 
> This is an example video_device_node_name usage typical from 
> what can be
> found in the second patch.
> 
> -       printk(KERN_INFO "bttv%d: registered device radio%d\n",
> -              btv->c.nr, btv->radio_dev->num);
> +       printk(KERN_INFO "bttv%d: registered device %s\n",
> +              btv->c.nr, video_device_node_name(btv->radio_dev));
> 
> The third patch removes left video_device::num usage from the drivers.
> The field was used to create information strings that 
> shouldn't include
> the device node name (such as video_device::name) or that should be
> created using a stable identifier (such as i2c_adapter::name).
> 
> The fourth, fifth and sixth patches replace video_is_unregistered with
> video_is_registered and use the new function in device drivers. As
> explained in the fourth patch commit message, the rationale 
> behind that
> is to have video_is_registered return false when called on an
> initialized but not yet registered video_device instance. The function
> can be used instead of checking video_device::minor manually, 
> making it
> less error-prone as drivers don't need to make sure they
> video_device::minor to -1 correctly for all error paths.
> 
> A typical use case is
> 
> -       if (-1 != dev->radio_dev->minor)
> +       if (video_is_registered(dev->radio_dev))
>                 video_unregister_device(dev->radio_dev);
>         else
>                 video_device_release(dev->radio_dev);
> 
> The seventh patch replace local minor to data lists by 
> video_drvdata().
> The function has been there for a long time but wasn't used by many
> drivers, probably because they were written before it was 
> available, or,
> for some of them, because they were written based on drivers that were
> not using it. This patch removes lots of identical unneeded 
> code blocks,
> making the result less bug-prone.
> 
> The eight patch removes now unneeded video_device::minor 
> assignments to
> -1, as the previous patches made them unneeded.
> 
> The last patch removes a few more video_device::minor users. As
> explained in the patch description, the field was used either to
> 
> - test for error conditions that can't happen anymore with the current
>   v4l-dvb core,
> - store the value in a driver private field that isn't used anymore,
> - check the video device type where video_device::vfl_type should be
>   used, or
> - create the name of a kernel thread that should get a stable name.
> 
> There are still two video_device::num users and those can easily be
> removed. Hans Verkuil is working on a patch, as one of the drivers is
> the ivtv driver and the other one is based on the same code.
> 
> There are also still a few video_device::minor users. One of them is
> the pvrusb2 driver that creates sysfs attributes storing the minor
> numbers of the device nodes created by the driver. I'm not 
> sure what to
> do about that one. All the others are V4L1 drivers that need the minor
> number for the VIDIOCGUNIT ioctl. Hopefully that will die when the
> drivers will be ported to V4L2 :-)
> 
> I've split the patches into core and device patches to make 
> them easier
> to apply on my work trees. I'll merge the core and device 
> code together
> when submitting a pull request to avoid bisection errors.
> 
> I'll send a pull request after receiving (and incorporating) your
> comments, or in a few days if there's no comments.
> 
> Regards,
> 
> Laurent Pinchart
> 
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 