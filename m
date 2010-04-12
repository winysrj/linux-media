Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40643 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270Ab0DLWaD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Apr 2010 18:30:03 -0400
Date: Mon, 12 Apr 2010 15:29:32 -0700
From: Sarah Sharp <sarah.a.sharp@intel.com>
To: linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Cc: Libin <libin.yang@amd.com>, andiry.xu@amd.com,
	Jean-Francois Moine <moinejf@free.fr>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: xHCI bandwidth error with USB webcam
Message-ID: <20100412222932.GA18647@xanatos>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I've been trying out the patches to enable isochronous transfers under
xHCI, and they work fine on my USB speaker.  However, I've been having
trouble getting my high speed USB webcam to work.  The NEC Express Card
I have rejects the first alternate setting that the uvcvideo driver
tries to install (altsetting 11), saying that it takes too much
bandwidth.  This happens even when I plug the device directly into the
roothub with no other devices plugged in.

I would like to know if this is correct behavior for the host, as I
can't believe a device would advertise an alternate setting that took up
too much bandwidth by itself.  Device descriptors and a log snippet are
attached.


The other problem is that uvcvideo then gives up on the device when
installing the alt setting fails, rather than trying the next less
resource-intensive alternate setting.  The past, submit_urb() might fail
if there wasn't enough bandwidth for the isochronous transfers, but
under an xHCI host controller, it will fail sooner, when
usb_set_interface() is called.  That needs to be fixed in all the USB
video drivers.

I figured out how to patch the gspca driver, but not uvcvideo.  The
patch looks a bit hackish; can with experience with that driver look it
over?  Can anyone tell me where to look for the usb_set_interface() in
uvcvideo?

Sarah Sharp

8<----------------------

>From 0e6bc81b178364ee9771c64a06ab006588c73ae6 Mon Sep 17 00:00:00 2001
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Date: Mon, 12 Apr 2010 11:23:46 -0700

Subject: [PATCH] gspca: Try a less bandwidth-intensive alt setting.

Under OHCI, UHCI, and EHCI, if an alternate interface setting took too
much of the bus bandwidth, then submit_urb() would fail.  The xHCI host
controller does bandwidth checking when the alternate interface setting is
installed, so usb_set_interface() can fail.  If it does, try the next
alternate interface setting.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
---
 drivers/media/video/gspca/gspca.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 222af47..6de3117 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -643,6 +643,7 @@ static struct usb_host_endpoint *get_ep(struct gspca_dev *gspca_dev)
 	xfer = gspca_dev->cam.bulk ? USB_ENDPOINT_XFER_BULK
 				   : USB_ENDPOINT_XFER_ISOC;
 	i = gspca_dev->alt;			/* previous alt setting */
