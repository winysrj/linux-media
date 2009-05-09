Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:61097 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbZEIO13 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 May 2009 10:27:29 -0400
Received: by fxm2 with SMTP id 2so1877881fxm.37
        for <linux-media@vger.kernel.org>; Sat, 09 May 2009 07:27:28 -0700 (PDT)
From: Andrew Savchenko <bircoph@gmail.com>
To: linux-media@vger.kernel.org
Subject: UVC USB web camera randomly fails to initialize after attachment
Date: Sat, 9 May 2009 18:27:24 +0400
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1895338.PyKRkXyqSK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200905091827.25006.bircoph@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart1895338.PyKRkXyqSK
Content-Type: multipart/mixed;
  boundary="Boundary-01=_MLZBKrl9JnnEhR1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_MLZBKrl9JnnEhR1
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

I use vanilla kernel-2.6.29.2 and own DEF-299A webcam. Outputs of=20
udevadm info and lsusb are attached.

The problem is in this device initialization by the driver=20
(uvcvideo). In ~80% of cases it fails with the following error:

May 09 12:45:41 [kernel] usb 1-6: new high speed USB device using ehci_hcd =
and address 58
May 09 12:45:41 [kernel] usb 1-6: configuration #1 chosen from 1 choice
May 09 12:45:41 [kernel] uvcvideo: Found UVC 1.00 device DEF-299A Camera (1=
871:0603)
May 09 12:45:42 [kernel] uvcvideo: UVC non compliance - GET_DEF(PROBE) not =
supported. Enabling workaround.
May 09 12:45:43 [kernel] uvcvideo: Failed to query (129) UVC probe control =
: -110 (exp. 26).
May 09 12:45:43 [kernel] uvcvideo: Failed to initialize the device (-5).
May 09 12:45:58 [kernel] usb 1-6: USB disconnect, address 58

So I need to reattach this device again and again. After successfull
attachment it looks like:

May 09 12:46:15 [kernel] usb 1-5: new high speed USB device using ehci_hcd =
and address 61
May 09 12:46:15 [kernel] usb 1-5: configuration #1 chosen from 1 choice
May 09 12:46:15 [kernel] uvcvideo: Found UVC 1.00 device DEF-299A Camera (1=
871:0603)
May 09 12:46:16 [kernel] uvcvideo: UVC non compliance - GET_DEF(PROBE) not =
supported. Enabling workaround.
May 09 12:46:16 [kernel] input: DEF-299A Camera as /devices/pci0000:00/0000=
:00:02.2/usb1/1-5/1-5:1.0/input/input19

After quick look at drivers/media/video/uvc/uvc_video.c I tried to
increase UVC_CTRL_STREAMING_TIMEOUT up to 10000, but this doesn't
help. Tuning UVC_CTRL_CONTROL_TIMEOUT up to 10000 doesn't solve the
issue also.

Maybe cam itself is bad (it is rather cheap), but after successfull
initialization it works flawlessly for several days, thus I doubt
this is hardware only problem. Maybe some other timeout should be
increased?

I found no reliable correlations between events of success and
failure, they also seems to not depend on USB port or host
controller (I have both EHCI and OHCI).

=2D-=20
Best regards,
Andrew

--Boundary-01=_MLZBKrl9JnnEhR1
Content-Type: text/plain;
  charset="iso 8859-15";
  name="uvc.udevadm.info"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="uvc.udevadm.info"


