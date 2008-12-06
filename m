Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB6H8OPB014349
	for <video4linux-list@redhat.com>; Sat, 6 Dec 2008 12:08:24 -0500
Received: from carla.brutex.net (carla.brutex.net [85.10.196.13])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB6H7GJC029472
	for <video4linux-list@redhat.com>; Sat, 6 Dec 2008 12:07:17 -0500
Received: from dslb-084-062-157-175.pools.arcor-ip.net ([84.62.157.175]
	helo=[192.168.1.245]) by carla.brutex.net with esmtpa (Exim 4.63)
	(envelope-from <brian@brutex.de>) id 1L90cW-0007gK-Gl
	for video4linux-list@redhat.com; Sat, 06 Dec 2008 18:07:15 +0100
From: Brian Rosenberger <brian@brutex.de>
To: video4linux-list@redhat.com
In-Reply-To: <412bdbff0812050949s545547d2v92bd3633b76b478e@mail.gmail.com>
References: <1228493415.439.8.camel@bru02>
	<412bdbff0812050822q63d946b8y960559f7bca10e6f@mail.gmail.com>
	<1228499124.2547.6.camel@bru02>
	<412bdbff0812050949s545547d2v92bd3633b76b478e@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 06 Dec 2008 18:07:07 +0100
Message-Id: <1228583227.6281.1.camel@bru02>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: Pinnacle PCTV USB (DVB-T device [eb1a:2870])
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

Am Freitag, den 05.12.2008, 12:49 -0500 schrieb Devin Heitmueller:

> 
> Yes, that's exactly what I needed to know.  If you can get the Windows
> USB trace, we should be able to extract the GPIOs from that and add
> the device support.
> 
> Devin
> 

Please find usbsniff log attached:

