Return-path: <linux-media-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38947 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753985AbaCMWIj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 18:08:39 -0400
Received: from compute3.internal (compute3.nyi.mail.srv.osa [10.202.2.43])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 5F87120AD0
	for <linux-media@vger.kernel.org>; Thu, 13 Mar 2014 18:08:38 -0400 (EDT)
Message-ID: <53222C64.90901@williammanley.net>
Date: Thu, 13 Mar 2014 22:08:36 +0000
From: William Manley <will@williammanley.net>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] uvcvideo: Work around buggy Logitech C920 firmware
References: <1394647711-25291-1-git-send-email-will@williammanley.net> <1854099.LO0jorujWf@avalon> <1394707700.15658.93976573.78252B46@webmail.messagingengine.com> <1832254.8GCCJyof1H@avalon>
In-Reply-To: <1832254.8GCCJyof1H@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13/03/14 17:03, Laurent Pinchart wrote:
> On Thursday 13 March 2014 10:48:20 Will Manley wrote:
>> On Thu, 13 Mar 2014, at 10:23, Laurent Pinchart wrote:
>>> On Wednesday 12 March 2014 18:08:31 William Manley wrote:
>>>> The uvcvideo webcam driver exposes the v4l2 control "Exposure
>>>> (Absolute)" which allows the user to control the exposure time of the
>>>> webcam, essentially controlling the brightness of the received image. 
>>>> By default the webcam automatically adjusts the exposure time
>>>> automatically but the if you set the control "Exposure, Auto"="Manual
>>>> Mode" the user can fix the exposure time.
>>>>
>>>> Unfortunately it seems that the Logitech C920 has a firmware bug where
>>>> it will forget that it's in manual mode temporarily during
>>>> initialisation. This means that the camera doesn't respect the exposure
>>>> time that the user requested if they request it before starting to
>>>> stream video. They end up with a video stream which is either too bright
>>>> or too dark and must reset the controls after video starts streaming.
>>>
>>> I would like to get a better understanding of the problem first. As I
>>> don't have a C920, could you please perform two tests for me ?
>>>
>>> I would first like to know what the camera reports as its exposure time
>>> after starting the stream. If you get the exposure time at that point (by
>>> sending a GET_CUR request, bypassing the driver cache), do you get the
>>> value you had previously set (which, from your explanation, would be
>>> incorrect, as the exposure time has changed based on your findings), or a
>>> different value ? Does the camera change the exposure priority control
>>> autonomously as well, or just the exposure time ?
>>
>> It's a bit of a strange behaviour. I'd already tried littering the code with
>> (uncached) GET_CUR requests. It seems that the value changes sometime during
>> the call to usb_set_interface in uvc_init_video.
> 
> I'll assume this means that the camera reports the updated exposure time in 
> response to the GET_CUR request.

That's right

> Does the value of other controls (such as the 
> exposure priority control for instance) change as well ?

No, I've not seen any of the other controls change.

>> Strangely enough though calling uvc_ctrl_restore_values immediately after
>> uvc_init_video has no effect. It must be put after the usb_submit_urb loop
>> to fix the problem.
>>
>>> Then, I would like to know whether the camera sends a control update
>>> event when you start the stream, or if it just changes the exposure time
>>> without notifying the driver.
>>
>> Wireshark tells me that it is sending a control update event, but it seems
>> like uvcvideo ignores it. I had to add the flag UVC_CTRL_FLAG_AUTO_UPDATE to
>> the uvc_control_info entry for "Exposure (Auto)" for the new value to be
>> properly reported to userspace.
> 
> Could you send me the USB trace ?

I've uploaded 3 traces: one with no patch (kernel 3.12) one with my
"PATCH v2" applied and one with no patch but caching of gets disabled.
You can get them here:

    http://williammanley.net/C920-no-patch.pcapng
    http://williammanley.net/C920-with-patch.pcapng
    http://williammanley.net/C920-no-caching.pcapng

The process to generate them was:

    sudo dumpcap -i usbmon1 -w /tmp/C920-no-patch2.pcapng &

    # Plug USB cable in here

    v4l2-ctl -d
/dev/v4l/by-id/usb-046d_HD_Pro_Webcam_C920_C833389F-video-index1

