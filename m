Return-path: <mchehab@pedra>
Received: from mx1.redhat.com (ext-mx08.extmail.prod.ext.phx2.redhat.com
	[10.5.110.12])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id p0BMpD5s026469
	for <video4linux-list@redhat.com>; Tue, 11 Jan 2011 17:51:13 -0500
Received: from dogbert.fhcrc.org (DOGBERT.FHCRC.ORG [140.107.89.15])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id p0BMp3pK000496
	for <video4linux-list@redhat.com>; Tue, 11 Jan 2011 17:51:04 -0500
Received: from dogbert.fhcrc.org (localhost.localdomain [127.0.0.1])
	by localhost (Postfix) with SMTP id 06BA6257F50
	for <video4linux-list@redhat.com>; Tue, 11 Jan 2011 14:51:03 -0800 (PST)
Received: from zimbra-mta2.fhcrc.org (ZIMBRA-MTA2.FHCRC.ORG [140.107.89.47])
	by dogbert.fhcrc.org (Postfix) with ESMTP id 8E5D8257F47
	for <video4linux-list@redhat.com>; Tue, 11 Jan 2011 14:51:02 -0800 (PST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zimbra-mta2.fhcrc.org (Postfix) with ESMTP id 804212F83D7
	for <video4linux-list@redhat.com>; Tue, 11 Jan 2011 14:51:02 -0800 (PST)
Received: from zimbra-mta2.fhcrc.org ([127.0.0.1])
	by localhost (zimbra-mta2.fhcrc.org [127.0.0.1]) (amavisd-new,
	port 10024)
	with ESMTP id Tsdz1PVGoOA0 for <video4linux-list@redhat.com>;
	Tue, 11 Jan 2011 14:51:02 -0800 (PST)
Received: from zimbra2.fhcrc.org (ZIMBRA2.FHCRC.ORG [140.107.89.82])
	by zimbra-mta2.fhcrc.org (Postfix) with ESMTP id 56EBA2F830B
	for <video4linux-list@redhat.com>; Tue, 11 Jan 2011 14:51:02 -0800 (PST)
Date: Tue, 11 Jan 2011 14:51:02 -0800 (PST)
From: "Pitt, Jason N" <jpitt@fhcrc.org>
To: video4linux-list@redhat.com
Message-ID: <1671500657.49904.1294786261940.JavaMail.root@zimbra2.fhcrc.org>
In-Reply-To: <mailman.5376.1294785690.9819.video4linux-list@redhat.com>
Subject: logitech web cameras fail using VFL2 and usb3.0
MIME-Version: 1.0
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: video4linux-list-bounces@redhat.com
Sender: <mchehab@pedra>
List-ID: <video4linux-list@redhat.com>


I'm having a problem with usb 2.0 logitech cameras on my usb 3.0 card. All of the cameras work fine when plugged into my usb2.0 ports but none work when I run them off the usb3.0 pcie card, they are listed as /dev/video0../dev/videoN but when I try to use them using guvcview or streamer I get the following errors:

medusa@medusa-OptiPlex-780:~$ guvcview -d /dev/video0
guvcview 1.4.1
bt_audio_service_open: connect() failed: Connection refused (111)
bt_audio_service_open: connect() failed: Connection refused (111)
bt_audio_service_open: connect() failed: Connection refused (111)
bt_audio_service_open: connect() failed: Connection refused (111)
Cannot connect to server socket err = No such file or directory
Cannot connect to server socket
jack server is not running or cannot be started
video device: /dev/video0
/dev/video0 - device 1
/dev/video1 - device 2
/dev/video2 - device 3
/dev/video3 - device 4
/dev/video4 - device 5
/dev/video5 - device 6
Init. UVC Camera (046d:09c2) (location: usb-0000:03:00.0-3.1)
{ pixelformat = 'MJPG', description = 'MJPEG' }
{ discrete: width = 160, height = 120 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 176, height = 144 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 320, height = 240 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 352, height = 288 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 640, height = 480 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 960, height = 720 }
    Time interval between frame: 1/15, 1/10, 1/5,
{ pixelformat = 'YUYV', description = 'YUV 4:2:2 (YUYV)' }
{ discrete: width = 160, height = 120 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 176, height = 144 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 320, height = 240 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 352, height = 288 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 640, height = 480 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 960, height = 720 }
    Time interval between frame: 1/10, 1/5,
{ discrete: width = 1280, height = 960 }
    Time interval between frame: 2/15, 1/5,
{ pixelformat = 'RGB3', description = 'RGB3' }
{ discrete: width = 160, height = 120 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 176, height = 144 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 320, height = 240 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 352, height = 288 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 640, height = 480 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 960, height = 720 }
    Time interval between frame: 1/15, 1/10, 1/5,
{ discrete: width = 1280, height = 960 }
    Time interval between frame: 2/15, 1/5,
{ pixelformat = 'BGR3', description = 'BGR3' }
{ discrete: width = 160, height = 120 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 176, height = 144 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 320, height = 240 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 352, height = 288 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 640, height = 480 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 960, height = 720 }
    Time interval between frame: 1/15, 1/10, 1/5,
{ discrete: width = 1280, height = 960 }
    Time interval between frame: 2/15, 1/5,
{ pixelformat = 'YU12', description = 'YU12' }
{ discrete: width = 160, height = 120 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 176, height = 144 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 320, height = 240 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 352, height = 288 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 640, height = 480 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 960, height = 720 }
    Time interval between frame: 1/15, 1/10, 1/5,
{ discrete: width = 1280, height = 960 }
    Time interval between frame: 2/15, 1/5,
{ pixelformat = 'YV12', description = 'YV12' }
{ discrete: width = 160, height = 120 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 176, height = 144 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 320, height = 240 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 352, height = 288 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 640, height = 480 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 960, height = 720 }
    Time interval between frame: 1/15, 1/10, 1/5,
{ discrete: width = 1280, height = 960 }
    Time interval between frame: 2/15, 1/5,
vid:046d
pid:09c2
driver:uvcvideo
Adding control for Pan (relative)
UVCIOC_CTRL_ADD - Error: Operation not permitted
checking format: 1196444237
libv4l2: error setting pixformat: Device or resource busy
VIDIOC_S_FORMAT - Unable to set format: Device or resource busy
Init v4L2 failed !!
Init video returned -2
trying minimum setup ...
video device: /dev/video0
/dev/video0 - device 1
/dev/video1 - device 2
/dev/video2 - device 3
/dev/video3 - device 4
/dev/video4 - device 5
/dev/video5 - device 6
Init. UVC Camera (046d:09c2) (location: usb-0000:03:00.0-3.1)
{ pixelformat = 'MJPG', description = 'MJPEG' }
{ discrete: width = 160, height = 120 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 176, height = 144 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 320, height = 240 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 352, height = 288 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 640, height = 480 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 960, height = 720 }
    Time interval between frame: 1/15, 1/10, 1/5,
{ pixelformat = 'YUYV', description = 'YUV 4:2:2 (YUYV)' }
{ discrete: width = 160, height = 120 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 176, height = 144 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 320, height = 240 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 352, height = 288 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 640, height = 480 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 960, height = 720 }
    Time interval between frame: 1/10, 1/5,
{ discrete: width = 1280, height = 960 }
    Time interval between frame: 2/15, 1/5,
{ pixelformat = 'RGB3', description = 'RGB3' }
{ discrete: width = 160, height = 120 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 176, height = 144 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 320, height = 240 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 352, height = 288 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 640, height = 480 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 960, height = 720 }
    Time interval between frame: 1/15, 1/10, 1/5,
{ discrete: width = 1280, height = 960 }
    Time interval between frame: 2/15, 1/5,
{ pixelformat = 'BGR3', description = 'BGR3' }
{ discrete: width = 160, height = 120 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 176, height = 144 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 320, height = 240 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 352, height = 288 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 640, height = 480 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 960, height = 720 }
    Time interval between frame: 1/15, 1/10, 1/5,
{ discrete: width = 1280, height = 960 }
    Time interval between frame: 2/15, 1/5,
{ pixelformat = 'YU12', description = 'YU12' }
{ discrete: width = 160, height = 120 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 176, height = 144 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 320, height = 240 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 352, height = 288 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 640, height = 480 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 960, height = 720 }
    Time interval between frame: 1/15, 1/10, 1/5,
{ discrete: width = 1280, height = 960 }
    Time interval between frame: 2/15, 1/5,
{ pixelformat = 'YV12', description = 'YV12' }
{ discrete: width = 160, height = 120 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 176, height = 144 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 320, height = 240 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 352, height = 288 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 640, height = 480 }
    Time interval between frame: 1/30, 1/25, 1/20, 1/15, 1/10, 1/5,
{ discrete: width = 960, height = 720 }
    Time interval between frame: 1/15, 1/10, 1/5,
{ discrete: width = 1280, height = 960 }
    Time interval between frame: 2/15, 1/5,
vid:046d
pid:09c2
driver:uvcvideo
Adding control for Pan (relative)
UVCIOC_CTRL_ADD - Error: Operation not permitted
checking format: 1196444237
libv4l2: error setting pixformat: Device or resource busy
VIDIOC_S_FORMAT - Unable to set format: Device or resource busy
Init v4L2 failed !!
ERROR: Minimum Setup Failed.
 Exiting...
VIDIOC_REQBUFS - Failed to delete buffers: Invalid argument (errno 22)
cleaned allocations - 100%
Closing portaudio ...OK
Terminated.[/CODE][CODE]medusa@medusa-OptiPlex-780:~$ streamer -t 17:0:0 -s 640x480 -r .4167 -c /dev/video0 -o ./bigger000000.pgm
files / video: 8 bit StaticGray / audio: none
libv4l2: error setting pixformat: Device or resource busy
ioctl: VIDIOC_S_FMT(type=VIDEO_CAPTURE;fmt.pix.width=640;fmt.pix.height=480;fmt.pix.pixelformat=0x56595559 [YUYV];fmt.pix.field=NONE;fmt.pix.bytesperline=1280;fmt.pix.sizeimage=614400;fmt.pix.colorspace=SRGB;fmt.pix.priv=0): Device or resource busy
libv4l2: error setting pixformat: Device or resource busy
ioctl: VIDIOC_S_FMT(type=VIDEO_CAPTURE;fmt.pix.width=640;fmt.pix.height=480;fmt.pix.pixelformat=0x56595559 [YUYV];fmt.pix.field=NONE;fmt.pix.bytesperline=1280;fmt.pix.sizeimage=614400;fmt.pix.colorspace=SRGB;fmt.pix.priv=0): Device or resource busy
no way to get: 640x480 8 bit StaticGray
movie writer initialisation failed
medusa@medusa-OptiPlex-780:~$



When I run gstreamer-properties I can test the cameras plugged into the usb2.0 ports but the same cameras plugged into usb3.0 gives:



medusa@medusa-OptiPlex-780:/dev$ gstreamer-properties
gstreamer-properties-Message: Skipping unavailable plugin 'artsdsink'
gstreamer-properties-Message: Skipping unavailable plugin 'esdsink'
gstreamer-properties-Message: Skipping unavailable plugin 'sunaudiosink'
gstreamer-properties-Message: Skipping unavailable plugin 'glimagesink'
gstreamer-properties-Message: Skipping unavailable plugin 'sdlvideosink'
gstreamer-properties-Message: Skipping unavailable plugin 'v4lmjpegsrc'
gstreamer-properties-Message: Skipping unavailable plugin 'qcamsrc'
gstreamer-properties-Message: Skipping unavailable plugin 'esdmon'
gstreamer-properties-Message: Skipping unavailable plugin 'sunaudiosrc'
gstreamer-properties-Message: Error running pipeline 'Video for Linux (v4l)': Could not get/set settings from/on resource. [v4l_calls.c(418): gst_v4l_set_chan_norm (): /GstPipeline:pipeline0/GstV4lSrc:v4lsrc1:
Error setting the channel/norm settings: Invalid argument]
libv4l2: error setting pixformat: Device or resource busy
gstreamer-properties-Message: Error running pipeline 'Video for Linux 2 (v4l2)': Device '/dev/video0' cannot capture at 1280x960 [gstv4l2object.c(1951): gst_v4l2_object_set_format (): /GstPipeline:pipeline1/GstV4l2Src:v4l2src1:
Call to S_FMT failed for YUYV @ 1280x960: Device or resource busy]
libv4l2: error setting pixformat: Device or resource busy
gstreamer-properties-Message: Error running pipeline 'Video for Linux 2 (v4l2)': Device '/dev/video0' cannot capture at 1280x960 [gstv4l2object.c(1951): gst_v4l2_object_set_format (): /GstPipeline:pipeline5/GstV4l2Src:v4l2src2:
Call to S_FMT failed for YUYV @ 1280x960: Device or resource busy]
gstreamer-properties-Message: Error running pipeline 'Video for Linux (v4l)': Could not get/set settings from/on resource. [v4l_calls.c(418): gst_v4l_set_chan_norm (): /GstPipeline:pipeline6/GstV4lSrc:v4lsrc2:
Error setting the channel/norm settings: Invalid argument]
libv4l2: error setting pixformat: Device or resource busy
gstreamer-properties-Message: Error running pipeline 'Video for Linux 2 (v4l2)': Device '/dev/video0' cannot capture at 1280x960 [gstv4l2object.c(1951): gst_v4l2_object_set_format (): /GstPipeline:pipeline7/GstV4l2Src:v4l2src3:
Call to S_FMT failed for YUYV @ 1280x960: Device or resource busy]
libv4l2: error setting pixformat: Device or resource busy
gstreamer-properties-Message: Error running pipeline 'Video for Linux 2 (v4l2)': Device '/dev/video0' cannot capture at 1280x960 [gstv4l2object.c(1951): gst_v4l2_object_set_format (): /GstPipeline:pipeline10/GstV4l2Src:v4l2src6:
Call to S_FMT failed for YUYV @ 1280x960: Device or resource busy]
libv4l2: error turning on stream: Invalid argument
gstreamer-properties-Message: Error running pipeline 'Video for Linux 2 (v4l2)': Error starting streaming on device '/dev/video1'. [gstv4l2object.c(1983): gst_v4l2_object_start_streaming (): /GstPipeline:pipeline11/GstV4l2Src:v4l2src7:
system error: Invalid argument]
libv4l2: error turning on stream: Invalid argument
gstreamer-properties-Message: Error running pipeline 'Video for Linux 2 (v4l2)': Error starting streaming on device '/dev/video2'. [gstv4l2object.c(1983): gst_v4l2_object_start_streaming (): /GstPipeline:pipeline12/GstV4l2Src:v4l2src8:
system error: Invalid argument]
libv4l2: error turning on stream: Invalid argument
gstreamer-properties-Message: Error running pipeline 'Video for Linux 2 (v4l2)': Error starting streaming on device '/dev/video3'. [gstv4l2object.c(1983): gst_v4l2_object_start_streaming (): /GstPipeline:pipeline13/GstV4l2Src:v4l2src9:
system error: Invalid argument]


My apologies if this isn't the right list for this.

-jason

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
