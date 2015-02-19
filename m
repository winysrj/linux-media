Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:52948 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbbBSCr7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 21:47:59 -0500
Received: by mail-vc0-f169.google.com with SMTP id kv19so277761vcb.0
        for <linux-media@vger.kernel.org>; Wed, 18 Feb 2015 18:47:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2359205.hdVH21fv1b@avalon>
References: <CAOraNAbMn227Doegfx-o=-edLCwaL3so-6019jHf+ydChuoiCQ@mail.gmail.com>
	<54E2144C.7030206@gmail.com>
	<54E21614.5010800@xs4all.nl>
	<2359205.hdVH21fv1b@avalon>
Date: Wed, 18 Feb 2015 21:47:58 -0500
Message-ID: <CAOraNAafQbA7vk8y3k8KkM9WYuc44TgiVC+zC9wDhPLyn6DJrA@mail.gmail.com>
Subject: Re: Can the patch adding support for the Tasco USB microscope be
 queued up?
From: Steven Zakulec <spzakulec@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Michael Hall <mhall119@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here are the results of running lsusb -v -d '1871:0516' on my system
that has the patch applied:
Thanks for your help here!


Bus 001 Device 104: ID 1871:0516 Aveo Technology Corp.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x1871 Aveo Technology Corp.
  idProduct          0x0516
  bcdDevice            3.07
  iManufacturer           1 AVEO Technology Corp.
  iProduct                2 USB2.0 Camera
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          411
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         0
      bInterfaceCount         2
      bFunctionClass        255 Vendor Specific Class
      bFunctionSubClass       3
      bFunctionProtocol       0
      iFunction               2 USB2.0 Camera
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      1
      bInterfaceProtocol      0
      iInterface              2 USB2.0 Camera
      ** UNRECOGNIZED:  0d 24 01 00 01 4d 00 80 c3 c9 01 01 01
      ** UNRECOGNIZED:  12 24 02 01 01 02 00 00 00 00 00 00 00 00 03 00 00 00
      ** UNRECOGNIZED:  09 24 03 02 01 01 00 04 00
      ** UNRECOGNIZED:  0b 24 05 03 01 00 00 02 1b 04 00
      ** UNRECOGNIZED:  1a 24 06 04 52 f2 b8 aa d1 8e 72 49 8c ed 96
b1 7f 04 40 8b 01 01 03 01 03 00
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               7
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0
      iInterface              0
      VideoStreaming Interface Descriptor:
        bLength                            14
        bDescriptorType                    36
        bDescriptorSubtype                  1 (INPUT_HEADER)
        bNumFormats                         1
        wTotalLength                      207
        bEndPointAddress                  131
        bmInfo                              0
        bTerminalLink                       2
        bStillCaptureMethod                 2
        bTriggerSupport                     1
        bTriggerUsage                       0
        bControlSize                        1
        bmaControls( 0)                    27
      VideoStreaming Interface Descriptor:
        bLength                            27
        bDescriptorType                    36
        bDescriptorSubtype                  4 (FORMAT_UNCOMPRESSED)
        bFormatIndex                        1
        bNumFrameDescriptors                5
        guidFormat
{59555932-0000-1000-8000-00aa00389b71}
        bBitsPerPixel                      16
        bDefaultFrameIndex                  1
        bAspectRatioX                       0
        bAspectRatioY                       0
        bmInterlaceFlags                 0x00
          Interlaced stream or variable: No
          Fields per frame: 2 fields
          Field 1 first: No
          Field pattern: Field 1 only
          bCopyProtect                      0
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         1
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            640
        wHeight                           480
        dwMinBitRate                147456000
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize      614400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  1
        dwFrameInterval( 0)            333333
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         3
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            320
        wHeight                           240
        dwMinBitRate                 36864000
        dwMaxBitRate                 36864000
        dwMaxVideoFrameBufferSize      153600
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  1
        dwFrameInterval( 0)            333333
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         5
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            352
        wHeight                           288
        dwMinBitRate                 48660480
        dwMaxBitRate                 48660480
        dwMaxVideoFrameBufferSize      202752
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  1
        dwFrameInterval( 0)            333333
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         9
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1280
        wHeight                           960
        dwMinBitRate                157286400
        dwMaxBitRate                157286400
        dwMaxVideoFrameBufferSize     2457600
        dwDefaultFrameInterval        1250000
        bFrameIntervalType                  1
        dwFrameInterval( 0)           1250000
      VideoStreaming Interface Descriptor:
        bLength                            30
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                        10
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                           1280
        wHeight                          1024
        dwMinBitRate                157286400
        dwMaxBitRate                157286400
        dwMaxVideoFrameBufferSize     2621440
        dwDefaultFrameInterval        1250000
        bFrameIntervalType                  1
        dwFrameInterval( 0)           1250000
      VideoStreaming Interface Descriptor:
        bLength                            10
        bDescriptorType                    36
        bDescriptorSubtype                  3 (STILL_IMAGE_FRAME)
        bEndpointAddress                    0
        bNumImageSizePatterns               1
        wWidth( 0)                        640
        wHeight( 0)                       480
        bNumCompressionPatterns             1
      VideoStreaming Interface Descriptor:
        bLength                             6
        bDescriptorType                    36
        bDescriptorSubtype                 13 (COLORFORMAT)
        bColorPrimaries                     1 (BT.709,sRGB)
        bTransferCharacteristics            1 (BT.709)
        bMatrixCoefficients                 4 (SMPTE 170M (BT.601))
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x020c  1x 524 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       2
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x030c  1x 780 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       3
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x03fc  1x 1020 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       4
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0bfc  2x 1020 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       5
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x13fc  3x 1020 bytes
        bInterval               1
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

