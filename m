Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.epfl.ch ([128.178.224.226]:38490 "HELO smtp3.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934323AbZHENyP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Aug 2009 09:54:15 -0400
Message-ID: <4A798F05.808@epfl.ch>
Date: Wed, 05 Aug 2009 15:54:13 +0200
From: Valentin Longchamp <valentin.longchamp@epfl.ch>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	"m-karicheri2@ti.com" <m-karicheri2@ti.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Darius Augulis <augulis.darius@gmail.com>
Subject: Re: [PATCH 0/4] soc-camera: cleanup + scaling / cropping API fix
References: <Pine.LNX.4.64.0907291640010.4983@axis700.grange> <4A71A159.60903@epfl.ch> <Pine.LNX.4.64.0907302019270.6813@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0907302019270.6813@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Guennadi Liakhovetski wrote:
> On Thu, 30 Jul 2009, Valentin Longchamp wrote:
> 
>> Hi Guennadi,
>>
>> Guennadi Liakhovetski wrote:
>>> Hi all
>>>
>>> here goes a new iteration of the soc-camera scaling / cropping API
>>> compliance fix. In fact, this is only the first _complete_ one, the previous
>>> version only converted one platform - i.MX31 and one camera driver -
>>> MT9T031. This patch converts all soc-camera drivers. The most difficult one
>>> is the SuperH driver, since it is currently the only host driver
>>> implementing own scaling and cropping on top of those of sensor drivers. The
>>> first three patches in the series are purely cosmetic, unifying device
>>> objects, used in dev_dbg, dev_info... functions. These patches extend the
>>> patch series uploaded at
>>> http://download.open-technology.de/soc-camera/20090701/ with the actual
>>> scaling / cropping patch still in
>>> http://download.open-technology.de/testing/. The series is still based on
>>> the git://git.pengutronix.de/git/imx/linux-2.6.git (now gone) for-rmk
>>> branch, but the i.MX31 patches, that my patch-series depends on, are now in
>>> the mainline, so, I will be rebasing the stack soon. In the meantime, I'm
>>> afraid, it might require some fiddling to test the stack.
>> I'd love to give your patches a try. But the fiddling looks very hard for me
>> ... patch 0010 does not apply correctly for me, and a 130K patch to do by hand
>> is .. looooong.
> 
> Ok, a rebased patch set is under 
> 
> http://download.open-technology.de/soc-camera/20090730/
> 
> now based on 2.6.31-rc4. Notice, all patches are now in the above 
> directory, .../testing is empty again.
> 

I have some feedback with your patches. I have tried to add support for 
my platform by doing the same as you did for pcm037. However it does not 
work. I have applied your patches directly on 2.6.31-rc4.

The first problem is that in order to be able to probe the camera 
correctly, I cannot have mt9t031 built as module and not loaded at this 
time. This certainly is not critcal for the time being, but it should be 
  handled correctly later (the error comes from 
v4l2_i2c_new_subdev_board -called from soc_camera_init_i2c - that does 
not create the subdev with the module not loaded - kernel boot).

The second and bigger problem is that even if I can register everything 
on the system (/dev/video0 gets created), when I try to access it, I get 
a device or resourse busy error.

Kernel log (end):

> Freescale High-Speed USB SOC Device Controller driver (Apr 20, 2007)
> Platform driver 'fsl-usb2-udc' needs updating - please use dev_pm_ops
> i2c /dev entries driver
> Linux video capture interface: v2.00
> camera 0-0: Probing 0-0
> mx3-camera mx3-camera.0: MX3 Camera driver attached to camera 0
> mt9t031 0-005d: Detected a MT9T031 chip ID 1621
> mx3-camera mx3-camera.0: MX3 Camera driver detached from camera 0
> i.MX SDHC driver
> i.MX SDHC driver
> TCP cubic registered
> NET: Registered protocol family 17
> RPC: Registered udp transport module.
> RPC: Registered tcp transport module.
> VFP support v0.3: implementor 41 architecture 1 part 20 variant b rev 2
> Waiting for root device /dev/mmcblk0p1...
> mmc0: new SD card at address b368
> mmcblk0: mmc0:b368 NCard 1.85 GiB 
>  mmcblk0: p1
> EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
> VFS: Mounted root (ext2 filesystem) on device 179:1.
> Freeing init memory: 100K


> root@mx31moboard:~# ./gst.sh 
> Setting pipeline to PAUSED ...
> mx3-camera mx3-camera.0: MX3 Camera driver attached to camera 0
> mx3-camera mx3-camera.0: MX3 Camera driver detached from camera 0
> ERROR: Pipeline doesn't want to pause.
> ERROR: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0: Could not open .
> Additional debug info:
> v4l2_calls.c(477): gst_v4l2_open (): /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
> system error: Device or resource busy
> Setting pipeline to NULL ...
> Freeing pipeline ...

I have noticed that using the old way of doing the things (without 
v4lsubdev support, using some code that works with 2.6.30), it does not 
work either with 2.6.31-rc4 (same device or resource busy). So maybe am 
I missing something here already. Here is the "log":

> root@mx31moboard:~# insmod modules/mt9t031.ko 
> camera 0-0: MX3 Camera driver attached to camera 0
> camera 0-0: Detected a MT9T031 chip ID 1621
> camera 0-0: MX3 Camera driver detached from camera 0
> root@mx31moboard:~# camera 0-0: MX3 Camera driver attached to camera 0
> camera 0-0: MX3 Camera driver detached from camera 0
> root@mx31moboard:~# ./gst.sh 
> Setting pipeline to PAUSED ...
> camera 0-0: MX3 Camera driver attached to camera 0
> camera 0-0: MX3 Camera driver detached from camera 0
> ERROR: Pipeline doesn't want to pause.
> ERROR: from element /GstPipeline:pipeline0/GstV4l2Src:v4l2src0: Could not open .
> Additional debug info:
> v4l2_calls.c(477): gst_v4l2_open (): /GstPipeline:pipeline0/GstV4l2Src:v4l2src0:
> system error: Device or resource busy
> Setting pipeline to NULL ...
> Freeing pipeline ...

Best Regards

Val

-- 
Valentin Longchamp, PhD Student, EPFL-STI-LSRO1
valentin.longchamp@epfl.ch, Phone: +41216937827
http://people.epfl.ch/valentin.longchamp
MEA3485, Station 9, CH-1015 Lausanne