Udevadm info starts with the device specified by the devpath and then
walks up the chain of parent devices. It prints for every device
found, all possible attributes in the udev rules key format.
A rule to match, can be composed by the attributes of the device
and the attributes from one single parent device.

  looking at device '/devices/pci0000:00/0000:00:02.2/usb1/1-5':
    KERNEL=="1-5"
    SUBSYSTEM=="usb"
    DRIVER=="usb"
    ATTR{configuration}==""
    ATTR{bNumInterfaces}==" 2"
    ATTR{bConfigurationValue}=="1"
    ATTR{bmAttributes}=="80"
    ATTR{bMaxPower}=="500mA"
    ATTR{urbnum}=="17483"
    ATTR{idVendor}=="1871"
    ATTR{idProduct}=="0603"
    ATTR{bcdDevice}=="0218"
    ATTR{bDeviceClass}=="ef"
    ATTR{bDeviceSubClass}=="02"
    ATTR{bDeviceProtocol}=="01"
    ATTR{bNumConfigurations}=="1"
    ATTR{bMaxPacketSize0}=="64"
    ATTR{speed}=="480"
    ATTR{busnum}=="1"
    ATTR{devnum}=="67"
    ATTR{version}==" 2.00"
    ATTR{maxchild}=="0"
    ATTR{quirks}=="0x0"
    ATTR{authorized}=="1"
    ATTR{manufacturer}=="USB2.0 Camera"
    ATTR{product}=="DEF-299A Camera"

  looking at parent device '/devices/pci0000:00/0000:00:02.2/usb1':
    KERNELS=="usb1"
    SUBSYSTEMS=="usb"
    DRIVERS=="usb"
    ATTRS{configuration}==""
    ATTRS{bNumInterfaces}==" 1"
    ATTRS{bConfigurationValue}=="1"
    ATTRS{bmAttributes}=="e0"
    ATTRS{bMaxPower}=="  0mA"
    ATTRS{urbnum}=="1702"
    ATTRS{idVendor}=="1d6b"
    ATTRS{idProduct}=="0002"
    ATTRS{bcdDevice}=="0206"
    ATTRS{bDeviceClass}=="09"
    ATTRS{bDeviceSubClass}=="00"
    ATTRS{bDeviceProtocol}=="00"
    ATTRS{bNumConfigurations}=="1"
    ATTRS{bMaxPacketSize0}=="64"
    ATTRS{speed}=="480"
    ATTRS{busnum}=="1"
    ATTRS{devnum}=="1"
    ATTRS{version}==" 2.00"
    ATTRS{maxchild}=="6"
    ATTRS{quirks}=="0x0"
    ATTRS{authorized}=="1"
    ATTRS{manufacturer}=="Linux 2.6.29.2-yoruichi ehci_hcd"
    ATTRS{product}=="EHCI Host Controller"
    ATTRS{serial}=="0000:00:02.2"
    ATTRS{authorized_default}=="1"

  looking at parent device '/devices/pci0000:00/0000:00:02.2':
    KERNELS=="0000:00:02.2"
    SUBSYSTEMS=="pci"
    DRIVERS=="ehci_hcd"
    ATTRS{vendor}=="0x10de"
    ATTRS{device}=="0x0068"
    ATTRS{subsystem_vendor}=="0x1043"
    ATTRS{subsystem_device}=="0x0c11"
    ATTRS{class}=="0x0c0320"
    ATTRS{irq}=="21"
    ATTRS{local_cpus}=="1"
    ATTRS{local_cpulist}=="0"
    ATTRS{modalias}=="pci:v000010DEd00000068sv00001043sd00000C11bc0Csc03i20"
    ATTRS{enable}=="1"
    ATTRS{broken_parity_status}=="0"
    ATTRS{msi_bus}==""

  looking at parent device '/devices/pci0000:00':
    KERNELS=="pci0000:00"
    SUBSYSTEMS==""
    DRIVERS==""


--Boundary-01=_MLZBKrl9JnnEhR1
Content-Type: text/plain;
  charset="iso 8859-15";
  name="uvc.lsusb"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="uvc.lsusb"