+find_alt:
 	if (gspca_dev->cam.reverse_alts) {
 		while (++i < gspca_dev->nbalt) {
 			ep = alt_xfer(&intf->altsetting[i], xfer);
@@ -666,10 +667,11 @@ static struct usb_host_endpoint *get_ep(struct gspca_dev *gspca_dev)
 	if (gspca_dev->nbalt > 1) {
 		gspca_input_destroy_urb(gspca_dev);
 		ret = usb_set_interface(gspca_dev->dev, gspca_dev->iface, i);
-		if (ret < 0) {
-			err("set alt %d err %d", i, ret);
-			ep = NULL;
-		}
+		/* xHCI hosts will reject set interface requests
+		 * if they take too much bandwidth, so try again.
+		 */
+		if (ret < 0)
+			goto find_alt;
 		gspca_input_create_urb(gspca_dev);
 	}
 	return ep;
-- 
1.6.3.3


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="logitech-webcam.descriptors"


Bus 009 Device 002: ID 046d:09a5 Logitech, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x046d Logitech, Inc.
  idProduct          0x09a5 
  bcdDevice            0.06
  iManufacturer           0 
  iProduct                0 
  iSerial                 2 0A539160
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength         1183
    bNumInterfaces          4
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
      bFunctionClass         14 Video
      bFunctionSubClass       3 Video Interface Collection
      bFunctionProtocol       0 
      iFunction               0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      1 Video Control
      bInterfaceProtocol      0 
      iInterface              0 
      VideoControl Interface Descriptor:
        bLength                13
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdUVC               1.00
        wTotalLength          133
        dwClockFrequency       48.000000MHz
        bInCollection           1
        baInterfaceNr( 0)       1
      VideoControl Interface Descriptor:
        bLength                18
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0201 Camera Sensor
        bAssocTerminal          0
        iTerminal               0 
        wObjectiveFocalLengthMin      0
        wObjectiveFocalLengthMax      0
        wOcularFocalLength            0
        bControlSize                  3
        bmControls           0x0000000e
          Auto-Exposure Mode
          Auto-Exposure Priority
          Exposure Time (Absolute)
      VideoControl Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      5 (PROCESSING_UNIT)
      Warning: Descriptor too short
        bUnitID                 2
        bSourceID               1
        wMaxMultiplier      16384
        bControlSize            2
        bmControls     0x0000175b
          Brightness
          Contrast
          Saturation
          Sharpness
          White Balance Temperature
          Backlight Compensation
          Gain
          Power Line Frequency
          White Balance Temperature, Auto
        iProcessing             0 
        bmVideoStandards     0x1b
          None
          NTSC - 525/60
          SECAM - 625/50
          NTSC - 625/50
      VideoControl Interface Descriptor:
        bLength                27
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                 4
        guidExtensionCode         {82066163-7050-ab49-b8cc-b3855e8d221e}
        bNumControl            10
        bNrPins                 1
        baSourceID( 0)          2
        bControlSize            2
        bmControls( 0)       0xff
        bmControls( 1)       0x03
        iExtension              0 
      VideoControl Interface Descriptor:
        bLength                27
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                13
        guidExtensionCode         {82066163-7050-ab49-b8cc-b3855e8d221f}
        bNumControl             8
        bNrPins                 1
        baSourceID( 0)          2
        bControlSize            2
        bmControls( 0)       0x7f
        bmControls( 1)       0x01
        iExtension              0 
      VideoControl Interface Descriptor:
        bLength                28
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                10
        guidExtensionCode         {82066163-7050-ab49-b8cc-b3855e8d2252}
        bNumControl            24
        bNrPins                 1
        baSourceID( 0)          4
        bControlSize            3
        bmControls( 0)       0xff
        bmControls( 1)       0xff
        bmControls( 2)       0xff
        iExtension              0 
      VideoControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             5
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               4
        iTerminal               0 
      ** UNRECOGNIZED:  20 41 01 0c 82 06 61 63 70 50 ab 49 b8 cc b3 85 5e 8d 22 50 14 01 04 03 ff ff 0f 00 00 00 00 00
      ** UNRECOGNIZED:  20 41 01 08 82 06 61 63 70 50 ab 49 b8 cc b3 85 5e 8d 22 51 03 01 04 03 19 00 00 00 00 00 01 00
      ** UNRECOGNIZED:  20 41 01 0b 82 06 61 63 70 50 ab 49 b8 cc b3 85 5e 8d 22 55 01 01 04 03 01 00 00 00 00 00 00 00
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x87  EP 7 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0010  1x 16 bytes
        bInterval               8
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
        bLength                            16
        bDescriptorType                    36
        bDescriptorSubtype                  1 (INPUT_HEADER)
        bNumFormats                         3
        wTotalLength                      624
        bEndPointAddress                  129
        bmInfo                              0
        bTerminalLink                       5
        bStillCaptureMethod                 2
        bTriggerSupport                     1
        bTriggerUsage                       0
        bControlSize                        1
        bmaControls( 0)                    11
        bmaControls( 1)                    11
        bmaControls( 2)                    11
      VideoStreaming Interface Descriptor:
        bLength                            11
        bDescriptorType                    36
        bDescriptorSubtype                  6 (FORMAT_MJPEG)
        bFormatIndex                        1
        bNumFrameDescriptors                5
        bFlags                              1
          Fixed-size samples: Yes
        bDefaultFrameIndex                  3
        bAspectRatioX                       0
        bAspectRatioY                       0
        bmInterlaceFlags                 0x00
          Interlaced stream or variable: No
          Fields per frame: 1 fields
          Field 1 first: No
          Field pattern: Field 1 only
          bCopyProtect                      0
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         1
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            160
        wHeight                           120
        dwMinBitRate                  1536000
        dwMaxBitRate                  9216000
        dwMaxVideoFrameBufferSize       38400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         2
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            176
        wHeight                           144
        dwMinBitRate                  2027520
        dwMaxBitRate                 12165120
        dwMaxVideoFrameBufferSize       50688
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         3
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            320
        wHeight                           240
        dwMinBitRate                  6144000
        dwMaxBitRate                 36864000
        dwMaxVideoFrameBufferSize      153600
        dwDefaultFrameInterval         666666
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         4
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            352
        wHeight                           288
        dwMinBitRate                  8110080
        dwMaxBitRate                 48660480
        dwMaxVideoFrameBufferSize      202752
        dwDefaultFrameInterval         666666
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  7 (FRAME_MJPEG)
        bFrameIndex                         5
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            640
        wHeight                           480
        dwMinBitRate                 24576000
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize      614400
        dwDefaultFrameInterval         666666
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            31
        bDescriptorType                    36
        bDescriptorSubtype                  3 (STILL_IMAGE_FRAME)
        bEndpointAddress                    0
        bNumImageSizePatterns               5
        wWidth( 0)                        160
        wHeight( 0)                       120
        wWidth( 1)                        176
        wHeight( 1)                       144
        wWidth( 2)                        320
        wHeight( 2)                       240
        wWidth( 3)                        352
        wHeight( 3)                       288
        wWidth( 4)                        640
        wHeight( 4)                       480
        bNumCompressionPatterns             5
        bCompression( 0)                    5
        bCompression( 1)                   10
        bCompression( 2)                   15
        bCompression( 3)                   20
        bCompression( 4)                   25
      VideoStreaming Interface Descriptor:
        bLength                             6
        bDescriptorType                    36
        bDescriptorSubtype                 13 (COLORFORMAT)
        bColorPrimaries                     1 (BT.709,sRGB)
        bTransferCharacteristics            1 (BT.709)
        bMatrixCoefficients                 4 (SMPTE 170M (BT.601))
      VideoStreaming Interface Descriptor:
        bLength                            27
        bDescriptorType                    36
        bDescriptorSubtype                  4 (FORMAT_UNCOMPRESSED)
        bFormatIndex                        2
        bNumFrameDescriptors                5
        guidFormat                            {59555932-0000-1000-8000-00aa00389b71}
        bBitsPerPixel                      16
        bDefaultFrameIndex                  3
        bAspectRatioX                       0
        bAspectRatioY                       0
        bmInterlaceFlags                 0x00
          Interlaced stream or variable: No
          Fields per frame: 1 fields
          Field 1 first: No
          Field pattern: Field 1 only
          bCopyProtect                      0
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         1
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            160
        wHeight                           120
        dwMinBitRate                  1536000
        dwMaxBitRate                  9216000
        dwMaxVideoFrameBufferSize       38400
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         2
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            176
        wHeight                           144
        dwMinBitRate                  2027520
        dwMaxBitRate                 12165120
        dwMaxVideoFrameBufferSize       50688
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         3
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            320
        wHeight                           240
        dwMinBitRate                  6144000
        dwMaxBitRate                 36864000
        dwMaxVideoFrameBufferSize      153600
        dwDefaultFrameInterval         666666
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         4
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            352
        wHeight                           288
        dwMinBitRate                  8110080
        dwMaxBitRate                 48660480
        dwMaxVideoFrameBufferSize      202752
        dwDefaultFrameInterval         666666
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            50
        bDescriptorType                    36
        bDescriptorSubtype                  5 (FRAME_UNCOMPRESSED)
        bFrameIndex                         5
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            640
        wHeight                           480
        dwMinBitRate                 24576000
        dwMaxBitRate                147456000
        dwMaxVideoFrameBufferSize      614400
        dwDefaultFrameInterval         666666
        bFrameIntervalType                  6
        dwFrameInterval( 0)            333333
        dwFrameInterval( 1)            400000
        dwFrameInterval( 2)            500000
        dwFrameInterval( 3)            666666
        dwFrameInterval( 4)           1000000
        dwFrameInterval( 5)           2000000
      VideoStreaming Interface Descriptor:
        bLength                            27
        bDescriptorType                    36
        bDescriptorSubtype                  3 (STILL_IMAGE_FRAME)
        bEndpointAddress                    0
        bNumImageSizePatterns               5
        wWidth( 0)                        160
        wHeight( 0)                       120
        wWidth( 1)                        176
        wHeight( 1)                       144
        wWidth( 2)                        320
        wHeight( 2)                       240
        wWidth( 3)                        352
        wHeight( 3)                       288
        wWidth( 4)                        640
        wHeight( 4)                       480
        bNumCompressionPatterns             5
        bCompression( 0)                    5
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
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x00c0  1x 192 bytes
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
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0180  1x 384 bytes
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
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
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
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0280  1x 640 bytes
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
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0320  1x 800 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       6
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x03b0  1x 944 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       7
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0a80  2x 640 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       8
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0b20  2x 800 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       9
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0be0  2x 992 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting      10
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x1380  3x 896 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting      11
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x13fc  3x 1020 bytes
        bInterval               1
    Interface Association:
      bLength                 8
      bDescriptorType        11
      bFirstInterface         2
      bInterfaceCount         2
      bFunctionClass          1 Audio
      bFunctionSubClass       2 Streaming
      bFunctionProtocol       0 
      iFunction               0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      1 Control Device
      bInterfaceProtocol      0 
      iInterface              0 
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdADC               1.00
        wTotalLength           38
        bInCollection           1
        baInterfaceNr( 0)       3
      AudioControl Interface Descriptor:
        bLength                12
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0201 Microphone
        bAssocTerminal          0
        bNrChannels             1
        wChannelConfig     0x0000
        iChannelNames           0 
        iTerminal               0 
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             3
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          1
        bSourceID               5
        iTerminal               0 
      AudioControl Interface Descriptor:
        bLength                 8
        bDescriptorType        36
        bDescriptorSubtype      6 (FEATURE_UNIT)
        bUnitID                 5
        bSourceID               1
        bControlSize            1
        bmaControls( 0)      0x03
          Mute
          Volume
        iFeature                0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0 
      iInterface              0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       1
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           3
        bDelay                  1 frames
        wFormatTag              1 PCM
      AudioStreaming Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             1
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            1 Discrete
        tSamFreq[ 0]        16000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0024  1x 36 bytes
        bInterval               4
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x01
            Sampling Frequency
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
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

--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="isoc-bw-error.log"

Apr  9 16:20:55 xanatos kernel: [ 1425.109695] usb 9-3.2: ep 0x81 - rounding interval to 1 microframes
Apr  9 16:20:55 xanatos kernel: [ 1425.109699] xhci_hcd 0000:05:00.0: add ep 0x81, slot id 3, new drop flags = 0x0, new add flags = 0x8, new slot info = 0x18300002
Apr  9 16:20:55 xanatos kernel: [ 1425.109703] xhci_hcd 0000:05:00.0: xhci_check_bandwidth called for udev ffff880070557000
Apr  9 16:20:55 xanatos kernel: [ 1425.109705] xhci_hcd 0000:05:00.0: New Input Control Context:
Apr  9 16:20:55 xanatos kernel: [ 1425.109709] xhci_hcd 0000:05:00.0: @ffff88006cb9b000 (virt) @6cb9b000 (dma) 0x000000 - drop flags
Apr  9 16:20:55 xanatos kernel: [ 1425.109712] xhci_hcd 0000:05:00.0: @ffff88006cb9b004 (virt) @6cb9b004 (dma) 0x000009 - add flags
Apr  9 16:20:55 xanatos kernel: [ 1425.109716] xhci_hcd 0000:05:00.0: @ffff88006cb9b008 (virt) @6cb9b008 (dma) 0x000000 - rsvd2[0]
Apr  9 16:20:55 xanatos kernel: [ 1425.109719] xhci_hcd 0000:05:00.0: @ffff88006cb9b00c (virt) @6cb9b00c (dma) 0x000000 - rsvd2[1]
Apr  9 16:20:55 xanatos kernel: [ 1425.109723] xhci_hcd 0000:05:00.0: @ffff88006cb9b010 (virt) @6cb9b010 (dma) 0x000000 - rsvd2[2]
Apr  9 16:20:55 xanatos kernel: [ 1425.109726] xhci_hcd 0000:05:00.0: @ffff88006cb9b014 (virt) @6cb9b014 (dma) 0x000000 - rsvd2[3]
Apr  9 16:20:55 xanatos kernel: [ 1425.109730] xhci_hcd 0000:05:00.0: @ffff88006cb9b018 (virt) @6cb9b018 (dma) 0x000000 - rsvd2[4]
Apr  9 16:20:55 xanatos kernel: [ 1425.109733] xhci_hcd 0000:05:00.0: @ffff88006cb9b01c (virt) @6cb9b01c (dma) 0x000000 - rsvd2[5]
Apr  9 16:20:55 xanatos kernel: [ 1425.109736] xhci_hcd 0000:05:00.0: Slot Context:
Apr  9 16:20:55 xanatos kernel: [ 1425.109739] xhci_hcd 0000:05:00.0: @ffff88006cb9b020 (virt) @6cb9b020 (dma) 0x18300002 - dev_info
Apr  9 16:20:55 xanatos kernel: [ 1425.109742] xhci_hcd 0000:05:00.0: @ffff88006cb9b024 (virt) @6cb9b024 (dma) 0x030000 - dev_info2
Apr  9 16:20:55 xanatos kernel: [ 1425.109746] xhci_hcd 0000:05:00.0: @ffff88006cb9b028 (virt) @6cb9b028 (dma) 0x000000 - tt_info
Apr  9 16:20:55 xanatos kernel: [ 1425.109749] xhci_hcd 0000:05:00.0: @ffff88006cb9b02c (virt) @6cb9b02c (dma) 0x000000 - dev_state
Apr  9 16:20:55 xanatos kernel: [ 1425.109753] xhci_hcd 0000:05:00.0: @ffff88006cb9b030 (virt) @6cb9b030 (dma) 0x000000 - rsvd[0]
Apr  9 16:20:55 xanatos kernel: [ 1425.109756] xhci_hcd 0000:05:00.0: @ffff88006cb9b034 (virt) @6cb9b034 (dma) 0x000000 - rsvd[1]
Apr  9 16:20:55 xanatos kernel: [ 1425.109759] xhci_hcd 0000:05:00.0: @ffff88006cb9b038 (virt) @6cb9b038 (dma) 0x000000 - rsvd[2]
Apr  9 16:20:55 xanatos kernel: [ 1425.109763] xhci_hcd 0000:05:00.0: @ffff88006cb9b03c (virt) @6cb9b03c (dma) 0x000000 - rsvd[3]
Apr  9 16:20:55 xanatos kernel: [ 1425.109766] xhci_hcd 0000:05:00.0: Endpoint 00 Context:
Apr  9 16:20:55 xanatos kernel: [ 1425.109768] xhci_hcd 0000:05:00.0: @ffff88006cb9b040 (virt) @6cb9b040 (dma) 0x000000 - ep_info
Apr  9 16:20:55 xanatos kernel: [ 1425.109772] xhci_hcd 0000:05:00.0: @ffff88006cb9b044 (virt) @6cb9b044 (dma) 0x400026 - ep_info2
Apr  9 16:20:55 xanatos kernel: [ 1425.109775] xhci_hcd 0000:05:00.0: @ffff88006cb9b048 (virt) @6cb9b048 (dma) 0x578e6001 - deq
Apr  9 16:20:55 xanatos kernel: [ 1425.109778] xhci_hcd 0000:05:00.0: @ffff88006cb9b050 (virt) @6cb9b050 (dma) 0x000000 - tx_info
Apr  9 16:20:55 xanatos kernel: [ 1425.109782] xhci_hcd 0000:05:00.0: @ffff88006cb9b054 (virt) @6cb9b054 (dma) 0x000000 - rsvd[0]
Apr  9 16:20:55 xanatos kernel: [ 1425.109785] xhci_hcd 0000:05:00.0: @ffff88006cb9b058 (virt) @6cb9b058 (dma) 0x000000 - rsvd[1]
Apr  9 16:20:55 xanatos kernel: [ 1425.109789] xhci_hcd 0000:05:00.0: @ffff88006cb9b05c (virt) @6cb9b05c (dma) 0x000000 - rsvd[2]
Apr  9 16:20:55 xanatos kernel: [ 1425.109792] xhci_hcd 0000:05:00.0: Endpoint 01 Context:
Apr  9 16:20:55 xanatos kernel: [ 1425.109795] xhci_hcd 0000:05:00.0: @ffff88006cb9b060 (virt) @6cb9b060 (dma) 0x000000 - ep_info
Apr  9 16:20:55 xanatos kernel: [ 1425.109798] xhci_hcd 0000:05:00.0: @ffff88006cb9b064 (virt) @6cb9b064 (dma) 0x000000 - ep_info2
Apr  9 16:20:55 xanatos kernel: [ 1425.109801] xhci_hcd 0000:05:00.0: @ffff88006cb9b068 (virt) @6cb9b068 (dma) 0x000000 - deq
Apr  9 16:20:55 xanatos kernel: [ 1425.109805] xhci_hcd 0000:05:00.0: @ffff88006cb9b070 (virt) @6cb9b070 (dma) 0x000000 - tx_info
Apr  9 16:20:55 xanatos kernel: [ 1425.109808] xhci_hcd 0000:05:00.0: @ffff88006cb9b074 (virt) @6cb9b074 (dma) 0x000000 - rsvd[0]
Apr  9 16:20:55 xanatos kernel: [ 1425.109812] xhci_hcd 0000:05:00.0: @ffff88006cb9b078 (virt) @6cb9b078 (dma) 0x000000 - rsvd[1]
Apr  9 16:20:55 xanatos kernel: [ 1425.109815] xhci_hcd 0000:05:00.0: @ffff88006cb9b07c (virt) @6cb9b07c (dma) 0x000000 - rsvd[2]
Apr  9 16:20:55 xanatos kernel: [ 1425.109818] xhci_hcd 0000:05:00.0: Endpoint 02 Context:
Apr  9 16:20:55 xanatos kernel: [ 1425.109821] xhci_hcd 0000:05:00.0: @ffff88006cb9b080 (virt) @6cb9b080 (dma) 0x000000 - ep_info
Apr  9 16:20:55 xanatos kernel: [ 1425.109824] xhci_hcd 0000:05:00.0: @ffff88006cb9b084 (virt) @6cb9b084 (dma) 0x3fc022a - ep_info2
Apr  9 16:20:55 xanatos kernel: [ 1425.109828] xhci_hcd 0000:05:00.0: @ffff88006cb9b088 (virt) @6cb9b088 (dma) 0x657a8001 - deq
Apr  9 16:20:55 xanatos kernel: [ 1425.109831] xhci_hcd 0000:05:00.0: @ffff88006cb9b090 (virt) @6cb9b090 (dma) 0x000000 - tx_info
Apr  9 16:20:55 xanatos kernel: [ 1425.109834] xhci_hcd 0000:05:00.0: @ffff88006cb9b094 (virt) @6cb9b094 (dma) 0x000000 - rsvd[0]
Apr  9 16:20:55 xanatos kernel: [ 1425.109838] xhci_hcd 0000:05:00.0: @ffff88006cb9b098 (virt) @6cb9b098 (dma) 0x000000 - rsvd[1]
Apr  9 16:20:55 xanatos kernel: [ 1425.109841] xhci_hcd 0000:05:00.0: @ffff88006cb9b09c (virt) @6cb9b09c (dma) 0x000000 - rsvd[2]
Apr  9 16:20:55 xanatos kernel: [ 1425.109845] xhci_hcd 0000:05:00.0: Command ring enq = 0x671d6210 (DMA)
Apr  9 16:20:55 xanatos kernel: [ 1425.109848] xhci_hcd 0000:05:00.0: // Ding dong!
Apr  9 16:20:55 xanatos kernel: [ 1425.109854] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90019534800, 32'h0, 4'hf);
Apr  9 16:20:55 xanatos kernel: [ 1425.110026] xhci_hcd 0000:05:00.0: op reg status = 00000008
Apr  9 16:20:55 xanatos kernel: [ 1425.110029] xhci_hcd 0000:05:00.0: ir set irq_pending = 00000003
Apr  9 16:20:55 xanatos kernel: [ 1425.110031] xhci_hcd 0000:05:00.0: Event ring dequeue ptr:
Apr  9 16:20:55 xanatos kernel: [ 1425.110034] xhci_hcd 0000:05:00.0: @671d64d0 671d6200 00000000 08000000 03008400
Apr  9 16:20:55 xanatos kernel: [ 1425.110041] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90019534024, 32'h8, 4'hf);
Apr  9 16:20:55 xanatos kernel: [ 1425.110048] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90019534620, 32'h3, 4'hf);
Apr  9 16:20:55 xanatos kernel: [ 1425.110055] xhci_hcd 0000:05:00.0: In xhci_handle_event
Apr  9 16:20:55 xanatos kernel: [ 1425.110057] xhci_hcd 0000:05:00.0: xhci_handle_event - OS owns TRB
Apr  9 16:20:55 xanatos kernel: [ 1425.110060] xhci_hcd 0000:05:00.0: xhci_handle_event - calling handle_cmd_completion
Apr  9 16:20:55 xanatos kernel: [ 1425.110063] xhci_hcd 0000:05:00.0: Completed config ep cmd
Apr  9 16:20:55 xanatos kernel: [ 1425.110067] xhci_hcd 0000:05:00.0: Command ring deq = 0x671d6210 (DMA)
Apr  9 16:20:55 xanatos kernel: [ 1425.110070] xhci_hcd 0000:05:00.0: xhci_handle_event - returned from handle_cmd_completion
Apr  9 16:20:55 xanatos kernel: [ 1425.110073] xhci_hcd 0000:05:00.0: Event ring deq = 0x671d64e0 (DMA)
Apr  9 16:20:55 xanatos kernel: [ 1425.110082] xhci_hcd 0000:05:00.0: // Write event ring dequeue pointer, preserving EHB bit
Apr  9 16:20:55 xanatos kernel: [ 1425.110085] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90019534638, 64'h671d64e0, 4'hf);
Apr  9 16:20:55 xanatos kernel: [ 1425.110088] xhci_hcd 0000:05:00.0: In xhci_handle_event
Apr  9 16:20:55 xanatos kernel: [ 1425.110098] xhci_hcd 0000:05:00.0: `MEM_WRITE_DWORD(3'b000, 64'hffffc90019534638, 64'h671d64e8, 4'hf);
Apr  9 16:20:55 xanatos kernel: [ 1425.110109] usb 9-3.2: Not enough bandwidth for new device state.
Apr  9 16:20:55 xanatos kernel: [ 1425.110112] xhci_hcd 0000:05:00.0: xhci_reset_bandwidth called for udev ffff880070557000
Apr  9 16:20:55 xanatos kernel: [ 1425.110116] xhci_hcd 0000:05:00.0: Freeing ring at ffff88006b866780
Apr  9 16:20:55 xanatos kernel: [ 1425.110119] xhci_hcd 0000:05:00.0: Freeing DMA segment at ffff8800657a8000 (virtual) 0x657a8000 (DMA)
Apr  9 16:20:55 xanatos kernel: [ 1425.110122] xhci_hcd 0000:05:00.0: Freeing priv segment structure at ffff880076c0c040
Apr  9 16:20:55 xanatos kernel: [ 1425.110131] usb 9-3.2: Not enough bandwidth for altsetting 11

--OXfL5xGRrasGEqWY--
