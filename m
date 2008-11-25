Return-path: <video4linux-list-bounces@redhat.com>
From: Adam Baker <linux@baker-net.org.uk>
To: kilgota@banach.math.auburn.edu
Date: Tue, 25 Nov 2008 00:02:36 +0000
References: <mailman.208512.1227000563.24145.sqcam-devel@lists.sourceforge.net>
	<492A8E76.3070701@redhat.com>
	<Pine.LNX.4.64.0811241446210.6862@banach.math.auburn.edu>
In-Reply-To: <Pine.LNX.4.64.0811241446210.6862@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_cC0KJwMcxZWoykn"
Message-Id: <200811250002.36951.linux@baker-net.org.uk>
Cc: Hans de Goede <hdegoede@redhat.com>, video4linux-list@redhat.com,
	sqcam-devel@lists.sourceforge.net
Subject: Re: [sqcam-devel] Advice wanted on producing an in kernel sq905
	driver
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

--Boundary-00=_cC0KJwMcxZWoykn
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 24 November 2008, kilgota@banach.math.auburn.edu wrote:
> Well, there is another ideal solution which probably cannot work for ten
> thousand other very good reasons. That would be to eliminate the need for
> the kernel to create a "device" before a webcam is fired up.
>

Unfortunately that would mean changing lots of existing applications.

> So in other words the ability of libusb to load up a kernel module is
> another trick which may alleviate the problem for some people, but does
> not solve the problem. Not yet.

libusb doesn't actually reload the kernel module. The patch I posted a 
reference to just causes the same scan for modules to run as would have run 
when the device was first plugged in.

This approach can even cope with the complex case that no-one has yet 
considered, wanting to use one sq905 based camera to record video while you 
download stills from another.

On an embedded system that didn't want camera drivers it would never use you 
would probably build the kernel without V4L support and nothing anyone does 
is then going to load the module.

To hopefully convince you this can easily provide all the functionality you 
want I've attempted to do some testing and in order to avoid changing 
libgphoto I've written a little standalone app (attached) to do the cleanup. 
I'm taking advantage of the fact I know we want ifno 0 for this cam but 
libgphoto2 has already found the correct value.

I can now happily run the following sequence

Plug in camera, driver loads and /dev/video0 is created

run gphoto2 -L and it tells me there are photos on the camera and /dev/video0 
dissappears (and this is a model that deletes photos when used as a web cam)

run my rescan app which I'd suggest libgphoto2 should do automatically if it 
has called usb_detach_kernel_driver_np
./usbscan /dev/bus/usb/005/008
and /dev/video0 re-appears and I can run up xawtv and see a picture

If I now run up gphoto2 again all my images have gone as I actually used the 
webcam functionality.

I've changed the ioctl's in the patch from using libusb private values to 
values from a kernel provided header file.

--Boundary-00=_cC0KJwMcxZWoykn
Content-Type: text/x-csrc;
  charset="iso 8859-15";
  name="usbscan.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="usbscan.c"

#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <linux/usbdevice_fs.h>

int main(int argc, char *argv[])
{
    int fd;
    struct usbdevfs_ioctl command;

    if (argc != 2) exit(1);
    fd=open(argv[1],O_RDWR);

    if (fd < 0)
    {
        perror(argv[1]);
        exit(1);
    }

    command.ifno = 0;
    command.ioctl_code = USBDEVFS_CONNECT;
    command.data = NULL;

    if (ioctl(fd, USBDEVFS_IOCTL, &command))
       perror("ioctl");
       
    close(fd);

    return 0;
}

--Boundary-00=_cC0KJwMcxZWoykn
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--Boundary-00=_cC0KJwMcxZWoykn--
