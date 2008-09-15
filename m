Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n45.bullet.mail.ukl.yahoo.com ([87.248.110.178])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dirk_vornheder@yahoo.de>) id 1KfLth-0003xr-Cs
	for linux-dvb@linuxtv.org; Mon, 15 Sep 2008 23:46:28 +0200
From: Dirk Vornheder <dirk_vornheder@yahoo.de>
To: linux-dvb@linuxtv.org
Date: Mon, 15 Sep 2008 23:45:37 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809152345.37786.dirk_vornheder@yahoo.de>
Subject: [linux-dvb] New unspported device AVerMedia DVB-T
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi !

I buy a new notebook HP Pavilion dv7-1070eg which includes one

AVerMedia DVB-T-Device.

lsusb shows:

Bus 003 Device 003: ID 07ca:a309 AVerMedia Technologies, Inc. 
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x07ca AVerMedia Technologies, Inc.
  idProduct          0xa309 
  bcdDevice            2.00
  iManufacturer           1 AVerMedia
  iProduct                2 A309
  iSerial                 3 300938405000000
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 
      bInterfaceProtocol      0 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x85  EP 5 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
Device Qualifier (for other device speed):
  bLength                10
  bDescriptorType         6
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)

;*******************************************************************************
; Copyright (C) AVerMedia
;*******************************************************************************

[Version]
signature="$CHICAGO$"
Class=Media
ClassGUID={4d36e96c-e325-11ce-bfc1-08002be10318}
Provider=%MfgName%
DriverVer=03/14/2008,1.0.0.43
CatalogFile=AVerAF15.cat

[DestinationDirs]
AVerAF15.CopyDrivers=10,System32\Drivers
AVerAF15.CopyFiles=10,System32

[SourceDisksNames]
1=%AVerAF15.Disc%,,,

[SourceDisksFiles]
AVerAF15.sys=1
AP6RMFP.BIN=1
AP6RMHR.BIN=1
AP6RMHV.BIN=1
AP6RMJH.BIN=1

[Manufacturer]
%MfgName%=AVerMedia

[ControlFlags]
ExcludeFromSelect=*
ExcludeFromSelect.NT=*

[AVerMedia]
%AVerAF15.DeviceDesc.A309% = AVerAF15.Device,USB\VID_07CA&PID_A309

[AVerAF15.Device.NT]
Include    = ks.inf, kscaptur.inf, bda.inf
Needs      = KS.Registration.NT,KSCAPTUR.Registration.NT,BDA.Installation.NT
DelReg	   = AVerAF15.DeleteReg
;AddReg     = AVerAF15_DemodInit.AddReg
AddReg     = AVerAF15.AddReg
CopyFiles  = AVerAF15.CopyDrivers,AVerAF15.CopyFiles

[AVerAF15.Device.NT.Services]
Addservice = AVerAF15, 0x00000002, AVerAF15.AddService

[AVerAF15.AddService]
DisplayName    = %AVerAF15.FriendlyName%
ServiceType    = %SERVICE_KERNEL_DRIVER%
StartType      = %SERVICE_DEMAND_START%
ErrorControl   = %SERVICE_ERROR_NORMAL%
ServiceBinary  = %10%\System32\Drivers\AVerAF15.sys
LoadOrderGroup = Base

[AVerAF15.CopyDrivers]
AVerAF15.sys

[AVerAF15.CopyFiles]
AP6RMFP.BIN
AP6RMHR.BIN
AP6RMHV.BIN
AP6RMJH.BIN

[AVerAF15.DeleteReg]
HKLM,System\CurrentControlSet\SERVICES\AF15BDA\DemodInit

;[AVerAF15_DemodInit.AddReg]
;HKLM,System\CurrentControlSet\SERVICES\AF15BDA\DemodInit,InitScriptPatch,
%REG_DWORD%,0x00
;HKLM,System\CurrentControlSet\SERVICES\AF15BDA\DemodInit,1,
%REG_DWORD%,0xd5,0x9b,0x08,0x01
;HKLM,System\CurrentControlSet\SERVICES\AF15BDA\DemodInit,2,
%REG_DWORD%,0xd5,0x9b,0x08,0x01

[AVerAF15.AddReg]
HKR,,DevLoader,,*ntkern
HKR,,NTMPDriver,,AVerAF15.sys
HKR,,PageOutWhenUnopened,3,01
HKLM,System\CurrentControlSet\Control\MediaCategories\{1A9333B6-3704-4b18-
A6DD-E1979FC56970}
HKLM,System\CurrentControlSet\Control\MediaCategories\{1A9333B6-3704-4b18-
A6DD-E1979FC56970},Display,0x00010001,0
HKLM,System\CurrentControlSet\Control\MediaCategories\{1A9333B6-3704-4b18-
A6DD-E1979FC56970},Name,,"Tuner Node"
HKLM,System\CurrentControlSet\Control\MediaCategories\{F65394A2-
A018-4307-8D12-35AA494A406F}
HKLM,System\CurrentControlSet\Control\MediaCategories\{F65394A2-
A018-4307-8D12-35AA494A406F},Display,0x00010001,0
HKLM,System\CurrentControlSet\Control\MediaCategories\{F65394A2-
A018-4307-8D12-35AA494A406F},Name,,"Demodulator Node"
HKLM,System\CurrentControlSet\Control\MediaCategories\{870E4D6F-77E7-4c40-
ADE3-BEF8708A9D52}
HKLM,System\CurrentControlSet\Control\MediaCategories\{870E4D6F-77E7-4c40-
ADE3-BEF8708A9D52},Display,0x00010001,0
HKLM,System\CurrentControlSet\Control\MediaCategories\{870E4D6F-77E7-4c40-
ADE3-BEF8708A9D52},Name,,"Antenna In Pin"

