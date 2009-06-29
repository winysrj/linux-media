Return-path: <linux-media-owner@vger.kernel.org>
Received: from server50105.uk2net.com ([83.170.97.106]:45691 "EHLO
	mail.autotrain.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbZF2NdP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2009 09:33:15 -0400
Date: Mon, 29 Jun 2009 14:04:11 +0100 (BST)
From: Tim Williams <tmw@autotrain.org>
To: linux-media@vger.kernel.org
cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] USBVision device defaults
In-Reply-To: <1246275235.3917.12.camel@palomino.walls.org>
Message-ID: <alpine.LRH.2.00.0906291303170.29847@server50105.uk2net.com>
References: <alpine.LRH.2.00.0906261505320.14258@server50105.uk2net.com> <1246275235.3917.12.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 29 Jun 2009, Andy Walls wrote:

> According to the V4L2 specification for the close() call, all devices
> should remember their settings.
>
> There have been recent discussions on devices that do power management
> not saving the RF tuner freq after the final close() (and what to do
> about it), but the last input and standard should be preserved.  (Note,
> I have not looked at the usbvision driver to look for problems.)

It would appear that the usbvision driver isn't following the spec. As I 
mentioned in my earlier message, there is an LED which indicates that the 
box is active. Under windows this comes on and stays on after the first 
use, until reboot. Under linux it always goes off when the programme using 
the device exits.

> What precise WinTV USB device/verision are you using?

>From lsusb :

Bus 002 Device 002: ID 0573:4d22 Zoran Co. Personal Media Division 
(Nogatech) Hauppauge WinTV-USB II (PAL) Model 566

> Try something like:
>
> $ v4l2-ctl --help
> $ v4l2-ctl -d /dev/video0 --log-status
> $ v4l2-ctl -d /dev/video0 --list-inputs
> $ v4l2-ctl -d /dev/video0 --set-input=2
> $ v4l2-ctl -d /dev/video0 --log-status

[root@saucy ~]# v4l2-ctl -d /dev/video0 --log-status
[root@saucy ~]# v4l2-ctl -d /dev/video0 --list-inputs
ioctl: VIDIOC_ENUMINPUT
         Input   : 0
         Name    : Television
         Type    : 0x00000001
         Audioset: 0x00000001
         Tuner   : 0x00000000
         Standard: 0x0000000000FFB1FF ( PAL NTSC SECAM )
         Status  : 0

         Input   : 1
         Name    : Composite Video Input
         Type    : 0x00000002
         Audioset: 0x00000000
         Tuner   : 0x00000000
         Standard: 0x00000000000000FF ( PAL )
         Status  : 0

         Input   : 2
         Name    : S-Video Input
         Type    : 0x00000002
         Audioset: 0x00000000
         Tuner   : 0x00000000
         Standard: 0x00000000000000FF ( PAL )
         Status  : 0
[root@saucy ~]# v4l2-ctl -d /dev/video0 --set-input=2
Video input set to 2 (S-Video Input)
[root@saucy ~]# v4l2-ctl -d /dev/video0 --log-status
[root@saucy ~]#

Each of these commands causes the following messages to be repeated in 
/var/log/messages

Jun 29 13:43:06 saucy kernel: saa7115' 1-0025: saa7113 found 
(1f7113d0e100000) @ 0x4a (usbvision #0)
Jun 29 13:43:08 saucy kernel: tuner' 1-0061: chip found @ 0xc2 (usbvision 
#0)
Jun 29 13:43:08 saucy kernel: tuner-simple 1-0061: creating new instance
Jun 29 13:43:08 saucy kernel: tuner-simple 1-0061: type set to 5 (Philips 
PAL_BG (FI1216 and compatibles))
Jun 29 13:43:12 saucy kernel: tuner-simple 1-0061: destroying instance

I'm currently using kernel 2.6.27.21-desktop-1mnb on Mandriva 2009.0.

Tim W

-- 
Tim Williams BSc MSc MBCS
Euromotor Autotrain LLP
58 Jacoby Place
Priory Road
Edgbaston
Birmingham
B5 7UW
United Kingdom

Web : http://www.autotrain.org
Tel : +44 (0)121 414 2214

EuroMotor-AutoTrain is a company registered in the UK, Registration
number: OC317070.
