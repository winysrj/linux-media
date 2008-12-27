Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBR3Jf4D014663
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 22:19:41 -0500
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBR3JPwC027699
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 22:19:25 -0500
Received: by qw-out-2122.google.com with SMTP id 3so1515463qwe.39
	for <video4linux-list@redhat.com>; Fri, 26 Dec 2008 19:19:24 -0800 (PST)
Message-ID: <412bdbff0812261919k425a3a24w7910628cc9865a83@mail.gmail.com>
Date: Fri, 26 Dec 2008 22:19:24 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Trevor Campbell" <tca42186@bigpond.net.au>
In-Reply-To: <495564E3.4070702@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495564E3.4070702@bigpond.net.au>
Cc: video4linux-list@redhat.com
Subject: Re: em28xx: new board id [1b80:e302]
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

2008/12/26 Trevor Campbell <tca42186@bigpond.net.au>:
> Hi,
>
> I have a Kiaser Baas Video to DVD maker.  It is a USB analog capture device.
>  It doesn't sem to have an actual model number.
>
> idVendor=1b80, idProduct=e302
>
> Tested with
> # uname -r
> 2.6.27.9-1mdvsmp
> # modprobe em28xx
> # modprobe em28xx-dvb
> # modprobe em28xx-alsa
>
> # lsmod | grep em28
> em28xx_alsa            11784  0
> em28xx_dvb             11012  0
> dvb_core               77312  1 em28xx_dvb
> em28xx                 63400  2 em28xx_alsa,em28xx_dvb
> videodev               35840  1 em28xx
> compat_ioctl32          5120  1 em28xx
> videobuf_vmalloc       10244  1 em28xx
> videobuf_core          19844  2 em28xx,videobuf_vmalloc
> ir_common              39044  1 em28xx
> tveeprom               15876  1 em28xx
> snd_pcm                72324  3 em28xx_alsa,snd_hda_intel,snd_usb_audio
> i2c_core               24212  3 em28xx,tveeprom,i2c_i801
> snd                    52644  10
> em28xx_alsa,snd_hda_intel,snd_usb_audio,snd_pcm,snd_timer,snd_rawmidi,snd_seq_device,snd_hwdep
> usbcore               138096  11
> em28xx_alsa,em28xx_dvb,em28xx,snd_usb_audio,btusb,snd_usb_lib,usbhid,uhci_hcd,ohci_hcd,ehci_hcd
>
>
> lsusb output is attached:
>
> Relevant dmesg output seems to be:
> usb 1-1: new high speed USB device using ehci_hcd and address 11
> usb 1-1: configuration #1 chosen from 1 choice
> usb 1-1: New USB device found, idVendor=1b80, idProduct=e302
> usb 1-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
> usb 1-1: Product: USB 2861 Device
> Linux video capture interface: v2.00
> em28xx v4l2 driver version 0.1.0 loaded
> usbcore: registered new interface driver em28xx
> Em28xx: Initialized (Em28xx dvb Extension) extension
> Em28xx: Initialized (Em28xx Audio Extension) extension
>
> Nothing worked.  There is no device /dev/video0 or similar that I can find.
>
> Trevor
>
>
>
> Bus 001 Device 012: ID 1b80:e302
> Device Descriptor:
>  bLength                18
>  bDescriptorType         1
>  bcdUSB               2.00
>  bDeviceClass            0 (Defined at Interface level)
>  bDeviceSubClass         0
>  bDeviceProtocol         0
>  bMaxPacketSize0        64
>  idVendor           0x1b80
>  idProduct          0xe302
>  bcdDevice            1.00
>  iManufacturer           0
>  iProduct                1 USB 2861 Device
>  iSerial                 0
>  bNumConfigurations      1
>  Configuration Descriptor:
>    bLength                 9
>    bDescriptorType         2
>    wTotalLength          555
>    bNumInterfaces          3
>    bConfigurationValue     1
>    iConfiguration          0
>    bmAttributes         0x80
>      (Bus Powered)
>    MaxPower              500mA
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        0
>      bAlternateSetting       0
>      bNumEndpoints           3
>      bInterfaceClass       255 Vendor Specific Class
>      bInterfaceSubClass      0
>      bInterfaceProtocol    255
>      iInterface              0
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x81  EP 1 IN
>        bmAttributes            3
>          Transfer Type            Interrupt
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0001  1x 1 bytes
>        bInterval              11
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x82  EP 2 IN
>        bmAttributes            1
>          Transfer Type            Isochronous
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0000  1x 0 bytes
>        bInterval               1
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x84  EP 4 IN
>        bmAttributes            1
>          Transfer Type            Isochronous
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0000  1x 0 bytes
>        bInterval               1
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        0
>      bAlternateSetting       1
>      bNumEndpoints           3
>      bInterfaceClass       255 Vendor Specific Class
>      bInterfaceSubClass      0
>      bInterfaceProtocol    255
>      iInterface              0
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x81  EP 1 IN
>        bmAttributes            3
>          Transfer Type            Interrupt
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0001  1x 1 bytes
>        bInterval              11
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x82  EP 2 IN
>        bmAttributes            1
>          Transfer Type            Isochronous
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0000  1x 0 bytes
>        bInterval               1
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x84  EP 4 IN
>        bmAttributes            1
>          Transfer Type            Isochronous
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0000  1x 0 bytes
>        bInterval               1
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        0
>      bAlternateSetting       2
>      bNumEndpoints           3
>      bInterfaceClass       255 Vendor Specific Class
>      bInterfaceSubClass      0
>      bInterfaceProtocol    255
>      iInterface              0
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x81  EP 1 IN
>        bmAttributes            3
>          Transfer Type            Interrupt
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0001  1x 1 bytes
>        bInterval              11
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x82  EP 2 IN
>        bmAttributes            1
>          Transfer Type            Isochronous
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0ad4  2x 724 bytes
>        bInterval               1
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x84  EP 4 IN
>        bmAttributes            1
>          Transfer Type            Isochronous
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0000  1x 0 bytes
>        bInterval               1
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        0
>      bAlternateSetting       3
>      bNumEndpoints           3
>      bInterfaceClass       255 Vendor Specific Class
>      bInterfaceSubClass      0
>      bInterfaceProtocol    255
>      iInterface              0
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x81  EP 1 IN
>        bmAttributes            3
>          Transfer Type            Interrupt
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0001  1x 1 bytes
>        bInterval              11
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x82  EP 2 IN
>        bmAttributes            1
>          Transfer Type            Isochronous
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0c00  2x 1024 bytes
>        bInterval               1
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x84  EP 4 IN
>        bmAttributes            1
>          Transfer Type            Isochronous
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0000  1x 0 bytes
>        bInterval               1
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        0
>      bAlternateSetting       4
>      bNumEndpoints           3
>      bInterfaceClass       255 Vendor Specific Class
>      bInterfaceSubClass      0
>      bInterfaceProtocol    255
>      iInterface              0
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x81  EP 1 IN
>        bmAttributes            3
>          Transfer Type            Interrupt
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0001  1x 1 bytes
>        bInterval              11
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x82  EP 2 IN
>        bmAttributes            1
>          Transfer Type            Isochronous
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x1300  3x 768 bytes
>        bInterval               1
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x84  EP 4 IN
>        bmAttributes            1
>          Transfer Type            Isochronous
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0000  1x 0 bytes
>        bInterval               1
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        0
>      bAlternateSetting       5
>      bNumEndpoints           3
>      bInterfaceClass       255 Vendor Specific Class
>      bInterfaceSubClass      0
>      bInterfaceProtocol    255
>      iInterface              0
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x81  EP 1 IN
>        bmAttributes            3
>          Transfer Type            Interrupt
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0001  1x 1 bytes
>        bInterval              11
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x82  EP 2 IN
>        bmAttributes            1
>          Transfer Type            Isochronous
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x135c  3x 860 bytes
>        bInterval               1
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x84  EP 4 IN
>        bmAttributes            1
>          Transfer Type            Isochronous
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0000  1x 0 bytes
>        bInterval               1
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        0
>      bAlternateSetting       6
>      bNumEndpoints           3
>      bInterfaceClass       255 Vendor Specific Class
>      bInterfaceSubClass      0
>      bInterfaceProtocol    255
>      iInterface              0
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x81  EP 1 IN
>        bmAttributes            3
>          Transfer Type            Interrupt
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0001  1x 1 bytes
>        bInterval              11
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x82  EP 2 IN
>        bmAttributes            1
>          Transfer Type            Isochronous
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x13c4  3x 964 bytes
>        bInterval               1
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x84  EP 4 IN
>        bmAttributes            1
>          Transfer Type            Isochronous
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0000  1x 0 bytes
>        bInterval               1
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        0
>      bAlternateSetting       7
>      bNumEndpoints           3
>      bInterfaceClass       255 Vendor Specific Class
>      bInterfaceSubClass      0
>      bInterfaceProtocol    255
>      iInterface              0
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x81  EP 1 IN
>        bmAttributes            3
>          Transfer Type            Interrupt
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0001  1x 1 bytes
>        bInterval              11
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x82  EP 2 IN
>        bmAttributes            1
>          Transfer Type            Isochronous
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x1400  3x 1024 bytes
>        bInterval               1
>      Endpoint Descriptor:
>        bLength                 7
>        bDescriptorType         5
>        bEndpointAddress     0x84  EP 4 IN
>        bmAttributes            1
>          Transfer Type            Isochronous
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0000  1x 0 bytes
>        bInterval               1
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        1
>      bAlternateSetting       0
>      bNumEndpoints           0
>      bInterfaceClass         1 Audio
>      bInterfaceSubClass      1 Control Device
>      bInterfaceProtocol      0
>      iInterface              0
>      AudioControl Interface Descriptor:
>        bLength                 9
>        bDescriptorType        36
>        bDescriptorSubtype      1 (HEADER)
>        bcdADC               1.00
>        wTotalLength           39
>        bInCollection           1
>        baInterfaceNr( 0)       2
>      AudioControl Interface Descriptor:
>        bLength                12
>        bDescriptorType        36
>        bDescriptorSubtype      2 (INPUT_TERMINAL)
>        bTerminalID             1
>        wTerminalType      0x0603 Line Connector
>        bAssocTerminal          0
>        bNrChannels             2
>        wChannelConfig     0x0003
>          Left Front (L)
>          Right Front (R)
>        iChannelNames           0
>        iTerminal               0
>      AudioControl Interface Descriptor:
>        bLength                 9
>        bDescriptorType        36
>        bDescriptorSubtype      6 (FEATURE_UNIT)
>        bUnitID                 2
>        bSourceID               1
>        bControlSize            1
>        bmaControls( 0)      0x03
>          Mute
>          Volume
>        bmaControls( 1)      0x00
>        iFeature                0
>      AudioControl Interface Descriptor:
>        bLength                 9
>        bDescriptorType        36
>        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
>        bTerminalID             3
>        wTerminalType      0x0101 USB Streaming
>        bAssocTerminal          0
>        bSourceID               2
>        iTerminal               0
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        2
>      bAlternateSetting       0
>      bNumEndpoints           1
>      bInterfaceClass         1 Audio
>      bInterfaceSubClass      2 Streaming
>      bInterfaceProtocol      0
>      iInterface              0
>      AudioStreaming Interface Descriptor:
>        bLength                 7
>        bDescriptorType        36
>        bDescriptorSubtype      1 (AS_GENERAL)
>        bTerminalLink           3
>        bDelay                  1 frames
>        wFormatTag              1 PCM
>      AudioStreaming Interface Descriptor:
>        bLength                11
>        bDescriptorType        36
>        bDescriptorSubtype      2 (FORMAT_TYPE)
>        bFormatType             1 (FORMAT_TYPE_I)
>        bNrChannels             2
>        bSubframeSize           2
>        bBitResolution         16
>        bSamFreqType            1 Discrete
>        tSamFreq[ 0]            0
>      Endpoint Descriptor:
>        bLength                 9
>        bDescriptorType         5
>        bEndpointAddress     0x83  EP 3 IN
>        bmAttributes            1
>          Transfer Type            Isochronous
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0000  1x 0 bytes
>        bInterval               4
>        bRefresh                0
>        bSynchAddress           0
>        AudioControl Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType        37
>          bDescriptorSubtype      1 (EP_GENERAL)
>          bmAttributes         0x00
>          bLockDelayUnits         0 Undefined
>          wLockDelay              0 Undefined
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        2
>      bAlternateSetting       1
>      bNumEndpoints           1
>      bInterfaceClass         1 Audio
>      bInterfaceSubClass      2 Streaming
>      bInterfaceProtocol      0
>      iInterface              0
>      AudioStreaming Interface Descriptor:
>        bLength                 7
>        bDescriptorType        36
>        bDescriptorSubtype      1 (AS_GENERAL)
>        bTerminalLink           3
>        bDelay                  1 frames
>        wFormatTag              1 PCM
>      AudioStreaming Interface Descriptor:
>        bLength                11
>        bDescriptorType        36
>        bDescriptorSubtype      2 (FORMAT_TYPE)
>        bFormatType             1 (FORMAT_TYPE_I)
>        bNrChannels             2
>        bSubframeSize           2
>        bBitResolution         16
>        bSamFreqType            1 Discrete
>        tSamFreq[ 0]        48000
>      Endpoint Descriptor:
>        bLength                 9
>        bDescriptorType         5
>        bEndpointAddress     0x83  EP 3 IN
>        bmAttributes            1
>          Transfer Type            Isochronous
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x00c4  1x 196 bytes
>        bInterval               4
>        bRefresh                0
>        bSynchAddress           0
>        AudioControl Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType        37
>          bDescriptorSubtype      1 (EP_GENERAL)
>          bmAttributes         0x00
>          bLockDelayUnits         0 Undefined
>          wLockDelay              0 Undefined
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        2
>      bAlternateSetting       2
>      bNumEndpoints           1
>      bInterfaceClass         1 Audio
>      bInterfaceSubClass      2 Streaming
>      bInterfaceProtocol      0
>      iInterface              0
>      AudioStreaming Interface Descriptor:
>        bLength                 7
>        bDescriptorType        36
>        bDescriptorSubtype      1 (AS_GENERAL)
>        bTerminalLink           3
>        bDelay                  1 frames
>        wFormatTag              1 PCM
>      AudioStreaming Interface Descriptor:
>        bLength                11
>        bDescriptorType        36
>        bDescriptorSubtype      2 (FORMAT_TYPE)
>        bFormatType             1 (FORMAT_TYPE_I)
>        bNrChannels             2
>        bSubframeSize           2
>        bBitResolution         16
>        bSamFreqType            1 Discrete
>        tSamFreq[ 0]        44100
>      Endpoint Descriptor:
>        bLength                 9
>        bDescriptorType         5
>        bEndpointAddress     0x83  EP 3 IN
>        bmAttributes            1
>          Transfer Type            Isochronous
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x00b4  1x 180 bytes
>        bInterval               4
>        bRefresh                0
>        bSynchAddress           0
>        AudioControl Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType        37
>          bDescriptorSubtype      1 (EP_GENERAL)
>          bmAttributes         0x00
>          bLockDelayUnits         0 Undefined
>          wLockDelay              0 Undefined
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        2
>      bAlternateSetting       3
>      bNumEndpoints           1
>      bInterfaceClass         1 Audio
>      bInterfaceSubClass      2 Streaming
>      bInterfaceProtocol      0
>      iInterface              0
>      AudioStreaming Interface Descriptor:
>        bLength                 7
>        bDescriptorType        36
>        bDescriptorSubtype      1 (AS_GENERAL)
>        bTerminalLink           3
>        bDelay                  1 frames
>        wFormatTag              1 PCM
>      AudioStreaming Interface Descriptor:
>        bLength                11
>        bDescriptorType        36
>        bDescriptorSubtype      2 (FORMAT_TYPE)
>        bFormatType             1 (FORMAT_TYPE_I)
>        bNrChannels             2
>        bSubframeSize           2
>        bBitResolution         16
>        bSamFreqType            1 Discrete
>        tSamFreq[ 0]        32000
>      Endpoint Descriptor:
>        bLength                 9
>        bDescriptorType         5
>        bEndpointAddress     0x83  EP 3 IN
>        bmAttributes            1
>          Transfer Type            Isochronous
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0084  1x 132 bytes
>        bInterval               4
>        bRefresh                0
>        bSynchAddress           0
>        AudioControl Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType        37
>          bDescriptorSubtype      1 (EP_GENERAL)
>          bmAttributes         0x00
>          bLockDelayUnits         0 Undefined
>          wLockDelay              0 Undefined
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        2
>      bAlternateSetting       4
>      bNumEndpoints           1
>      bInterfaceClass         1 Audio
>      bInterfaceSubClass      2 Streaming
>      bInterfaceProtocol      0
>      iInterface              0
>      AudioStreaming Interface Descriptor:
>        bLength                 7
>        bDescriptorType        36
>        bDescriptorSubtype      1 (AS_GENERAL)
>        bTerminalLink           3
>        bDelay                  1 frames
>        wFormatTag              1 PCM
>      AudioStreaming Interface Descriptor:
>        bLength                11
>        bDescriptorType        36
>        bDescriptorSubtype      2 (FORMAT_TYPE)
>        bFormatType             1 (FORMAT_TYPE_I)
>        bNrChannels             2
>        bSubframeSize           2
>        bBitResolution         16
>        bSamFreqType            1 Discrete
>        tSamFreq[ 0]        16000
>      Endpoint Descriptor:
>        bLength                 9
>        bDescriptorType         5
>        bEndpointAddress     0x83  EP 3 IN
>        bmAttributes            1
>          Transfer Type            Isochronous
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0044  1x 68 bytes
>        bInterval               4
>        bRefresh                0
>        bSynchAddress           0
>        AudioControl Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType        37
>          bDescriptorSubtype      1 (EP_GENERAL)
>          bmAttributes         0x00
>          bLockDelayUnits         0 Undefined
>          wLockDelay              0 Undefined
>    Interface Descriptor:
>      bLength                 9
>      bDescriptorType         4
>      bInterfaceNumber        2
>      bAlternateSetting       5
>      bNumEndpoints           1
>      bInterfaceClass         1 Audio
>      bInterfaceSubClass      2 Streaming
>      bInterfaceProtocol      0
>      iInterface              0
>      AudioStreaming Interface Descriptor:
>        bLength                 7
>        bDescriptorType        36
>        bDescriptorSubtype      1 (AS_GENERAL)
>        bTerminalLink           3
>        bDelay                  1 frames
>        wFormatTag              1 PCM
>      AudioStreaming Interface Descriptor:
>        bLength                11
>        bDescriptorType        36
>        bDescriptorSubtype      2 (FORMAT_TYPE)
>        bFormatType             1 (FORMAT_TYPE_I)
>        bNrChannels             2
>        bSubframeSize           2
>        bBitResolution         16
>        bSamFreqType            1 Discrete
>        tSamFreq[ 0]         8000
>      Endpoint Descriptor:
>        bLength                 9
>        bDescriptorType         5
>        bEndpointAddress     0x83  EP 3 IN
>        bmAttributes            1
>          Transfer Type            Isochronous
>          Synch Type               None
>          Usage Type               Data
>        wMaxPacketSize     0x0024  1x 36 bytes
>        bInterval               4
>        bRefresh                0
>        bSynchAddress           0
>        AudioControl Endpoint Descriptor:
>          bLength                 7
>          bDescriptorType        37
>          bDescriptorSubtype      1 (EP_GENERAL)
>          bmAttributes         0x00
>          bLockDelayUnits         0 Undefined
>          wLockDelay              0 Undefined
> Device Qualifier (for other device speed):
>  bLength                10
>  bDescriptorType         6
>  bcdUSB               2.00
>  bDeviceClass            0 (Defined at Interface level)
>  bDeviceSubClass         0
>  bDeviceProtocol         0
>  bMaxPacketSize0        64
>  bNumConfigurations      1
> Device Status:     0x0000
>  (Bus Powered)
>
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

The fact that the lsusb product info says "USB Product 2861" probably
does indicate that it's an em28xx based design, but you cannot just
"modprobe em28xx" and expect the driver to somehow be associated with
the device.

Start by opening the device, taking high resolution photos of the PCB,
and creating a page in the LinuxTV wiki.  That will allow the
developers to identify the other components in the device and see what
other drivers are required (the em28xx driver is the bridge but we
also need to know what tuner and/or video decoder are in the device).

Regards,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