Bus 001 Device 067: ID 1871:0603 Aveo Technology Corp.=20
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          239 Miscellaneous Device
  bDeviceSubClass         2 ?
  bDeviceProtocol         1 Interface Association
  bMaxPacketSize0        64
  idVendor           0x1871 Aveo Technology Corp.
  idProduct          0x0603=20
  bcdDevice            2.18
  iManufacturer           1 USB2.0 Camera
  iProduct                2 DEF-299A Camera
  iSerial                 0=20
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          419
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0=20
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
      bFunctionProtocol       0=20
      iFunction               2 DEF-299A Camera
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      1 Video Control
      bInterfaceProtocol      0=20
      iInterface              2 DEF-299A Camera
      VideoControl Interface Descriptor:
        bLength                13
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdUVC               1.00
        wTotalLength           77
        dwClockFrequency       12.000000MHz
        bInCollection           1
        baInterfaceNr( 0)       1
      VideoControl Interface Descriptor:
        bLength                18
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0201 Camera Sensor
        bAssocTerminal          0
        iTerminal               0=20
        wObjectiveFocalLengthMin      0
        wObjectiveFocalLengthMax      0
        wOcularFocalLength            0
        bControlSize                  3
        bmControls           0x00000000
      VideoControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             2
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bSourceID               4
        iTerminal               0=20
      VideoControl Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      5 (PROCESSING_UNIT)
      Warning: Descriptor too short
        bUnitID                 3
        bSourceID               1
        wMaxMultiplier          0
        bControlSize            2
        bmControls     0x0000043b
          Brightness
          Contrast
          Saturation
          Sharpness
          Gamma
          Power Line Frequency
        iProcessing             0=20
        bmVideoStandards     0x1a
          NTSC - 525/60
          SECAM - 625/50
          NTSC - 625/50
      VideoControl Interface Descriptor:
        bLength                26
        bDescriptorType        36
        bDescriptorSubtype      6 (EXTENSION_UNIT)
        bUnitID                 4
        guidExtensionCode         {52f2b8aa-d18e-7249-8ced-96b17f04408b}
        bNumControl             1
        bNrPins                 1
        baSourceID( 0)          3
        bControlSize            1
        bmControls( 0)       0x01
        iExtension              0=20
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0008  1x 8 bytes
        bInterval               7
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0=20
      iInterface              0=20
      VideoStreaming Interface Descriptor:
        bLength                            14
        bDescriptorType                    36
        bDescriptorSubtype                  1 (INPUT_HEADER)
        bNumFormats                         1
        wTotalLength                      215
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
        guidFormat                            {59555932-0000-1000-8000-00aa=
00389b71}
        bBitsPerPixel                      16
        bDefaultFrameIndex                  1
        bAspectRatioX                       4
        bAspectRatioY                       3
        bmInterlaceFlags                 0x00
          Interlaced stream or variable: No
          Fields per frame: 1 fields
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
        bFrameIndex                         2
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            160
        wHeight                           120
        dwMinBitRate                  9216000
        dwMaxBitRate                  9216000
        dwMaxVideoFrameBufferSize       38400
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
        bFrameIndex                         4
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
        bFrameIndex                         5
        bmCapabilities                   0x00
          Still image unsupported
        wWidth                            176
        wHeight                           144
        dwMinBitRate                 12165120
        dwMaxBitRate                 12165120
        dwMaxVideoFrameBufferSize       50688
        dwDefaultFrameInterval         333333
        bFrameIntervalType                  1
        dwFrameInterval( 0)            333333
      VideoStreaming Interface Descriptor:
        bLength                            18
        bDescriptorType                    36
        bDescriptorSubtype                  3 (STILL_IMAGE_FRAME)
        bEndpointAddress                    0
        bNumImageSizePatterns               3
        wWidth( 0)                        640
        wHeight( 0)                       480
        wWidth( 1)                        320
        wHeight( 1)                       240
        wWidth( 2)                        160
        wHeight( 2)                       120
        bNumCompressionPatterns             3
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
      bInterfaceProtocol      0=20
      iInterface              0=20
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0204  1x 516 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       2
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0=20
      iInterface              0=20
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0304  1x 772 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       3
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0=20
      iInterface              0=20
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x03f4  1x 1012 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       4
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0=20
      iInterface              0=20
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0bf4  2x 1012 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       5
      bNumEndpoints           1
      bInterfaceClass        14 Video
      bInterfaceSubClass      2 Video Streaming
      bInterfaceProtocol      0=20
      iInterface              0=20
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x13f4  3x 1012 bytes
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

--Boundary-01=_MLZBKrl9JnnEhR1--

--nextPart1895338.PyKRkXyqSK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkoFkswACgkQ2anJBBcsZw253gCguhLcfsXBmxYJt92jll4uBHgz
2k4AoLb7ZA/6tv7WFxYEi/+SMJ/XheI3
=MB01
-----END PGP SIGNATURE-----

--nextPart1895338.PyKRkXyqSK--
