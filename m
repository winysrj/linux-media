Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9BHaUSV012477
	for <video4linux-list@redhat.com>; Sat, 11 Oct 2008 13:36:30 -0400
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org
	[140.211.169.13])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9BHaENW001926
	for <video4linux-list@redhat.com>; Sat, 11 Oct 2008 13:36:15 -0400
Date: Sat, 11 Oct 2008 10:36:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: video4linux-list@redhat.com, linux-usb@vger.kernel.org
Message-Id: <20081011103612.efa9beaa.akpm@linux-foundation.org>
In-Reply-To: <bug-11741-10286@http.bugzilla.kernel.org/>
References: <bug-11741-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: bugme-daemon@bugzilla.kernel.org, michael.letzgus@uni-bielefeld.de
Subject: Re: [Bugme-new] [Bug 11741] New: Webcam: Logitech QuickCam
 Communicate won't work with 2.6.27
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


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Sat, 11 Oct 2008 10:13:36 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11741
> 
>            Summary: Webcam: Logitech QuickCam Communicate won't work with
>                     2.6.27
>            Product: Drivers
>            Version: 2.5
>      KernelVersion: 2.6.27
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: high
>           Priority: P1
>          Component: Other
>         AssignedTo: drivers_other@kernel-bugs.osdl.org
>         ReportedBy: michael.letzgus@uni-bielefeld.de
> 
> 
> Latest working kernel version: 2.6.26.2 + additional GSPCA
> Earliest failing kernel version: 2.6.27 (with internal GSPCA)

It's a regression.

> Distribution: Debian lenny
> Hardware Environment: AMD64, Core2Duo
> 
> Problem Description:
> 
> Camera does not work!

Is it due to DVB or to USB?

> Trying "camstream":
>  VDLinux::run() VIDIOCMCAPTURE failed (Invalid argument)
>  run(): VIDIOCSYNC(1) failed (Invalid argument)
> 
> Skype:
>  No error message but colorful noise instead of input signal
> 
> Steps to reproduce:
>  Get a "Logitech QuickCam Communicate" an plug it into a 2.6.27 Kernel.
> 
> 
> Log from a working 2.6.26.2:
> 
> Oct 11 16:16:57 heros kernel: usb 2-2: new full speed USB device using uhci_hcd
> and address 2
> Oct 11 16:16:57 heros kernel: usb 2-2: configuration #1 chosen from 1 choice
> Oct 11 16:16:57 heros kernel: Linux video capture interface: v2.00
> Oct 11 16:16:58 heros kernel: gspca: USB GSPCA camera found.(ZC3XX)
> Oct 11 16:16:58 heros kernel: gspca: [spca5xx_probe:4275] Camera type JPEG
> Oct 11 16:16:58 heros kernel: gspca: [zc3xx_config:669] Find Sensor HV7131R(c)
> Oct 11 16:16:58 heros kernel: gspca: [spca5xx_getcapability:1249] maxw 640 maxh
> 480 minw 160 minh 120
> Oct 11 16:16:58 heros kernel: usbcore: registered new interface driver gspca
> Oct 11 16:16:58 heros kernel: gspca: gspca driver 01.00.20 registered
> Oct 11 16:16:58 heros kernel: usbcore: registered new interface driver
> snd-usb-audio
> Oct 11 16:16:58 heros kernel: gspca: [spca5xx_set_light_freq:1932] Sensor
> currently not support light frequency banding filters.
> Oct 11 16:16:58 heros kernel: gspca: [gspca_set_isoc_ep:945] ISO EndPoint found
> 0x81 AlternateSet 7
> Oct 11 16:20:00 heros kernel: usb 2-2: USB disconnect, address 2
> 
> Log from a nonworking 2.6.27:
> Oct 11 16:26:15 heros kernel: usb 7-1: new full speed USB device using uhci_hcd
> and address 2
> Oct 11 16:26:15 heros kernel: usb 7-1: configuration #1 chosen from 1 choice
> Oct 11 16:26:15 heros kernel: Linux video capture interface: v2.00
> Oct 11 16:26:15 heros kernel: gspca: main v2.2.0 registered
> Oct 11 16:26:15 heros kernel: gspca: probing 0ac8:0302
> Oct 11 16:26:17 heros kernel: zc3xx: probe 2wr ov vga 0x0000
> Oct 11 16:26:17 heros kernel: zc3xx: probe sensor -> 11
> Oct 11 16:26:17 heros kernel: zc3xx: Find Sensor HV7131R(c)
> Oct 11 16:26:17 heros kernel: gspca: probe ok
> Oct 11 16:26:17 heros kernel: gspca: probing 0ac8:0302
> Oct 11 16:26:17 heros kernel: gspca: probing 0ac8:0302
> Oct 11 16:26:17 heros kernel: usbcore: registered new interface driver zc3xx
> Oct 11 16:26:17 heros kernel: zc3xx: registered
> Oct 11 16:26:17 heros kernel: usbcore: registered new interface driver
> snd-usb-audio
> Oct 11 16:27:58 heros kernel: zc3xx: probe 2wr ov vga 0x0000
> Oct 11 16:28:03 heros kernel: zc3xx: probe 2wr ov vga 0x0000
> Oct 11 16:28:19 heros kernel: usb 7-1: USB disconnect, address 2
> Oct 11 16:28:19 heros kernel: gspca: disconnect complete
> 
> 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
