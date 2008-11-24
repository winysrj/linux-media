Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAOAfi6A031307
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 05:41:44 -0500
Received: from smtp2.infomaniak.ch (smtp2.infomaniak.ch [84.16.68.90])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAOAfVA0031015
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 05:41:31 -0500
Received: from [10.192.52.111] (pub1.heig-vd.ch [193.134.216.2])
	(authenticated bits=0)
	by smtp2.infomaniak.ch (8.14.2/8.14.2) with ESMTP id mAOAfUL7026978
	for <video4linux-list@redhat.com>; Mon, 24 Nov 2008 11:41:31 +0100
Message-ID: <492A84DA.4080409@glorfindel.ch>
Date: Mon, 24 Nov 2008 11:41:30 +0100
From: Gilles Curchod <mailing@glorfindel.ch>
MIME-Version: 1.0
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: V4L error on Linux 2.6.22
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

Hi,

As part of my diploma project, I'd like to set a demonstration with two
i.MX31 boards: one with a webcam sending a UDP/RTP stream video and the
other getting this stream and displaying it to the framebuffer.

I have a Logitech Webcam (id 046d:08ad). The i.MX31 boards run Linux
2.6.22.6.
I installed the GSPCA (gspcav1-20071224) drivers and I god the following
message while starting the GSPCA module:

     /imx/sandbox/drivers/gspcav1-20071224/gspca_core.c: USB GSPCA camera
found.(ZC3XX)
     /imx/sandbox/drivers/gspcav1-20071224/gspca_core.c:
[spca5xx_probe:4275] Camera type JPEG
     /imx/sandbox/drivers/gspcav1-20071224/Vimicro/zc3xx.h:
[zc3xx_config:669] Find Sensor HV7131R(c)
     usb_endpoint usbdev1.3_ep81: ep_device_release called for 
usbdev1.3_ep81
     usb_endpoint usbdev1.3_ep82: ep_device_release called for 
usbdev1.3_ep82
     /imx/sandbox/drivers/gspcav1-20071224/gspca_core.c:
[spca5xx_getcapability:1249] maxw 640 maxh 480 minw 160 minh 120
     gspca 1-1:1.1: usb_probe_interface
     gspca 1-1:1.1: usb_probe_interface - got id
     gspca 1-1:1.2: usb_probe_interface
     gspca 1-1:1.2: usb_probe_interface - got id
     usbcore: registered new interface driver gspca

Then I use a self-made GStreamer application to get the device's image
and send the stream via UDP/RTP.
The equivalent gst-launch command is:
     gst-launch-0.10 -v v4lsrc !
video/x-raw-yuv,format='(fourcc)'I420,width='(int)'320,height='(int)'240,framerate='(fraction)'25/1 

! ffmpegcolorspace ! ffenc_mpeg4 ! rtpmp4vpay ! udpsink
host=10.192.51.44 port=5000

While I do this on my Ubuntu 8.04, it works fine, but on my embedded
system, I got the following output:
     /imx/sandbox/drivers/gspcav1-20071224/gspca_core.c:
[spca5xx_set_light_freq:1932] Sensor currently not support light fre.
     /imx/sandbox/drivers/gspcav1-20071224/gspca_core.c:
[gspca_set_isoc_ep:945] ISO EndPoint found 0x81 AlternateSet 7
     /imx/sandbox/drivers/gspcav1-20071224/gspca_core.c:
[spca5xx_do_ioctl:2124] Bridge ZC301-2
     /imx/sandbox/drivers/gspcav1-20071224/gspca_core.c:
[spca5xx_do_ioctl:2124] Bridge ZC301-2
     /imx/sandbox/drivers/gspcav1-20071224/gspca_core.c: VIDIOCMCAPTURE:
invalid format (7)

Is this a V4L configuration issue?

Thank for your help.

Gilles

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