-cexposure_auto=1,exposure_auto_priority=0,exposure_absolute=152,white_balance_temperature_auto=0

    ./streamon

The relevant output seems to be (here from C920-no-patch.pcapng):

> 10446 23.095874000 21:14:16.313257000         host -> 32.0         USB 64 SET INTERFACE Request
> 10447 23.109379000 21:14:16.326762000         32.3 -> host         USBVIDEO 70 URB_INTERRUPT in
> 10448 23.109389000 21:14:16.326772000         host -> 32.3         USB 64 URB_INTERRUPT in
> 10449 23.189448000 21:14:16.406831000         32.3 -> host         USBVIDEO 73 URB_INTERRUPT in
> 10450 23.189486000 21:14:16.406869000         host -> 32.3         USB 64 URB_INTERRUPT in
> 10451 23.243314000 21:14:16.460697000         32.0 -> host         USB 64 SET INTERFACE Response

Taking a closer look at packet 10449:

> Frame 10449: 73 bytes on wire (584 bits), 73 bytes captured (584 bits) on interface 0
>     Interface id: 0
>     Encapsulation type: USB packets with Linux header and padding (115)
>     Arrival Time: Mar 13, 2014 21:14:16.406831000 GMT
>     [Time shift for this packet: 0.000000000 seconds]
>     Epoch Time: 1394745256.406831000 seconds
>     [Time delta from previous captured frame: 0.080059000 seconds]
>     [Time delta from previous displayed frame: 0.080059000 seconds]
>     [Time since reference or first frame: 23.189448000 seconds]
>     Frame Number: 10449
>     Frame Length: 73 bytes (584 bits)
>     Capture Length: 73 bytes (584 bits)
>     [Frame is marked: False]
>     [Frame is ignored: False]
>     [Protocols in frame: usb:usbvideo]
> USB URB
>     URB id: 0xffff88081bf95240
>     URB type: URB_COMPLETE ('C')
>     URB transfer type: URB_INTERRUPT (0x01)
>     Endpoint: 0x83, Direction: IN
>         1... .... = Direction: IN (1)
>         .000 0011 = Endpoint value: 3
>     Device: 32
>     URB bus id: 1
>     Device setup request: not relevant ('-')
>     Data: present (0)
>     URB sec: 1394745256
>     URB usec: 406831
>     URB status: Success (0)
>     URB length [bytes]: 9
>     Data length [bytes]: 9
>     [Request in: 10448]
>     [Time from request: 0.080059000 seconds]
>     [bInterfaceClass: Video (0x0e)]
> .... 0001 = Status Type: VideoControl Interface (0x01)
> Originator: 1
> Event: Control Change (0x00)
> Control Selector: Exposure Time (Absolute) (0x04)
> Change Type: Value (0x00)
> Current value: 333 (0x0000014d)

This is the notification of the change of the value.  As you can see it
happens between "SET INTERFACE Request" and "SET INTERFACE Response".

The sources for "streamon" look like:

     #include <linux/videodev2.h>
     #include <stdio.h>
     #include <stdlib.h>
     #include <fcntl.h>
     #include <errno.h>
     #include <string.h>
     #include <unistd.h>
     #include <sys/ioctl.h>

     #define DEVICE
"/dev/v4l/by-id/usb-046d_HD_Pro_Webcam_C920_C833389F-video-index1"

     int main()
     {
             int fd, type;

             fd = open(DEVICE, O_RDWR | O_CLOEXEC);
             if (fd < 0) {
                     perror("Failed to open " DEVICE "\n");
                     return 1;
             }

             struct v4l2_requestbuffers reqbuf = {
                     .type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
                     .memory = V4L2_MEMORY_MMAP,
                     .count = 1,
             };

             if (-1 == ioctl (fd, VIDIOC_REQBUFS, &reqbuf)) {
                     perror("VIDIOC_REQBUFS");
                     return 1;
             }

             type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
             if (ioctl (fd, VIDIOC_STREAMON, &type) != 0) {
                     perror("VIDIOC_STREAMON");
                     return 1;
             }

             printf("VIDIOC_STREAMON\n");

             usleep(100000);

             return 0;
     }

Thanks

Will
