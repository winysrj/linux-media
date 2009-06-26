Return-path: <linux-media-owner@vger.kernel.org>
Received: from node03.cambriumhosting.nl ([217.19.16.164]:36578 "EHLO
	node03.cambriumhosting.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZFZIHJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 04:07:09 -0400
Received: from localhost (localhost [127.0.0.1])
	by node03.cambriumhosting.nl (Postfix) with ESMTP id 19689B00005E
	for <linux-media@vger.kernel.org>; Fri, 26 Jun 2009 10:07:11 +0200 (CEST)
Received: from node03.cambriumhosting.nl ([127.0.0.1])
	by localhost (node03.cambriumhosting.nl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SWp47uiP4W4m for <linux-media@vger.kernel.org>;
	Fri, 26 Jun 2009 10:07:09 +0200 (CEST)
Received: from ashley.powercraft.nl (84-245-3-195.dsl.cambrium.nl [84.245.3.195])
	by node03.cambriumhosting.nl (Postfix) with ESMTP id 396C4B00005C
	for <linux-media@vger.kernel.org>; Fri, 26 Jun 2009 10:07:09 +0200 (CEST)
Received: from [192.168.1.185] (unknown [192.168.1.185])
	by ashley.powercraft.nl (Postfix) with ESMTPSA id CB90D23BC51F
	for <linux-media@vger.kernel.org>; Fri, 26 Jun 2009 10:07:08 +0200 (CEST)
Message-ID: <4A4481AC.4050302@powercraft.nl>
Date: Fri, 26 Jun 2009 10:07:08 +0200
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Afatech AF9013 DVB-T not working with mplayer radio streams
Content-Type: multipart/mixed;
 boundary="------------060005060602060900040309"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060005060602060900040309
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi all,

Because i now use a new kernel and new mplayer versions I did some
testing again on one of my long standing issues.

My Afatech AF9015 DVB-T USB2.0 stick does not work with mplayer, other
em28xx devices do work with mplayer.

Would somebody be willing to do some tests and see if mplayers works on
your devices?

Debian 2.6.30-1

/usr/bin/mplayer -identify -v -dvbin timeout=10 dvb://"3FM(Digitenne)"

See the attachments for full details.

Best regards,

Jelle de Jong

--------------060005060602060900040309
Content-Type: text/x-log;
 name="device1.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="device1.log"

$ dmesg
[ 1179.756075] usb 1-2: new high speed USB device using ehci_hcd and address 7
[ 1179.892943] usb 1-2: New USB device found, idVendor=15a4, idProduct=9016
[ 1179.892958] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 1179.892969] usb 1-2: Product: DVB-T
[ 1179.892978] usb 1-2: Manufacturer: Afatech
[ 1179.893314] usb 1-2: configuration #1 chosen from 1 choice
[ 1179.917431] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in cold state, will try to load a firmware
[ 1179.917458] usb 1-2: firmware: requesting dvb-usb-af9015.fw
[ 1179.955337] dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'
[ 1180.029702] dvb-usb: found a 'Afatech AF9015 DVB-T USB2.0 stick' in warm state.
[ 1180.029843] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[ 1180.030323] DVB: registering new adapter (Afatech AF9015 DVB-T USB2.0 stick)
[ 1180.445189] af9013: firmware version:4.95.0
[ 1180.450068] DVB: registering adapter 0 frontend 0 (Afatech AF9013 DVB-T)...
[ 1180.453854] MT2060: successfully identified (IF1 = 1220)
[ 1180.923942] dvb-usb: Afatech AF9015 DVB-T USB2.0 stick successfully initialized and connected.
[ 1180.942283] Afatech DVB-T: Fixing fullspeed to highspeed interval: 16 -> 8
[ 1180.943283] input: Afatech DVB-T as /devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2:1.1/input/input11
[ 1180.943730] generic-usb 0003:15A4:9016.0004: input,hidraw0: USB HID v1.01 Keyboard [Afatech DVB-T] on usb-0000:00:1d.7-2/input1

$ sudo lsusb -v -d 15a4:9016
Bus 001 Device 007: ID 15a4:9016
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x15a4
  idProduct          0x9016
  bcdDevice            2.00
  iManufacturer           1 Afatech
  iProduct                2 DVB-T
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           71
    bNumInterfaces          2
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
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      0 No Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              0
      ** UNRECOGNIZED:  09 21 01 01 00 01 22 41 00
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval              16
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


--------------060005060602060900040309
Content-Type: text/plain;
 name="mplayer4.txt"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="mplayer4.txt"

JCBjYXQgL3Byb2MvdmVyc2lvbgpMaW51eCB2ZXJzaW9uIDIuNi4zMC0xLTY4NiAoRGViaWFu
IDIuNi4zMC0xKSAod2FsZGlAZGViaWFuLm9yZykgKGdjYyB2ZXJzaW9uIDQuMy4zIChEZWJp
YW4gNC4zLjMtMTEpICkgIzEgU01QIFN1biBKdW4gMTQgMTY6MTE6MzIgVVRDIDIwMDkKCi0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLQoKJCAvdXNyL2Jpbi9tcGxheWVyIC1pZGVudGlmeSAtdiAtZHZi
aW4gdGltZW91dD0xMCBkdmI6Ly8iM0ZNKERpZ2l0ZW5uZSkiCk1QbGF5ZXIgZGV2LVNWTi1y
MjkyNDFDUFUgdmVuZG9yIG5hbWU6IEdlbnVpbmVJbnRlbCAgbWF4IGNwdWlkIGxldmVsOiAx
MApDUFU6IEludGVsKFIpIEF0b20oVE0pIENQVSBOMjcwICAgQCAxLjYwR0h6IChGYW1pbHk6
IDYsIE1vZGVsOiAyOCwgU3RlcHBpbmc6IDIpCmV4dGVuZGVkIGNwdWlkLWxldmVsOiA4CmV4
dGVuZGVkIGNhY2hlLWluZm86IDMzNTg3MjY0CkRldGVjdGVkIGNhY2hlLWxpbmUgc2l6ZSBp
cyA2NCBieXRlcwpUZXN0aW5nIE9TIHN1cHBvcnQgZm9yIFNTRS4uLiB5ZXMuClRlc3RzIG9m
IE9TIHN1cHBvcnQgZm9yIFNTRSBwYXNzZWQuCkNQVWZsYWdzOiAgTU1YOiAxIE1NWDI6IDEg
M0ROb3c6IDAgM0ROb3dFeHQ6IDAgU1NFOiAxIFNTRTI6IDEgU1NTRTM6IDEKQ29tcGlsZWQg
d2l0aCBydW50aW1lIENQVSBkZXRlY3Rpb24uCmdldF9wYXRoKCdjb2RlY3MuY29uZicpIC0+
ICcvaG9tZS9qZWxsZS8ubXBsYXllci9jb2RlY3MuY29uZicKUmVhZGluZyAvaG9tZS9qZWxs
ZS8ubXBsYXllci9jb2RlY3MuY29uZjogQ2FuJ3Qgb3BlbiAnL2hvbWUvamVsbGUvLm1wbGF5
ZXIvY29kZWNzLmNvbmYnOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5ClJlYWRpbmcgL2V0
Yy9tcGxheWVyL2NvZGVjcy5jb25mOiBDYW4ndCBvcGVuICcvZXRjL21wbGF5ZXIvY29kZWNz
LmNvbmYnOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5ClVzaW5nIGJ1aWx0LWluIGRlZmF1
bHQgY29kZWNzLmNvbmYuCkNvbmZpZ3VyYXRpb246IC0tcHJlZml4PS91c3IgLS1jb25mZGly
PS9ldGMvbXBsYXllciAtLWRhdGFkaXI9L3Vzci9zaGFyZS9tcGxheWVyIC0tZW5hYmxlLXht
Z2EgLS1lbmFibGUtbWdhIC0tZW5hYmxlLWpveXN0aWNrIC0tZGlzYWJsZS10cmVtb3ItaW50
ZXJuYWwgLS1sYW5ndWFnZT1hbGwgLS1lbmFibGUtbGFyZ2VmaWxlcyAtLWVuYWJsZS1tZW51
IC0tZGlzYWJsZS1saWJkdmRjc3MtaW50ZXJuYWwgLS1lbmFibGUtcmFkaW8gLS1lbmFibGUt
cmFkaW8tY2FwdHVyZSAtLWRpc2FibGUtZHZkcmVhZC1pbnRlcm5hbCAtLWRpc2FibGUtbGli
YXZ1dGlsX2EgLS1kaXNhYmxlLWxpYmF2Y29kZWNfYSAtLWRpc2FibGUtbGlicG9zdHByb2Nf
YSAtLWRpc2FibGUtbGliYXZmb3JtYXRfYSAtLWRpc2FibGUtbGlic3dzY2FsZV9hIC0tZW5h
YmxlLWxpYmFtcl9uYiAtLWVuYWJsZS1saWJhbXJfd2IgLS1lbmFibGUtbGliZGlyYWMtbGF2
YyAtLWVuYWJsZS1saWJzY2hyb2VkaW5nZXItbGF2YyAtLWVuYWJsZS14dm1jIC0td2l0aC14
dm1jbGliPVh2TUNXIC0tZW5hYmxlLXdpbjMyZGxsIC0tZW5hYmxlLXRkZnhmYiAtLWVuYWJs
ZS1zM2ZiIC0tcmVhbGNvZGVjc2Rpcj0vdXNyL2xpYi9jb2RlY3MgLS14YW5pbWNvZGVjc2Rp
cj0vdXNyL2xpYi9jb2RlY3MgLS1lbmFibGUtZ3VpIC0tZW5hYmxlLXJ1bnRpbWUtY3B1ZGV0
ZWN0aW9uCkNvbW1hbmRMaW5lOiAnLWlkZW50aWZ5JyAnLXYnICctZHZiaW4nICd0aW1lb3V0
PTEwJyAnZHZiOi8vM0ZNKERpZ2l0ZW5uZSknCmluaXRfZnJlZXR5cGUKVXNpbmcgTU1YICh3
aXRoIHRpbnkgYml0IE1NWDIpIE9wdGltaXplZCBPblNjcmVlbkRpc3BsYXkKZ2V0X3BhdGgo
J2ZvbnRzJykgLT4gJy9ob21lL2plbGxlLy5tcGxheWVyL2ZvbnRzJwpVc2luZyBuYW5vc2xl
ZXAoKSB0aW1pbmcKZ2V0X3BhdGgoJ2lucHV0LmNvbmYnKSAtPiAnL2hvbWUvamVsbGUvLm1w
bGF5ZXIvaW5wdXQuY29uZicKQ2FuJ3Qgb3BlbiBpbnB1dCBjb25maWcgZmlsZSAvaG9tZS9q
ZWxsZS8ubXBsYXllci9pbnB1dC5jb25mOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5ClBh
cnNpbmcgaW5wdXQgY29uZmlnIGZpbGUgL2V0Yy9tcGxheWVyL2lucHV0LmNvbmYKSW5wdXQg
Y29uZmlnIGZpbGUgL2V0Yy9tcGxheWVyL2lucHV0LmNvbmYgcGFyc2VkOiA5MCBiaW5kcwpP
cGVuaW5nIGpveXN0aWNrIGRldmljZSAvZGV2L2lucHV0L2pzMApDYW4ndCBvcGVuIGpveXN0
aWNrIGRldmljZSAvZGV2L2lucHV0L2pzMDogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQpD
YW4ndCBpbml0IGlucHV0IGpveXN0aWNrClNldHRpbmcgdXAgTElSQyBzdXBwb3J0Li4uCm1w
bGF5ZXI6IGNvdWxkIG5vdCBjb25uZWN0IHRvIHNvY2tldAptcGxheWVyOiBObyBzdWNoIGZp
bGUgb3IgZGlyZWN0b3J5CkZhaWxlZCB0byBvcGVuIExJUkMgc3VwcG9ydC4gWW91IHdpbGwg
bm90IGJlIGFibGUgdG8gdXNlIHlvdXIgcmVtb3RlIGNvbnRyb2wuCmdldF9wYXRoKCczRk0o
RGlnaXRlbm5lKS5jb25mJykgLT4gJy9ob21lL2plbGxlLy5tcGxheWVyLzNGTShEaWdpdGVu
bmUpLmNvbmYnCgpQbGF5aW5nIGR2YjovLzNGTShEaWdpdGVubmUpLgpnZXRfcGF0aCgnc3Vi
LycpIC0+ICcvaG9tZS9qZWxsZS8ubXBsYXllci9zdWIvJwpUVU5FUiBUWVBFIFNFRU1TIFRP
IEJFIERWQi1UCmdldF9wYXRoKCdjaGFubmVscy5jb25mLnRlcicpIC0+ICcvaG9tZS9qZWxs
ZS8ubXBsYXllci9jaGFubmVscy5jb25mLnRlcicKZ2V0X3BhdGgoJ2NoYW5uZWxzLmNvbmYn
KSAtPiAnL2hvbWUvamVsbGUvLm1wbGF5ZXIvY2hhbm5lbHMuY29uZicKQ09ORklHX1JFQUQg
RklMRTogL2hvbWUvamVsbGUvLm1wbGF5ZXIvY2hhbm5lbHMuY29uZiwgdHlwZTogMgpURVIs
IE5VTTogMCwgTlVNX0ZJRUxEUzogMTEsIE5BTUU6IE5lZGVybGFuZCAxKERpZ2l0ZW5uZSks
IEZSRVE6IDcyMjAwMDAwMCBQSURTOiAgNzAxMSAgNzAxMiAgMApURVIsIE5VTTogMSwgTlVN
X0ZJRUxEUzogMTEsIE5BTUU6IE5lZGVybGFuZCAyKERpZ2l0ZW5uZSksIEZSRVE6IDcyMjAw
MDAwMCBQSURTOiAgNzAyMSAgNzAyMiAgMApURVIsIE5VTTogMiwgTlVNX0ZJRUxEUzogMTEs
IE5BTUU6IE5lZGVybGFuZCAzKERpZ2l0ZW5uZSksIEZSRVE6IDcyMjAwMDAwMCBQSURTOiAg
NzAzMSAgNzAzMiAgMApURVIsIE5VTTogMywgTlVNX0ZJRUxEUzogMTEsIE5BTUU6IFRWIFdl
c3QoRGlnaXRlbm5lKSwgRlJFUTogNzIyMDAwMDAwIFBJRFM6ICA3MDQxICA3MDQyICAwClRF
UiwgTlVNOiA0LCBOVU1fRklFTERTOiAxMSwgTkFNRTogUmFkaW8gV2VzdChEaWdpdGVubmUp
LCBGUkVROiA3MjIwMDAwMDAgUElEUzogIDAgIDcxMTIKVEVSLCBOVU06IDUsIE5VTV9GSUVM
RFM6IDExLCBOQU1FOiBSYWRpbyAxKERpZ2l0ZW5uZSksIEZSRVE6IDcyMjAwMDAwMCBQSURT
OiAgMCAgNzEyMgpURVIsIE5VTTogNiwgTlVNX0ZJRUxEUzogMTEsIE5BTUU6IFJhZGlvIDIo
RGlnaXRlbm5lKSwgRlJFUTogNzIyMDAwMDAwIFBJRFM6ICAwICA3MTMyClRFUiwgTlVNOiA3
LCBOVU1fRklFTERTOiAxMSwgTkFNRTogM0ZNKERpZ2l0ZW5uZSksIEZSRVE6IDcyMjAwMDAw
MCBQSURTOiAgMCAgNzE0MgpURVIsIE5VTTogOCwgTlVNX0ZJRUxEUzogMTEsIE5BTUU6IFJh
ZGlvIDQoRGlnaXRlbm5lKSwgRlJFUTogNzIyMDAwMDAwIFBJRFM6ICAwICA3MTUyClRFUiwg
TlVNOiA5LCBOVU1fRklFTERTOiAxMSwgTkFNRTogUmFkaW8gNShEaWdpdGVubmUpLCBGUkVR
OiA3MjIwMDAwMDAgUElEUzogIDAgIDcxNjIKVEVSLCBOVU06IDEwLCBOVU1fRklFTERTOiAx
MSwgTkFNRTogUmFkaW8gNihEaWdpdGVubmUpLCBGUkVROiA3MjIwMDAwMDAgUElEUzogIDAg
IDcxNzIKVEVSLCBOVU06IDExLCBOVU1fRklFTERTOiAxMSwgTkFNRTogQ29uY2VydHplbmRl
cihEaWdpdGVubmUpLCBGUkVROiA3MjIwMDAwMDAgUElEUzogIDAgIDcxODIKVEVSLCBOVU06
IDEyLCBOVU1fRklFTERTOiAxMSwgTkFNRTogRnVuWChEaWdpdGVubmUpLCBGUkVROiA3MjIw
MDAwMDAgUElEUzogIDAgIDcxOTIKRFZCX0NPTkZJRywgY2FuJ3Qgb3BlbiBkZXZpY2UgL2Rl
di9kdmIvYWRhcHRlcjEvZnJvbnRlbmQwLCBza2lwcGluZwpEVkJfQ09ORklHLCBjYW4ndCBv
cGVuIGRldmljZSAvZGV2L2R2Yi9hZGFwdGVyMi9mcm9udGVuZDAsIHNraXBwaW5nCkRWQl9D
T05GSUcsIGNhbid0IG9wZW4gZGV2aWNlIC9kZXYvZHZiL2FkYXB0ZXIzL2Zyb250ZW5kMCwg
c2tpcHBpbmcKT1BFTl9EVkI6IHByb2c9M0ZNKERpZ2l0ZW5uZSksIGNhcmQ9MSwgdHlwZT0y
CgpkdmJfc3RyZWFtaW5nX3N0YXJ0KFBST0c6IDNGTShEaWdpdGVubmUpLCBDQVJEOiAxLCBG
SUxFOiAobnVsbCkpClBST0dSQU0gTlVNQkVSIDc6IG5hbWU9M0ZNKERpZ2l0ZW5uZSksIGZy
ZXE9NzIyMDAwMDAwCkRWQl9PUEVOX0RFVklDRVMoMikKT1BFTigwKSwgZmlsZSAvZGV2L2R2
Yi9hZGFwdGVyMC9kZW11eDA6IEZEPTQsIENOVD0wCk9QRU4oMSksIGZpbGUgL2Rldi9kdmIv
YWRhcHRlcjAvZGVtdXgwOiBGRD01LCBDTlQ9MQpEVkJfU0VUX0NIQU5ORUw6IG5ldyBjaGFu
bmVsIG5hbWU9M0ZNKERpZ2l0ZW5uZSksIGNhcmQ6IDAsIGNoYW5uZWwgNwpkdmJfdHVuZSBG
cmVxOiA3MjIwMDAwMDAKVFVORV9JVCwgZmRfZnJvbnRlbmQgMywgZmRfc2VjIC0xCmZyZXEg
NzIyMDAwMDAwLCBzcmF0ZSAwLCBwb2wgVXNpbmcgRFZCIGNhcmQgIkFmYXRlY2ggQUY5MDEz
IERWQi1UIgp0dW5pbmcgRFZCLVQgdG8gNzIyMDAwMDAwIEh6LCBiYW5kd2lkdGg6IDAKR2V0
dGluZyBmcm9udGVuZCBzdGF0dXMKTm90IGFibGUgdG8gbG9jayB0byB0aGUgc2lnbmFsIG9u
IHRoZSBnaXZlbiBmcmVxdWVuY3ksIHRpbWVvdXQ6IDEwCmR2Yl90dW5lLCBUVU5JTkcgRkFJ
TEVECkVSUk9SLCBDT1VMRE4nVCBTRVQgQ0hBTk5FTCAgNzogRFZCSU5fQ0xPU0UsIGNsb3Nl
KDEpLCBmZD01LCBDT1VOVD0xCkRWQklOX0NMT1NFLCBjbG9zZSgwKSwgZmQ9NCwgQ09VTlQ9
MApGYWlsZWQgdG8gb3BlbiBkdmI6Ly8zRk0oRGlnaXRlbm5lKS4KCnZvOiB4MTEgdW5pbml0
IGNhbGxlZCBidXQgWDExIG5vdCBpbml0aWFsaXplZC4uCgpFeGl0aW5nLi4uIChFbmQgb2Yg
ZmlsZSkKSURfRVhJVD1FT0YKCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQoKJCAvdXNyL2Jpbi9tcGxh
eWVyIC1pZGVudGlmeSAtdiBkdmI6Ly8iM0ZNKERpZ2l0ZW5uZSkiCk1QbGF5ZXIgZGV2LVNW
Ti1yMjkyNDFDUFUgdmVuZG9yIG5hbWU6IEdlbnVpbmVJbnRlbCAgbWF4IGNwdWlkIGxldmVs
OiAxMApDUFU6IEludGVsKFIpIEF0b20oVE0pIENQVSBOMjcwICAgQCAxLjYwR0h6IChGYW1p
bHk6IDYsIE1vZGVsOiAyOCwgU3RlcHBpbmc6IDIpCmV4dGVuZGVkIGNwdWlkLWxldmVsOiA4
CmV4dGVuZGVkIGNhY2hlLWluZm86IDMzNTg3MjY0CkRldGVjdGVkIGNhY2hlLWxpbmUgc2l6
ZSBpcyA2NCBieXRlcwpUZXN0aW5nIE9TIHN1cHBvcnQgZm9yIFNTRS4uLiB5ZXMuClRlc3Rz
IG9mIE9TIHN1cHBvcnQgZm9yIFNTRSBwYXNzZWQuCkNQVWZsYWdzOiAgTU1YOiAxIE1NWDI6
IDEgM0ROb3c6IDAgM0ROb3dFeHQ6IDAgU1NFOiAxIFNTRTI6IDEgU1NTRTM6IDEKQ29tcGls
ZWQgd2l0aCBydW50aW1lIENQVSBkZXRlY3Rpb24uCmdldF9wYXRoKCdjb2RlY3MuY29uZicp
IC0+ICcvaG9tZS9qZWxsZS8ubXBsYXllci9jb2RlY3MuY29uZicKUmVhZGluZyAvaG9tZS9q
ZWxsZS8ubXBsYXllci9jb2RlY3MuY29uZjogQ2FuJ3Qgb3BlbiAnL2hvbWUvamVsbGUvLm1w
bGF5ZXIvY29kZWNzLmNvbmYnOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5ClJlYWRpbmcg
L2V0Yy9tcGxheWVyL2NvZGVjcy5jb25mOiBDYW4ndCBvcGVuICcvZXRjL21wbGF5ZXIvY29k
ZWNzLmNvbmYnOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5ClVzaW5nIGJ1aWx0LWluIGRl
ZmF1bHQgY29kZWNzLmNvbmYuCkNvbmZpZ3VyYXRpb246IC0tcHJlZml4PS91c3IgLS1jb25m
ZGlyPS9ldGMvbXBsYXllciAtLWRhdGFkaXI9L3Vzci9zaGFyZS9tcGxheWVyIC0tZW5hYmxl
LXhtZ2EgLS1lbmFibGUtbWdhIC0tZW5hYmxlLWpveXN0aWNrIC0tZGlzYWJsZS10cmVtb3It
aW50ZXJuYWwgLS1sYW5ndWFnZT1hbGwgLS1lbmFibGUtbGFyZ2VmaWxlcyAtLWVuYWJsZS1t
ZW51IC0tZGlzYWJsZS1saWJkdmRjc3MtaW50ZXJuYWwgLS1lbmFibGUtcmFkaW8gLS1lbmFi
bGUtcmFkaW8tY2FwdHVyZSAtLWRpc2FibGUtZHZkcmVhZC1pbnRlcm5hbCAtLWRpc2FibGUt
bGliYXZ1dGlsX2EgLS1kaXNhYmxlLWxpYmF2Y29kZWNfYSAtLWRpc2FibGUtbGlicG9zdHBy
b2NfYSAtLWRpc2FibGUtbGliYXZmb3JtYXRfYSAtLWRpc2FibGUtbGlic3dzY2FsZV9hIC0t
ZW5hYmxlLWxpYmFtcl9uYiAtLWVuYWJsZS1saWJhbXJfd2IgLS1lbmFibGUtbGliZGlyYWMt
bGF2YyAtLWVuYWJsZS1saWJzY2hyb2VkaW5nZXItbGF2YyAtLWVuYWJsZS14dm1jIC0td2l0
aC14dm1jbGliPVh2TUNXIC0tZW5hYmxlLXdpbjMyZGxsIC0tZW5hYmxlLXRkZnhmYiAtLWVu
YWJsZS1zM2ZiIC0tcmVhbGNvZGVjc2Rpcj0vdXNyL2xpYi9jb2RlY3MgLS14YW5pbWNvZGVj
c2Rpcj0vdXNyL2xpYi9jb2RlY3MgLS1lbmFibGUtZ3VpIC0tZW5hYmxlLXJ1bnRpbWUtY3B1
ZGV0ZWN0aW9uCkNvbW1hbmRMaW5lOiAnLWlkZW50aWZ5JyAnLXYnICdkdmI6Ly8zRk0oRGln
aXRlbm5lKScKaW5pdF9mcmVldHlwZQpVc2luZyBNTVggKHdpdGggdGlueSBiaXQgTU1YMikg
T3B0aW1pemVkIE9uU2NyZWVuRGlzcGxheQpnZXRfcGF0aCgnZm9udHMnKSAtPiAnL2hvbWUv
amVsbGUvLm1wbGF5ZXIvZm9udHMnClVzaW5nIG5hbm9zbGVlcCgpIHRpbWluZwpnZXRfcGF0
aCgnaW5wdXQuY29uZicpIC0+ICcvaG9tZS9qZWxsZS8ubXBsYXllci9pbnB1dC5jb25mJwpD
YW4ndCBvcGVuIGlucHV0IGNvbmZpZyBmaWxlIC9ob21lL2plbGxlLy5tcGxheWVyL2lucHV0
LmNvbmY6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkKUGFyc2luZyBpbnB1dCBjb25maWcg
ZmlsZSAvZXRjL21wbGF5ZXIvaW5wdXQuY29uZgpJbnB1dCBjb25maWcgZmlsZSAvZXRjL21w
bGF5ZXIvaW5wdXQuY29uZiBwYXJzZWQ6IDkwIGJpbmRzCk9wZW5pbmcgam95c3RpY2sgZGV2
aWNlIC9kZXYvaW5wdXQvanMwCkNhbid0IG9wZW4gam95c3RpY2sgZGV2aWNlIC9kZXYvaW5w
dXQvanMwOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5CkNhbid0IGluaXQgaW5wdXQgam95
c3RpY2sKU2V0dGluZyB1cCBMSVJDIHN1cHBvcnQuLi4KbXBsYXllcjogY291bGQgbm90IGNv
bm5lY3QgdG8gc29ja2V0Cm1wbGF5ZXI6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkKRmFp
bGVkIHRvIG9wZW4gTElSQyBzdXBwb3J0LiBZb3Ugd2lsbCBub3QgYmUgYWJsZSB0byB1c2Ug
eW91ciByZW1vdGUgY29udHJvbC4KZ2V0X3BhdGgoJzNGTShEaWdpdGVubmUpLmNvbmYnKSAt
PiAnL2hvbWUvamVsbGUvLm1wbGF5ZXIvM0ZNKERpZ2l0ZW5uZSkuY29uZicKClBsYXlpbmcg
ZHZiOi8vM0ZNKERpZ2l0ZW5uZSkuCmdldF9wYXRoKCdzdWIvJykgLT4gJy9ob21lL2plbGxl
Ly5tcGxheWVyL3N1Yi8nClRVTkVSIFRZUEUgU0VFTVMgVE8gQkUgRFZCLVQKZ2V0X3BhdGgo
J2NoYW5uZWxzLmNvbmYudGVyJykgLT4gJy9ob21lL2plbGxlLy5tcGxheWVyL2NoYW5uZWxz
LmNvbmYudGVyJwpnZXRfcGF0aCgnY2hhbm5lbHMuY29uZicpIC0+ICcvaG9tZS9qZWxsZS8u
bXBsYXllci9jaGFubmVscy5jb25mJwpDT05GSUdfUkVBRCBGSUxFOiAvaG9tZS9qZWxsZS8u
bXBsYXllci9jaGFubmVscy5jb25mLCB0eXBlOiAyClRFUiwgTlVNOiAwLCBOVU1fRklFTERT
OiAxMSwgTkFNRTogTmVkZXJsYW5kIDEoRGlnaXRlbm5lKSwgRlJFUTogNzIyMDAwMDAwIFBJ
RFM6ICA3MDExICA3MDEyICAwClRFUiwgTlVNOiAxLCBOVU1fRklFTERTOiAxMSwgTkFNRTog
TmVkZXJsYW5kIDIoRGlnaXRlbm5lKSwgRlJFUTogNzIyMDAwMDAwIFBJRFM6ICA3MDIxICA3
MDIyICAwClRFUiwgTlVNOiAyLCBOVU1fRklFTERTOiAxMSwgTkFNRTogTmVkZXJsYW5kIDMo
RGlnaXRlbm5lKSwgRlJFUTogNzIyMDAwMDAwIFBJRFM6ICA3MDMxICA3MDMyICAwClRFUiwg
TlVNOiAzLCBOVU1fRklFTERTOiAxMSwgTkFNRTogVFYgV2VzdChEaWdpdGVubmUpLCBGUkVR
OiA3MjIwMDAwMDAgUElEUzogIDcwNDEgIDcwNDIgIDAKVEVSLCBOVU06IDQsIE5VTV9GSUVM
RFM6IDExLCBOQU1FOiBSYWRpbyBXZXN0KERpZ2l0ZW5uZSksIEZSRVE6IDcyMjAwMDAwMCBQ
SURTOiAgMCAgNzExMgpURVIsIE5VTTogNSwgTlVNX0ZJRUxEUzogMTEsIE5BTUU6IFJhZGlv
IDEoRGlnaXRlbm5lKSwgRlJFUTogNzIyMDAwMDAwIFBJRFM6ICAwICA3MTIyClRFUiwgTlVN
OiA2LCBOVU1fRklFTERTOiAxMSwgTkFNRTogUmFkaW8gMihEaWdpdGVubmUpLCBGUkVROiA3
MjIwMDAwMDAgUElEUzogIDAgIDcxMzIKVEVSLCBOVU06IDcsIE5VTV9GSUVMRFM6IDExLCBO
QU1FOiAzRk0oRGlnaXRlbm5lKSwgRlJFUTogNzIyMDAwMDAwIFBJRFM6ICAwICA3MTQyClRF
UiwgTlVNOiA4LCBOVU1fRklFTERTOiAxMSwgTkFNRTogUmFkaW8gNChEaWdpdGVubmUpLCBG
UkVROiA3MjIwMDAwMDAgUElEUzogIDAgIDcxNTIKVEVSLCBOVU06IDksIE5VTV9GSUVMRFM6
IDExLCBOQU1FOiBSYWRpbyA1KERpZ2l0ZW5uZSksIEZSRVE6IDcyMjAwMDAwMCBQSURTOiAg
MCAgNzE2MgpURVIsIE5VTTogMTAsIE5VTV9GSUVMRFM6IDExLCBOQU1FOiBSYWRpbyA2KERp
Z2l0ZW5uZSksIEZSRVE6IDcyMjAwMDAwMCBQSURTOiAgMCAgNzE3MgpURVIsIE5VTTogMTEs
IE5VTV9GSUVMRFM6IDExLCBOQU1FOiBDb25jZXJ0emVuZGVyKERpZ2l0ZW5uZSksIEZSRVE6
IDcyMjAwMDAwMCBQSURTOiAgMCAgNzE4MgpURVIsIE5VTTogMTIsIE5VTV9GSUVMRFM6IDEx
LCBOQU1FOiBGdW5YKERpZ2l0ZW5uZSksIEZSRVE6IDcyMjAwMDAwMCBQSURTOiAgMCAgNzE5
MgpEVkJfQ09ORklHLCBjYW4ndCBvcGVuIGRldmljZSAvZGV2L2R2Yi9hZGFwdGVyMS9mcm9u
dGVuZDAsIHNraXBwaW5nCkRWQl9DT05GSUcsIGNhbid0IG9wZW4gZGV2aWNlIC9kZXYvZHZi
L2FkYXB0ZXIyL2Zyb250ZW5kMCwgc2tpcHBpbmcKRFZCX0NPTkZJRywgY2FuJ3Qgb3BlbiBk
ZXZpY2UgL2Rldi9kdmIvYWRhcHRlcjMvZnJvbnRlbmQwLCBza2lwcGluZwpPUEVOX0RWQjog
cHJvZz0zRk0oRGlnaXRlbm5lKSwgY2FyZD0xLCB0eXBlPTIKCmR2Yl9zdHJlYW1pbmdfc3Rh
cnQoUFJPRzogM0ZNKERpZ2l0ZW5uZSksIENBUkQ6IDEsIEZJTEU6IChudWxsKSkKUFJPR1JB
TSBOVU1CRVIgNzogbmFtZT0zRk0oRGlnaXRlbm5lKSwgZnJlcT03MjIwMDAwMDAKRFZCX09Q
RU5fREVWSUNFUygyKQpPUEVOKDApLCBmaWxlIC9kZXYvZHZiL2FkYXB0ZXIwL2RlbXV4MDog
RkQ9NCwgQ05UPTAKT1BFTigxKSwgZmlsZSAvZGV2L2R2Yi9hZGFwdGVyMC9kZW11eDA6IEZE
PTUsIENOVD0xCkRWQl9TRVRfQ0hBTk5FTDogbmV3IGNoYW5uZWwgbmFtZT0zRk0oRGlnaXRl
bm5lKSwgY2FyZDogMCwgY2hhbm5lbCA3CmR2Yl90dW5lIEZyZXE6IDcyMjAwMDAwMApUVU5F
X0lULCBmZF9mcm9udGVuZCAzLCBmZF9zZWMgLTEKZnJlcSA3MjIwMDAwMDAsIHNyYXRlIDAs
IHBvbCBVc2luZyBEVkIgY2FyZCAiQWZhdGVjaCBBRjkwMTMgRFZCLVQiCnR1bmluZyBEVkIt
VCB0byA3MjIwMDAwMDAgSHosIGJhbmR3aWR0aDogMApHZXR0aW5nIGZyb250ZW5kIHN0YXR1
cwpOb3QgYWJsZSB0byBsb2NrIHRvIHRoZSBzaWduYWwgb24gdGhlIGdpdmVuIGZyZXF1ZW5j
eSwgdGltZW91dDogMzAKZHZiX3R1bmUsIFRVTklORyBGQUlMRUQKRVJST1IsIENPVUxETidU
IFNFVCBDSEFOTkVMICA3OiBEVkJJTl9DTE9TRSwgY2xvc2UoMSksIGZkPTUsIENPVU5UPTEK
RFZCSU5fQ0xPU0UsIGNsb3NlKDApLCBmZD00LCBDT1VOVD0wCkZhaWxlZCB0byBvcGVuIGR2
YjovLzNGTShEaWdpdGVubmUpLgoKdm86IHgxMSB1bmluaXQgY2FsbGVkIGJ1dCBYMTEgbm90
IGluaXRpYWxpemVkLi4KCkV4aXRpbmcuLi4gKEVuZCBvZiBmaWxlKQpJRF9FWElUPUVPRgoK

--------------060005060602060900040309--
