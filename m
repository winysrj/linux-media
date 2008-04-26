Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.183])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1JpqCJ-0003Vv-MS
	for linux-dvb@linuxtv.org; Sat, 26 Apr 2008 21:36:36 +0200
Received: by py-out-1112.google.com with SMTP id a29so4973079pyi.0
	for <linux-dvb@linuxtv.org>; Sat, 26 Apr 2008 12:36:26 -0700 (PDT)
Message-ID: <d9def9db0804261236l527b7deew67d1c9df4ea66460@mail.gmail.com>
Date: Sat, 26 Apr 2008 21:36:25 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Steffen Schulz" <pepe_ml@gmx.net>
In-Reply-To: <20080426141433.GA14917@cbg.dyndns.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <20080426141433.GA14917@cbg.dyndns.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] crash with terratec cinergy hybrid XS [0ccd:0042]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On 4/26/08, Steffen Schulz <pepe_ml@gmx.net> wrote:
> Hi,
>
>
> The mailman on mcentral.de seems to be dead, so I'll ask here.
>

it's temporary offline due a server move, archives are available though.

>
> I installed userspace-drivers and em28xx-userspace2 with a  2.6.24.4
> kernel with mactel-linux patches(some macbook specific drivers).
>
> I needed to activate some dvb-support to get the drivers compile
> cleanly, e.g. v4l1-compat, IIRC.
>
> When I plug in the device, em28xx.ko is loaded and the usb subsystem
> kind of crashes. Internal and external keyboards(both attached via USB)
> do not work anymore, but mouse+touchpad works. When media-daemon is
> enabled, I get this with dmesg(USB freezes without media-daemon, too):
>
> | usb 6-2: new high speed USB device using ehci_hcd and address 3
> | usb 6-2: configuration #1 chosen from 1 choice
> | em28xx v4l2 driver version 0.0.1 loaded
> | em28xx new video device (0ccd:0042): interface 0, class 255
> | em28xx: device is attached to a USB 2.0 bus
> | em28xx #0: Alternate settings: 8
> | em28xx #0: Alternate setting 0, max size= 0
> | em28xx #0: Alternate setting 1, max size= 0
> | em28xx #0: Alternate setting 2, max size= 1448
> | em28xx #0: Alternate setting 3, max size= 2048
> | em28xx #0: Alternate setting 4, max size= 2304
> | em28xx #0: Alternate setting 5, max size= 2580
> | em28xx #0: Alternate setting 6, max size= 2892
> | em28xx #0: Alternate setting 7, max size= 3072
> | input: em2880/em2870 remote control as /devices/virtual/input/input15
> | em28xx-input.c: remote control handler attached
> | moduleid: 0
> | media-stub: adding support for Texas Instruments - tvp5150
> | media-stub: userspace driver version 1
> | media-stub: Copyright: Mauro Chehab
> | em28xx: registered module_id 1
> | media-stub: adding support for Texas Instruments - tvp5150
> | media-stub: userspace driver version 1
> | media-stub: Copyright: Mauro Chehab
> | em28xx #0: V4L2 VBI device registered as /dev/vbi0
> | media-daemon[2457]: segfault at 0000000c eip b7fc418e esp bfb82080 error 6
> | removing support for Texas Instruments - tvp5150
>

you might try

hg clone http://mcentral.de/hg/~mrec/em28xx-new

this is a full inkernel driver.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