HKLM,System\CurrentControlSet\SERVICES\AF15BDA\Parameters,TPSLockTimes,0x00010001,60
HKLM,System\CurrentControlSet\SERVICES\AF15BDA\Parameters,IRModel,0x00010001,0x00000004
HKLM,System\CurrentControlSet\SERVICES\AF15BDA\Parameters,TunerMode,0x00010001,0x00000000
HKLM,System\CurrentControlSet\SERVICES\AF15BDA\Parameters,SelectiveSuspend,0x00010001,0x00000001
HKLM,System\CurrentControlSet\SERVICES\AF15BDA\Parameters,EnRSSI,0x00010001,0x00000001
HKLM,System\CurrentControlSet\SERVICES\AF15BDA\Parameters,SS_NormalDelayTime,0x00010001,0
HKLM,System\CurrentControlSet\SERVICES\AF15BDA\Parameters,SS_StartDelayTime,0x00010001,120000

[AVerAF15.Device.NT.Interfaces]
AddInterface=%GUID.TunerCatID%,%KSNAME_Filter%,AVerAF15.Interfaces,
AddInterface=%GUID.BdaReceiverCompID%,%KSNAME_Filter%,AVerAF15.Interfaces,
AddInterface=%GUID.BdaReceiverCtrl%,%KSNAME_Filter%,AVerAF15.Interfaces,
AddInterface=%GUID.TunerCatID%,%KSNAME_Filter2%,AVerAF152.Interfaces,
AddInterface=%GUID.BdaReceiverCompID%,%KSNAME_Filter2%,AVerAF152.Interfaces,
AddInterface=%GUID.BdaReceiverCtrl%,%KSNAME_Filter2%,AVerAF152.Interfaces,

[AVerAF15.Interfaces]
AddReg=AVerAF15.Interface.AddReg

[AVerAF152.Interfaces]
AddReg=AVerAF152.Interface.AddReg

[AVerAF15.Interface.AddReg]
HKR,,CLSID,,%AVerAF15.CLSID%
HKR,,FriendlyName,,%AVerAF15.FriendlyName%

[AVerAF152.Interface.AddReg]
HKR,,CLSID,,%AVerAF15.CLSID%
HKR,,FriendlyName,,%AVerAF152.FriendlyName%

[Strings]
MfgName						= "AVerMedia TECHNOLOGIES, Inc."
AVerAF15.CLSID				= "{17CCA71B-ECD7-11D0-B908-00A0C9223196}"
AVerAF15.Disc				= "AVerMedia DVB-T BDA Video Capture Installation Disk"
AVerAF15.DeviceDesc.A309	= "HP DVB-T TV Tuner"
AVerAF15.FriendlyName		= "HP DVB-T TV Tuner"
AVerAF152.FriendlyName		= "HP DVB-T TV Tuner"
KSNAME_Filter           = "{9B365890-165F-11D0-A195-0020AFD156E4}"
KSNAME_Filter2          = "{9B365890-165F-11D0-A195-0020AFD156E5}"

Plugin_BdaDevice        = "BDA Device Control Plug-in"
GUID.TunerCatID         = "{71985F48-1CA1-11d3-9CC8-00C04F7971E0}"
GUID.BdaReceiverCompID	= "{FD0A5AF4-B41D-11d2-9C95-00C04F7971E0}"
AMcatID                 = "{DA4E3DA0-D07D-11d0-BD50-00A0C911CE86}"
BDAReceivers            = "BDA Streaming Receiver Components"
MediaCategories         = "SYSTEM\CurrentControlSet\Control\MediaCategories"
Pin.BdaTransport        = "BDA Transport Stream"
GUID.BdaTransport       = "{78216A81-CFA8-493e-9711-36A61C08BD9D}"
GUID.BdaReceiverCtrl    = "{FD0A5AF3-B41D-11d2-9C95-00C04F7971E0}"

; ServiceType values
SERVICE_KERNEL_DRIVER       = 0x00000001
SERVICE_FILE_SYSTEM_DRIVER  = 0x00000002
SERVICE_ADAPTER             = 0x00000004
SERVICE_RECOGNIZER_DRIVER   = 0x00000008
SERVICE_WIN32_OWN_PROCESS   = 0x00000010
SERVICE_WIN32_SHARE_PROCESS = 0x00000020
SERVICE_INTERACTIVE_PROCESS = 0x00000100
SERVICE_INTERACTIVE_SHARE_PROCESS = 0x00000120

; StartType values
SERVICE_BOOT_START          = 0x00000000
SERVICE_SYSTEM_START        = 0x00000001
SERVICE_AUTO_START          = 0x00000002
SERVICE_DEMAND_START        = 0x00000003
SERVICE_DISABLED            = 0x00000004

; ErrorControl values
SERVICE_ERROR_IGNORE        = 0x00000000
SERVICE_ERROR_NORMAL        = 0x00000001
SERVICE_ERROR_SEVERE        = 0x00000002
SERVICE_ERROR_CRITICAL      = 0x00000003

; Registry types
REG_MULTI_SZ                = 0x10000
REG_EXPAND_SZ               = 0x20000
REG_DWORD                   = 0x10001

Hope this helps to get working the device under linux.

Dirk



		
___________________________________________________________ 
Telefonate ohne weitere Kosten vom PC zum PC: http://messenger.yahoo.de


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
