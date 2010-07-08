Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:39988 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab0GHMIw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Jul 2010 08:08:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC/PATCH 2/6] v4l: subdev: Add device node support
Date: Thu, 8 Jul 2010 14:08:49 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com> <201007072144.46481.laurent.pinchart@ideasonboard.com> <4C34E954.5090907@redhat.com>
In-Reply-To: <4C34E954.5090907@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007081408.50289.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wednesday 07 July 2010 22:53:40 Mauro Carvalho Chehab wrote:
> Em 07-07-2010 16:44, Laurent Pinchart escreveu:
> > On Wednesday 07 July 2010 16:58:01 Mauro Carvalho Chehab wrote:
> >> Em 07-07-2010 08:53, Laurent Pinchart escreveu:
> >>> Create a device node named subdevX for every registered subdev.
> >>> As the device node is registered before the subdev core::s_config
> >>> function is called, return -EGAIN on open until initialization
> >>> completes.
> > 
> > [snip]
> > 
> >>> +static int subdev_open(struct file *file)
> >>> +{
> >>> +	struct video_device *vdev = video_devdata(file);
> >>> +	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
> >>> +
> >>> +	if (!sd->initialized)
> >>> +		return -EAGAIN;
> >> 
> >> Those internal interfaces should not be used on normal
> >> devices/applications, as none of the existing drivers are tested or
> >> supposed to properly work if an external program is touching on its
> >> 
> >> internal interfaces. So, please add:
> >> 	if (!capable(CAP_SYS_ADMIN))
> >> 	
> >> 		return -EPERM;
> > 
> > As Hans pointed out, subdev device nodes should only be created if the
> > subdev request it explicitly. I'll fix the patch accordingly. Existing
> > subdevs will not have a device node by default anymore, so the
> > CAP_SYS_ADMIN capability won't be required (new subdevs that explicitly
> > ask for a device node are supposed to handle the calls properly,
> > otherwise it's a bit pointless :-)).
> 
> It should be not requested by the subdev, but by the bridge driver (or
> maybe by both).
> 
> On several drivers, the bridge is connected to more than one subdev, and
> some changes need to go to both subdevs, in order to work. As the glue
> logic is at the bridge driver, creating subdev interfaces will not make
> sense on those devices.

Agreed. I've added a flag that subdev drivers can set to request creation of a 
device node explicitly, and an argument to to v4l2_i2c_new_subdev_board and 
v4l2_spi_new_subdev to overwrite the flag. A device node will only be created 
if the flag is set by the subdev (meaning "I can support device nodes") and 
the flag is not forced to 0 by the bridge driver (meaning "I allow userspace 
to access the subdev directly).

[snip]

> >>> +static long subdev_ioctl(struct file *file, unsigned int cmd,
> >>> +	unsigned long arg)
> >>> +{
> >>> +	return video_usercopy(file, cmd, arg, subdev_do_ioctl);
> >> 
> >> This is a legacy call. Please, don't use it.
> > 
> > What should I use instead then ? I need the functionality of
> > video_usercopy. I could copy it to v4l2-subdev.c verbatim. As
> > video_ioctl2 shares lots of code with video_usercopy I think
> > video_usercopy should stay, and video_ioctl2 should use it.
> 
> The bad thing of video_usercopy() is that it has a "compat" code, to fix
> broken definitions of some iotls (see video_fix_command()), and that a few
> drivers still use it, instead of video_ioctl2.

video_ioctl2 has the same compat code.

> For sure, we don't need the "compat" code for subdev interface. Also, as
> time goes by, we'll eventually have different needs at the subdev interface,
> as some types of ioctl's may be specific to subdevs and may require
> different copy logic.

We can change the logic then :-)

> IMO, the better is to use the same logic inside the subdev stuff, of course
> removing that "old ioctl" fix logic:
> 
> #ifdef __OLD_VIDIOC_
> 	cmd = video_fix_command(cmd);
> #endif
> 
> And replacing the call to:
> 	err = func(file, cmd, parg);
> 
> By the proper subdev handling.

What about renaming video_usercopy to __video_usercopy, adding an argument to 
enable/disable the compat code, create a new video_usercopy that calls 
__video_usercopy with compat code enabled, have video_ioctl2 call 
__video_usercopy with compat code enabled, and having subdev_ioctl call 
__video_usercopy with compat code disabled ?

-- 
Regards,

Laurent Pinchart
