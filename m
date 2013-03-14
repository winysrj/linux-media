Return-path: <linux-media-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:35086 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab3CNPpT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Mar 2013 11:45:19 -0400
Message-ID: <1363275911.7599.9.camel@obelisk.thedillows.org>
Subject: Re: Custom device names for v4l2 devices
From: David Dillow <dave@thedillows.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: vkalia@codeaurora.org, linux-media@vger.kernel.org,
	vrajesh@codeaurora.org
Date: Thu, 14 Mar 2013 11:45:11 -0400
In-Reply-To: <1672808.rITBMNsUax@avalon>
References: <3fe50e59b4f7baeda879f4f7b2e5cc1a.squirrel@www.codeaurora.org>
	 <a6da9ec89bbf3e28549a4a25efe3f166.squirrel@www.codeaurora.org>
	 <1672808.rITBMNsUax@avalon>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2013-03-11 at 22:28 +0100, Laurent Pinchart wrote:
> Hi Vinay,
> 
> On Monday 11 March 2013 10:55:37 vkalia@codeaurora.org wrote:
> > > Names of V4L2 device nodes keep on varying depending on target, on some
> > > targets, the device node assigned to my device is /dev/video21 and on some
> > > it is /dev/video15. In order to determine my device, i am opening it,
> > > reading the capabilities, enumerating its formats and then chose the one
> > > matching my requirements. This is impacting start-up latency. One way to
> > > resolve this without impacting start-up latency is to give custom name to
> > > my V4L2 device node (/dev/custom_name instead of /dev/video21). This needs
> > > following change in V4L2 framework. Please review this patch. If you have
> > > faced similar problem please let me know.
> 
> Shouldn't this be implemented in userspace as udev rules instead ?

Indeed, this is possible; I use it to provide consistent names for my
MythTV installation. If you have different V4L devices, you could have a
utility that probes the capabilities when the device is discovered and
use its output to add appropriate symlinks -- for example 

IMPORT{program}="your/utility/here $tempnode"
ENV{YOUR_EXPORTED_VAR_VBI_SUPPORT}=="yes", SYMLINK+="v4l/hd-capable/video"

That that would need some tweaks to handle multiple devices (ie, naming)
that I didn't go look up the escapes for.

Here's my set from home to give you more grist for the mill:

$ cat /etc/udev/rules.d/60-persistent-capture.rules
# Give a persistent name for MythTV to use
#
ACTION=="remove", GOTO="name_video_end"
SUBSYSTEM!="video4linux", GOTO="name_video_end"

IMPORT{program}="v4l_id $tempnode"
#IMPORT{program}="path_id %p"

SUBSYSTEMS=="usb", IMPORT{program}="usb_id --export %p"

KERNEL=="video*", ENV{ID_SERIAL}=="Hauppauge_Hauppauge_Device_4034580546", SYMLINK+="v4l/HVR850/video"
KERNEL=="vbi*", ENV{ID_SERIAL}=="Hauppauge_Hauppauge_Device_4034580546", SYMLINK+="v4l/HVR850/vbi"

# These no longer work; we stopped getting a PCI device path from the kernel it seems...
#KERNEL=="video*", ENV{ID_PATH}=="pci-0000:04:00.0", SYMLINK+="v4l/WinTV/video"
#KERNEL=="vbi*", ENV{ID_PATH}=="pci-0000:04:00.0", SYMLINK+="v4l/WinTV/vbi"

# Key off of the product name now that we cannot tie it to the PCI path
KERNEL=="video*", ENV{ID_V4L_PRODUCT}=="Hauppauge WinTV 34xxx models", SYMLINK+="v4l/WinTV/video"
KERNEL=="vbi*", ENV{ID_V4L_PRODUCT}=="Hauppauge WinTV 34xxx models", SYMLINK+="v4l/WinTV/vbi"

LABEL="name_video_end"