25 ms] UsbSnoop - FilterAddDevice(aa501748) : DriverObject 86d60bd8, pdo
877c7dc8
[25 ms] UsbSnoop - FilterDispatchPnp(aa50145c) : IRP_MJ_PNP
(IRP_MN_QUERY_INTERFACE)
[25 ms] UsbSnoop - FdoHookDispatchPnp(aa50145c) : IRP_MJ_PNP
(IRP_MN_QUERY_INTERFACE)
[25 ms] UsbSnoop - FilterDispatchPnp(aa50145c) : IRP_MJ_PNP
(IRP_MN_QUERY_LEGACY_BUS_INFORMATION)
[25 ms] UsbSnoop - FdoHookDispatchPnp(aa50145c) : IRP_MJ_PNP
(IRP_MN_QUERY_LEGACY_BUS_INFORMATION)
[25 ms] UsbSnoop - FilterDispatchPnp(aa50145c) : IRP_MJ_PNP
(IRP_MN_QUERY_RESOURCE_REQUIREMENTS)
[25 ms] UsbSnoop - FdoHookDispatchPnp(aa50145c) : IRP_MJ_PNP
(IRP_MN_QUERY_RESOURCE_REQUIREMENTS)
[25 ms] UsbSnoop - FilterDispatchPnp(aa50145c) : IRP_MJ_PNP
(IRP_MN_FILTER_RESOURCE_REQUIREMENTS)
[25 ms] UsbSnoop - FdoHookDispatchPnp(aa50145c) : IRP_MJ_PNP
(IRP_MN_FILTER_RESOURCE_REQUIREMENTS)
[25 ms] UsbSnoop - FilterDispatchPnp(aa50145c) : IRP_MJ_PNP
(IRP_MN_START_DEVICE)
[25 ms] UsbSnoop - FdoHookDispatchPnp(aa50145c) : IRP_MJ_PNP
(IRP_MN_START_DEVICE)
[491 ms] UsbSnoop - FilterDispatchPnp(aa50145c) : IRP_MJ_PNP
(IRP_MN_QUERY_INTERFACE)
[491 ms] UsbSnoop - FdoHookDispatchPnp(aa50145c) : IRP_MJ_PNP
(IRP_MN_QUERY_INTERFACE)
[491 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[491 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=874cf008, IRQL=0
[491 ms]  >>>  URB 1 going down  >>> 
-- URB_FUNCTION_GET_DESCRIPTOR_FROM_DEVICE:
  TransferBufferLength = 00000012
  TransferBuffer       = 864dded8
  TransferBufferMDL    = 00000000
  Index                = 00000000
  DescriptorType       = 00000001 (USB_DEVICE_DESCRIPTOR_TYPE)
  LanguageId           = 00000000
[491 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=874cf008, Context=87f47e48, IRQL=2
[491 ms]  <<<  URB 1 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000012
  TransferBuffer       = 864dded8
  TransferBufferMDL    = 880eb4c8
    00000000: 12 01 00 02 00 00 00 40 1a eb 70 28 00 01 00 01
    00000010: 00 01
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 80 06 00 01 00 00 12 00
[491 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[491 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=874cf008, IRQL=0
[491 ms]  >>>  URB 2 going down  >>> 
-- URB_FUNCTION_GET_DESCRIPTOR_FROM_DEVICE:
  TransferBufferLength = 00000040
  TransferBuffer       = 89ff3b68
  TransferBufferMDL    = 00000000
  Index                = 00000000
  DescriptorType       = 00000002 (USB_CONFIGURATION_DESCRIPTOR_TYPE)
  LanguageId           = 00000000
[491 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=874cf008, Context=87f47e48, IRQL=2
[491 ms]  <<<  URB 2 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000040
  TransferBuffer       = 89ff3b68
  TransferBufferMDL    = 880eb4c8
    00000000: 09 02 f9 00 01 01 00 80 fa 09 04 00 00 03 ff 00
    00000010: ff 00 07 05 81 03 01 00 0b 07 05 82 01 00 00 01
    00000020: 07 05 84 01 00 00 01 09 04 00 01 03 ff 00 ff 00
    00000030: 07 05 81 03 01 00 0b 07 05 82 01 00 00 01 07 05
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 80 06 00 02 00 00 40 00
[491 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[491 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=874cf008, IRQL=0
[491 ms]  >>>  URB 3 going down  >>> 
-- URB_FUNCTION_GET_DESCRIPTOR_FROM_DEVICE:
  TransferBufferLength = 000000f9
  TransferBuffer       = 86b0c130
  TransferBufferMDL    = 00000000
  Index                = 00000000
  DescriptorType       = 00000002 (USB_CONFIGURATION_DESCRIPTOR_TYPE)
  LanguageId           = 00000000
[491 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=874cf008, Context=87f47e48, IRQL=2
[491 ms]  <<<  URB 3 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 000000f9
  TransferBuffer       = 86b0c130
  TransferBufferMDL    = 880eb4c8
    00000000: 09 02 f9 00 01 01 00 80 fa 09 04 00 00 03 ff 00
    00000010: ff 00 07 05 81 03 01 00 0b 07 05 82 01 00 00 01
    00000020: 07 05 84 01 00 00 01 09 04 00 01 03 ff 00 ff 00
    00000030: 07 05 81 03 01 00 0b 07 05 82 01 00 00 01 07 05
    00000040: 84 01 34 02 01 09 04 00 02 03 ff 00 ff 00 07 05
    00000050: 81 03 01 00 0b 07 05 82 01 d4 0a 01 07 05 84 01
    00000060: 34 02 01 09 04 00 03 03 ff 00 ff 00 07 05 81 03
    00000070: 01 00 0b 07 05 82 01 00 0c 01 07 05 84 01 34 02
    00000080: 01 09 04 00 04 03 ff 00 ff 00 07 05 81 03 01 00
    00000090: 0b 07 05 82 01 00 13 01 07 05 84 01 34 02 01 09
    000000a0: 04 00 05 03 ff 00 ff 00 07 05 81 03 01 00 0b 07
    000000b0: 05 82 01 5c 13 01 07 05 84 01 34 02 01 09 04 00
    000000c0: 06 03 ff 00 ff 00 07 05 81 03 01 00 0b 07 05 82
    000000d0: 01 c4 13 01 07 05 84 01 34 02 01 09 04 00 07 03
    000000e0: ff 00 ff 00 07 05 81 03 01 00 0b 07 05 82 01 00
    000000f0: 14 01 07 05 84 01 34 02 01
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 80 06 00 02 00 00 f9 00
[491 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[491 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=874cf008, IRQL=0
[491 ms]  >>>  URB 4 going down  >>> 
-- URB_FUNCTION_SELECT_CONFIGURATION:
  ConfigurationDescriptor = 0x86b0c130 (configure)
  ConfigurationDescriptor : bLength             = 9
  ConfigurationDescriptor : bDescriptorType     = 0x00000002
  ConfigurationDescriptor : wTotalLength        = 0x000000f9
  ConfigurationDescriptor : bNumInterfaces      = 0x00000001
  ConfigurationDescriptor : bConfigurationValue = 0x00000001
  ConfigurationDescriptor : iConfiguration      = 0x00000000
  ConfigurationDescriptor : bmAttributes        = 0x00000080
  ConfigurationDescriptor : MaxPower            = 0x000000fa
  ConfigurationHandle     = 0x00000000
  Interface[0]: Length            = 76
  Interface[0]: InterfaceNumber   = 0
  Interface[0]: AlternateSetting  = 0
[517 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=874cf008, Context=87f47e48, IRQL=0
[517 ms]  <<<  URB 4 coming back  <<< 
-- URB_FUNCTION_SELECT_CONFIGURATION:
  ConfigurationDescriptor = 0x86b0c130 (configure)
  ConfigurationDescriptor : bLength             = 9
  ConfigurationDescriptor : bDescriptorType     = 0x00000002
  ConfigurationDescriptor : wTotalLength        = 0x000000f9
  ConfigurationDescriptor : bNumInterfaces      = 0x00000001
  ConfigurationDescriptor : bConfigurationValue = 0x00000001
  ConfigurationDescriptor : iConfiguration      = 0x00000000
  ConfigurationDescriptor : bmAttributes        = 0x00000080
  ConfigurationDescriptor : MaxPower            = 0x000000fa
  ConfigurationHandle     = 0x875731c0
  Interface[0]: Length            = 76
  Interface[0]: InterfaceNumber   = 0
  Interface[0]: AlternateSetting  = 0
  Interface[0]: Class             = 0x000000ff
  Interface[0]: SubClass          = 0x00000000
  Interface[0]: Protocol          = 0x000000ff
  Interface[0]: InterfaceHandle   = 0x86bcf190
  Interface[0]: NumberOfPipes     = 3
  Interface[0]: Pipes[0] : MaximumPacketSize = 0x00000001
  Interface[0]: Pipes[0] : EndpointAddress   = 0x00000081
  Interface[0]: Pipes[0] : Interval          = 0x0000000b
  Interface[0]: Pipes[0] : PipeType          = 0x00000003
(UsbdPipeTypeInterrupt)
  Interface[0]: Pipes[0] : PipeHandle        = 0x86bcf1ac
  Interface[0]: Pipes[0] : MaxTransferSize   = 0x00001000
  Interface[0]: Pipes[0] : PipeFlags         = 0x00000000
  Interface[0]: Pipes[1] : MaximumPacketSize = 0x00000000
  Interface[0]: Pipes[1] : EndpointAddress   = 0x00000082
  Interface[0]: Pipes[1] : Interval          = 0x00000001
  Interface[0]: Pipes[1] : PipeType          = 0x00000001
(UsbdPipeTypeIsochronous)
  Interface[0]: Pipes[1] : PipeHandle        = 0x86bcf1cc
  Interface[0]: Pipes[1] : MaxTransferSize   = 0x00001000
  Interface[0]: Pipes[1] : PipeFlags         = 0x00000000
  Interface[0]: Pipes[2] : MaximumPacketSize = 0x00000000
  Interface[0]: Pipes[2] : EndpointAddress   = 0x00000084
  Interface[0]: Pipes[2] : Interval          = 0x00000001
  Interface[0]: Pipes[2] : PipeType          = 0x00000001
(UsbdPipeTypeIsochronous)
  Interface[0]: Pipes[2] : PipeHandle        = 0x86bcf1ec
  Interface[0]: Pipes[2] : MaxTransferSize   = 0x00001000
  Interface[0]: Pipes[2] : PipeFlags         = 0x00000000
[517 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[517 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=874cf008, IRQL=0
[517 ms]  >>>  URB 5 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8ef
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 0000000a
[517 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=874cf008, Context=87f47e48, IRQL=2
[517 ms]  <<<  URB 5 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8ef
  TransferBufferMDL    = 880eb4c8
    00000000: 23
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 0a 00 01 00
[517 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[517 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=874cf008, IRQL=0
[517 ms]  >>>  URB 6 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8db
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 0000000a
[518 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=874cf008, Context=87f47e48, IRQL=2
[518 ms]  <<<  URB 6 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8db
  TransferBufferMDL    = 880eb4c8
    00000000: 23
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 0a 00 01 00
[518 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[518 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=874cf008, IRQL=0
[518 ms]  >>>  URB 7 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8e7
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000006
[518 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=874cf008, Context=87f47e48, IRQL=2
[518 ms]  <<<  URB 7 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8e7
  TransferBufferMDL    = 880eb4c8
    00000000: 4c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 06 00 01 00
[518 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[518 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=874cf008, IRQL=0
[518 ms]  >>>  URB 8 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8ef
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 0000000c
[518 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=874cf008, Context=87f47e48, IRQL=2
[518 ms]  <<<  URB 8 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8ef
  TransferBufferMDL    = 880eb4c8
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 0c 00 01 00
[519 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[519 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=8801d008, IRQL=0
[519 ms]  >>>  URB 9 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb928
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000002
[519 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=8801d008, Context=87f47e48, IRQL=2
[519 ms]  <<<  URB 9 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb928
  TransferBufferMDL    = 880eb4c8
    00000000: 81 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 02 00 02 00
[519 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[519 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=8801d008, IRQL=1
[519 ms]  >>>  URB 10 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb927
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[520 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=8801d008, Context=87f47e48, IRQL=2
[520 ms]  <<<  URB 10 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb927
  TransferBufferMDL    = 880eb4c8
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[520 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[520 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=8801d008, IRQL=1
[520 ms]  >>>  URB 11 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb877
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[520 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=8801d008, Context=87f47e48, IRQL=2
[520 ms]  <<<  URB 11 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb877
  TransferBufferMDL    = 880eb4c8
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[520 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[520 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=8801d008, IRQL=1
[520 ms]  >>>  URB 12 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb937
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[520 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=8801d008, Context=87f47e48, IRQL=2
[520 ms]  <<<  URB 12 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb937
  TransferBufferMDL    = 880eb4c8
    00000000: c0
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[520 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[520 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=8801d008, IRQL=1
[520 ms]  >>>  URB 13 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb877
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[520 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=8801d008, Context=87f47e48, IRQL=2
[520 ms]  <<<  URB 13 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb877
  TransferBufferMDL    = 880eb4c8
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[521 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[521 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=8801d008, IRQL=1
[521 ms]  >>>  URB 14 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb917
  TransferBufferMDL    = 00000000
    00000000: 04
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[521 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=8801d008, Context=87f47e48, IRQL=2
[521 ms]  <<<  URB 14 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb917
  TransferBufferMDL    = 880eb4c8
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[521 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[521 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=8801d008, IRQL=1
[521 ms]  >>>  URB 15 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb867
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[521 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=8801d008, Context=87f47e48, IRQL=2
[521 ms]  <<<  URB 15 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb867
  TransferBufferMDL    = 880eb4c8
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[521 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[521 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=8801d008, IRQL=1
[521 ms]  >>>  URB 16 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb930
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[522 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=8801d008, Context=87f47e48, IRQL=2
[522 ms]  <<<  URB 16 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb930
  TransferBufferMDL    = 880eb4c8
    00000000: 1a eb
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 02 00
[522 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[522 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=8801d008, IRQL=1
[522 ms]  >>>  URB 17 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb867
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[522 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=8801d008, Context=87f47e48, IRQL=2
[522 ms]  <<<  URB 17 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb867
  TransferBufferMDL    = 880eb4c8
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[523 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[523 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=875d9008, IRQL=1
[523 ms]  >>>  URB 18 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb5f3
  TransferBufferMDL    = 00000000
    00000000: 20
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[523 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=875d9008, Context=87f47e48, IRQL=2
[523 ms]  <<<  URB 18 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb5f3
  TransferBufferMDL    = 880eb4c8
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[523 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[523 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=875d9008, IRQL=1
[523 ms]  >>>  URB 19 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb543
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[523 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=875d9008, Context=87f47e48, IRQL=2
[523 ms]  <<<  URB 19 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb543
  TransferBufferMDL    = 880eb4c8
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[523 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[523 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=875d9008, IRQL=1
[523 ms]  >>>  URB 20 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = 87ec12e6
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[523 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=875d9008, Context=87f47e48, IRQL=2
[523 ms]  <<<  URB 20 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = 87ec12e6
  TransferBufferMDL    = 880eb4c8
    00000000: 44
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[524 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[524 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=875d9008, IRQL=1
[524 ms]  >>>  URB 21 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb543
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[524 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=875d9008, Context=87f47e48, IRQL=2
[524 ms]  <<<  URB 21 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb543
  TransferBufferMDL    = 880eb4c8
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[524 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[524 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=875d9008, IRQL=1
[524 ms]  >>>  URB 22 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb5ec
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[524 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=875d9008, Context=87f47e48, IRQL=2
[524 ms]  <<<  URB 22 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb5ec
  TransferBufferMDL    = 880eb4c8
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[524 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[524 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=875d9008, IRQL=1
[524 ms]  >>>  URB 23 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb53b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[524 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=875d9008, Context=87f47e48, IRQL=2
[524 ms]  <<<  URB 23 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb53b
  TransferBufferMDL    = 877acf88
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[524 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[524 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=875d9008, IRQL=1
[524 ms]  >>>  URB 24 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb928
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[525 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=875d9008, Context=87f47e48, IRQL=2
[525 ms]  <<<  URB 24 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb928
  TransferBufferMDL    = 877acf88
    00000000: c0 12
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 02 00
[525 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[525 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=875d9008, IRQL=1
[525 ms]  >>>  URB 25 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb53b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[525 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=875d9008, Context=87f47e48, IRQL=2
[525 ms]  <<<  URB 25 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb53b
  TransferBufferMDL    = 877acf88
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[525 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[525 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=875d9008, IRQL=1
[525 ms]  >>>  URB 26 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb5f3
  TransferBufferMDL    = 00000000
    00000000: 14
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[525 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=875d9008, Context=87f47e48, IRQL=2
[525 ms]  <<<  URB 26 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb5f3
  TransferBufferMDL    = 877acf88
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[526 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[526 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=875d9008, IRQL=1
[526 ms]  >>>  URB 27 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb543
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[526 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=875d9008, Context=87f47e48, IRQL=2
[526 ms]  <<<  URB 27 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb543
  TransferBufferMDL    = 877acf88
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[526 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[526 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=875d9008, IRQL=1
[526 ms]  >>>  URB 28 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000004
  TransferBuffer       = ba4fb930
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[526 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=875d9008, Context=87f47e48, IRQL=2
[526 ms]  <<<  URB 28 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000004
  TransferBuffer       = ba4fb930
  TransferBufferMDL    = 877acf88
    00000000: 02 0d 00 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 04 00
[526 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[526 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=875d9008, IRQL=1
[526 ms]  >>>  URB 29 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb543
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[527 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=875d9008, Context=87f47e48, IRQL=2
[527 ms]  <<<  URB 29 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb543
  TransferBufferMDL    = 877acf88
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[531 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[531 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[531 ms]  >>>  URB 30 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb91f
  TransferBufferMDL    = 00000000
    00000000: 26
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[531 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[531 ms]  <<<  URB 30 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb91f
  TransferBufferMDL    = 87ac7c68
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[531 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[531 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[531 ms]  >>>  URB 31 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb86f
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[531 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[531 ms]  <<<  URB 31 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb86f
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[531 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[531 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[531 ms]  >>>  URB 32 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb93c
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[532 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[532 ms]  <<<  URB 32 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb93c
  TransferBufferMDL    = 87ac7c68
    00000000: 02
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[532 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[532 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[532 ms]  >>>  URB 33 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb86f
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[532 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[532 ms]  <<<  URB 33 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb86f
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[532 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[532 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[532 ms]  >>>  URB 34 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb91b
  TransferBufferMDL    = 00000000
    00000000: 2a
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[532 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[532 ms]  <<<  URB 34 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb91b
  TransferBufferMDL    = 87ac7c68
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[532 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[532 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[532 ms]  >>>  URB 35 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb86b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[532 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[532 ms]  <<<  URB 35 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb86b
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[533 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[533 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[533 ms]  >>>  URB 36 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb93c
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[533 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[533 ms]  <<<  URB 36 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb93c
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[533 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[533 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[533 ms]  >>>  URB 37 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb86b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[533 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[533 ms]  <<<  URB 37 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb86b
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[533 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[533 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=0
[533 ms]  >>>  URB 38 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb91b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 0000000f
[533 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[533 ms]  <<<  URB 38 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb91b
  TransferBufferMDL    = 87ac7c68
    00000000: 27
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 0f 00 01 00
[534 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[534 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=0
[534 ms]  >>>  URB 39 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb910
  TransferBufferMDL    = 00000000
    00000000: 27
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 0000000f
[534 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[534 ms]  <<<  URB 39 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb910
  TransferBufferMDL    = 87ac7c68
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 00 00 00 0f 00 01 00
[534 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[534 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[534 ms]  >>>  URB 40 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb904
  TransferBufferMDL    = 00000000
    00000000: 1c
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[534 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[534 ms]  <<<  URB 40 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb904
  TransferBufferMDL    = 87ac7c68
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[534 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[534 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[534 ms]  >>>  URB 41 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[534 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[534 ms]  <<<  URB 41 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[534 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[534 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[534 ms]  >>>  URB 42 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb920
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[535 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[535 ms]  <<<  URB 42 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb920
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[535 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[535 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[535 ms]  >>>  URB 43 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[535 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[535 ms]  <<<  URB 43 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[535 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[535 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[535 ms]  >>>  URB 44 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb904
  TransferBufferMDL    = 00000000
    00000000: 18
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[535 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[535 ms]  <<<  URB 44 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb904
  TransferBufferMDL    = 87ac7c68
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[535 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[535 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[535 ms]  >>>  URB 45 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[536 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[536 ms]  <<<  URB 45 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[536 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[536 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[536 ms]  >>>  URB 46 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb920
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[536 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[536 ms]  <<<  URB 46 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb920
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[536 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[536 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[536 ms]  >>>  URB 47 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[536 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[536 ms]  <<<  URB 47 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[536 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[536 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[536 ms]  >>>  URB 48 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb904
  TransferBufferMDL    = 00000000
    00000000: 1d
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[537 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[537 ms]  <<<  URB 48 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb904
  TransferBufferMDL    = 87ac7c68
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[537 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[537 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[537 ms]  >>>  URB 49 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[537 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[537 ms]  <<<  URB 49 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[537 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[537 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[537 ms]  >>>  URB 50 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb920
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[537 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[537 ms]  <<<  URB 50 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb920
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[537 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[537 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[537 ms]  >>>  URB 51 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[537 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[537 ms]  <<<  URB 51 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[538 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[538 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[538 ms]  >>>  URB 52 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb904
  TransferBufferMDL    = 00000000
    00000000: 19
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[538 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[538 ms]  <<<  URB 52 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb904
  TransferBufferMDL    = 87ac7c68
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[538 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[538 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[538 ms]  >>>  URB 53 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[538 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[538 ms]  <<<  URB 53 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[538 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[538 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[538 ms]  >>>  URB 54 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb920
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[538 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[538 ms]  <<<  URB 54 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb920
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[539 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[539 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[539 ms]  >>>  URB 55 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[539 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[539 ms]  <<<  URB 55 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[539 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[539 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[539 ms]  >>>  URB 56 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb904
  TransferBufferMDL    = 00000000
    00000000: 1e
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[539 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[539 ms]  <<<  URB 56 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb904
  TransferBufferMDL    = 87ac7c68
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[539 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[539 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[539 ms]  >>>  URB 57 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[539 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[539 ms]  <<<  URB 57 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[539 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[539 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[539 ms]  >>>  URB 58 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb920
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[540 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[540 ms]  <<<  URB 58 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb920
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[540 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[540 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[540 ms]  >>>  URB 59 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[540 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[540 ms]  <<<  URB 59 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[540 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[540 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[540 ms]  >>>  URB 60 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb904
  TransferBufferMDL    = 00000000
    00000000: 1a
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[540 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[540 ms]  <<<  URB 60 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb904
  TransferBufferMDL    = 87ac7c68
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[540 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[540 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[540 ms]  >>>  URB 61 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[541 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[541 ms]  <<<  URB 61 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[541 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[541 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[541 ms]  >>>  URB 62 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb920
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[541 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[541 ms]  <<<  URB 62 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb920
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[541 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[541 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[541 ms]  >>>  URB 63 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[541 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[541 ms]  <<<  URB 63 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[541 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[541 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[541 ms]  >>>  URB 64 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb904
  TransferBufferMDL    = 00000000
    00000000: 1f
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[542 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[542 ms]  <<<  URB 64 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb904
  TransferBufferMDL    = 87ac7c68
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[542 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[542 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[542 ms]  >>>  URB 65 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[542 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[542 ms]  <<<  URB 65 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[542 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[542 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[542 ms]  >>>  URB 66 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb920
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[542 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[542 ms]  <<<  URB 66 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb920
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[542 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[542 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[542 ms]  >>>  URB 67 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[542 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[542 ms]  <<<  URB 67 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[543 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[543 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[543 ms]  >>>  URB 68 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb904
  TransferBufferMDL    = 00000000
    00000000: 1b
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[543 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[543 ms]  <<<  URB 68 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb904
  TransferBufferMDL    = 87ac7c68
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[543 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[543 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[543 ms]  >>>  URB 69 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[543 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[543 ms]  <<<  URB 69 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[543 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[543 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[543 ms]  >>>  URB 70 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb920
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[543 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[543 ms]  <<<  URB 70 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb920
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[544 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[544 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[544 ms]  >>>  URB 71 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[544 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[544 ms]  <<<  URB 71 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb853
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[544 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[544 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[544 ms]  >>>  URB 72 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8eb
  TransferBufferMDL    = 00000000
    00000000: 22
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[544 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[544 ms]  <<<  URB 72 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8eb
  TransferBufferMDL    = 87ac7c68
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[544 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[544 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[544 ms]  >>>  URB 73 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb83b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[544 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[544 ms]  <<<  URB 73 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb83b
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[544 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[544 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[544 ms]  >>>  URB 74 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = 87ec12c4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[545 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[545 ms]  <<<  URB 74 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = 87ec12c4
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[545 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[545 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[545 ms]  >>>  URB 75 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb83b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[545 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[545 ms]  <<<  URB 75 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb83b
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[545 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[545 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[545 ms]  >>>  URB 76 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8eb
  TransferBufferMDL    = 00000000
    00000000: 23
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[545 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[545 ms]  <<<  URB 76 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8eb
  TransferBufferMDL    = 87ac7c68
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[545 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[545 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[545 ms]  >>>  URB 77 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb83b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[546 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[546 ms]  <<<  URB 77 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb83b
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[546 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[546 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[546 ms]  >>>  URB 78 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = 87ec12c8
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[546 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[546 ms]  <<<  URB 78 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = 87ec12c8
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[546 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[546 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[546 ms]  >>>  URB 79 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb83b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[546 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[546 ms]  <<<  URB 79 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb83b
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[546 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[546 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[546 ms]  >>>  URB 80 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb917
  TransferBufferMDL    = 00000000
    00000000: 2d
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[547 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[547 ms]  <<<  URB 80 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb917
  TransferBufferMDL    = 87ac7c68
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[547 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[547 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[547 ms]  >>>  URB 81 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb867
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[547 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[547 ms]  <<<  URB 81 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb867
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[547 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[547 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[547 ms]  >>>  URB 82 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb92c
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[547 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[547 ms]  <<<  URB 82 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb92c
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[547 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[547 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[547 ms]  >>>  URB 83 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb867
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[547 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[547 ms]  <<<  URB 83 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb867
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[548 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[548 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[548 ms]  >>>  URB 84 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb917
  TransferBufferMDL    = 00000000
    00000000: 28
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[548 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[548 ms]  <<<  URB 84 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb917
  TransferBufferMDL    = 87ac7c68
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[548 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[548 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[548 ms]  >>>  URB 85 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb867
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[548 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[548 ms]  <<<  URB 85 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb867
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[548 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[548 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[548 ms]  >>>  URB 86 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb928
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[548 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[549 ms]  <<<  URB 86 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb928
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[549 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[549 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[549 ms]  >>>  URB 87 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb867
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[549 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[549 ms]  <<<  URB 87 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb867
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[549 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[549 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[549 ms]  >>>  URB 88 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb917
  TransferBufferMDL    = 00000000
    00000000: 27
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[549 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[549 ms]  <<<  URB 88 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb917
  TransferBufferMDL    = 87ac7c68
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[549 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[549 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[549 ms]  >>>  URB 89 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb867
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[550 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[550 ms]  <<<  URB 89 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb867
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[550 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[550 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[550 ms]  >>>  URB 90 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb924
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[550 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[550 ms]  <<<  URB 90 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb924
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[550 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[550 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[550 ms]  >>>  URB 91 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb867
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[550 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[550 ms]  <<<  URB 91 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb867
  TransferBufferMDL    = 87ac7c68
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[550 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[550 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[550 ms]  >>>  URB 92 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb917
  TransferBufferMDL    = 00000000
    00000000: 0a
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[551 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[551 ms]  <<<  URB 92 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb917
  TransferBufferMDL    = 87ac7c68
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[551 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[551 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[551 ms]  >>>  URB 93 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb867
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[551 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[551 ms]  <<<  URB 93 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb867
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[551 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[551 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[551 ms]  >>>  URB 94 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb933
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[551 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[551 ms]  <<<  URB 94 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb933
  TransferBufferMDL    = 86570d98
    00000000: 81
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[551 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[551 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[551 ms]  >>>  URB 95 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb867
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[551 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[551 ms]  <<<  URB 95 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb867
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[552 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[552 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[552 ms]  >>>  URB 96 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb88b
  TransferBufferMDL    = 00000000
    00000000: 0b
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[552 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[552 ms]  <<<  URB 96 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb88b
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[552 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[552 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[552 ms]  >>>  URB 97 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7db
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[552 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[552 ms]  <<<  URB 97 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7db
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[552 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[552 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[552 ms]  >>>  URB 98 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8df
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[553 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[553 ms]  <<<  URB 98 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8df
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[553 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[553 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=1
[553 ms]  >>>  URB 99 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7db
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[553 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[553 ms]  <<<  URB 99 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7db
  TransferBufferMDL    = 876e6190
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[553 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[553 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=0
[553 ms]  >>>  URB 100 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb914
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000006
[553 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[553 ms]  <<<  URB 100 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb914
  TransferBufferMDL    = 876e6190
    00000000: 4c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 06 00 01 00
[553 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[553 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=0
[553 ms]  >>>  URB 101 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8dc
  TransferBufferMDL    = 00000000
    00000000: 4c
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000006
[553 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[553 ms]  <<<  URB 101 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8dc
  TransferBufferMDL    = 876e6190
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 00 00 00 06 00 01 00
[553 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[553 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=0
[553 ms]  >>>  URB 102 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb87f
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000008
[553 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[553 ms]  <<<  URB 102 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb87f
  TransferBufferMDL    = 876e6190
    00000000: ff
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 08 00 01 00
[554 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[554 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=0
[554 ms]  >>>  URB 103 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb874
  TransferBufferMDL    = 00000000
    00000000: fe
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000008
[554 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[554 ms]  <<<  URB 103 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb874
  TransferBufferMDL    = 876e6190
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 00 00 00 08 00 01 00
[554 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[554 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=0
[554 ms]  >>>  URB 104 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb877
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000008
[554 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[554 ms]  <<<  URB 104 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb877
  TransferBufferMDL    = 876e6190
    00000000: fe
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 08 00 01 00
[554 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[554 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87d8e008, IRQL=0
[554 ms]  >>>  URB 105 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb86c
  TransferBufferMDL    = 00000000
    00000000: de
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000008
[554 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87d8e008, Context=87f47e48, IRQL=2
[554 ms]  <<<  URB 105 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb86c
  TransferBufferMDL    = 876e6190
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 00 00 00 08 00 01 00
[658 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[658 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87294008, IRQL=0
[658 ms]  >>>  URB 106 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb877
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000008
[658 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87294008, Context=87f47e48, IRQL=2
[658 ms]  <<<  URB 106 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb877
  TransferBufferMDL    = 87bddf08
    00000000: de
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 08 00 01 00
[658 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[658 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87294008, IRQL=0
[658 ms]  >>>  URB 107 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb86c
  TransferBufferMDL    = 00000000
    00000000: fe
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000008
[658 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87294008, Context=87f47e48, IRQL=2
[658 ms]  <<<  URB 107 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb86c
  TransferBufferMDL    = 87bddf08
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 00 00 00 08 00 01 00
[767 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[767 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87db0008, IRQL=1
[767 ms]  >>>  URB 108 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb800
  TransferBufferMDL    = 00000000
    00000000: 2f
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[768 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87db0008, Context=87f47e48, IRQL=2
[768 ms]  <<<  URB 108 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb800
  TransferBufferMDL    = 87bddf08
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[768 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[768 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87db0008, IRQL=1
[768 ms]  >>>  URB 109 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb74f
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[768 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87db0008, Context=87f47e48, IRQL=2
[768 ms]  <<<  URB 109 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb74f
  TransferBufferMDL    = 87bddf08
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[768 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[768 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87db0008, IRQL=1
[768 ms]  >>>  URB 110 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8df
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[768 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87db0008, Context=87f47e48, IRQL=2
[768 ms]  <<<  URB 110 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8df
  TransferBufferMDL    = 87bddf08
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[768 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[768 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87db0008, IRQL=1
[768 ms]  >>>  URB 111 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb74f
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[768 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87db0008, Context=87f47e48, IRQL=2
[768 ms]  <<<  URB 111 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb74f
  TransferBufferMDL    = 87bddf08
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[768 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[768 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87db0008, IRQL=1
[768 ms]  >>>  URB 112 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb807
  TransferBufferMDL    = 00000000
    00000000: 2d
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[769 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87db0008, Context=87f47e48, IRQL=2
[769 ms]  <<<  URB 112 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb807
  TransferBufferMDL    = 87bddf08
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[769 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[769 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87db0008, IRQL=1
[769 ms]  >>>  URB 113 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb757
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[769 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87db0008, Context=87f47e48, IRQL=2
[769 ms]  <<<  URB 113 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb757
  TransferBufferMDL    = 87bddf08
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[769 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[769 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87db0008, IRQL=1
[769 ms]  >>>  URB 114 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = 87ec2158
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[769 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87db0008, Context=87f47e48, IRQL=2
[769 ms]  <<<  URB 114 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = 87ec2158
  TransferBufferMDL    = 87bddf08
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[769 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[769 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87db0008, IRQL=1
[769 ms]  >>>  URB 115 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb757
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[770 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87db0008, Context=87f47e48, IRQL=2
[770 ms]  <<<  URB 115 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb757
  TransferBufferMDL    = 87bddf08
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[770 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[770 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87db0008, IRQL=0
[770 ms]  >>>  URB 116 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7b7
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000008
[770 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87db0008, Context=87f47e48, IRQL=2
[770 ms]  <<<  URB 116 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7b7
  TransferBufferMDL    = 87bddf08
    00000000: fe
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 08 00 01 00
[770 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[770 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87db0008, IRQL=0
[770 ms]  >>>  URB 117 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7ac
  TransferBufferMDL    = 00000000
    00000000: fe
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000008
[770 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87db0008, Context=87f47e48, IRQL=2
[770 ms]  <<<  URB 117 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7ac
  TransferBufferMDL    = 87bddf08
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 00 00 00 08 00 01 00
[877 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[877 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=8823bcf0, IRQL=0
[877 ms]  >>>  URB 118 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb77a
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 00000020
[877 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=8823bcf0, Context=87f47e48, IRQL=2
[877 ms]  <<<  URB 118 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb77a
  TransferBufferMDL    = 87bddf08
    00000000: fe
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 20 00 01 00
[877 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[877 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=8823bcf0, IRQL=0
[877 ms]  >>>  URB 119 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6f3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[878 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=8823bcf0, Context=87f47e48, IRQL=2
[878 ms]  <<<  URB 119 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6f3
  TransferBufferMDL    = 87bddf08
    00000000: 10
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[878 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[878 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=8823bcf0, IRQL=0
[878 ms]  >>>  URB 120 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb79a
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000d0
[878 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=8823bcf0, Context=87f47e48, IRQL=2
[878 ms]  <<<  URB 120 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb79a
  TransferBufferMDL    = 87bddf08
    00000000: 10
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 d0 00 01 00
[878 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[878 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=8823bcf0, IRQL=0
[878 ms]  >>>  URB 121 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb713
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[878 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=8823bcf0, Context=87f47e48, IRQL=2
[878 ms]  <<<  URB 121 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb713
  TransferBufferMDL    = 87bddf08
    00000000: 10
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[878 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[878 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=8823bcf0, IRQL=0
[878 ms]  >>>  URB 122 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7ee
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 0000001e
[879 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=8823bcf0, Context=87f47e48, IRQL=2
[879 ms]  <<<  URB 122 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7ee
  TransferBufferMDL    = 87bddf08
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 1e 00 01 00
[879 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[879 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=8823bcf0, IRQL=0
[879 ms]  >>>  URB 123 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb767
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[879 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=8823bcf0, Context=87f47e48, IRQL=2
[879 ms]  <<<  URB 123 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb767
  TransferBufferMDL    = 87bddf08
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[879 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[879 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=8823bcf0, IRQL=1
[879 ms]  >>>  URB 124 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb804
  TransferBufferMDL    = 00000000
    00000000: 7f
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 0000001e
[879 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=8823bcf0, Context=87f47e48, IRQL=2
[879 ms]  <<<  URB 124 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb804
  TransferBufferMDL    = 87bddf08
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 1e 00 01 00
[879 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[879 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=8823bcf0, IRQL=1
[879 ms]  >>>  URB 125 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb77b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[879 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=8823bcf0, Context=87f47e48, IRQL=2
[879 ms]  <<<  URB 125 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb77b
  TransferBufferMDL    = 87bddf08
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[879 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[879 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=8823bcf0, IRQL=1
[879 ms]  >>>  URB 126 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 0000001e
[880 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=8823bcf0, Context=87f47e48, IRQL=2
[880 ms]  <<<  URB 126 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8d3
  TransferBufferMDL    = 87bddf08
    00000000: 14
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 1e 00 01 00
[880 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[880 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=8823bcf0, IRQL=1
[880 ms]  >>>  URB 127 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb77b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[880 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=8823bcf0, Context=87f47e48, IRQL=2
[880 ms]  <<<  URB 127 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb77b
  TransferBufferMDL    = 87bddf08
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[880 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[880 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=8823bcf0, IRQL=1
[880 ms]  >>>  URB 128 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb8a2
  TransferBufferMDL    = 00000000
    00000000: 50 0c
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 0000001e
[881 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=8823bcf0, Context=87f47e48, IRQL=2
[881 ms]  <<<  URB 128 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb8a2
  TransferBufferMDL    = 87bddf08
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 02 00 00 1e 00 02 00
[881 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[881 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=8823bcf0, IRQL=1
[881 ms]  >>>  URB 129 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb847
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[881 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=8823bcf0, Context=87f47e48, IRQL=2
[881 ms]  <<<  URB 129 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb847
  TransferBufferMDL    = 87bddf08
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[892 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[892 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=860e3008, IRQL=0
[892 ms]  >>>  URB 130 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb89b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000008
[892 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=860e3008, Context=87f47e48, IRQL=2
[892 ms]  <<<  URB 130 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb89b
  TransferBufferMDL    = 87bddf08
    00000000: fe
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 08 00 01 00
[892 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[892 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=860e3008, IRQL=0
[892 ms]  >>>  URB 131 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb890
  TransferBufferMDL    = 00000000
    00000000: ff
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000008
[893 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=860e3008, Context=87f47e48, IRQL=2
[893 ms]  <<<  URB 131 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb890
  TransferBufferMDL    = 87bddf08
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 00 00 00 08 00 01 00
[893 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[893 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=860e3008, IRQL=0
[893 ms]  >>>  URB 132 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8cb
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000000
[893 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=860e3008, Context=87f47e48, IRQL=2
[893 ms]  <<<  URB 132 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8cb
  TransferBufferMDL    = 87bddf08
    00000000: c0
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 00 00 01 00
[893 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[893 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=860e3008, IRQL=0
[893 ms]  >>>  URB 133 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb88f
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000008
[893 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=860e3008, Context=87f47e48, IRQL=2
[893 ms]  <<<  URB 133 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb88f
  TransferBufferMDL    = 87bddf08
    00000000: ff
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 08 00 01 00
[893 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[893 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=860e3008, IRQL=0
[893 ms]  >>>  URB 134 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb884
  TransferBufferMDL    = 00000000
    00000000: 7f
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000008
[893 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=860e3008, Context=87f47e48, IRQL=2
[893 ms]  <<<  URB 134 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb884
  TransferBufferMDL    = 87bddf08
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 00 00 00 08 00 01 00
[955 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[955 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87581008, IRQL=1
[955 ms]  >>>  URB 135 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb858
  TransferBufferMDL    = 00000000
    00000000: 30
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[955 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87581008, Context=87f47e48, IRQL=2
[955 ms]  <<<  URB 135 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb858
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[955 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[955 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87581008, IRQL=1
[955 ms]  >>>  URB 136 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7a7
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[956 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87581008, Context=87f47e48, IRQL=2
[956 ms]  <<<  URB 136 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7a7
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[956 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[956 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87581008, IRQL=1
[956 ms]  >>>  URB 137 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8d0
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[956 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87581008, Context=87f47e48, IRQL=2
[956 ms]  <<<  URB 137 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8d0
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[956 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[956 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87581008, IRQL=1
[956 ms]  >>>  URB 138 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7a7
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[956 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87581008, Context=87f47e48, IRQL=2
[956 ms]  <<<  URB 138 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7a7
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[956 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[956 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[956 ms]  >>>  URB 139 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb82f
  TransferBufferMDL    = 00000000
    00000000: 0a
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[957 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[957 ms]  <<<  URB 139 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb82f
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[957 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[957 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[957 ms]  >>>  URB 140 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb77f
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[957 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[957 ms]  <<<  URB 140 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb77f
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[957 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[957 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[957 ms]  >>>  URB 141 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb85c
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[957 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[957 ms]  <<<  URB 141 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb85c
  TransferBufferMDL    = 86570d98
    00000000: 81
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[957 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[957 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[957 ms]  >>>  URB 142 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb77f
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[958 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[958 ms]  <<<  URB 142 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb77f
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[958 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[958 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[958 ms]  >>>  URB 143 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb837
  TransferBufferMDL    = 00000000
    00000000: 2e
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[958 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[958 ms]  <<<  URB 143 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb837
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[958 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[958 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[958 ms]  >>>  URB 144 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb787
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[958 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[958 ms]  <<<  URB 144 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb787
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[958 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[958 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[958 ms]  >>>  URB 145 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb848
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[959 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[959 ms]  <<<  URB 145 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb848
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[959 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[959 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[959 ms]  >>>  URB 146 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb787
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[959 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[959 ms]  <<<  URB 146 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb787
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[959 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[959 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[959 ms]  >>>  URB 147 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb80b
  TransferBufferMDL    = 00000000
    00000000: 0a
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[959 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[959 ms]  <<<  URB 147 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb80b
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[959 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[959 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[959 ms]  >>>  URB 148 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb75b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[960 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[960 ms]  <<<  URB 148 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb75b
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[960 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[960 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[960 ms]  >>>  URB 149 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb838
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[960 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[960 ms]  <<<  URB 149 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb838
  TransferBufferMDL    = 86570d98
    00000000: 81
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[960 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[960 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[960 ms]  >>>  URB 150 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb75b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[960 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[960 ms]  <<<  URB 150 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb75b
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[960 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[960 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=0
[960 ms]  >>>  URB 151 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7be
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c6
[960 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[960 ms]  <<<  URB 151 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7be
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c6 00 01 00
[960 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[960 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=0
[960 ms]  >>>  URB 152 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb737
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[961 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[961 ms]  <<<  URB 152 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb737
  TransferBufferMDL    = 86570d98
    00000000: 10
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[961 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[961 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=0
[961 ms]  >>>  URB 153 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7be
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c4
[961 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[961 ms]  <<<  URB 153 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7be
  TransferBufferMDL    = 86570d98
    00000000: 10
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c4 00 01 00
[961 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[961 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=0
[961 ms]  >>>  URB 154 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb737
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[961 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[961 ms]  <<<  URB 154 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb737
  TransferBufferMDL    = 86570d98
    00000000: 10
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[961 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[961 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=0
[961 ms]  >>>  URB 155 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7be
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c2
[961 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[961 ms]  <<<  URB 155 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7be
  TransferBufferMDL    = 86570d98
    00000000: 10
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c2 00 01 00
[961 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[961 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=0
[961 ms]  >>>  URB 156 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb737
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[962 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[962 ms]  <<<  URB 156 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb737
  TransferBufferMDL    = 86570d98
    00000000: 10
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[962 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[962 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=0
[962 ms]  >>>  URB 157 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7be
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[962 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[962 ms]  <<<  URB 157 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7be
  TransferBufferMDL    = 86570d98
    00000000: c1
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[962 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[962 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=0
[962 ms]  >>>  URB 158 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb737
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[962 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[962 ms]  <<<  URB 158 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb737
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[962 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[962 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[962 ms]  >>>  URB 159 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 00
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[963 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[963 ms]  <<<  URB 159 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[963 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[963 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[963 ms]  >>>  URB 160 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[963 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[963 ms]  <<<  URB 160 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[963 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[963 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[963 ms]  >>>  URB 161 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400cc
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[963 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[963 ms]  <<<  URB 161 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400cc
  TransferBufferMDL    = 86570d98
    00000000: 63
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[963 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[963 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[963 ms]  >>>  URB 162 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[964 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[964 ms]  <<<  URB 162 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[964 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[964 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[964 ms]  >>>  URB 163 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 00000000
    00000000: 01 3f
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[964 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[964 ms]  <<<  URB 163 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 02 00 00 c0 00 02 00
[964 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[964 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[964 ms]  >>>  URB 164 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[964 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[964 ms]  <<<  URB 164 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[964 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[964 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[964 ms]  >>>  URB 165 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 00000000
    00000000: 02 74
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[965 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[965 ms]  <<<  URB 165 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 02 00 00 c0 00 02 00
[965 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[965 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[965 ms]  >>>  URB 166 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[965 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[965 ms]  <<<  URB 166 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[965 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[965 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[965 ms]  >>>  URB 167 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 00000000
    00000000: 03 80
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[966 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[966 ms]  <<<  URB 167 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 02 00 00 c0 00 02 00
[966 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[966 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[966 ms]  >>>  URB 168 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[966 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[966 ms]  <<<  URB 168 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[966 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[966 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[966 ms]  >>>  URB 169 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 00000000
    00000000: 04 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[966 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[966 ms]  <<<  URB 169 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 02 00 00 c0 00 02 00
[966 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[966 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[966 ms]  >>>  URB 170 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[967 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[967 ms]  <<<  URB 170 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[967 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[967 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[967 ms]  >>>  URB 171 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 00000000
    00000000: 05 93
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[967 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[967 ms]  <<<  URB 171 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 88092798
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 02 00 00 c0 00 02 00
[967 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[967 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[967 ms]  >>>  URB 172 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[967 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[967 ms]  <<<  URB 172 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[967 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[967 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[967 ms]  >>>  URB 173 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 00000000
    00000000: 06 88
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[968 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[968 ms]  <<<  URB 173 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 02 00 00 c0 00 02 00
[968 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[968 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[968 ms]  >>>  URB 174 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[968 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[968 ms]  <<<  URB 174 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[968 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[968 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[968 ms]  >>>  URB 175 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 00000000
    00000000: 07 80
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[969 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[969 ms]  <<<  URB 175 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 02 00 00 c0 00 02 00
[969 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[969 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[969 ms]  >>>  URB 176 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[969 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[969 ms]  <<<  URB 176 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[969 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[969 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[969 ms]  >>>  URB 177 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 00000000
    00000000: 08 60
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[969 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[969 ms]  <<<  URB 177 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 02 00 00 c0 00 02 00
[969 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[969 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[969 ms]  >>>  URB 178 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[970 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[970 ms]  <<<  URB 178 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[970 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[970 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[970 ms]  >>>  URB 179 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 00000000
    00000000: 09 20
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[970 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[970 ms]  <<<  URB 179 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 02 00 00 c0 00 02 00
[970 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[970 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[970 ms]  >>>  URB 180 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[970 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[970 ms]  <<<  URB 180 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[970 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[970 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[970 ms]  >>>  URB 181 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 00000000
    00000000: 0a 1e
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[971 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[971 ms]  <<<  URB 181 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 02 00 00 c0 00 02 00
[971 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[971 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[971 ms]  >>>  URB 182 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[971 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[971 ms]  <<<  URB 182 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[971 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[971 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[971 ms]  >>>  URB 183 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 00000000
    00000000: 0b 31
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[972 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[972 ms]  <<<  URB 183 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 02 00 00 c0 00 02 00
[972 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[972 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[972 ms]  >>>  URB 184 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[972 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[972 ms]  <<<  URB 184 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[972 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[972 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[972 ms]  >>>  URB 185 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 00000000
    00000000: 0c ff
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[972 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[972 ms]  <<<  URB 185 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 02 00 00 c0 00 02 00
[972 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[972 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[972 ms]  >>>  URB 186 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[973 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[973 ms]  <<<  URB 186 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[973 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[973 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[973 ms]  >>>  URB 187 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 00000000
    00000000: 0d 80
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[973 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[973 ms]  <<<  URB 187 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 02 00 00 c0 00 02 00
[973 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[973 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[973 ms]  >>>  URB 188 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[973 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[973 ms]  <<<  URB 188 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[973 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[973 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[973 ms]  >>>  URB 189 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 00000000
    00000000: 0e ff
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[974 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[974 ms]  <<<  URB 189 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 02 00 00 c0 00 02 00
[974 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[974 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[974 ms]  >>>  URB 190 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[974 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[974 ms]  <<<  URB 190 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[974 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[974 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[974 ms]  >>>  URB 191 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 00000000
    00000000: 0f 00
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[975 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[975 ms]  <<<  URB 191 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 02 00 00 c0 00 02 00
[975 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[975 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[975 ms]  >>>  URB 192 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[975 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[975 ms]  <<<  URB 192 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[975 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[975 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[975 ms]  >>>  URB 193 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 00000000
    00000000: 10 2c
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[975 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[975 ms]  <<<  URB 193 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 02 00 00 c0 00 02 00
[975 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[975 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[975 ms]  >>>  URB 194 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[976 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[976 ms]  <<<  URB 194 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[976 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[976 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[976 ms]  >>>  URB 195 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 00000000
    00000000: 11 42
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[976 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[976 ms]  <<<  URB 195 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb77e
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 02 00 00 c0 00 02 00
[976 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[976 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[976 ms]  >>>  URB 196 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[976 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[976 ms]  <<<  URB 196 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb70b
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[976 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[976 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[976 ms]  >>>  URB 197 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 00
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[977 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[977 ms]  <<<  URB 197 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[977 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[977 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[977 ms]  >>>  URB 198 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[977 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[977 ms]  <<<  URB 198 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[977 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[977 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[977 ms]  >>>  URB 199 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400cc
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[977 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[977 ms]  <<<  URB 199 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400cc
  TransferBufferMDL    = 86570d98
    00000000: 63
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[977 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[977 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[977 ms]  >>>  URB 200 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[978 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[978 ms]  <<<  URB 200 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[978 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[978 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[978 ms]  >>>  URB 201 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 01
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[978 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[978 ms]  <<<  URB 201 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[978 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[978 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[978 ms]  >>>  URB 202 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[978 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[978 ms]  <<<  URB 202 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[978 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[978 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[978 ms]  >>>  URB 203 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400cd
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[979 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[979 ms]  <<<  URB 203 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400cd
  TransferBufferMDL    = 86570d98
    00000000: 3f
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[979 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[979 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[979 ms]  >>>  URB 204 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[979 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[979 ms]  <<<  URB 204 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[979 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[979 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[979 ms]  >>>  URB 205 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 02
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[979 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[979 ms]  <<<  URB 205 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[979 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[979 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[979 ms]  >>>  URB 206 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[979 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[979 ms]  <<<  URB 206 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[979 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[979 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[979 ms]  >>>  URB 207 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400ce
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[980 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[980 ms]  <<<  URB 207 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400ce
  TransferBufferMDL    = 86570d98
    00000000: 74
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[980 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[980 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[980 ms]  >>>  URB 208 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[980 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[980 ms]  <<<  URB 208 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[980 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[980 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[980 ms]  >>>  URB 209 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 03
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[980 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[980 ms]  <<<  URB 209 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[980 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[980 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[980 ms]  >>>  URB 210 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[981 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[981 ms]  <<<  URB 210 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[981 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[981 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[981 ms]  >>>  URB 211 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400cf
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[981 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[981 ms]  <<<  URB 211 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400cf
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[981 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[981 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[981 ms]  >>>  URB 212 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[981 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[981 ms]  <<<  URB 212 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[981 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[981 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[981 ms]  >>>  URB 213 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 04
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[982 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[982 ms]  <<<  URB 213 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[982 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[982 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[982 ms]  >>>  URB 214 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[982 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[982 ms]  <<<  URB 214 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[982 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[982 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[982 ms]  >>>  URB 215 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d0
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[982 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[982 ms]  <<<  URB 215 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d0
  TransferBufferMDL    = 86570d98
    00000000: 08
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[982 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[982 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[982 ms]  >>>  URB 216 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[983 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[983 ms]  <<<  URB 216 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[983 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[983 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[983 ms]  >>>  URB 217 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 05
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[983 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[983 ms]  <<<  URB 217 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[983 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[983 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[983 ms]  >>>  URB 218 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[983 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[983 ms]  <<<  URB 218 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[983 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[983 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[983 ms]  >>>  URB 219 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d1
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[984 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[984 ms]  <<<  URB 219 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d1
  TransferBufferMDL    = 86570d98
    00000000: 93
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[984 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[984 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[984 ms]  >>>  URB 220 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[984 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[984 ms]  <<<  URB 220 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[984 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[984 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[984 ms]  >>>  URB 221 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 06
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[984 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[984 ms]  <<<  URB 221 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[984 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[984 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[984 ms]  >>>  URB 222 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[984 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[984 ms]  <<<  URB 222 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[984 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[984 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[984 ms]  >>>  URB 223 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d2
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[985 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[985 ms]  <<<  URB 223 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d2
  TransferBufferMDL    = 86570d98
    00000000: 08
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[985 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[985 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[985 ms]  >>>  URB 224 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[985 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[985 ms]  <<<  URB 224 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[985 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[985 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[985 ms]  >>>  URB 225 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 07
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[985 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[985 ms]  <<<  URB 225 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[985 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[985 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[985 ms]  >>>  URB 226 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[986 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[986 ms]  <<<  URB 226 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[986 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[986 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[986 ms]  >>>  URB 227 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[986 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[986 ms]  <<<  URB 227 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d3
  TransferBufferMDL    = 86570d98
    00000000: a0
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[986 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[986 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[986 ms]  >>>  URB 228 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[986 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[986 ms]  <<<  URB 228 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[986 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[986 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[986 ms]  >>>  URB 229 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[987 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[987 ms]  <<<  URB 229 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[987 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[987 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[987 ms]  >>>  URB 230 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[987 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[987 ms]  <<<  URB 230 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[987 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[987 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[987 ms]  >>>  URB 231 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[987 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[987 ms]  <<<  URB 231 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 8c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[987 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[987 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[987 ms]  >>>  URB 232 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[988 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[988 ms]  <<<  URB 232 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[988 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[988 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[988 ms]  >>>  URB 233 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 09
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[988 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[988 ms]  <<<  URB 233 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[988 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[988 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[988 ms]  >>>  URB 234 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[988 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[988 ms]  <<<  URB 234 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[988 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[988 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[988 ms]  >>>  URB 235 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d5
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[989 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[989 ms]  <<<  URB 235 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d5
  TransferBufferMDL    = 86570d98
    00000000: 20
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[989 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[989 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[989 ms]  >>>  URB 236 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[989 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[989 ms]  <<<  URB 236 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[989 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[989 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[989 ms]  >>>  URB 237 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 0a
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[989 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[989 ms]  <<<  URB 237 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[989 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[989 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[989 ms]  >>>  URB 238 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[989 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[989 ms]  <<<  URB 238 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[989 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[989 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[989 ms]  >>>  URB 239 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d6
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[990 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[990 ms]  <<<  URB 239 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d6
  TransferBufferMDL    = 86570d98
    00000000: 1e
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[990 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[990 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[990 ms]  >>>  URB 240 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[990 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[990 ms]  <<<  URB 240 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[990 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[990 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[990 ms]  >>>  URB 241 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 0b
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[990 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[990 ms]  <<<  URB 241 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[990 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[990 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[990 ms]  >>>  URB 242 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[991 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[991 ms]  <<<  URB 242 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[991 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[991 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[991 ms]  >>>  URB 243 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d7
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[991 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[991 ms]  <<<  URB 243 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d7
  TransferBufferMDL    = 86570d98
    00000000: 31
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[991 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[991 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[991 ms]  >>>  URB 244 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[991 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[991 ms]  <<<  URB 244 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[991 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[991 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[991 ms]  >>>  URB 245 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 0c
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[992 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[992 ms]  <<<  URB 245 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[992 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[992 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[992 ms]  >>>  URB 246 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[992 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[992 ms]  <<<  URB 246 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[992 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[992 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[992 ms]  >>>  URB 247 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d8
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[992 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[992 ms]  <<<  URB 247 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d8
  TransferBufferMDL    = 86570d98
    00000000: ff
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[992 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[992 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[992 ms]  >>>  URB 248 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[993 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[993 ms]  <<<  URB 248 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[993 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[993 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[993 ms]  >>>  URB 249 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 0d
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[993 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[993 ms]  <<<  URB 249 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[993 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[993 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[993 ms]  >>>  URB 250 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[993 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[993 ms]  <<<  URB 250 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[993 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[993 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[993 ms]  >>>  URB 251 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d9
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[994 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[994 ms]  <<<  URB 251 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d9
  TransferBufferMDL    = 86570d98
    00000000: 8b
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[994 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[994 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[994 ms]  >>>  URB 252 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[994 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[994 ms]  <<<  URB 252 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[994 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[994 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[994 ms]  >>>  URB 253 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[994 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[994 ms]  <<<  URB 253 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[994 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[994 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[994 ms]  >>>  URB 254 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[994 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[994 ms]  <<<  URB 254 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[994 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[994 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[994 ms]  >>>  URB 255 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[995 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[995 ms]  <<<  URB 255 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 8c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[995 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[995 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[995 ms]  >>>  URB 256 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[995 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[995 ms]  <<<  URB 256 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 88092798
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[995 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[995 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[995 ms]  >>>  URB 257 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[995 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[995 ms]  <<<  URB 257 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[995 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[995 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[995 ms]  >>>  URB 258 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[996 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[996 ms]  <<<  URB 258 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[996 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[996 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[996 ms]  >>>  URB 259 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[996 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[996 ms]  <<<  URB 259 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 8c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[996 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[996 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[996 ms]  >>>  URB 260 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[996 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[996 ms]  <<<  URB 260 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[996 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[996 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[996 ms]  >>>  URB 261 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[997 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[997 ms]  <<<  URB 261 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[997 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[997 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[997 ms]  >>>  URB 262 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[997 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[997 ms]  <<<  URB 262 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[997 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[997 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[997 ms]  >>>  URB 263 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[997 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[997 ms]  <<<  URB 263 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 8c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[997 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[997 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[997 ms]  >>>  URB 264 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[998 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[998 ms]  <<<  URB 264 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[998 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[998 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[998 ms]  >>>  URB 265 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[998 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[998 ms]  <<<  URB 265 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[998 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[998 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[998 ms]  >>>  URB 266 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[998 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[998 ms]  <<<  URB 266 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[998 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[998 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[998 ms]  >>>  URB 267 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[999 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[999 ms]  <<<  URB 267 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 8c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[999 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[999 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[999 ms]  >>>  URB 268 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[999 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[999 ms]  <<<  URB 268 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[999 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[999 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[999 ms]  >>>  URB 269 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[999 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[999 ms]  <<<  URB 269 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[999 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[999 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[999 ms]  >>>  URB 270 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[999 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) : fido=00000000,
Irp=87328de0, Context=87f47e48, IRQL=2
[999 ms]  <<<  URB 270 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[999 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[999 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[999 ms]  >>>  URB 271 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1000 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1000 ms]  <<<  URB 271 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 8c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1000 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1000 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1000 ms]  >>>  URB 272 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1000 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1000 ms]  <<<  URB 272 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1000 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1000 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1000 ms]  >>>  URB 273 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[1000 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1000 ms]  <<<  URB 273 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[1000 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1000 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1000 ms]  >>>  URB 274 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1001 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1001 ms]  <<<  URB 274 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1001 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1001 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1001 ms]  >>>  URB 275 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1001 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1001 ms]  <<<  URB 275 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 8c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1001 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1001 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1001 ms]  >>>  URB 276 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1001 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1001 ms]  <<<  URB 276 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1001 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1001 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1001 ms]  >>>  URB 277 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[1002 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1002 ms]  <<<  URB 277 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[1002 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1002 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1002 ms]  >>>  URB 278 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1002 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1002 ms]  <<<  URB 278 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 880f2a60
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1002 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1002 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1002 ms]  >>>  URB 279 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1002 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1002 ms]  <<<  URB 279 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 880f2a60
    00000000: 0c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1002 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1002 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1002 ms]  >>>  URB 280 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1003 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1003 ms]  <<<  URB 280 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1003 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1003 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1003 ms]  >>>  URB 281 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[1003 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1003 ms]  <<<  URB 281 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[1003 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1003 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1003 ms]  >>>  URB 282 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1003 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1003 ms]  <<<  URB 282 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1003 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1003 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1003 ms]  >>>  URB 283 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1004 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1004 ms]  <<<  URB 283 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 0c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1004 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1004 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1004 ms]  >>>  URB 284 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1004 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1004 ms]  <<<  URB 284 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1004 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1004 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1004 ms]  >>>  URB 285 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[1004 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1004 ms]  <<<  URB 285 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[1004 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1004 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1004 ms]  >>>  URB 286 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1004 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1004 ms]  <<<  URB 286 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1004 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1004 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1004 ms]  >>>  URB 287 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1005 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1005 ms]  <<<  URB 287 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 8c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1005 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1005 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1005 ms]  >>>  URB 288 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1005 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1005 ms]  <<<  URB 288 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1005 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1005 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1005 ms]  >>>  URB 289 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[1005 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1005 ms]  <<<  URB 289 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[1005 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1005 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1005 ms]  >>>  URB 290 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1006 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1006 ms]  <<<  URB 290 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1006 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1006 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1006 ms]  >>>  URB 291 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1006 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1006 ms]  <<<  URB 291 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 8c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1006 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1006 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1006 ms]  >>>  URB 292 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1006 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1006 ms]  <<<  URB 292 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1006 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1006 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1006 ms]  >>>  URB 293 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[1007 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1007 ms]  <<<  URB 293 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[1007 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1007 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1007 ms]  >>>  URB 294 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1007 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1007 ms]  <<<  URB 294 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1007 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1007 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1007 ms]  >>>  URB 295 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1007 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1007 ms]  <<<  URB 295 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 8c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1007 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1007 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1007 ms]  >>>  URB 296 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1008 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1008 ms]  <<<  URB 296 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1008 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1008 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1008 ms]  >>>  URB 297 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[1008 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1008 ms]  <<<  URB 297 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[1008 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1008 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1008 ms]  >>>  URB 298 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1008 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1008 ms]  <<<  URB 298 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1008 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1008 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1008 ms]  >>>  URB 299 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1009 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1009 ms]  <<<  URB 299 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 8c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1009 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1009 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1009 ms]  >>>  URB 300 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1009 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1009 ms]  <<<  URB 300 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1009 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1009 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1009 ms]  >>>  URB 301 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[1009 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1009 ms]  <<<  URB 301 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[1009 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1009 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1009 ms]  >>>  URB 302 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1009 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1009 ms]  <<<  URB 302 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1009 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1009 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1009 ms]  >>>  URB 303 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1010 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1010 ms]  <<<  URB 303 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 8c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1010 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1010 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1010 ms]  >>>  URB 304 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1010 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1010 ms]  <<<  URB 304 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1010 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1010 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1010 ms]  >>>  URB 305 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[1010 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1010 ms]  <<<  URB 305 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[1010 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1010 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1010 ms]  >>>  URB 306 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1011 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1011 ms]  <<<  URB 306 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1011 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1011 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1011 ms]  >>>  URB 307 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1011 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1011 ms]  <<<  URB 307 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 8c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1011 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1011 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1011 ms]  >>>  URB 308 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1011 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1011 ms]  <<<  URB 308 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1011 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1011 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1011 ms]  >>>  URB 309 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[1012 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1012 ms]  <<<  URB 309 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[1012 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1012 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1012 ms]  >>>  URB 310 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1012 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1012 ms]  <<<  URB 310 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1012 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1012 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1012 ms]  >>>  URB 311 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1012 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1012 ms]  <<<  URB 311 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 8c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1012 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1012 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1012 ms]  >>>  URB 312 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1013 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1013 ms]  <<<  URB 312 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1013 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1013 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1013 ms]  >>>  URB 313 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[1013 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1013 ms]  <<<  URB 313 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[1013 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1013 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1013 ms]  >>>  URB 314 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1013 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1013 ms]  <<<  URB 314 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1013 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1013 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1013 ms]  >>>  URB 315 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1014 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1014 ms]  <<<  URB 315 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 0c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1014 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1014 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1014 ms]  >>>  URB 316 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1014 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1014 ms]  <<<  URB 316 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1014 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1014 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1014 ms]  >>>  URB 317 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[1014 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1014 ms]  <<<  URB 317 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[1014 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1014 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1014 ms]  >>>  URB 318 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1014 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1014 ms]  <<<  URB 318 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1014 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1014 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1014 ms]  >>>  URB 319 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1015 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1015 ms]  <<<  URB 319 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 8c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1015 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1015 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1015 ms]  >>>  URB 320 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1015 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1015 ms]  <<<  URB 320 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1015 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1015 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1015 ms]  >>>  URB 321 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[1015 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1015 ms]  <<<  URB 321 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[1015 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1015 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1015 ms]  >>>  URB 322 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1016 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1016 ms]  <<<  URB 322 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1016 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1016 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1016 ms]  >>>  URB 323 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1016 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1016 ms]  <<<  URB 323 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 8c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1016 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1016 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1016 ms]  >>>  URB 324 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1016 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1016 ms]  <<<  URB 324 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1016 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1016 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1016 ms]  >>>  URB 325 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[1017 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1017 ms]  <<<  URB 325 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[1017 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1017 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1017 ms]  >>>  URB 326 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1017 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1017 ms]  <<<  URB 326 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1017 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1017 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1017 ms]  >>>  URB 327 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1017 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1017 ms]  <<<  URB 327 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 8c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1017 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1017 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1017 ms]  >>>  URB 328 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1018 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1018 ms]  <<<  URB 328 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1018 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1018 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1018 ms]  >>>  URB 329 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[1018 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1018 ms]  <<<  URB 329 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[1018 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1018 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1018 ms]  >>>  URB 330 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1018 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1018 ms]  <<<  URB 330 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1018 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1018 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1018 ms]  >>>  URB 331 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1019 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1019 ms]  <<<  URB 331 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 8c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1019 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1019 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1019 ms]  >>>  URB 332 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1019 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1019 ms]  <<<  URB 332 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1019 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1019 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1019 ms]  >>>  URB 333 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[1019 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1019 ms]  <<<  URB 333 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[1019 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1019 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1019 ms]  >>>  URB 334 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1019 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1019 ms]  <<<  URB 334 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1019 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1019 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1019 ms]  >>>  URB 335 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1020 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1020 ms]  <<<  URB 335 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 8c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1020 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1020 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1020 ms]  >>>  URB 336 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1020 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1020 ms]  <<<  URB 336 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1020 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1020 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1020 ms]  >>>  URB 337 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[1020 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1020 ms]  <<<  URB 337 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[1020 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1020 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1020 ms]  >>>  URB 338 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1021 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1021 ms]  <<<  URB 338 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1021 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1021 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1021 ms]  >>>  URB 339 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1021 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1021 ms]  <<<  URB 339 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 0c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1021 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1021 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1021 ms]  >>>  URB 340 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1021 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1021 ms]  <<<  URB 340 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1021 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1021 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1021 ms]  >>>  URB 341 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[1022 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1022 ms]  <<<  URB 341 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[1022 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1022 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1022 ms]  >>>  URB 342 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1022 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1022 ms]  <<<  URB 342 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1022 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1022 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1022 ms]  >>>  URB 343 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1022 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1022 ms]  <<<  URB 343 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 0c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1022 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1022 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1022 ms]  >>>  URB 344 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1023 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1023 ms]  <<<  URB 344 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1023 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1023 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1023 ms]  >>>  URB 345 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[1023 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1023 ms]  <<<  URB 345 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[1023 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1023 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1023 ms]  >>>  URB 346 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1023 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1023 ms]  <<<  URB 346 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1023 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1023 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1023 ms]  >>>  URB 347 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1024 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1024 ms]  <<<  URB 347 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 0c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1024 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1024 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1024 ms]  >>>  URB 348 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1024 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1024 ms]  <<<  URB 348 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1024 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1024 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1024 ms]  >>>  URB 349 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[1024 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1024 ms]  <<<  URB 349 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[1024 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1024 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1024 ms]  >>>  URB 350 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1024 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1024 ms]  <<<  URB 350 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 880f2a60
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1024 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1024 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1024 ms]  >>>  URB 351 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1025 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1025 ms]  <<<  URB 351 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 0c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1025 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1025 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1025 ms]  >>>  URB 352 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1025 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1025 ms]  <<<  URB 352 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1025 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1025 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1025 ms]  >>>  URB 353 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[1025 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1025 ms]  <<<  URB 353 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[1025 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1025 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1025 ms]  >>>  URB 354 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1026 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1026 ms]  <<<  URB 354 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1026 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1026 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1026 ms]  >>>  URB 355 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1026 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1026 ms]  <<<  URB 355 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 8c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1026 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1026 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1026 ms]  >>>  URB 356 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1026 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1026 ms]  <<<  URB 356 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1026 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1026 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1026 ms]  >>>  URB 357 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 00000000
    00000000: 08
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[1027 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1027 ms]  <<<  URB 357 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb780
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[1027 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1027 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1027 ms]  >>>  URB 358 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1027 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1027 ms]  <<<  URB 358 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1027 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1027 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1027 ms]  >>>  URB 359 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1027 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1027 ms]  <<<  URB 359 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d4
  TransferBufferMDL    = 86570d98
    00000000: 8c
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1027 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1027 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1027 ms]  >>>  URB 360 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1028 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1028 ms]  <<<  URB 360 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb6d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1028 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1028 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1028 ms]  >>>  URB 361 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7c4
  TransferBufferMDL    = 00000000
    00000000: 09
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000c0
[1028 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1028 ms]  <<<  URB 361 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7c4
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 c0 00 01 00
[1028 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1028 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1028 ms]  >>>  URB 362 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb717
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1028 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1028 ms]  <<<  URB 362 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb717
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1028 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1028 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1028 ms]  >>>  URB 363 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d5
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1029 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1029 ms]  <<<  URB 363 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = a8b400d5
  TransferBufferMDL    = 86570d98
    00000000: 20
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 c0 00 01 00
[1029 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1029 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1029 ms]  >>>  URB 364 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb717
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1029 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1029 ms]  <<<  URB 364 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb717
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1029 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1029 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1029 ms]  >>>  URB 365 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb7c2
  TransferBufferMDL    = 00000000
    00000000: 09 e8
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000c0
[1029 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1029 ms]  <<<  URB 365 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb7c2
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 02 00 00 c0 00 02 00
[1029 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1029 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=1
[1029 ms]  >>>  URB 366 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb74f
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1030 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1030 ms]  <<<  URB 366 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb74f
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1030 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1030 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=0
[1030 ms]  >>>  URB 367 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8cf
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000000
[1030 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1030 ms]  <<<  URB 367 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8cf
  TransferBufferMDL    = 86570d98
    00000000: c0
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 00 00 01 00
[1030 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1030 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=0
[1030 ms]  >>>  URB 368 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb88f
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000008
[1030 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1030 ms]  <<<  URB 368 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb88f
  TransferBufferMDL    = 880f2a60
    00000000: 7f
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 08 00 01 00
[1030 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1030 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=0
[1030 ms]  >>>  URB 369 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb884
  TransferBufferMDL    = 00000000
    00000000: ff
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000008
[1030 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1030 ms]  <<<  URB 369 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb884
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 00 00 00 08 00 01 00
[1034 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1034 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1034 ms]  >>>  URB 370 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb884
  TransferBufferMDL    = 00000000
    00000000: 38
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[1034 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1034 ms]  <<<  URB 370 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb884
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[1034 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1034 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1034 ms]  >>>  URB 371 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1035 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1035 ms]  <<<  URB 371 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1035 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1035 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1035 ms]  >>>  URB 372 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb92d
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[1035 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1035 ms]  <<<  URB 372 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb92d
  TransferBufferMDL    = 86570d98
    00000000: 01
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[1035 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1035 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1035 ms]  >>>  URB 373 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1035 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1035 ms]  <<<  URB 373 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1035 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1035 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1035 ms]  >>>  URB 374 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb884
  TransferBufferMDL    = 00000000
    00000000: 39
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[1036 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1036 ms]  <<<  URB 374 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb884
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[1036 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1036 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1036 ms]  >>>  URB 375 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1036 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1036 ms]  <<<  URB 375 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1036 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1036 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1036 ms]  >>>  URB 376 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb932
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[1036 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1036 ms]  <<<  URB 376 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb932
  TransferBufferMDL    = 86570d98
    00000000: 01
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[1036 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1036 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1036 ms]  >>>  URB 377 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1036 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1036 ms]  <<<  URB 377 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1036 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1036 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1036 ms]  >>>  URB 378 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb884
  TransferBufferMDL    = 00000000
    00000000: 3a
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[1037 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1037 ms]  <<<  URB 378 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb884
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[1037 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1037 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1037 ms]  >>>  URB 379 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1037 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1037 ms]  <<<  URB 379 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1037 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1037 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1037 ms]  >>>  URB 380 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb92f
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[1037 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1037 ms]  <<<  URB 380 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb92f
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[1037 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1037 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1037 ms]  >>>  URB 381 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1038 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1038 ms]  <<<  URB 381 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1038 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1038 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1038 ms]  >>>  URB 382 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb884
  TransferBufferMDL    = 00000000
    00000000: 3b
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[1038 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1038 ms]  <<<  URB 382 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb884
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[1038 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1038 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1038 ms]  >>>  URB 383 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1038 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1038 ms]  <<<  URB 383 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1038 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1038 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1038 ms]  >>>  URB 384 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb930
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[1039 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1039 ms]  <<<  URB 384 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb930
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[1039 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1039 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1039 ms]  >>>  URB 385 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1039 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1039 ms]  <<<  URB 385 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1039 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1039 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1039 ms]  >>>  URB 386 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb884
  TransferBufferMDL    = 00000000
    00000000: 40
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[1039 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1039 ms]  <<<  URB 386 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb884
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[1039 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1039 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1039 ms]  >>>  URB 387 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1040 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1040 ms]  <<<  URB 387 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 880f2a60
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1040 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1040 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1040 ms]  >>>  URB 388 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb933
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[1040 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1040 ms]  <<<  URB 388 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb933
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[1040 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1040 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1040 ms]  >>>  URB 389 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1040 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1040 ms]  <<<  URB 389 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1040 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1040 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1040 ms]  >>>  URB 390 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb884
  TransferBufferMDL    = 00000000
    00000000: 41
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[1041 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1041 ms]  <<<  URB 390 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb884
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[1041 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1041 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1041 ms]  >>>  URB 391 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1041 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1041 ms]  <<<  URB 391 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1041 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1041 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1041 ms]  >>>  URB 392 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb931
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[1041 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1041 ms]  <<<  URB 392 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb931
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[1041 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1041 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=876e4008, IRQL=1
[1041 ms]  >>>  URB 393 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1041 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=876e4008, Context=87f47e48, IRQL=2
[1041 ms]  <<<  URB 393 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb7d3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1049 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1049 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=0
[1049 ms]  >>>  URB 394 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb91b
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000012
[1049 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1049 ms]  <<<  URB 394 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb91b
  TransferBufferMDL    = 86570d98
    00000000: 20
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 12 00 01 00
[1049 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1049 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=0
[1049 ms]  >>>  URB 395 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb910
  TransferBufferMDL    = 00000000
    00000000: 20
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000012
[1049 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1049 ms]  <<<  URB 395 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb910
  TransferBufferMDL    = 880f2a60
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 00 00 00 12 00 01 00
[1049 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1049 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=87328de0, IRQL=0
[1049 ms]  >>>  URB 396 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb934
  TransferBufferMDL    = 00000000
    00000000: 42
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 0000000d
[1050 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=87328de0, Context=87f47e48, IRQL=2
[1050 ms]  <<<  URB 396 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb934
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 00 00 00 0d 00 01 00
[1050 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1050 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=860e3008, IRQL=1
[1050 ms]  >>>  URB 397 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb83f
  TransferBufferMDL    = 00000000
    00000000: 12
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[1050 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=860e3008, Context=87f47e48, IRQL=2
[1050 ms]  <<<  URB 397 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb83f
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[1050 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1050 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=860e3008, IRQL=1
[1050 ms]  >>>  URB 398 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb77f
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1051 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=860e3008, Context=87f47e48, IRQL=2
[1051 ms]  <<<  URB 398 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb77f
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1051 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1051 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=860e3008, IRQL=1
[1051 ms]  >>>  URB 399 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb831
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[1051 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=860e3008, Context=87f47e48, IRQL=2
[1051 ms]  <<<  URB 399 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb831
  TransferBufferMDL    = 86570d98
    00000000: 04
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[1051 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1051 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=860e3008, IRQL=1
[1051 ms]  >>>  URB 400 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb77f
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1051 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=860e3008, Context=87f47e48, IRQL=2
[1051 ms]  <<<  URB 400 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb77f
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1051 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1051 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=860e3008, IRQL=1
[1051 ms]  >>>  URB 401 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb843
  TransferBufferMDL    = 00000000
    00000000: 06
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[1052 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=860e3008, Context=87f47e48, IRQL=2
[1052 ms]  <<<  URB 401 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb843
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[1052 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1052 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=860e3008, IRQL=1
[1052 ms]  >>>  URB 402 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb793
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1052 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=860e3008, Context=87f47e48, IRQL=2
[1052 ms]  <<<  URB 402 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb793
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1052 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1052 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=860e3008, IRQL=1
[1052 ms]  >>>  URB 403 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb924
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[1052 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=860e3008, Context=87f47e48, IRQL=2
[1052 ms]  <<<  URB 403 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000002
  TransferBuffer       = ba4fb924
  TransferBufferMDL    = 86570d98
    00000000: 70 28
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 02 00
[1052 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1052 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=860e3008, IRQL=1
[1052 ms]  >>>  URB 404 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb793
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1053 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=860e3008, Context=87f47e48, IRQL=2
[1053 ms]  <<<  URB 404 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb793
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1053 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1053 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=860e3008, IRQL=1
[1053 ms]  >>>  URB 405 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000000 (USBD_TRANSFER_DIRECTION_OUT,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb963
  TransferBufferMDL    = 00000000
    00000000: 0a
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000003
  Value                   = 00000000
  Index                   = 000000a0
[1054 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=860e3008, Context=87f47e48, IRQL=2
[1054 ms]  <<<  URB 405 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000a (USBD_TRANSFER_DIRECTION_OUT,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb963
  TransferBufferMDL    = 86570d98
  UrbLink              = 00000000
  SetupPacket          =
    00000000: 40 03 00 00 a0 00 01 00
[1054 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1054 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=860e3008, IRQL=1
[1054 ms]  >>>  URB 406 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8b3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1054 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=860e3008, Context=87f47e48, IRQL=2
[1054 ms]  <<<  URB 406 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8b3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1054 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1054 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=860e3008, IRQL=1
[1054 ms]  >>>  URB 407 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb990
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000002
  Value                   = 00000000
  Index                   = 000000a0
[1054 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=860e3008, Context=87f47e48, IRQL=2
[1054 ms]  <<<  URB 407 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb990
  TransferBufferMDL    = 86570d98
    00000000: 81
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 02 00 00 a0 00 01 00
[1054 ms] UsbSnoop - FilterDispatchAny(aa4fcfd2) :
IRP_MJ_INTERNAL_DEVICE_CONTROL
[1054 ms] UsbSnoop - FdoHookDispatchInternalIoctl(aa4fd1ea) :
fdo=87b44eb0, Irp=860e3008, IRQL=1
[1054 ms]  >>>  URB 408 going down  >>> 
-- URB_FUNCTION_VENDOR_DEVICE:
  TransferFlags          = 00000001 (USBD_TRANSFER_DIRECTION_IN,
~USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8b3
  TransferBufferMDL    = 00000000
  UrbLink                 = 00000000
  RequestTypeReservedBits = 00000000
  Request                 = 00000000
  Value                   = 00000000
  Index                   = 00000005
[1054 ms] UsbSnoop - MyInternalIOCTLCompletion(aa4fd126) :
fido=00000000, Irp=860e3008, Context=87f47e48, IRQL=2
[1054 ms]  <<<  URB 408 coming back  <<< 
-- URB_FUNCTION_CONTROL_TRANSFER:
  PipeHandle           = 8837fe58
  TransferFlags        = 0000000b (USBD_TRANSFER_DIRECTION_IN,
USBD_SHORT_TRANSFER_OK)
  TransferBufferLength = 00000001
  TransferBuffer       = ba4fb8b3
  TransferBufferMDL    = 86570d98
    00000000: 00
  UrbLink              = 00000000
  SetupPacket          =
    00000000: c0 00 00 00 05 00 01 00
[1054 ms] UsbSnoop - FilterDispatchPnp(aa50145c) : IRP_MJ_PNP
(IRP_MN_QUERY_INTERFACE)
[1055 ms] UsbSnoop - FdoHookDispatchPnp(aa50145c) : IRP_MJ_PNP
(IRP_MN_QUERY_INTERFACE)
[1056 ms] UsbSnoop - FilterDispatchPnp(aa50145c) : IRP_MJ_PNP
(IRP_MN_QUERY_CAPABILITIES)
[1056 ms] UsbSnoop - FdoHookDispatchPnp(aa50145c) : IRP_MJ_PNP
(IRP_MN_QUERY_CAPABILITIES)
[1056 ms] UsbSnoop - FilterDispatchPnp(aa50145c) : IRP_MJ_PNP
(IRP_MN_QUERY_PNP_DEVICE_STATE)
[1056 ms] UsbSnoop - FdoHookDispatchPnp(aa50145c) : IRP_MJ_PNP
(IRP_MN_QUERY_PNP_DEVICE_STATE)
[1056 ms] UsbSnoop - FilterDispatchPnp(aa50145c) : IRP_MJ_PNP
(IRP_MN_QUERY_DEVICE_RELATIONS)
[1056 ms] UsbSnoop - FdoHookDispatchPnp(aa50145c) : IRP_MJ_PNP
(IRP_MN_QUERY_DEVICE_RELATIONS)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
