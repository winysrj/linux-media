Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab1HHSjl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Aug 2011 14:39:41 -0400
Message-ID: <4E402D61.103@redhat.com>
Date: Mon, 08 Aug 2011 15:39:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
CC: Adam Baker <linux@baker-net.org.uk>,
	Hans de Goede <hdegoede@redhat.com>,
	workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
References: <4E398381.4080505@redhat.com> <4E3A91D1.1040000@redhat.com> <4E3B9597.4040307@redhat.com> <201108072353.42237.linux@baker-net.org.uk> <alpine.LNX.2.00.1108072103200.20613@banach.math.auburn.edu> <4E3FE86A.5030908@redhat.com> <alpine.LNX.2.00.1108081208080.21409@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.1108081208080.21409@banach.math.auburn.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 08-08-2011 14:39, Theodore Kilgore escreveu:
> 
> 
> On Mon, 8 Aug 2011, Mauro Carvalho Chehab wrote:
> 
>> Em 07-08-2011 23:26, Theodore Kilgore escreveu:
>>>
>>> (first of two replies to Adam's message; second reply deals with other 
>>> topics)
>>>
>>> On Sun, 7 Aug 2011, Adam Baker wrote:
>>>
>>>> On Friday 05 August 2011, Hans de Goede wrote:
>>>>>> This sounds to be a good theme for the Workshop, or even to KS/2011.
>>>>>
>>>>> Agreed, although we don't need to talk about this for very long, the
>>>>> solution is basically:
>>>>> 1) Define a still image retrieval API for v4l2 devices (there is only 1
>>>>>    interface for both functions on these devices, so only 1 driver, and to
>>>>>    me it makes sense to extend the existing drivers to also do still image
>>>>>    retrieval).
>>>>> 2) Modify existing kernel v4l2 drivers to provide this API
>>>>> 3) Write a new libgphoto driver which talks this interface (only need to
>>>>>    do one driver since all dual mode cams will export the same API).
>>>>>
>>>>> 1) is something to discuss at the workshop.
>>>>>
>>>> This approach sounds fine as long as you can come up with a definition for the 
>>>> API that covers the existing needs and is extensible when new cameras come 
>>>> along and doesn't create horrible inefficiencies by not matching the way some 
>>>> cameras work. I've only got one example of such a camera and it is a fairly 
>>>> basic one but things I can imagine the API needing to provide are
>>>>
>>>> 1) Report number of images on device
>>>> 2) Select an image to read (for some cameras selecting next may be much more 
>>>> efficient than selecting at random although whether that inefficiency occurs 
>>>> when selecting, when reading image info or when reading image data may vary)
>>>> 3) Read image information for selected image (resolution, compression type, 
>>>> FOURCC)
>>>> 4) Read raw image data for selected image
>>>> 5) Delete individual image (not supported by all cameras)
>>>> 6) Delete all images (sometimes supported on cameras that don't support 
>>>> individual delete)
>>>>
>>>> I'm not sure if any of these cameras support tethered capture but if they do 
>>>> then add
>>>> Take photo
>>>> Set resolution
>>>>
>>>> I doubt if any of them support EXIF data, thumbnail images, the ability to 
>>>> upload images to the camera or any sound recording but if they do then those 
>>>> are additional things that gphoto2 would want to be able to do.
>>>
>>>
>>> Adam,
>>>
>>> Yipe. This looks to me like one inglorious mess. I do not know if it is 
>>> feasible, or not, but I would wish for something much more simple. Namely, 
>>> if the camera is not a dual-mode camera then nothing of this is necessary, 
>>> of course. But if it is a dual-mode camera then the kernel driver is able 
>>> to "hand off" the camera to a (libgphoto2-based) userspace driver which 
>>> can handle all of the gory details of what the camera can do in its role 
>>> as a still camera. This would imply that there is a device which 
>>> libgphoto2 can access, presumably another device which is distinct from 
>>> /dev/videoX, lets call it right now /dev/camX just to give it a name 
>>> during the discussion.
>>>
>>> So then what happens ought to be something like the following:
>>>
>>> 1. Camera is plugged in, detected, and kernel module is fired up. Then 
>>> either
>>>
>>> 2a. A streaming app is started. Then, upon request from outside the 
>>> kernel, the /dev/videoX is locked in and /dev/camX is locked out. The 
>>> camera streams until told to quit streaming, and in the meantime any 
>>> access to /dev/camX is not permitted. When the streaming is turned off, 
>>> the lock is released.
>>>
>>> or
>>>
>>> 2b. A stillcam app is started. Then similar to 2a, but the locking is 
>>> reversed.
>>>
>>> I think that this kind of thing would keep life simple. As I understand 
>>> what Hans is envisioning, it is pretty much along the same lines, too. It 
>>> would mean, of course, that the way that libgphoto2 would access one of 
>>> these cameras would be directly to access the /dev/camX provided by the 
>>> kernel, and not to use libusb. But that can be done, I think. As I 
>>> mentioned before, Hans has written several libgphoto2 drivers for digital 
>>> picture frames which are otherwise seen as USB mass storage devices. 
>>> Something similar would have to be done with dual-mode cameras.
>>>
>>>
>>> I will send a second reply to this message, which deals in particular with 
>>> the list of abilities you outlined above. The point is, the situation as 
>>> to that list of abilities is more chaotic than is generally realized. And 
>>> when people are laying plans they really need to be aware of that.
>>
>> >From what I understood from your proposal, "/dev/camX" would be providing a
>> libusb-like interface, right?
>>
>> If so, then, I'd say that we should just use the current libusb infrastructure.
>> All we need is a way to lock libusb access when another driver is using the same
>> USB interface.
>>
>> Hans and Adam's proposal is to actually create a "/dev/camX" node that will give
>> fs-like access to the pictures. As the data access to the cameras generally use
>> PTP (or a PTP-like protocol), probably one driver will handle several different
>> types of cameras, so, we'll end by having one different driver for PTP than the
>> V4L driver.
>>
>> In other words, part of libgphoto2 code will be moved into the Kernel, to allow 
>> abstracting the webcam differences into a common interface.
>>
>> In summary, there are currently two proposals:
>>
>> 1) a resource lock for USB interface between V4L and libusb;
>>
>> 2) a PTP-like USB driver, plus a resource lock between V4L and the PTP-like driver.
>> The same resource lock may also be implemented at libusb, in order to avoid
>> concurrency.
>>
>> As you said that streaming on some cameras may delete all pictures from it,
>> I suspect that (2) is the best alternative.
>>
>> Thanks,
>> Mauro
>>
> 
> Mauro,
> 
> In fact none of the currently known and supported cameras are using PTP. 
> All of them are proprietary. They have a rather intimidating set of 
> differences in functionality, too. Namely, some of them have an 
> isochronous endpoint, and some of them rely exclusively upon bulk 
> transport. Some of them have a well developed set of internal capabilities 
> as far as handling still photos are concerned. I mean, such things as the 
> ability to download a single photo, selected at random from the set of 
> photos on the camera, and some do not, requiring that the "ability" to do 
> this is emulated in software -- by first downloading all previously listed 
> photos and sending the data to /dev/null, then downloading the desired 
> photo and saving it. Some of them permit deletion of individual photos, or 
> all photos, and some do not. For some of them it is even true, as I have 
> previously mentioned, that the USB command string which will delete all 
> photos is the same command used for starting the camera in streaming mode.
> 
> But the point here is that these cameras are all different from one 
> another, depending upon chipset and even, sometimes, upon firmware 
> or chipset version. The still camera abilities and limitations of all of 
> them are pretty much worked out in libgphoto2. My suggestion would be that 
> the libgphoto2 support libraries for these cameras ought to be left the 
> hell alone, except for some changes in, for example, how the camera is 
> accessed in the first place (through libusb or through a kernel device) in 
> order to address adequately the need to support both modes. I know what is 
> in those libgphoto2 drivers because I wrote them. I can definitely promise 
> that to move all of that functionality over into kernel modules would be a 
> nightmare and would moreover greatly contribute to kernel bloat. You 
> really don't want to go there.
> 
> As to whether to use libusb or not to use libusb:
>
> It would be very nice to be able to keep using libusb to get access to 
> these cameras, as then no change in the existing stillcam drivers would be 
> required at all. Furthermore, if it were possible to solve all of the 
> associated locking problems and to do it this way, it would be something 
> that could be generalized to any analogous situation. 