On Mon, Feb 16, 2015 at 1:35 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Hans,
>
> On Monday 16 February 2015 17:08:52 Hans Verkuil wrote:
>> On 02/16/2015 05:01 PM, Michael Hall wrote:
>> > My apologies, the other emails were sent to linux-uvc-devel, not
>> > linux-media.
>> >
>> > Do you want an attached patch file, or simply a diff in the body of the
>> > email? I'm also not clear on what you mean by "correct Signed-off-by
>> > line", I have very little experience with git, I've mostly used bzr.
>>
>> This is a good link with the relevant information:
>>
>> http://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches
>>
>> Anyway, I checked where the original patch came from, and Laurent Pinchart
>> wrote it. Since he's kernel maintainer he knows all about well-formatted
>> patches and it's best if he just posts and merges his own patch :-)
>>
>> Laurent, it's all yours!
>
> I've sent the patch to linux-media and will include it in my next uvcvideo
> pull request.
>
> Steven, could you please send me the output of
>
> lsusb -v -d '1871:0516'
>
> (if possible running as root) on your system ?
>
>> > On 02/16/2015 10:40 AM, Hans Verkuil wrote:
>> >> On 02/16/2015 04:31 PM, Michael Hall wrote:
>> >>> This is now the 3rd or 4th email to this list requesting that this patch
>> >>> be merged in. If there is something wrong with the patch that needs
>> >>> fixing, please let me know and I will work on the fix. Otherwise I've
>> >>> lost interest in pushing to get it into upstream.
>> >>
>> >> I can't remember ever seeing a patch for that posted to the linux-media
>> >> mailinglist.
>> >>
>> >> The best way is just to post the patch to this mailinglist, check that it
>> >> appears in patchwork
>> >> (https://patchwork.linuxtv.org/project/linux-media/list/), make sure you
>> >> keep the author and correct Signed-off-by line and it's *guaranteed*
>> >> that someone will look at it, and merge it or reply to it if there are
>> >> problems.
>> >>
>> >> Mails like 'please pick up a patch from some other git repo' are very
>> >> likely to be forgotten due to volume of other postings. Patchwork won't
>> >> pick them up and that's what we all rely on.
>> >>
>> >> So if either of you can just post this as a properly formatted patch,
>> >> then it will be taken care of.
>> >>
>> >> Regards,
>> >>
>> >>    Hans
>> >>
>> >>> Michael Hall
>> >>> mhall119@gmail.com
>> >>>
>> >>> On 02/16/2015 10:08 AM, Steven Zakulec wrote:
>> >>>> Hi, as an owner of a Tasco/Aveo USB microscope detected but not
>> >>>> working under Linux, I'd really like to see the patch adding this
>> >>>> variant added to the kernel.  I've copied the patch's author on the
>> >>>> email. The people on the linux-uvc-devel list directed me over here.
>> >>>>
>> >>>> The patch here:
>> >>>> http://sourceforge.net/p/linux-uvc/mailman/message/32434617/ , itself
>> >>>> an update of an earlier patch:
>> >>>> http://sourceforge.net/p/linux-uvc/mailman/message/29835445/ works.
>> >>>> The patch does make the USB microscope work where it didn't work at all
>> >>>> before.
>> >>>>
>> >>>> Thank you!
>
> --
> Regards,
>
> Laurent Pinchart
>
