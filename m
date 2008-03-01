Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m21NnC7k018525
	for <video4linux-list@redhat.com>; Sat, 1 Mar 2008 18:49:12 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m21Nmeb9026100
	for <video4linux-list@redhat.com>; Sat, 1 Mar 2008 18:48:41 -0500
Date: Sun, 2 Mar 2008 00:48:21 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Elvis Chen <chene77@hotmail.com>
Message-ID: <20080301234821.GA1691@daniel.bse>
References: <BAY122-W46E61F0928F2E422B22355AA150@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY122-W46E61F0928F2E422B22355AA150@phx.gbl>
Cc: video4linux-list@redhat.com
Subject: Re: newbie programming help:  grabbing image(s) from /dev/video0,
	example code?
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

On Sat, Mar 01, 2008 at 09:33:08PM +0000, Elvis Chen wrote:
> We have 2 Hauppauge WInTV PVR-150 installed on a ubuntu 7.10 x86_64 machine.
> They appear to the linux as /dev/video0 and /dev/video1, respectively.

On this card video0 and video1 are for MPEG captures.
Use video32 and video33 for YUV captures.

The only possible YUV format is 4:2:0 with rearranged bytes.
Read Documentation/video4linux/cx2341x/README.hm12.

> My first attempt was to find a small/simple API to access the linux/video device.

No need to find another API, V4L2 is small enough:

#include <linux/videodev2.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <unistd.h>

static unsigned char image[720*480*3/2];

int main()
{
  struct v4l2_format vf;
  int i=1,fd=open("/dev/video32",O_RDWR);
  ioctl(fd,VIDIOC_S_INPUT,&i);
  memset(&vf,0,sizeof(vf));
  vf.type=V4L2_BUF_TYPE_VIDEO_CAPTURE;
  vf.fmt.pix.width=720;
  vf.fmt.pix.height=480;
  vf.fmt.pix.pixelformat=V4L2_PIX_FMT_HM12;
  vf.fmt.pix.field=V4L2_FIELD_INTERLACED;
  vf.fmt.pix.bytesperline=vf.fmt.pix.width;
  ioctl(fd,VIDIOC_S_FMT,&vf);
  write(1,image,read(fd,image,sizeof(image)));
  return 0;
}

You may want to insert some error checks :-)
And if you want better performance, use memory mapped I/O.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
