Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933320Ab0BPVEy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2010 16:04:54 -0500
Message-ID: <4B7B089A.4060504@redhat.com>
Date: Tue, 16 Feb 2010 22:05:30 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-media@vger.kernel.org
Subject: Re: pac207: problem with Trust USB webcam
References: <201002150038.03060.elendil@planet.nl>
In-Reply-To: <201002150038.03060.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

You need to use libv4l and have your apps patched
to use libv4l or use the LD_PRELOAD wrapper.

Here is the latest libv4l:
http://people.fedoraproject.org/~jwrdegoede/libv4l-0.6.5-test.tar.gz

And here are install instructions:
http://hansdegoede.livejournal.com/7622.html

Regards,

Hans


On 02/15/2010 12:38 AM, Frans Pop wrote:
> Hello,
>
> I'm having a problem with a (cheap) Trust USB webcam I bought yesterday.
> It works fine under Windows XP.
>
> The device is:
> ID 093a:2460 Pixart Imaging, Inc. Q-TEC WEBCAM 100
>
> For Linux I've found that it is recognized by the gspca_pac207 driver.
> But opening the video device using xawtv or vlc shows nothing.
> Problem seems to be that after I plug it in the led on the device goes
> on, but after a very short time (less than a second) it goes out again.
>
> When I plug it in (after a clean boot), dmesg shows:
> usb 1-2.1: new full speed USB device using ehci_hcd and address 7
> Linux video capture interface: v2.00
> gspca: main v2.8.0 registered
> gspca: probing 093a:2460
> pac207: Pixart Sensor ID 0x27 Chips ID 0x09
> pac207: Pixart PAC207BCA Image Processor and Control Chip detected (vid/pid 0x093A:0x2460)
> gspca: video0 created
> usbcore: registered new interface driver pac207
> pac207: registered
>
> And the following (extra) modules get loaded:
> Module                  Size  Used by
> gspca_pac207            6021  0
> gspca_main             22454  1 gspca_pac207
> videodev               37424  1 gspca_main
> v4l1_compat            12201  1 videodev
> v4l2_compat_ioctl32     9867  1 videodev
>
> I'm running 2.6.33-rc8 (x86_64) on a Debian stable ("Lenny") system.
>
> Kernel config, relevant contents from /sys/kernel/debug/usb/devices and
> output from v4l-info attached. Some other info below.
>
> This is the first time I'm trying a webcam, so it may be that I'm missing
> something obvious. I googled around a fair bit, but nothing I tried helped.
> Any help would be appreciated. I can provide any additional info that's
> needed and test any kernel version.
>
> Cheers,
> FJP
>
> $ ls -l /dev/video0
> crw-rw---- 1 root video 81, 0 2010-02-14 23:16 /dev/video0
> My user account is a member of the video group.
>
> $ xawtv -hwscan
> This is xawtv-3.95.dfsg.1, running on Linux/x86_64 (2.6.33-rc8)
> looking for available devices
> port 100-115
>      type : Xvideo, image scaler
>      name : Intel(R) Textured Video
>
> port 116-116
>      type : Xvideo, image scaler
>      name : Intel(R) Video Overlay
>
> /dev/video0: OK                         [ -device /dev/video0 ]
>      type : v4l2
>      name : CIF Single Chip
>      flags:  capture
