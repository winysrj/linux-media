Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f171.google.com ([209.85.220.171]:47262 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbaD0PYW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Apr 2014 11:24:22 -0400
Received: by mail-vc0-f171.google.com with SMTP id lg15so6822626vcb.2
        for <linux-media@vger.kernel.org>; Sun, 27 Apr 2014 08:24:22 -0700 (PDT)
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: dvbv5-scan errors trying to search channels
From: Roberto Alcantara <roberto@eletronica.org>
In-Reply-To: <20140427080040.37a44d66.m.chehab@samsung.com>
Date: Sun, 27 Apr 2014 12:24:09 -0300
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <F47097FD-78E8-41AD-8CAC-96BAF685F90A@eletronica.org>
References: <956F4699-C5BA-482E-813F-3CA05EC0CF43@eletronica.org> <20140427080040.37a44d66.m.chehab@samsung.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

I put a few additional debug prints and one thing looks strange on scanning:

Apr 27 12:13:26 awsom kernel: [13340.448022] smscore_set_device_mode: firmware download success
Apr 27 12:13:26 awsom kernel: [13340.454118] smsusb_sendrequest: sending MSG_SMS_INIT_DEVICE_REQ(578) size: 12
Apr 27 12:13:26 awsom kernel: [13340.461089] smsusb_onresponse: received MSG_SMS_INIT_DEVICE_RES(579) size: 12
Apr 27 12:13:26 awsom kernel: [13340.468198] smsusb_sendrequest: sending MSG_SMS_INIT_DEVICE_REQ(578) size: 12
Apr 27 12:13:26 awsom kernel: [13340.474447] smsusb_onresponse: received MSG_SMS_INIT_DEVICE_RES(579) size: 12
Apr 27 12:13:26 awsom kernel: [13340.480238] smscore_set_device_mode: Success setting device mode.
Apr 27 12:13:26 awsom kernel: [13340.486148] DVB: registering new adapter (Siano Rio Digital Receiver)
Apr 27 12:13:26 awsom kernel: [13340.493759] DVB: registering adapter 0 frontend 0 (Siano Mobile Digital MDTV Receiver)...
Apr 27 12:13:26 awsom kernel: [13340.498591] smscore_register_client: ed8d5000 693 1
Apr 27 12:13:26 awsom kernel: [13340.502528] sms_board_dvb3_event: DVB3_EVENT_HOTPLUG
Apr 27 12:13:26 awsom kernel: [13340.505694] smsdvb_hotplug: success
Apr 27 12:13:26 awsom kernel: [13340.510158] smscore_init_ir: IR port has not been detected
Apr 27 12:13:26 awsom kernel: [13340.515628] smscore_start_device: device ee69e400 started, rc 0
Apr 27 12:13:26 awsom kernel: [13340.520064] smsusb_init_device: device 0xed8d3000 created
Apr 27 12:13:26 awsom kernel: [13340.522708] smsusb_probe: rc 0

(scanning started)

Apr 27 12:13:45 awsom kernel: [13359.589096] sms_board_dvb3_event: DVB3_EVENT_INIT
Apr 27 12:13:45 awsom kernel: [13359.598219] smsdvb_get_tune_settings: 
Apr 27 12:13:45 awsom kernel: [13359.606804] smsdvb_isdbt_set_frontend: smsdvb_isdbt_set_frontend: freq 473142857 segwidth 1 segindex 0
Apr 27 12:13:45 awsom kernel: [13359.606820] 
Apr 27 12:13:45 awsom kernel: [13359.613463] smsusb_sendrequest: sending MSG_SMS_ISDBT_TUNE_REQ(776) size: 24
Apr 27 12:13:45 awsom kernel: [13359.619781] smsusb_onresponse: received MSG_SMS_ISDBT_TUNE_RES(777) size: 12
Apr 27 12:13:45 awsom kernel: [13359.625534] smsdvb_sendrequest_and_wait: RF-> wait_for_completion_timeout
Apr 27 12:13:45 awsom kernel: [13359.629994] smscore_onresponse: 
Apr 27 12:13:45 awsom kernel: [13359.630002] data rate 180 bytes/secs
Apr 27 12:13:45 awsom kernel: [13359.635233] smsdvb_onresponse: ->RF smsdvb_onresponse: msgType: 777
Apr 27 12:13:45 awsom kernel: [13359.639947] smsdvb_onresponse: ->RF  - MSG_SMS_ISDBT_TUNE_RES
Apr 27 12:13:45 awsom kernel: [13359.646219] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Apr 27 12:13:45 awsom kernel: [13359.653164] smsdvb_sendrequest_and_wait: RF-> wait_for_completion_timeout
Apr 27 12:13:46 awsom kernel: [13360.045830] smsusb_onresponse: received MSG_SMS_NO_SIGNAL_IND(828) size: 8
Apr 27 12:13:46 awsom kernel: [13360.051071] smsdvb_onresponse: ->RF smsdvb_onresponse: msgType: 828
Apr 27 12:13:46 awsom kernel: [13360.055000] smsdvb_onresponse: MSG_SMS_NO_SIGNAL_IND

Apr 27 12:13:46 awsom kernel: [13360.059105] sms_board_dvb3_event: DVB3_EVENT_FE_UNLOCK     <<<<<<<<<<<<<<<<<<<

Apr 27 12:13:47 awsom kernel: [13361.656042] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Apr 27 12:13:47 awsom kernel: [13361.663340] smsdvb_sendrequest_and_wait: RF-> wait_for_completion_timeout
Apr 27 12:13:49 awsom kernel: [13363.666068] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
Apr 27 12:13:49 awsom kernel: [13363.673174] smsdvb_sendrequest_and_wait: RF-> wait_for_completion_timeout


I couldn’t find detailed description about all events, but DVB3_EVENT_FE_UNLOCK should happen in this point?

GET_STATISTICS_REQ before this point returns MSG_SMS_NO_SIGNAL_IND   but after this point we have always timeout.

Thank you guys!

Regards,
 - Roberto



root@awsom:~# dvbv5-scan freq.conf 
INFO     Scanning frequency #1 473142857
ERROR    FE_READ_STATUS: Timer expired
ERROR: dvb_fe_get_stats failed (Timer expired)
ERROR    Error: no adapter status
ERROR    FE_READ_STATUS: Timer expired
ERROR: dvb_fe_get_stats failed (Timer expired)
ERROR    Error: no adapter status
ERROR    FE_READ_STATUS: Timer expired
ERROR: dvb_fe_get_stats failed (Timer expired)
ERROR    Error: no adapter status



Em 27/04/2014, à(s) 10:00, Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:

> Em Sun, 27 Apr 2014 09:31:17 -0300
> Roberto Alcantara <roberto@eletronica.org> escreveu:
> 
>> Hello,
>> 
>> After a lot of tries with a few commits I obtained an version from siano drivers that loads fine in my 3.4.75.sun7i kernel @A20 device.
> 
> This message looks weird:
> 	[ 1267.803903] data rate 0 bytes/secs
> 
> 
> I’m using checkout from 2a7643159d commit.
>> 
>> Firmware is loading without any issue reported. But when I try to scan with dvbv5-scan I see:
>> 
>> root@awsom:~# dvbv5-scan freq.conf 
>> INFO     Scanning frequency #1 473142857
>> ERROR    FE_READ_STATUS: Timer expired
>> ERROR: dvb_fe_get_stats failed (Timer expired)
>> ERROR    Error: no adapter status
>> ERROR    FE_READ_STATUS: Timer expired
>> ERROR: dvb_fe_get_stats failed (Timer expired)
>> ERROR    Error: no adapter status
>> ERROR    FE_READ_STATUS: Timer expired
>> ERROR: dvb_fe_get_stats failed (Timer expired)
>> ERROR    Error: no adapter status
>> 
>> In my desktop using same firmware I can scan without this errors.  I tried with device directly connected and via usb powered hub with same results.
> 
> You should search for ETIME at the Siano driver. There are lots of
> cases where this is returned at:
> 	drivers/media/common/siano/smscoreapi.c
> 
> Probably, it is due to those:
>> [ 1050.516057] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
>> [ 1052.516059] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
>> [ 1054.516049] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
>> [ 1056.516057] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
>> [ 1058.516047] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
> 
> I'm not seeing any receive packet from those requested stats.
> 
>> 
>> Did you have any tips for debug this error? Any ideas will be appreciated :-)
> 
> I suspect that this is due to driver's bad backport to Kernel 3.4.
> 
> Another possibility would be some troubles with URB settings or with the USB
> driver.
> 
> Regards,
> Mauro
> 
>> Thank you very much!
>> 
>> - Roberto
>> 
>> 
>> dmesg:
>> 
>> [    6.012466] init: plymouth-splash main process (271) terminated with status 2
>> [    6.301960] init: bluetooth main process (231) terminated with status 1
>> [    6.359855] init: bluetooth main process ended, respawning
>> [    6.706961] smsusb_probe: interface number 0
>> [    6.709849] smsusb_probe: smsusb_probe 0
>> [    6.764522] smsusb_probe: endpoint 0 81 02 512
>> [    6.825161] smsusb_probe: endpoint 1 02 02 512
>> [    6.863769] smsusb_init_device: in_ep = 81, out_ep = 02
>> [    6.927804] smscore_register_device: allocated 50 buffers
>> [    6.932445] smscore_register_device: device ee6a7c00 created
>> [    7.040405] smsusb_init_device: smsusb_start_streaming(...).
>> [    7.158579] smscore_set_device_mode: set device mode to 6
>> [    7.212493] smsusb_sendrequest: sending MSG_SMS_GET_VERSION_EX_REQ(668) size: 8
>> [    7.275489] smsusb_onresponse: received MSG_SMS_GET_VERSION_EX_RES(669) size: 100
>> [    7.280571] smscore_onresponse: Firmware id 255 prots 0x0 ver 8.1
>> [    7.289832] smscore_get_fw_filename: trying to get fw name from sms_boards board_id 18 mode 6
>> [    7.362775] smscore_get_fw_filename: cannot find fw name in sms_boards, getting from lookup table mode 6 type 7
>> [    7.425728] smscore_load_firmware_from_file: Firmware name: isdbt_rio.inp
>> [    7.492292] smscore_load_firmware_from_file: read fw isdbt_rio.inp, buffer size=0x14f50
>> [    7.520049] smscore_load_firmware_family2: loading FW to addr 0x40260 size 85828
>> [    7.531771] smsusb_sendrequest: sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
>> [    7.546317] smsusb_onresponse: received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
>> [    7.556369] smsusb_sendrequest: sending MSG_SMS_DATA_DOWNLOAD_REQ(660) size: 252
>> [    7.572398] smsusb_onresponse: received MSG_SMS_DATA_DOWNLOAD_RES(661) size: 12
>> ...
>> [ 1037.808015] smscore_set_device_mode: firmware download success
>> [ 1037.814104] smsusb_sendrequest: sending MSG_SMS_INIT_DEVICE_REQ(578) size: 12
>> [ 1037.820918] smsusb_onresponse: received MSG_SMS_INIT_DEVICE_RES(579) size: 12
>> [ 1037.827058] smsusb_sendrequest: sending MSG_SMS_INIT_DEVICE_REQ(578) size: 12
>> [ 1037.833273] smsusb_onresponse: received MSG_SMS_INIT_DEVICE_RES(579) size: 12
>> [ 1037.838957] smscore_set_device_mode: Success setting device mode.
>> [ 1037.844360] DVB: registering new adapter (Siano Rio Digital Receiver)
>> [ 1037.852324] DVB: registering adapter 0 frontend 0 (Siano Mobile Digital MDTV Receiver)...
>> [ 1037.856897] smscore_register_client: eccd2800 693 1
>> [ 1037.861345] smscore_init_ir: IR port has not been detected
>> [ 1037.866723] smscore_start_device: device ee575c00 started, rc 0
>> [ 1037.871092] smsusb_init_device: device 0xeccd2000 created
>> [ 1037.873514] smsusb_probe: rc 0
>> [ 1048.492613] smsusb_sendrequest: sending MSG_SMS_ISDBT_TUNE_REQ(776) size: 24
>> [ 1048.499073] smsusb_onresponse: received MSG_SMS_ISDBT_TUNE_RES(777) size: 12
>> [ 1048.503532] smscore_onresponse: 
>> [ 1048.503540] data rate 275 bytes/secs
>> [ 1048.509963] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
>> [ 1048.926409] smsusb_onresponse: received MSG_SMS_NO_SIGNAL_IND(828) size: 8
>> [ 1050.516057] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
>> [ 1052.516059] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
>> [ 1054.516049] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
>> [ 1056.516057] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
>> [ 1058.516047] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
>> [ 1075.740431] smsusb_sendrequest: sending MSG_SMS_ISDBT_TUNE_REQ(776) size: 24
>> [ 1075.747999] smsusb_onresponse: received MSG_SMS_ISDBT_TUNE_RES(777) size: 12
>> [ 1075.752285] smscore_onresponse: 
>> [ 1075.752293] data rate 0 bytes/secs
>> [ 1075.759951] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
>> [ 1075.941272] smsusb_onresponse: received MSG_SMS_NO_SIGNAL_IND(828) size: 8
>> [ 1077.766050] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
>> [ 1135.457780] smsusb_sendrequest: sending MSG_SMS_ISDBT_TUNE_REQ(776) size: 24
>> [ 1135.463989] smsusb_onresponse: received MSG_SMS_ISDBT_TUNE_RES(777) size: 12
>> [ 1135.468278] smscore_onresponse: 
>> [ 1135.468286] data rate 0 bytes/secs
>> [ 1135.474758] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
>> [ 1135.657430] smsusb_onresponse: received MSG_SMS_NO_SIGNAL_IND(828) size: 8
>> [ 1137.496749] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
>> [ 1139.496050] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
>> [ 1141.496582] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
>> [ 1267.793252] smsusb_sendrequest: sending MSG_SMS_ISDBT_TUNE_REQ(776) size: 24
>> [ 1267.799608] smsusb_onresponse: received MSG_SMS_ISDBT_TUNE_RES(777) size: 12
>> [ 1267.803895] smscore_onresponse: 
>> [ 1267.803903] data rate 0 bytes/secs
>> [ 1267.810356] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
>> [ 1267.992273] smsusb_onresponse: received MSG_SMS_NO_SIGNAL_IND(828) size: 8
>> [ 1269.816058] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
>> [ 1271.816059] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
>> [ 1273.816488] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
>> [ 1275.816050] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
>> [ 1277.816965] smsusb_sendrequest: sending MSG_SMS_GET_STATISTICS_REQ(615) size: 8
>> 
>> 
>> 
>> root@awsom:~# lsmod
>> Module                  Size  Used by
>> smsdvb                 13909  0 
>> disp_ump                 854  0 
>> smsusb                 10021  0 
>> smsmdtv                43874  2 smsdvb,smsusb
>> mali_drm                2638  0 
>> mali                  116265  0 
>> ump                    56392  2 disp_ump,mali
>> lcd                     3646  0 
>> root@awsom:~# 
>> 
>> 
>> 
>> 
>> root@awsom:~# lsusb -v
>> 
>> Bus 001 Device 005: ID 187f:0600 Siano Mobile Silicon 
>> Device Descriptor:
>>  bLength                18
>>  bDescriptorType         1
>>  bcdUSB               2.00
>>  bDeviceClass            0 (Defined at Interface level)
>>  bDeviceSubClass         0 
>>  bDeviceProtocol         0 
>>  bMaxPacketSize0        64
>>  idVendor           0x187f Siano Mobile Silicon
>>  idProduct          0x0600 
>>  bcdDevice            0.08
>>  iManufacturer           1 MDTV Receiver
>>  iProduct                2 MDTV Receiver
>>  iSerial                 0 
>>  bNumConfigurations      1
>>  Configuration Descriptor:
>>    bLength                 9
>>    bDescriptorType         2
>>    wTotalLength           32
>>    bNumInterfaces          1
>>    bConfigurationValue     1
>>    iConfiguration          0 
>>    bmAttributes         0x80
>>      (Bus Powered)
>>    MaxPower              100mA
>>    Interface Descriptor:
>>      bLength                 9
>>      bDescriptorType         4
>>      bInterfaceNumber        0
>>      bAlternateSetting       0
>>      bNumEndpoints           2
>>      bInterfaceClass       255 Vendor Specific Class
>>      bInterfaceSubClass    255 Vendor Specific Subclass
>>      bInterfaceProtocol    255 Vendor Specific Protocol
>>      iInterface              0 
>>      Endpoint Descriptor:
>>        bLength                 7
>>        bDescriptorType         5
>>        bEndpointAddress     0x81  EP 1 IN
>>        bmAttributes            2
>>          Transfer Type            Bulk
>>          Synch Type               None
>>          Usage Type               Data
>>        wMaxPacketSize     0x0200  1x 512 bytes
>>        bInterval               0
>>      Endpoint Descriptor:
>>        bLength                 7
>>        bDescriptorType         5
>>        bEndpointAddress     0x02  EP 2 OUT
>>        bmAttributes            2
>>          Transfer Type            Bulk
>>          Synch Type               None
>>          Usage Type               Data
>>        wMaxPacketSize     0x0200  1x 512 bytes
>>        bInterval               0
>> Device Qualifier (for other device speed):
>>  bLength                10
>>  bDescriptorType         6
>>  bcdUSB               2.00
>>  bDeviceClass          255 Vendor Specific Class
>>  bDeviceSubClass       255 Vendor Specific Subclass
>>  bDeviceProtocol       255 Vendor Specific Protocol
>>  bMaxPacketSize0        64
>>  bNumConfigurations      1
>> Device Status:     0x0000
>>  (Bus Powered)
>> 
>> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>> Device Descriptor:
>>  bLength                18
>>  bDescriptorType         1
>>  bcdUSB               2.00
>>  bDeviceClass            9 Hub
>>  bDeviceSubClass         0 Unused
>>  bDeviceProtocol         0 Full speed (or root) hub
>>  bMaxPacketSize0        64
>>  idVendor           0x1d6b Linux Foundation
>>  idProduct          0x0002 2.0 root hub
>>  bcdDevice            3.04
>>  iManufacturer           3 Linux 3.4.75.sun7i_CRAFF+ ehci_hcd
>>  iProduct                2 SW USB2.0 'Enhanced' Host Controller (EHCI) Driver
>>  iSerial                 1 sw-ehci
>>  bNumConfigurations      1
>>  Configuration Descriptor:
>>    bLength                 9
>>    bDescriptorType         2
>>    wTotalLength           25
>>    bNumInterfaces          1
>>    bConfigurationValue     1
>>    iConfiguration          0 
>>    bmAttributes         0xe0
>>      Self Powered
>>      Remote Wakeup
>>    MaxPower                0mA
>>    Interface Descriptor:
>>      bLength                 9
>>      bDescriptorType         4
>>      bInterfaceNumber        0
>>      bAlternateSetting       0
>>      bNumEndpoints           1
>>      bInterfaceClass         9 Hub
>>      bInterfaceSubClass      0 Unused
>>      bInterfaceProtocol      0 Full speed (or root) hub
>>      iInterface              0 
>>      Endpoint Descriptor:
>>        bLength                 7
>>        bDescriptorType         5
>>        bEndpointAddress     0x81  EP 1 IN
>>        bmAttributes            3
>>          Transfer Type            Interrupt
>>          Synch Type               None
>>          Usage Type               Data
>>        wMaxPacketSize     0x0004  1x 4 bytes
>>        bInterval              12
>> Hub Descriptor:
>>  bLength               9
>>  bDescriptorType      41
>>  nNbrPorts             1
>>  wHubCharacteristic 0x000a
>>    No power switching (usb 1.0)
>>    Per-port overcurrent protection
>>  bPwrOn2PwrGood       10 * 2 milli seconds
>>  bHubContrCurrent      0 milli Ampere
>>  DeviceRemovable    0x00
>>  PortPwrCtrlMask    0xff
>> Hub Port Status:
>>   Port 1: 0000.0503 highspeed power enable connect
>> Device Status:     0x0001
>>  Self Powered
>> 
>> Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Device Descriptor:
>>  bLength                18
>>  bDescriptorType         1
>>  bcdUSB               1.10
>>  bDeviceClass            9 Hub
>>  bDeviceSubClass         0 Unused
>>  bDeviceProtocol         0 Full speed (or root) hub
>>  bMaxPacketSize0        64
>>  idVendor           0x1d6b Linux Foundation
>>  idProduct          0x0001 1.1 root hub
>>  bcdDevice            3.04
>>  iManufacturer           3 Linux 3.4.75.sun7i_CRAFF+ ohci_hcd
>>  iProduct                2 SW USB2.0 'Open' Host Controller (OHCI) Driver
>>  iSerial                 1 sw-ohci
>>  bNumConfigurations      1
>>  Configuration Descriptor:
>>    bLength                 9
>>    bDescriptorType         2
>>    wTotalLength           25
>>    bNumInterfaces          1
>>    bConfigurationValue     1
>>    iConfiguration          0 
>>    bmAttributes         0xe0
>>      Self Powered
>>      Remote Wakeup
>>    MaxPower                0mA
>>    Interface Descriptor:
>>      bLength                 9
>>      bDescriptorType         4
>>      bInterfaceNumber        0
>>      bAlternateSetting       0
>>      bNumEndpoints           1
>>      bInterfaceClass         9 Hub
>>      bInterfaceSubClass      0 Unused
>>      bInterfaceProtocol      0 Full speed (or root) hub
>>      iInterface              0 
>>      Endpoint Descriptor:
>>        bLength                 7
>>        bDescriptorType         5
>>        bEndpointAddress     0x81  EP 1 IN
>>        bmAttributes            3
>>          Transfer Type            Interrupt
>>          Synch Type               None
>>          Usage Type               Data
>>        wMaxPacketSize     0x0002  1x 2 bytes
>>        bInterval             255
>> Hub Descriptor:
>>  bLength               9
>>  bDescriptorType      41
>>  nNbrPorts             1
>>  wHubCharacteristic 0x0012
>>    No power switching (usb 1.0)
>>    No overcurrent protection
>>  bPwrOn2PwrGood        2 * 2 milli seconds
>>  bHubContrCurrent      0 milli Ampere
>>  DeviceRemovable    0x00
>>  PortPwrCtrlMask    0xff
>> Hub Port Status:
>>   Port 1: 0000.0100 power
>> Device Status:     0x0001
>>  Self Powered
>> 
>> Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>> Device Descriptor:
>>  bLength                18
>>  bDescriptorType         1
>>  bcdUSB               2.00
>>  bDeviceClass            9 Hub
>>  bDeviceSubClass         0 Unused
>>  bDeviceProtocol         0 Full speed (or root) hub
>>  bMaxPacketSize0        64
>>  idVendor           0x1d6b Linux Foundation
>>  idProduct          0x0002 2.0 root hub
>>  bcdDevice            3.04
>>  iManufacturer           3 Linux 3.4.75.sun7i_CRAFF+ ehci_hcd
>>  iProduct                2 SW USB2.0 'Enhanced' Host Controller (EHCI) Driver
>>  iSerial                 1 sw-ehci
>>  bNumConfigurations      1
>>  Configuration Descriptor:
>>    bLength                 9
>>    bDescriptorType         2
>>    wTotalLength           25
>>    bNumInterfaces          1
>>    bConfigurationValue     1
>>    iConfiguration          0 
>>    bmAttributes         0xe0
>>      Self Powered
>>      Remote Wakeup
>>    MaxPower                0mA
>>    Interface Descriptor:
>>      bLength                 9
>>      bDescriptorType         4
>>      bInterfaceNumber        0
>>      bAlternateSetting       0
>>      bNumEndpoints           1
>>      bInterfaceClass         9 Hub
>>      bInterfaceSubClass      0 Unused
>>      bInterfaceProtocol      0 Full speed (or root) hub
>>      iInterface              0 
>>      Endpoint Descriptor:
>>        bLength                 7
>>        bDescriptorType         5
>>        bEndpointAddress     0x81  EP 1 IN
>>        bmAttributes            3
>>          Transfer Type            Interrupt
>>          Synch Type               None
>>          Usage Type               Data
>>        wMaxPacketSize     0x0004  1x 4 bytes
>>        bInterval              12
>> Hub Descriptor:
>>  bLength               9
>>  bDescriptorType      41
>>  nNbrPorts             1
>>  wHubCharacteristic 0x000a
>>    No power switching (usb 1.0)
>>    Per-port overcurrent protection
>>  bPwrOn2PwrGood       10 * 2 milli seconds
>>  bHubContrCurrent      0 milli Ampere
>>  DeviceRemovable    0x00
>>  PortPwrCtrlMask    0xff
>> Hub Port Status:
>>   Port 1: 0000.0100 power
>> Device Status:     0x0001
>>  Self Powered
>> 
>> Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
>> Device Descriptor:
>>  bLength                18
>>  bDescriptorType         1
>>  bcdUSB               1.10
>>  bDeviceClass            9 Hub
>>  bDeviceSubClass         0 Unused
>>  bDeviceProtocol         0 Full speed (or root) hub
>>  bMaxPacketSize0        64
>>  idVendor           0x1d6b Linux Foundation
>>  idProduct          0x0001 1.1 root hub
>>  bcdDevice            3.04
>>  iManufacturer           3 Linux 3.4.75.sun7i_CRAFF+ ohci_hcd
>>  iProduct                2 SW USB2.0 'Open' Host Controller (OHCI) Driver
>>  iSerial                 1 sw-ohci
>>  bNumConfigurations      1
>>  Configuration Descriptor:
>>    bLength                 9
>>    bDescriptorType         2
>>    wTotalLength           25
>>    bNumInterfaces          1
>>    bConfigurationValue     1
>>    iConfiguration          0 
>>    bmAttributes         0xe0
>>      Self Powered
>>      Remote Wakeup
>>    MaxPower                0mA
>>    Interface Descriptor:
>>      bLength                 9
>>      bDescriptorType         4
>>      bInterfaceNumber        0
>>      bAlternateSetting       0
>>      bNumEndpoints           1
>>      bInterfaceClass         9 Hub
>>      bInterfaceSubClass      0 Unused
>>      bInterfaceProtocol      0 Full speed (or root) hub
>>      iInterface              0 
>>      Endpoint Descriptor:
>>        bLength                 7
>>        bDescriptorType         5
>>        bEndpointAddress     0x81  EP 1 IN
>>        bmAttributes            3
>>          Transfer Type            Interrupt
>>          Synch Type               None
>>          Usage Type               Data
>>        wMaxPacketSize     0x0002  1x 2 bytes
>>        bInterval             255
>> Hub Descriptor:
>>  bLength               9
>>  bDescriptorType      41
>>  nNbrPorts             1
>>  wHubCharacteristic 0x0012
>>    No power switching (usb 1.0)
>>    No overcurrent protection
>>  bPwrOn2PwrGood        2 * 2 milli seconds
>>  bHubContrCurrent      0 milli Ampere
>>  DeviceRemovable    0x00
>>  PortPwrCtrlMask    0xff
>> Hub Port Status:
>>   Port 1: 0000.0100 power
>> Device Status:     0x0001
>>  Self Powered
>> root@awsom:~# 
>> 
>> 
> 
> 
> -- 
> 
> Cheers,
> Mauro