> This would be very nice. I can also imagine, of course, that such an 
> approach might require changes in libusb. For example, the current ability 
> of libusb itself to switch off a kernel device might possibly be a step in 
> the wrong direction, and it might possibly be needed to move that 
> function, somehow, out of libusb and into the kernel support for affected 
> hardware. 
> 
> In the alternative, it ought to be possible for a libgphoto2 driver to 
> hook up directly to a kernel-created device without going through libusb, 
> and, as I have said in earlier messages, some of our driver code (for 
> digital picture frames in particular) does just that. Then, whatever /dev 
> entries and associated locking problems are needed could be handled by the 
> kernel, and libgphoto2 talks to the device. But if things are done this 
> way I strongly suggest that as little of the internals of the libgphoto2 
> driver are put in the kernel as it is possible to do. Be very economical 
> about that, else there will be a big mess. 

Doing an specific libusb-like approach just for those cams seems to be the
wrong direction, as such driver would be just a fork of an already existing
code. I'm all against duplicating it.

So, either we need to move the code from libgphoto2 to kernel or work into
an approach that will make libusb to return -EBUSY when a driver like V4L
is in usage, and vice-versa.

I never took a look on how libusb works. It seems that the logic for it is
at drivers/usb/core/devio.c. Assuming that this is correct driver for libusb,
the locking patch would be similar to the enclosed one.

