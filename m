Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:34845 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbZGBAiE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jul 2009 20:38:04 -0400
Subject: Re: [linux-dvb] USBVision device defaults
From: Andy Walls <awalls@radix.net>
To: Tim Williams <tmw@autotrain.org>
Cc: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
In-Reply-To: <alpine.LRH.2.00.0906291303170.29847@server50105.uk2net.com>
References: <alpine.LRH.2.00.0906261505320.14258@server50105.uk2net.com>
	 <1246275235.3917.12.camel@palomino.walls.org>
	 <alpine.LRH.2.00.0906291303170.29847@server50105.uk2net.com>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 20:39:43 -0400
Message-Id: <1246495183.4227.77.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-06-29 at 14:04 +0100, Tim Williams wrote:
> On Mon, 29 Jun 2009, Andy Walls wrote:
> 
> > According to the V4L2 specification for the close() call, all devices
> > should remember their settings.
> >
> > There have been recent discussions on devices that do power management
> > not saving the RF tuner freq after the final close() (and what to do
> > about it), but the last input and standard should be preserved.  (Note,
> > I have not looked at the usbvision driver to look for problems.)
> 
> It would appear that the usbvision driver isn't following the spec. As I 
> mentioned in my earlier message, there is an LED which indicates that the 
> box is active. Under windows this comes on and stays on after the first 
> use, until reboot. Under linux it always goes off when the programme using 
> the device exits.

I just looked at the usbvision driver - ugh.  It uses the big kernel
lock - not good.  Only a single open at a time - inconvenient.  Powers
off in <= 3 seconds (hardcoded) after close if the "PowerOnAtOpen"
module parameter is set to 1 (the default) - not useful.  I think the 3
seconds isn't guaranteed; it might be anywhere from 0 to 3 seconds.

It's unclear to me if the PowerOnAtOpen module parameter works properly
when set to 0.  It might actually prevent the automatic shutoff in 3
seconds if set to zero.

Also, by inspection I think the driver has a bug you may be able to
exploit.  If you already have the driver open with an application,
trying to open it with another application will fail, but not before
reseting the poweroff timer back to three seconds.  So if you have an
app that attempts to open() and close() the usbvision device node every
1 second, I think you can keep it from powering down and losing it's
settings.

Here's a useless little program to do just that.  Compile it and invoke
it as 'program-name /dev/video0'


#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
        int fd;

        if (argc < 2)
                exit(1);

        for (;;) {
                fd = open (argv[1], O_RDONLY);
                if (fd >= 0)
                        close(fd);
                sleep(1);
        }
        exit(0);
}


Using it, you hopefully can use v4l2-ctl to set the input and have it
preserved.

The usbvision driver really needs some work to allow preserving settings
and/or multiple opens.

Regards,
Andy



> > What precise WinTV USB device/verision are you using?
> 
> >From lsusb :
> 
> Bus 002 Device 002: ID 0573:4d22 Zoran Co. Personal Media Division 
> (Nogatech) Hauppauge WinTV-USB II (PAL) Model 566
> 
> > Try something like:
> >
> > $ v4l2-ctl --help
> > $ v4l2-ctl -d /dev/video0 --log-status
> > $ v4l2-ctl -d /dev/video0 --list-inputs
> > $ v4l2-ctl -d /dev/video0 --set-input=2
> > $ v4l2-ctl -d /dev/video0 --log-status
> 
> [root@saucy ~]# v4l2-ctl -d /dev/video0 --log-status
> [root@saucy ~]# v4l2-ctl -d /dev/video0 --list-inputs
> ioctl: VIDIOC_ENUMINPUT
>          Input   : 0
>          Name    : Television
>          Type    : 0x00000001
>          Audioset: 0x00000001
>          Tuner   : 0x00000000
>          Standard: 0x0000000000FFB1FF ( PAL NTSC SECAM )
>          Status  : 0
> 
>          Input   : 1
>          Name    : Composite Video Input
>          Type    : 0x00000002
>          Audioset: 0x00000000
>          Tuner   : 0x00000000
>          Standard: 0x00000000000000FF ( PAL )
>          Status  : 0
> 
>          Input   : 2
>          Name    : S-Video Input
>          Type    : 0x00000002
>          Audioset: 0x00000000
>          Tuner   : 0x00000000
>          Standard: 0x00000000000000FF ( PAL )
>          Status  : 0
> [root@saucy ~]# v4l2-ctl -d /dev/video0 --set-input=2
> Video input set to 2 (S-Video Input)
> [root@saucy ~]# v4l2-ctl -d /dev/video0 --log-status
> [root@saucy ~]#
> 
> Each of these commands causes the following messages to be repeated in 
> /var/log/messages
> 
> Jun 29 13:43:06 saucy kernel: saa7115' 1-0025: saa7113 found 
> (1f7113d0e100000) @ 0x4a (usbvision #0)
> Jun 29 13:43:08 saucy kernel: tuner' 1-0061: chip found @ 0xc2 (usbvision 
> #0)
> Jun 29 13:43:08 saucy kernel: tuner-simple 1-0061: creating new instance
> Jun 29 13:43:08 saucy kernel: tuner-simple 1-0061: type set to 5 (Philips 
> PAL_BG (FI1216 and compatibles))
> Jun 29 13:43:12 saucy kernel: tuner-simple 1-0061: destroying instance
> 
> I'm currently using kernel 2.6.27.21-desktop-1mnb on Mandriva 2009.0.
> 
> Tim W
> 

