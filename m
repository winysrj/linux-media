Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m231wdoG016165
	for <video4linux-list@redhat.com>; Sun, 2 Mar 2008 20:58:39 -0500
Received: from qb-out-0506.google.com (qb-out-0506.google.com [72.14.204.228])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m231w2Qb020923
	for <video4linux-list@redhat.com>; Sun, 2 Mar 2008 20:58:02 -0500
Received: by qb-out-0506.google.com with SMTP id o12so7405884qba.17
	for <video4linux-list@redhat.com>; Sun, 02 Mar 2008 17:58:02 -0800 (PST)
Message-ID: <9618a85a0803021758m7acf5d98ub5730c4188e5fe6d@mail.gmail.com>
Date: Mon, 3 Mar 2008 09:58:00 +0800
From: "kevin liu" <lwtbenben@gmail.com>
To: chene77@hotmail.com
In-Reply-To: <20080302170011.59F11618C33@hormel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <20080302170011.59F11618C33@hormel.redhat.com>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: video4linux-list Digest, Vol 49, Issue 2
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

There is a video frame grabbing example in V4L APIs.
You may take that for your first try, but you must add some
extra actions such as config the hardware chips ioctls by
yourself according to your hardware driver.

Wish good luck.

2008/3/3  <video4linux-list-request@redhat.com>:
> Send video4linux-list mailing list submissions to
>         video4linux-list@redhat.com
>
>  To subscribe or unsubscribe via the World Wide Web, visit
>         https://www.redhat.com/mailman/listinfo/video4linux-list
>  or, via email, send a message with subject or body 'help' to
>         video4linux-list-request@redhat.com
>
>  You can reach the person managing the list at
>         video4linux-list-owner@redhat.com
>
>  When replying, please edit your Subject line so it is more specific
>  than "Re: Contents of video4linux-list digest..."
>
> Today's Topics:
>
>    1. Problems with microdia webcam (Peter Nabbefeld)
>    2. newbie programming help:  grabbing image(s) from /dev/video0,
>       example code? (Elvis Chen)
>    3. Re: Problems with microdia webcam (JoJo jojo)
>    4. Re: newbie programming help:  grabbing image(s) from
>       /dev/video0, example code? (Carl Karsten)
>    5. question (Michael Williamson)
>    6. When uvcvideo will be merged in the official kernel?
>       (D?niel Fraga)
>    7. Re: newbie programming help:  grabbing image(s) from
>       /dev/video0,      example code? (Daniel Gl?ckner)
>    8. Re: question (Daniel Gl?ckner)
>    9. Re: [patch] vivi: registered as /dev/video%d (Carl Karsten)
>   10. [patch] ioctl-test.c (Carl Karsten)
>   11. Re: [v4l-dvb-maintainer] [PATCH] v4l2: add hardware frequency
>       seek      ioctl interface (Tobias Lorenz)
>
>
> ---------- Forwarded message ----------
> From: Peter Nabbefeld <Peter.Nabbefeld@gmx.de>
> To: video4linux-list@redhat.com
> Date: Sat, 01 Mar 2008 23:00:43 +0100
> Subject: Problems with microdia webcam
>
>  Hello!
>
>  I'm new to video4linux, and I've got a "0c45:624e Microdia" webcam. I've
>  already installed the microdia driver from google newsgroup, /dev/v4l
>  and /dev/video0 exist.
>
>  I've tried to use camorama, vidcat, xsane. Camorama freezes, vidcat with
>  default size says "VIDIOCMCAPTURE: Resource temporarily unavailable".
>  Calling vidcat with "vidcat -d /dev/video0 -s 640x480" seems at least to
>  wait for picture data, but nothing happens. Xsane does detect my camera,
>  but when I try to "scan", it also freezes. Seems, the apps are waiting
>  for data, but no data arrives for some reason.
>
>  Any ideas?
>
>  Kind regards
>
>  Peter Nabbefeld
>
>
>
>  BTW: Are there any Java bindings for V4L? Then I could probably try to
>  write my own hacks to find out what happens ...
>
>
>
>
> ---------- Forwarded message ----------
> From: Elvis Chen <chene77@hotmail.com>
> To: <video4linux-list@redhat.com>
> Date: Sat, 1 Mar 2008 21:33:08 +0000
> Subject: newbie programming help: grabbing image(s) from /dev/video0, example code?
>
>  Greetings,
>
>  I'm a researcher in computer-science.  I'm very new to V4L2 but am reasonably proficient in  C++ programming.  I seek your help in getting something simple done, in the meanwhile I'm trying to learn V4L2 programming API (http://v4l2spec.bytesex.org/)
>
>  We have 2 Hauppauge WInTV PVR-150 installed on a ubuntu 7.10 x86_64 machine.  They appear to the linux as /dev/video0 and /dev/video1, respectively.  What we like to do is to capture still images (or video) via s-video inputs on each card, and perform image-processing algorithms on them (in C++) and display the resultant images on the screen (C++/OpenGL).  Basically what I want to do is very simple:  open a linux/video device, capture an image, store it as a C array/buffer, display it, and refresh the C array/buffer.
>
>  Both cards work with kdetv and mplayer, so hardware-wise they work fine.
>
>  My first attempt was to find a small/simple API to access the linux/video device.  I came across videodog  (http://linux.softpedia.com/get/Multimedia/Video/VideoDog-9261.shtml) but it looks like it isn't been developed anymore (no source either).  Currently I'm trying to learn V4L2 (and trying to utilize the sample capture.c).
>
>
>  Can anyone please give me a pointer on where I should start learning the V4L2 API?  Are there more example codes available?
>
>
>  any help is very much appreciated,
>
>  _________________________________________________________________
>
>
>
>
> ---------- Forwarded message ----------
> From: "JoJo jojo" <onetwojojo@gmail.com>
> To: Peter.Nabbefeld@gmx.de
> Date: Sun, 2 Mar 2008 03:06:26 +0530
> Subject: Re: Problems with microdia webcam
> Hi Peter
>
>  Your webcam is currently not supported by any free kernel driver.
>
>  -JoJo
>
>  On Sun, Mar 2, 2008 at 3:30 AM, Peter Nabbefeld <Peter.Nabbefeld@gmx.de> wrote:
>  >
>  >  Hello!
>  >
>  >  I'm new to video4linux, and I've got a "0c45:624e Microdia" webcam. I've
>  >  already installed the microdia driver from google newsgroup, /dev/v4l
>  >  and /dev/video0 exist.
>  >
>  >  I've tried to use camorama, vidcat, xsane. Camorama freezes, vidcat with
>  >  default size says "VIDIOCMCAPTURE: Resource temporarily unavailable".
>  >  Calling vidcat with "vidcat -d /dev/video0 -s 640x480" seems at least to
>  >  wait for picture data, but nothing happens. Xsane does detect my camera,
>  >  but when I try to "scan", it also freezes. Seems, the apps are waiting
>  >  for data, but no data arrives for some reason.
>  >
>  >  Any ideas?
>  >
>  >  Kind regards
>  >
>  >  Peter Nabbefeld
>  >
>  >
>  >
>  >  BTW: Are there any Java bindings for V4L? Then I could probably try to
>  >  write my own hacks to find out what happens ...
>
>
>
>
> ---------- Forwarded message ----------
> From: Carl Karsten <carl@personnelware.com>
> To:
> Date: Sat, 01 Mar 2008 16:21:51 -0600
> Subject: Re: newbie programming help: grabbing image(s) from /dev/video0, example code?
> Elvis Chen wrote:
>  > Greetings,
>  >
>  > I'm a researcher in computer-science.  I'm very new to V4L2 but am reasonably proficient in  C++ programming.  I seek your help in getting something simple done, in the meanwhile I'm trying to learn V4L2 programming API (http://v4l2spec.bytesex.org/)
>  >
>  > We have 2 Hauppauge WInTV PVR-150 installed on a ubuntu 7.10 x86_64 machine.  They appear to the linux as /dev/video0 and /dev/video1, respectively.  What we like to do is to capture still images (or video) via s-video inputs on each card, and perform image-processing algorithms on them (in C++) and display the resultant images on the screen (C++/OpenGL).  Basically what I want to do is very simple:  open a linux/video device, capture an image, store it as a C array/buffer, display it, and refresh the C array/buffer.
>  >
>  > Both cards work with kdetv and mplayer, so hardware-wise they work fine.
>  >
>  > My first attempt was to find a small/simple API to access the linux/video device.  I came across videodog  (http://linux.softpedia.com/get/Multimedia/Video/VideoDog-9261.shtml) but it looks like it isn't been developed anymore (no source either).  Currently I'm trying to learn V4L2 (and trying to utilize the sample capture.c).
>  >
>  >
>  > Can anyone please give me a pointer on where I should start learning the V4L2 API?  Are there more example codes available?
>
>  http://lwn.net/Articles/203924/
>
>  I think the code you need may be in
>  http://www.video4linux.org/browser/v4l2-apps/test
>
>  btw - I am on a campaign to get better tests, so if you are in the mood, use one
>  or more of those apps to test your driver, and improve the tests (they are
>  currently not very extensive.)
>
>  Carl K
>
>
>
>
> ---------- Forwarded message ----------
> From: Michael Williamson <michael_h_williamson@yahoo.com>
> To: video4linux-list@redhat.com
> Date: Sat, 1 Mar 2008 14:49:42 -0800 (PST)
> Subject: question
> Hi,
>
>  With CX100 frame grabbers, it is possible to poll the
>  even/odd video field bit through the ISA bus.
>  This is useful to have for cameras with electronic
>  shutters to make long exposures. Is it possible to do
>  with v4l2/bt848 PCI devices?
>
>  Thanks,
>  -Mike
>
>
>
>       ____________________________________________________________________________________
>  Never miss a thing.  Make Yahoo your home page.
>  http://www.yahoo.com/r/hs
>
>
>
>
> ---------- Forwarded message ----------
> From: Dâniel Fraga <fragabr@gmail.com>
> To: video4linux-list@redhat.com
> Date: Sat, 1 Mar 2008 20:22:26 -0300
> Subject: When uvcvideo will be merged in the official kernel?
> http://linux-uvc.berlios.de/
>
>         I'd like to know if there's a chance that uvcvideo will be
>  merged in the official kernel... Is there a timeline or something like
>  that? Thanks.
>
>  --
>  Linux 2.6.24: Arr Matey! A Hairy Bilge Rat!
>  http://u-br.net http://www.abusar.org/FELIZ_2008.html
>  John Petrucci - "Lost Without You" (Suspended Animation)
>
>
>
>
>
> ---------- Forwarded message ----------
> From: Daniel Glöckner <daniel-gl@gmx.net>
> To: Elvis Chen <chene77@hotmail.com>
> Date: Sun, 2 Mar 2008 00:48:21 +0100
> Subject: Re: newbie programming help: grabbing image(s) from /dev/video0, example code?
> On Sat, Mar 01, 2008 at 09:33:08PM +0000, Elvis Chen wrote:
>  > We have 2 Hauppauge WInTV PVR-150 installed on a ubuntu 7.10 x86_64 machine.
>  > They appear to the linux as /dev/video0 and /dev/video1, respectively.
>
>  On this card video0 and video1 are for MPEG captures.
>  Use video32 and video33 for YUV captures.
>
>  The only possible YUV format is 4:2:0 with rearranged bytes.
>  Read Documentation/video4linux/cx2341x/README.hm12.
>
>  > My first attempt was to find a small/simple API to access the linux/video device.
>
>  No need to find another API, V4L2 is small enough:
>
>  #include <linux/videodev2.h>
>  #include <sys/ioctl.h>
>  #include <fcntl.h>
>  #include <unistd.h>
>
>  static unsigned char image[720*480*3/2];
>
>  int main()
>  {
>   struct v4l2_format vf;
>   int i=1,fd=open("/dev/video32",O_RDWR);
>   ioctl(fd,VIDIOC_S_INPUT,&i);
>   memset(&vf,0,sizeof(vf));
>   vf.type=V4L2_BUF_TYPE_VIDEO_CAPTURE;
>   vf.fmt.pix.width=720;
>   vf.fmt.pix.height=480;
>   vf.fmt.pix.pixelformat=V4L2_PIX_FMT_HM12;
>   vf.fmt.pix.field=V4L2_FIELD_INTERLACED;
>   vf.fmt.pix.bytesperline=vf.fmt.pix.width;
>   ioctl(fd,VIDIOC_S_FMT,&vf);
>   write(1,image,read(fd,image,sizeof(image)));
>   return 0;
>  }
>
>  You may want to insert some error checks :-)
>  And if you want better performance, use memory mapped I/O.
>
>   Daniel
>
>
>
>
> ---------- Forwarded message ----------
> From: Daniel Glöckner <daniel-gl@gmx.net>
> To: Michael Williamson <michael_h_williamson@yahoo.com>
> Date: Sun, 2 Mar 2008 01:24:22 +0100
> Subject: Re: question
> On Sat, Mar 01, 2008 at 02:49:42PM -0800, Michael Williamson wrote:
>  > With CX100 frame grabbers, it is possible to poll the
>  > even/odd video field bit through the ISA bus.
>  > This is useful to have for cameras with electronic
>  > shutters to make long exposures. Is it possible to do
>  > with v4l2/bt848 PCI devices?
>
>  This information is available in the DSTATUS and INT_STAT register of the
>  bt848 but it is not exposed to userspace by the driver.
>
>  You can capture fields seperately to be informed of field changes.
>
>   Daniel
>
>
>
>
> ---------- Forwarded message ----------
> From: Carl Karsten <carl@personnelware.com>
> To: video4linux-list@redhat.com
> Date: Sun, 02 Mar 2008 00:34:00 -0600
> Subject: Re: [patch] vivi: registered as /dev/video%d
> added un registered messages.
>
>  Carl K
>
>
>  diff -r 127f67dea087 linux/drivers/media/video/vivi.c
>  --- a/linux/drivers/media/video/vivi.c  Tue Feb 26 20:43:56 2008 +0000
>  +++ b/linux/drivers/media/video/vivi.c  Sun Mar 02 00:33:27 2008 -0600
>  @@ -48,6 +48,8 @@
>   #include <linux/freezer.h>
>   #endif
>
>  +#define MODULE_NAME "vivi"
>  +
>   /* Wake up at about 30 fps */
>   #define WAKE_NUMERATOR 30
>   #define WAKE_DENOMINATOR 1001
>  @@ -56,7 +58,7 @@
>   #include "font.h"
>
>   #define VIVI_MAJOR_VERSION 0
>  -#define VIVI_MINOR_VERSION 4
>  +#define VIVI_MINOR_VERSION 5
>   #define VIVI_RELEASE 0
>   #define VIVI_VERSION \
>         KERNEL_VERSION(VIVI_MAJOR_VERSION, VIVI_MINOR_VERSION, VIVI_RELEASE)
>  @@ -1220,10 +1222,14 @@ static int vivi_release(void)
>                 list_del(list);
>                 dev = list_entry(list, struct vivi_dev, vivi_devlist);
>
>  -               if (-1 != dev->vfd->minor)
>  +               if (-1 != dev->vfd->minor) {
>                         video_unregister_device(dev->vfd);
>  -               else
>  +                       printk(KERN_INFO "%s: /dev/video%d unregistered.\n", MODULE_NAME,
>  dev->vfd->minor);
>  +               }
>  +               else {
>                         video_device_release(dev->vfd);
>  +                       printk(KERN_INFO "%s: /dev/video%d released.\n", MODULE_NAME, dev->vfd->minor);
>  +               }
>
>                 kfree(dev);
>         }
>  @@ -1338,6 +1344,7 @@ static int __init vivi_init(void)
>                         video_nr++;
>
>                 dev->vfd = vfd;
>  +               printk(KERN_INFO "%s: V4L2 device registered as /dev/video%d\n", MODULE_NAME,
>  vfd->minor);
>         }
>
>         if (ret < 0) {
>  @@ -1345,7 +1352,8 @@ static int __init vivi_init(void)
>                 printk(KERN_INFO "Error %d while loading vivi driver\n", ret);
>         } else
>                 printk(KERN_INFO "Video Technology Magazine Virtual Video "
>  -                                "Capture Board successfully loaded.\n");
>  +                                "Capture Board ver %u.%u.%u successfully loaded.\n",
>  +        (VIVI_VERSION >> 16) & 0xFF, (VIVI_VERSION >> 8) & 0xFF, VIVI_VERSION &
>  0xFF);
>         return ret;
>   }
>
>
>
>
>
> ---------- Forwarded message ----------
> From: Carl Karsten <carl@personnelware.com>
> To: video4linux-list@redhat.com
> Date: Sun, 02 Mar 2008 00:42:20 -0600
> Subject: [patch] ioctl-test.c
> I copied the command line parameter support from test/pixfmt-test.c, and used
>  the prt_caps() func from lib/v4l2_driver.c.
>
>  I am hoping to merge all of the test code into one big test, and put all the
>  generic code into one lib.
>
>  Carl K
>
>
>  diff -r 127f67dea087 v4l2-apps/lib/v4l2_driver.h
>  --- a/v4l2-apps/lib/v4l2_driver.h       Tue Feb 26 20:43:56 2008 +0000
>  +++ b/v4l2-apps/lib/v4l2_driver.h       Sun Mar 02 00:37:59 2008 -0600
>  @@ -12,6 +12,7 @@
>      Lesser General Public License for more details.
>     */
>
>  +#include <stddef.h>
>   #include <stdint.h>
>   #include <sys/time.h>
>   #include <linux/videodev2.h>
>  diff -r 127f67dea087 v4l2-apps/test/ioctl-test.c
>  --- a/v4l2-apps/test/ioctl-test.c       Tue Feb 26 20:43:56 2008 +0000
>  +++ b/v4l2-apps/test/ioctl-test.c       Sun Mar 02 00:37:59 2008 -0600
>  @@ -29,14 +29,24 @@
>    */
>   //#define INTERNAL 1 /* meant for testing ioctl debug msgs */
>
>  +#include <errno.h>
>  +#include <stdlib.h>
>   #include <stdio.h>
>   #include <unistd.h>
>  +#include <stdarg.h>
>   #include <string.h>
>   #include <sys/types.h>
>   #include <sys/stat.h>
>   #include <sys/ioctl.h>
>  +#include <assert.h>
>  +
>  +#include <getopt.h>             /* getopt_long() */
>  +
>   #include <fcntl.h>
>  -#include "linux/videodev.h"
>  +// #include "linux/videodev.h"
>  +#include <linux/videodev2.h>
>  +
>  +#include <lib/v4l2_driver.h>
>
>   #ifdef INTERNAL
>   typedef __u8 u8;
>  @@ -47,6 +57,25 @@ typedef __u32 u32;
>   #else
>   typedef u_int32_t u32;
>   #endif
>  +
>  +static const char *             my_name;
>  +#define VERSION "1.1"
>  +static const char *             dev_name = "/dev/video0";
>  +
>  +#define CLEAR(var) memset (&(var), 0, sizeof (var))
>  +
>  +typedef enum {
>  +        IO_METHOD_READ = 1,
>  +        IO_METHOD_MMAP,
>  +} io_methods;
>  +
>  +
>  +static int                      fd;
>  +static v4l2_std_id              std_id;
>  +static io_methods               io_method;
>  +static struct v4l2_format       fmt;
>  +//static io_buffer *              buffers;
>  +static unsigned int             n_buffers;
>
>   /* All possible parameters used on v4l ioctls */
>   union v4l_parms {
>  @@ -209,26 +238,253 @@ int ioctls[] = {
>   #define S_IOCTLS sizeof(ioctls)/sizeof(ioctls[0])
>
>   /********************************************************************/
>  +static int
>  +xioctl                          (int                    fd,
>  +                                 int                    request,
>  +                                 void *                 arg)
>  +{
>  +        int r;
>
>  -int main (void)
>  +        do r = ioctl (fd, request, arg);
>  +        while (-1 == r && EINTR == errno);
>  +
>  +        return r;
>  +}
>  +
>  +/********************************************************************/
>  +static void
>  +error_exit                      (const char *           templ,
>  +                                 ...)
>   {
>  -       int fd=0, ret=0;
>  +        va_list ap;
>  +
>  +        fprintf (stderr, "%s: ", my_name);
>  +        va_start (ap, templ);
>  +        vfprintf (stderr, templ, ap);
>  +        va_end (ap);
>  +
>  +        exit (EXIT_FAILURE);
>  +}
>  +
>  +/********************************************************************/
>  +static void
>  +errno_exit                      (const char *           s)
>  +{
>  +        error_exit ("%s error %d, %s\n",
>  +                    s, errno, strerror (errno));
>  +}
>  +
>  +
>  +/********************************************************************/
>  +static void
>  +open_device         (void)
>  +{
>  +    struct stat st;
>  +
>  +    if (-1 == stat (dev_name, &st)) {
>  +        error_exit ("Cannot identify '%s'. %s.\n",
>  +                dev_name, strerror (errno));
>  +    }
>  +
>  +    if (!S_ISCHR (st.st_mode)) {
>  +        error_exit ("%s is not a device file.\n", dev_name);
>  +    }
>  +
>  +    fd = open (dev_name, O_RDWR /* required */ | O_NONBLOCK, 0);
>  +
>  +    if (-1 == fd) {
>  +        error_exit ("Cannot open %s. %s.\n",
>  +                dev_name, strerror (errno));
>  +    }
>  +}
>  +
>  +/********************************************************************/
>  +static void
>  +printstat            (struct v4l2_capability cap)
>  +{
>  +    printf ("driver=%s\n" "card=%s\n" "bus=%s\n" "version=%d.%d.%d\n"
>  +            "capabilities=%s\n",
>  +            cap.driver,cap.card,cap.bus_info,
>  +            (cap.version >> 16) & 0xff,
>  +            (cap.version >>  8) & 0xff,
>  +            cap.version         & 0xff,
>  +            prt_caps(cap.capabilities));
>  +}
>  +
>  +/********************************************************************/
>  +
>  +static void
>  +init_device         (void)
>  +{
>  +    struct v4l2_capability cap;
>  +    struct v4l2_cropcap cropcap;
>  +    struct v4l2_crop crop;
>  +
>  +    if (-1 == xioctl (fd, VIDIOC_QUERYCAP, &cap)) {
>  +        if (EINVAL == errno) {
>  +            error_exit ("%s is not a V4L2 device.\n");
>  +        } else {
>  +            errno_exit ("VIDIOC_QUERYCAP");
>  +        }
>  +    }
>  +
>  +    printstat(cap);
>  +
>  +    switch (io_method) {
>  +    case 0:
>  +        if (cap.capabilities & V4L2_CAP_STREAMING) {
>  +            io_method = IO_METHOD_MMAP;
>  +        } else if (cap.capabilities & V4L2_CAP_READWRITE) {
>  +            io_method = IO_METHOD_READ;
>  +        } else {
>  +            error_exit ("%s does not support reading or "
>  +                    "streaming.\n");
>  +        }
>  +
>  +        break;
>  +
>  +    case IO_METHOD_READ:
>  +        if (0 == (cap.capabilities & V4L2_CAP_READWRITE)) {
>  +            error_exit ("%s does not support read i/o.\n");
>  +        }
>  +
>  +        break;
>  +
>  +    case IO_METHOD_MMAP:
>  +        if (0 == (cap.capabilities & V4L2_CAP_STREAMING)) {
>  +            error_exit ("%s does not support streaming i/o.\n");
>  +        }
>  +
>  +        break;
>  +
>  +    default:
>  +        assert (0);
>  +        break;
>  +    }
>  +
>  +    CLEAR (cropcap);
>  +
>  +    cropcap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>  +
>  +    if (0 == xioctl (fd, VIDIOC_CROPCAP, &cropcap)) {
>  +        crop.type = cropcap.type;
>  +        crop.c = cropcap.defrect; /* reset to default */
>  +
>  +        /* Errors ignored. */
>  +        xioctl (fd, VIDIOC_S_CROP, &crop);
>  +    } else {
>  +        /* Errors ignored. */
>  +    }
>  +
>  +    if (-1 == xioctl (fd, VIDIOC_G_STD, &std_id))
>  +        errno_exit ("VIDIOC_G_STD");
>  +}
>  +
>  +
>  +/********************************************************************/
>  +static void
>  +mainloop            (void)
>  +{
>  +
>  +    int ret=0;
>         unsigned i;
>  -       char *device="/dev/video0";
>         union v4l_parms p;
>
>  -       if ((fd = open(device, O_RDONLY)) < 0) {
>  -               perror("Couldn't open video0");
>  -               return(-1);
>  -       }
>
>         for (i=0;i<S_IOCTLS;i++) {
>                 memset(&p,0,sizeof(p));
>                 ret=ioctl(fd,ioctls[i], (void *) &p);
>                 printf("%i: ioctl=0x%08x, return=%d\n",i, ioctls[i], ret);
>         }
>  +}
>  +
>  +/********************************************************************/
>  +
>  +static void
>  +usage                           (FILE *                 fp,
>  +                                 int                    argc,
>  +                                 char **                argv)
>  +{
>  +        fprintf (fp, "\
>  +V4L2 test " VERSION "\n\
>  +Copyright (C) 2007 Michael H. Schimek\n\
>  +This program is licensed under GPL 2 or later. NO WARRANTIES.\n\n\
>  +Usage: %s [options]\n\n\
>  +Options:\n\
>  +-d | --device name  Video device name [%s]\n\
>  +-h | --help         Print this message\n\
>  +-m | --mmap         Use memory mapped buffers (auto)\n\
>  +-r | --read         Use read() calls (auto)\n\
>  +",
>  +                 my_name, dev_name);
>  +}
>  +
>  +static const char short_options [] = "d:hmr";
>  +
>  +static const struct option
>  +long_options [] = {
>  +        { "device",     required_argument,      NULL,           'd' },
>  +        { "help",       no_argument,            NULL,           'h' },
>  +        { "mmap",       no_argument,            NULL,           'm' },
>  +        { "read",       no_argument,            NULL,           'r' },
>  +        { "usage",      no_argument,            NULL,           'h' },
>  +        { 0, 0, 0, 0 }
>  +};
>  +
>  +
>  +
>  +int
>  +main                            (int                    argc,
>  +                                 char **                argv)
>  +{
>  +        my_name = argv[0];
>  +
>  +        for (;;) {
>  +                int index;
>  +                int c;
>  +
>  +                c = getopt_long (argc, argv,
>  +                                 short_options, long_options,
>  +                                 &index);
>  +
>  +                if (-1 == c)
>  +                        break;
>  +
>  +                switch (c) {
>  +                case 0: /* getopt_long() flag */
>  +                        break;
>  +
>  +                case 'd':
>  +                        dev_name = optarg;
>  +                        break;
>  +
>  +                case 'h':
>  +                        usage (stdout, argc, argv);
>  +                        exit (EXIT_SUCCESS);
>  +
>  +                case 'm':
>  +                        io_method = IO_METHOD_MMAP;
>  +                        break;
>  +
>  +                case 'r':
>  +                        io_method = IO_METHOD_READ;
>  +                        break;
>  +
>  +                default:
>  +                        usage (stderr, argc, argv);
>  +                        exit (EXIT_FAILURE);
>  +                }
>  +        }
>  +
>  +    open_device ();
>  +
>  +    init_device ();
>  +
>  +    mainloop ();
>
>         close (fd);
>
>  +    exit (EXIT_SUCCESS);
>  +
>         return (0);
>   }
>
>
>
>
> ---------- Forwarded message ----------
> From: Tobias Lorenz <tobias.lorenz@gmx.net>
> To: video4linux-list@redhat.com
> Date: Sun, 2 Mar 2008 12:42:57 +0100
> Subject: Re: [v4l-dvb-maintainer] [PATCH] v4l2: add hardware frequency seek ioctl interface
> Hi,
>
>  > Seems fine to me to have an specific ioctl for doing radio frequency seeks.
>
>  That seems to be a good approach. Is there any documentation on how the interface is currently implemented?
>
>  > It is good to have a patch to a real driver, implementing this feature. I don't
>  > like the idea of implementing newer ioctls at the API without having an
>  > in-kernel driver using. Having the driver ioctl implementation helps other
>  > developers that may need to use this interface on other places.
>
>  I would be very happy to add this functionality to my radio-si470x.c driver.
>  Seek support can be parameterized with this device in many ways.
>  This is all described in a document from Silabs (available via Google) called AN284Rev0_1.pdf
>
>  These parameters are not only used when seeking up/down, but also during frequency tuning.
>  They are already implemented as module parameters,
>  as they are country specific and should not be changed during normal operation:
>  - Band selection (upper/lower frequency limits)
>  - Spacing selection
>  - De-emphasis selection
>
>  Additionally these parameters are only used by the seek algorithm:
>  - RSSI Seek Threshold (range: 0..254, 254=highest threshold)
>  - Signal-Noise-Ratio (range: 0..15, 15=higest SNR ratio)
>  - FM-Impulse Noise Detection Counter (range: 0..15, 15=best audio quality)
>
>  Propably it is wise to give the user space applications the possiblity to change these parameters at run time (ioctl).
>  Else I'll implement them as module parameters, too.
>
>  Bye,
>   Toby
>
>
>
> --
>  video4linux-list mailing list
>  Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>  https://www.redhat.com/mailman/listinfo/video4linux-list
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