Of course, more work will be needed. For example, in the specific case of
devices where starting stream will clean the memory data, the V4L driver
will need some additional logic to detect if the memory is filled and not
allowing stream (or requiring CAP_SYS_ADMIN, returning -EPERM otherwise).

Thanks,
Mauro

-

Add a hardware resource locking schema at the Kernel

Sometimes, a hardware resource is used by more than one device driver. This
causes troubles, as sometimes, using the resource by one driver is mutually
exclusive than using the same resource by another driver.

Adds a resource locking schema that will avoid such troubles.

TODO: This is just a quick hack prototyping the a real solution. The
namespace there is not consistent, nor the actual code that locks the
resource is provided.

NOTE: As the problem also happens with some PCI devices, instead of adding
such locking schema at usb_device, it seems better to bind whatever
solution into struct device.


commit 7e4bd0a65c4b2f71157f42ce89ecd7df69480a4b
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Mon Aug 8 15:26:50 2011 -0300

    Add a hardware resource locking schema at the Kernel
    
    Sometimes, a hardware resource is used by more than one device driver. This
    causes troubles, as sometimes, using the resource by one driver is mutually
    exclusive than using the same resource by another driver.
    
    Adds a resource locking schema that will avoid such troubles.
    
    TODO: This is just a quick hack prototyping the a real solution. The
    namespace there is not consistent, nor the actual code that locks the
    resource is provided.
    
    NOTE: As the problem also happens with some PCI devices, instead of adding
    such locking schema at usb_device, it seems better to bind whatever
    solution into struct device.
    
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/include/linux/resourcelock.h b/include/linux/resourcelock.h
new file mode 100644
index 0000000..fc7238c
--- /dev/null
+++ b/include/linux/resourcelock.h
@@ -0,0 +1,27 @@
+#include <linux/device.h>
+
+/**
+ * enum hw_resources - type of resource to lock
+ * LOCK_DEVICE - The complete device should be locked with exclusive access
+ *
+ * TODO: Add other types of resource locking, for example, to lock just a
+ * tuner, or an I2C bus
+ */
+
+enum hw_resources {
+	LOCK_DEVICE,
+};
+
+static int get_resource_lock(struct device dev, enum hw_resources hw_rec) {
+	/*
+	 * TODO: implement the actual code for the function, returning
+	 *  -EBUSY if somebody else already allocated the needed resource
+	 */
+	return 0;
+}
+
+static void put_resource_lock(struct device dev, enum hw_resources hw_rec) {
+	/*
+	 * TODO: implrement a function to release the resource
+	 */
+}
diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 5da4879..d8da757 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -35,6 +35,7 @@
 #include <asm/page.h>
 #include <linux/uaccess.h>
 #include <linux/ktime.h>
+#include <linux/resourcelock.h>
 #include <media/v4l2-ioctl.h>
 
 #include "gspca.h"
@@ -1218,6 +1219,7 @@ static void gspca_release(struct video_device *vfd)
 static int dev_open(struct file *file)
 {
 	struct gspca_dev *gspca_dev;
+	int ret;
 
 	PDEBUG(D_STREAM, "[%s] open", current->comm);
 	gspca_dev = (struct gspca_dev *) video_devdata(file);
@@ -1228,6 +1230,10 @@ static int dev_open(struct file *file)
 	if (!try_module_get(gspca_dev->module))
 		return -ENODEV;
 
+	ret = get_resource_lock(gspca_dev->dev->dev, LOCK_DEVICE);
+	if (ret)
+		return ret;
+
 	file->private_data = gspca_dev;
 #ifdef GSPCA_DEBUG
 	/* activate the v4l2 debug */
@@ -1260,6 +1266,9 @@ static int dev_close(struct file *file)
 		frame_free(gspca_dev);
 	}
 	file->private_data = NULL;
+
+	put_resource_lock(gspca_dev->dev->dev, LOCK_DEVICE);
+
 	module_put(gspca_dev->module);
 	mutex_unlock(&gspca_dev->queue_lock);
 
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 37518df..f94a6d5 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -49,6 +49,7 @@
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
 #include <linux/moduleparam.h>
+#include <linux/resourcelock.h>
 
 #include "usb.h"
 
@@ -693,6 +694,10 @@ static int usbdev_open(struct inode *inode, struct file *file)
 	if (dev->state == USB_STATE_NOTATTACHED)
 		goto out_unlock_device;
 
+	ret = get_resource_lock(dev->dev, LOCK_DEVICE);
+	if (ret)
+		goto out_unlock_device;
+
 	ret = usb_autoresume_device(dev);
 	if (ret)
 		goto out_unlock_device;
@@ -747,6 +752,7 @@ static int usbdev_release(struct inode *inode, struct file *file)
 	destroy_all_async(ps);
 	usb_autosuspend_device(dev);
 	usb_unlock_device(dev);
+	put_resource_lock(dev->dev, LOCK_DEVICE);
 	usb_put_dev(dev);
 	put_pid(ps->disc_pid);
 
