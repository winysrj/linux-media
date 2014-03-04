Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <maxice@gmail.com>) id 1WKu87-00034n-7K
	for linux-dvb@linuxtv.org; Tue, 04 Mar 2014 19:31:52 +0100
Received: from mail-qc0-f179.google.com ([209.85.216.179])
	by mail.tu-berlin.de (exim-4.72/mailfrontend-5) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1WKu85-00050d-82; Tue, 04 Mar 2014 19:31:50 +0100
Received: by mail-qc0-f179.google.com with SMTP id m20so5376290qcx.24
	for <linux-dvb@linuxtv.org>; Tue, 04 Mar 2014 10:31:47 -0800 (PST)
MIME-Version: 1.0
From: Robert N <maxice@gmail.com>
Date: Tue, 4 Mar 2014 23:53:02 +0530
Message-ID: <CAATZahHVMYL83jZ6-aXV4GD+HhWC0+o=O19WNAfMswo8ob6rrA@mail.gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] I'd like to donate two Analog USB TV tuners with TV
	Capture and FM
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1672632897=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1672632897==
Content-Type: multipart/alternative; boundary=001a113518320081af04f3cc0140

--001a113518320081af04f3cc0140
Content-Type: text/plain; charset=UTF-8

Dear Linux DVB hackers out there,

I have two different USB TV tuners which I could not get to work even after
patching em drivers as seen in forums. These models are quite popular in
India and perhaps asia.

Since I am not capable to make them work in GNU/Linux, I'd like to donate
them to other  hackers out there. These devices are not in mint condition
as I have opened them up.

If anyone likes to have them for developing drivers, I could send the same
free of cost if you are in India. For other countries you would have to
bear the shipping costs.

These will be available for two months after which I will dispose them off.

Here are the lsusb -v outputs for each tuner stick:

1. UMAX TV Stick / rebranded Gadmei UTV382?
Coax in TV / FM / Composite AV in

Bus 001 Device 026: ID 1f71:3301
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x1f71
  idProduct          0x3301
  bcdDevice            1.00
  iManufacturer           3 Gadmei
  iProduct                4 USB TV Box
  iSerial                 2 330000000009
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           83
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
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0000  1x 0 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
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
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               4
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       1
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x1400  3x 1024 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0100  1x 256 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x84  EP 4 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               4
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

2. Intex With FM TV Tuner / rebranded ?
Coax in TV / FM / Composite AV in

Bus 001 Device 030: ID 18ec:3280 Arkmicro Technologies Inc.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x18ec Arkmicro Technologies Inc.
  idProduct          0x3280
  bcdDevice            0.01
  iManufacturer           1 USBTVBOX
  iProduct                2 USB3280DEVICE
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           69
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
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval             100
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval             100
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       1
      bNumEndpoints           4
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0
      bInterfaceProtocol    255
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval             100
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval             100
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval             100
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes           13
          Transfer Type            Isochronous
          Synch Type               Synchronous
          Usage Type               Data
        wMaxPacketSize     0x03ff  1x 1023 bytes
        bInterval               1
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


Please feel free to contact me at maxice@gmail.com .

Kind Regards,
Robert Nediyakalaparambil

--001a113518320081af04f3cc0140
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCIgc3R5bGU9ImZvbnQtZmFt
aWx5OmFyaWFsLGhlbHZldGljYSxzYW5zLXNlcmlmO2ZvbnQtc2l6ZTpzbWFsbDtjb2xvcjpyZ2Io
NTEsNTEsNTEpIj5EZWFyIExpbnV4IERWQiBoYWNrZXJzIG91dCB0aGVyZSw8L2Rpdj48ZGl2IGNs
YXNzPSJnbWFpbF9kZWZhdWx0IiBzdHlsZT0iZm9udC1mYW1pbHk6YXJpYWwsaGVsdmV0aWNhLHNh
bnMtc2VyaWY7Zm9udC1zaXplOnNtYWxsO2NvbG9yOnJnYig1MSw1MSw1MSkiPg0KDQo8YnI+PC9k
aXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCIgc3R5bGU9ImZvbnQtZmFtaWx5OmFyaWFsLGhl
bHZldGljYSxzYW5zLXNlcmlmO2ZvbnQtc2l6ZTpzbWFsbDtjb2xvcjpyZ2IoNTEsNTEsNTEpIj5J
IGhhdmUgdHdvIGRpZmZlcmVudCBVU0IgVFYgdHVuZXJzIHdoaWNoIEkgY291bGQgbm90IGdldCB0
byB3b3JrIGV2ZW4gYWZ0ZXIgcGF0Y2hpbmcgZW0gZHJpdmVycyBhcyBzZWVuIGluIGZvcnVtcy4g
VGhlc2UgbW9kZWxzIGFyZSBxdWl0ZSBwb3B1bGFyIGluIEluZGlhIGFuZCBwZXJoYXBzIGFzaWEu
PC9kaXY+DQoNCjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiIHN0eWxlPSJmb250LWZhbWlseTph
cmlhbCxoZWx2ZXRpY2Esc2Fucy1zZXJpZjtmb250LXNpemU6c21hbGw7Y29sb3I6cmdiKDUxLDUx
LDUxKSI+PGJyPjwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiIHN0eWxlPSJmb250LWZh
bWlseTphcmlhbCxoZWx2ZXRpY2Esc2Fucy1zZXJpZjtmb250LXNpemU6c21hbGw7Y29sb3I6cmdi
KDUxLDUxLDUxKSI+DQoNClNpbmNlIEkgYW0gbm90IGNhcGFibGUgdG8gbWFrZSB0aGVtIHdvcmsg
aW4gR05VL0xpbnV4LCBJJiMzOTtkIGxpa2UgdG8gZG9uYXRlIHRoZW0gdG8gb3RoZXIgwqBoYWNr
ZXJzIG91dCB0aGVyZS4gVGhlc2UgZGV2aWNlcyBhcmUgbm90IGluIG1pbnQgY29uZGl0aW9uIGFz
IEkgaGF2ZSBvcGVuZWQgdGhlbSB1cC48L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0IiBz
dHlsZT0iZm9udC1mYW1pbHk6YXJpYWwsaGVsdmV0aWNhLHNhbnMtc2VyaWY7Zm9udC1zaXplOnNt
YWxsO2NvbG9yOnJnYig1MSw1MSw1MSkiPg0KDQo8YnI+PC9kaXY+PGRpdiBjbGFzcz0iZ21haWxf
ZGVmYXVsdCIgc3R5bGU9ImZvbnQtZmFtaWx5OmFyaWFsLGhlbHZldGljYSxzYW5zLXNlcmlmO2Zv
bnQtc2l6ZTpzbWFsbDtjb2xvcjpyZ2IoNTEsNTEsNTEpIj5JZiBhbnlvbmUgbGlrZXMgdG8gaGF2
ZSB0aGVtIGZvciBkZXZlbG9waW5nIGRyaXZlcnMsIEkgY291bGQgc2VuZCB0aGUgc2FtZSBmcmVl
IG9mIGNvc3QgaWYgeW91IGFyZSBpbiBJbmRpYS4gRm9yIG90aGVyIGNvdW50cmllcyB5b3Ugd291
bGQgaGF2ZSB0byBiZWFyIHRoZSBzaGlwcGluZyBjb3N0cy48L2Rpdj4NCg0KPGRpdiBjbGFzcz0i
Z21haWxfZGVmYXVsdCIgc3R5bGU9ImZvbnQtZmFtaWx5OmFyaWFsLGhlbHZldGljYSxzYW5zLXNl
cmlmO2ZvbnQtc2l6ZTpzbWFsbDtjb2xvcjpyZ2IoNTEsNTEsNTEpIj48YnI+PC9kaXY+PGRpdiBj
bGFzcz0iZ21haWxfZGVmYXVsdCIgc3R5bGU9ImZvbnQtZmFtaWx5OmFyaWFsLGhlbHZldGljYSxz
YW5zLXNlcmlmO2ZvbnQtc2l6ZTpzbWFsbDtjb2xvcjpyZ2IoNTEsNTEsNTEpIj4NCg0KVGhlc2Ug
d2lsbCBiZSBhdmFpbGFibGUgZm9yIHR3byBtb250aHMgYWZ0ZXIgd2hpY2ggSSB3aWxsIGRpc3Bv
c2UgdGhlbSBvZmYuPC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCIgc3R5bGU9ImZvbnQt
ZmFtaWx5OmFyaWFsLGhlbHZldGljYSxzYW5zLXNlcmlmO2ZvbnQtc2l6ZTpzbWFsbDtjb2xvcjpy
Z2IoNTEsNTEsNTEpIj48YnI+PC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCIgc3R5bGU9
ImZvbnQtZmFtaWx5OmFyaWFsLGhlbHZldGljYSxzYW5zLXNlcmlmO2ZvbnQtc2l6ZTpzbWFsbDtj
b2xvcjpyZ2IoNTEsNTEsNTEpIj4NCg0KSGVyZSBhcmUgdGhlIGxzdXNiIC12IG91dHB1dHMgZm9y
IGVhY2ggdHVuZXIgc3RpY2s6PC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCIgc3R5bGU9
ImZvbnQtZmFtaWx5OmFyaWFsLGhlbHZldGljYSxzYW5zLXNlcmlmO2ZvbnQtc2l6ZTpzbWFsbDtj
b2xvcjpyZ2IoNTEsNTEsNTEpIj48YnI+PC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCIg
c3R5bGU9ImZvbnQtZmFtaWx5OmFyaWFsLGhlbHZldGljYSxzYW5zLXNlcmlmO2ZvbnQtc2l6ZTpz
bWFsbDtjb2xvcjpyZ2IoNTEsNTEsNTEpIj4NCg0KMS4gVU1BWCBUViBTdGljayAvIHJlYnJhbmRl
ZCBHYWRtZWkgVVRWMzgyPzwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiIHN0eWxlPSJm
b250LWZhbWlseTphcmlhbCxoZWx2ZXRpY2Esc2Fucy1zZXJpZjtmb250LXNpemU6c21hbGw7Y29s
b3I6cmdiKDUxLDUxLDUxKSI+Q29heCBpbiBUViAvIEZNIC8gQ29tcG9zaXRlIEFWIGluwqA8L2Rp
dj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0IiBzdHlsZT0iZm9udC1mYW1pbHk6YXJpYWwsaGVs
dmV0aWNhLHNhbnMtc2VyaWY7Zm9udC1zaXplOnNtYWxsO2NvbG9yOnJnYig1MSw1MSw1MSkiPg0K
DQo8YnI+PC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCIgc3R5bGU9ImZvbnQtZmFtaWx5
OmFyaWFsLGhlbHZldGljYSxzYW5zLXNlcmlmO2ZvbnQtc2l6ZTpzbWFsbDtjb2xvcjpyZ2IoNTEs
NTEsNTEpIj5CdXMgMDAxIERldmljZSAwMjY6IElEIDFmNzE6MzMwMSDCoDxicj48L2Rpdj48ZGl2
IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij48Zm9udCBjb2xvcj0iIzMzMzMzMyIgZmFjZT0iYXJpYWws
IGhlbHZldGljYSwgc2Fucy1zZXJpZiI+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+DQoNCkRl
dmljZSBEZXNjcmlwdG9yOjwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPsKgIGJMZW5n
dGggwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAxODwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1
bHQiPsKgIGJEZXNjcmlwdG9yVHlwZSDCoCDCoCDCoCDCoCAxPC9kaXY+PGRpdiBjbGFzcz0iZ21h
aWxfZGVmYXVsdCI+wqAgYmNkVVNCIMKgIMKgIMKgIMKgIMKgIMKgIMKgIDIuMDA8L2Rpdj48ZGl2
IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij4NCg0KwqAgYkRldmljZUNsYXNzIMKgIMKgIMKgIMKgIMKg
IMKgMCAoRGVmaW5lZCBhdCBJbnRlcmZhY2UgbGV2ZWwpPC9kaXY+PGRpdiBjbGFzcz0iZ21haWxf
ZGVmYXVsdCI+wqAgYkRldmljZVN1YkNsYXNzIMKgIMKgIMKgIMKgIDDCoDwvZGl2PjxkaXYgY2xh
c3M9ImdtYWlsX2RlZmF1bHQiPsKgIGJEZXZpY2VQcm90b2NvbCDCoCDCoCDCoCDCoCAwwqA8L2Rp
dj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij7CoCBiTWF4UGFja2V0U2l6ZTAgwqAgwqAgwqAg
wqA2NDwvZGl2Pg0KDQo8ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij7CoCBpZFZlbmRvciDCoCDC
oCDCoCDCoCDCoCAweDFmNzHCoDwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPsKgIGlk
UHJvZHVjdCDCoCDCoCDCoCDCoCDCoDB4MzMwMcKgPC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVm
YXVsdCI+wqAgYmNkRGV2aWNlIMKgIMKgIMKgIMKgIMKgIMKgMS4wMDwvZGl2PjxkaXYgY2xhc3M9
ImdtYWlsX2RlZmF1bHQiPsKgIGlNYW51ZmFjdHVyZXIgwqAgwqAgwqAgwqAgwqAgMyBHYWRtZWk8
L2Rpdj4NCg0KPGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+wqAgaVByb2R1Y3QgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqA0IFVTQiBUViBCb3g8L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0
Ij7CoCBpU2VyaWFsIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIDIgMzMwMDAwMDAwMDA5PC9kaXY+
PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+wqAgYk51bUNvbmZpZ3VyYXRpb25zIMKgIMKgIMKg
MTwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPg0KDQrCoCBDb25maWd1cmF0aW9uIERl
c2NyaXB0b3I6PC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+wqAgwqAgYkxlbmd0aCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCA5PC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+
wqAgwqAgYkRlc2NyaXB0b3JUeXBlIMKgIMKgIMKgIMKgIDI8L2Rpdj48ZGl2IGNsYXNzPSJnbWFp
bF9kZWZhdWx0Ij7CoCDCoCB3VG90YWxMZW5ndGggwqAgwqAgwqAgwqAgwqAgODM8L2Rpdj48ZGl2
IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij4NCg0KwqAgwqAgYk51bUludGVyZmFjZXMgwqAgwqAgwqAg
wqAgwqAxPC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+wqAgwqAgYkNvbmZpZ3VyYXRp
b25WYWx1ZSDCoCDCoCAxPC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+wqAgwqAgaUNv
bmZpZ3VyYXRpb24gwqAgwqAgwqAgwqAgwqAwwqA8L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZh
dWx0Ij7CoCDCoCBibUF0dHJpYnV0ZXMgwqAgwqAgwqAgwqAgMHg4MDwvZGl2Pg0KDQo8ZGl2IGNs
YXNzPSJnbWFpbF9kZWZhdWx0Ij7CoCDCoCDCoCAoQnVzIFBvd2VyZWQpPC9kaXY+PGRpdiBjbGFz
cz0iZ21haWxfZGVmYXVsdCI+wqAgwqAgTWF4UG93ZXIgwqAgwqAgwqAgwqAgwqAgwqAgwqA1MDBt
QTwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPsKgIMKgIEludGVyZmFjZSBEZXNjcmlw
dG9yOjwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPsKgIMKgIMKgIGJMZW5ndGggwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgOTwvZGl2Pg0KDQo8ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0
Ij7CoCDCoCDCoCBiRGVzY3JpcHRvclR5cGUgwqAgwqAgwqAgwqAgNDwvZGl2PjxkaXYgY2xhc3M9
ImdtYWlsX2RlZmF1bHQiPsKgIMKgIMKgIGJJbnRlcmZhY2VOdW1iZXIgwqAgwqAgwqAgwqAwPC9k
aXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+wqAgwqAgwqAgYkFsdGVybmF0ZVNldHRpbmcg
wqAgwqAgwqAgMDwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPsKgIMKgIMKgIGJOdW1F
bmRwb2ludHMgwqAgwqAgwqAgwqAgwqAgNDwvZGl2Pg0KDQo8ZGl2IGNsYXNzPSJnbWFpbF9kZWZh
dWx0Ij7CoCDCoCDCoCBiSW50ZXJmYWNlQ2xhc3MgwqAgwqAgwqAgMjU1IFZlbmRvciBTcGVjaWZp
YyBDbGFzczwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPsKgIMKgIMKgIGJJbnRlcmZh
Y2VTdWJDbGFzcyDCoCDCoCDCoDDCoDwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPsKg
IMKgIMKgIGJJbnRlcmZhY2VQcm90b2NvbCDCoCDCoDI1NcKgPC9kaXY+PGRpdiBjbGFzcz0iZ21h
aWxfZGVmYXVsdCI+DQoNCsKgIMKgIMKgIGlJbnRlcmZhY2UgwqAgwqAgwqAgwqAgwqAgwqAgwqAw
wqA8L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij7CoCDCoCDCoCBFbmRwb2ludCBEZXNj
cmlwdG9yOjwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPsKgIMKgIMKgIMKgIGJMZW5n
dGggwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgNzwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1
bHQiPsKgIMKgIMKgIMKgIGJEZXNjcmlwdG9yVHlwZSDCoCDCoCDCoCDCoCA1PC9kaXY+DQoNCjxk
aXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPsKgIMKgIMKgIMKgIGJFbmRwb2ludEFkZHJlc3MgwqAg
wqAgMHg4MSDCoEVQIDEgSU48L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij7CoCDCoCDC
oCDCoCBibUF0dHJpYnV0ZXMgwqAgwqAgwqAgwqAgwqAgwqAxPC9kaXY+PGRpdiBjbGFzcz0iZ21h
aWxfZGVmYXVsdCI+wqAgwqAgwqAgwqAgwqAgVHJhbnNmZXIgVHlwZSDCoCDCoCDCoCDCoCDCoCDC
oElzb2Nocm9ub3VzPC9kaXY+DQo8ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij4NCsKgIMKgIMKg
IMKgIMKgIFN5bmNoIFR5cGUgwqAgwqAgwqAgwqAgwqAgwqAgwqAgTm9uZTwvZGl2PjxkaXYgY2xh
c3M9ImdtYWlsX2RlZmF1bHQiPsKgIMKgIMKgIMKgIMKgIFVzYWdlIFR5cGUgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgRGF0YTwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPsKgIMKgIMKgIMKg
IHdNYXhQYWNrZXRTaXplIMKgIMKgIDB4MDAwMCDCoDF4IDAgYnl0ZXM8L2Rpdj48ZGl2IGNsYXNz
PSJnbWFpbF9kZWZhdWx0Ij4NCg0KwqAgwqAgwqAgwqAgYkludGVydmFsIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIDE8L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij7CoCDCoCDCoCBFbmRwb2lu
dCBEZXNjcmlwdG9yOjwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPsKgIMKgIMKgIMKg
IGJMZW5ndGggwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgNzwvZGl2PjxkaXYgY2xhc3M9ImdtYWls
X2RlZmF1bHQiPsKgIMKgIMKgIMKgIGJEZXNjcmlwdG9yVHlwZSDCoCDCoCDCoCDCoCA1PC9kaXY+
DQoNCjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPsKgIMKgIMKgIMKgIGJFbmRwb2ludEFkZHJl
c3MgwqAgwqAgMHg4MiDCoEVQIDIgSU48L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij7C
oCDCoCDCoCDCoCBibUF0dHJpYnV0ZXMgwqAgwqAgwqAgwqAgwqAgwqAyPC9kaXY+PGRpdiBjbGFz
cz0iZ21haWxfZGVmYXVsdCI+wqAgwqAgwqAgwqAgwqAgVHJhbnNmZXIgVHlwZSDCoCDCoCDCoCDC
oCDCoCDCoEJ1bGs8L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij4NCg0KwqAgwqAgwqAg
wqAgwqAgU3luY2ggVHlwZSDCoCDCoCDCoCDCoCDCoCDCoCDCoCBOb25lPC9kaXY+PGRpdiBjbGFz
cz0iZ21haWxfZGVmYXVsdCI+wqAgwqAgwqAgwqAgwqAgVXNhZ2UgVHlwZSDCoCDCoCDCoCDCoCDC
oCDCoCDCoCBEYXRhPC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+wqAgwqAgwqAgwqAg
d01heFBhY2tldFNpemUgwqAgwqAgMHgwMjAwIMKgMXggNTEyIGJ5dGVzPC9kaXY+PGRpdiBjbGFz
cz0iZ21haWxfZGVmYXVsdCI+DQoNCsKgIMKgIMKgIMKgIGJJbnRlcnZhbCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCAwPC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+wqAgwqAgwqAgRW5kcG9p
bnQgRGVzY3JpcHRvcjo8L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij7CoCDCoCDCoCDC
oCBiTGVuZ3RoIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIDc8L2Rpdj48ZGl2IGNsYXNzPSJnbWFp
bF9kZWZhdWx0Ij7CoCDCoCDCoCDCoCBiRGVzY3JpcHRvclR5cGUgwqAgwqAgwqAgwqAgNTwvZGl2
Pg0KDQo8ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij7CoCDCoCDCoCDCoCBiRW5kcG9pbnRBZGRy
ZXNzIMKgIMKgIDB4ODMgwqBFUCAzIElOPC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+
wqAgwqAgwqAgwqAgYm1BdHRyaWJ1dGVzIMKgIMKgIMKgIMKgIMKgIMKgMjwvZGl2PjxkaXYgY2xh
c3M9ImdtYWlsX2RlZmF1bHQiPsKgIMKgIMKgIMKgIMKgIFRyYW5zZmVyIFR5cGUgwqAgwqAgwqAg
wqAgwqAgwqBCdWxrPC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+DQoNCsKgIMKgIMKg
IMKgIMKgIFN5bmNoIFR5cGUgwqAgwqAgwqAgwqAgwqAgwqAgwqAgTm9uZTwvZGl2PjxkaXYgY2xh
c3M9ImdtYWlsX2RlZmF1bHQiPsKgIMKgIMKgIMKgIMKgIFVzYWdlIFR5cGUgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgRGF0YTwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPsKgIMKgIMKgIMKg
IHdNYXhQYWNrZXRTaXplIMKgIMKgIDB4MDIwMCDCoDF4IDUxMiBieXRlczwvZGl2PjxkaXYgY2xh
c3M9ImdtYWlsX2RlZmF1bHQiPg0KDQrCoCDCoCDCoCDCoCBiSW50ZXJ2YWwgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgMDwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPsKgIMKgIMKgIEVuZHBv
aW50IERlc2NyaXB0b3I6PC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+wqAgwqAgwqAg
wqAgYkxlbmd0aCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCA3PC9kaXY+PGRpdiBjbGFzcz0iZ21h
aWxfZGVmYXVsdCI+wqAgwqAgwqAgwqAgYkRlc2NyaXB0b3JUeXBlIMKgIMKgIMKgIMKgIDU8L2Rp
dj4NCg0KPGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+wqAgwqAgwqAgwqAgYkVuZHBvaW50QWRk
cmVzcyDCoCDCoCAweDg0IMKgRVAgNCBJTjwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQi
PsKgIMKgIMKgIMKgIGJtQXR0cmlidXRlcyDCoCDCoCDCoCDCoCDCoCDCoDM8L2Rpdj48ZGl2IGNs
YXNzPSJnbWFpbF9kZWZhdWx0Ij7CoCDCoCDCoCDCoCDCoCBUcmFuc2ZlciBUeXBlIMKgIMKgIMKg
IMKgIMKgIMKgSW50ZXJydXB0PC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+DQoNCsKg
IMKgIMKgIMKgIMKgIFN5bmNoIFR5cGUgwqAgwqAgwqAgwqAgwqAgwqAgwqAgTm9uZTwvZGl2Pjxk
aXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPsKgIMKgIMKgIMKgIMKgIFVzYWdlIFR5cGUgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgRGF0YTwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPsKgIMKg
IMKgIMKgIHdNYXhQYWNrZXRTaXplIMKgIMKgIDB4MDA0MCDCoDF4IDY0IGJ5dGVzPC9kaXY+PGRp
diBjbGFzcz0iZ21haWxfZGVmYXVsdCI+DQoNCsKgIMKgIMKgIMKgIGJJbnRlcnZhbCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCA0PC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+wqAgwqAgSW50
ZXJmYWNlIERlc2NyaXB0b3I6PC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+wqAgwqAg
wqAgYkxlbmd0aCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCA5PC9kaXY+PGRpdiBjbGFzcz0iZ21h
aWxfZGVmYXVsdCI+wqAgwqAgwqAgYkRlc2NyaXB0b3JUeXBlIMKgIMKgIMKgIMKgIDQ8L2Rpdj4N
Cg0KPGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+wqAgwqAgwqAgYkludGVyZmFjZU51bWJlciDC
oCDCoCDCoCDCoDA8L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij7CoCDCoCDCoCBiQWx0
ZXJuYXRlU2V0dGluZyDCoCDCoCDCoCAxPC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+
wqAgwqAgwqAgYk51bUVuZHBvaW50cyDCoCDCoCDCoCDCoCDCoCA0PC9kaXY+PGRpdiBjbGFzcz0i
Z21haWxfZGVmYXVsdCI+wqAgwqAgwqAgYkludGVyZmFjZUNsYXNzIMKgIMKgIMKgIDI1NSBWZW5k
b3IgU3BlY2lmaWMgQ2xhc3M8L2Rpdj4NCg0KPGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+wqAg
wqAgwqAgYkludGVyZmFjZVN1YkNsYXNzIMKgIMKgIMKgMMKgPC9kaXY+PGRpdiBjbGFzcz0iZ21h
aWxfZGVmYXVsdCI+wqAgwqAgwqAgYkludGVyZmFjZVByb3RvY29sIMKgIMKgMjU1wqA8L2Rpdj48
ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij7CoCDCoCDCoCBpSW50ZXJmYWNlIMKgIMKgIMKgIMKg
IMKgIMKgIMKgMMKgPC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+DQoNCsKgIMKgIMKg
IEVuZHBvaW50IERlc2NyaXB0b3I6PC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+wqAg
wqAgwqAgwqAgYkxlbmd0aCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCA3PC9kaXY+PGRpdiBjbGFz
cz0iZ21haWxfZGVmYXVsdCI+wqAgwqAgwqAgwqAgYkRlc2NyaXB0b3JUeXBlIMKgIMKgIMKgIMKg
IDU8L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij7CoCDCoCDCoCDCoCBiRW5kcG9pbnRB
ZGRyZXNzIMKgIMKgIDB4ODEgwqBFUCAxIElOPC9kaXY+DQoNCjxkaXYgY2xhc3M9ImdtYWlsX2Rl
ZmF1bHQiPsKgIMKgIMKgIMKgIGJtQXR0cmlidXRlcyDCoCDCoCDCoCDCoCDCoCDCoDE8L2Rpdj48
ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij7CoCDCoCDCoCDCoCDCoCBUcmFuc2ZlciBUeXBlIMKg
IMKgIMKgIMKgIMKgIMKgSXNvY2hyb25vdXM8L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0
Ij7CoCDCoCDCoCDCoCDCoCBTeW5jaCBUeXBlIMKgIMKgIMKgIMKgIMKgIMKgIMKgIE5vbmU8L2Rp
dj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij4NCg0KwqAgwqAgwqAgwqAgwqAgVXNhZ2UgVHlw
ZSDCoCDCoCDCoCDCoCDCoCDCoCDCoCBEYXRhPC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVs
dCI+wqAgwqAgwqAgwqAgd01heFBhY2tldFNpemUgwqAgwqAgMHgxNDAwIMKgM3ggMTAyNCBieXRl
czwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPsKgIMKgIMKgIMKgIGJJbnRlcnZhbCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAxPC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+wqAg
wqAgwqAgRW5kcG9pbnQgRGVzY3JpcHRvcjo8L2Rpdj4NCg0KPGRpdiBjbGFzcz0iZ21haWxfZGVm
YXVsdCI+wqAgwqAgwqAgwqAgYkxlbmd0aCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCA3PC9kaXY+
PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+wqAgwqAgwqAgwqAgYkRlc2NyaXB0b3JUeXBlIMKg
IMKgIMKgIMKgIDU8L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij7CoCDCoCDCoCDCoCBi
RW5kcG9pbnRBZGRyZXNzIMKgIMKgIDB4ODIgwqBFUCAyIElOPC9kaXY+PGRpdiBjbGFzcz0iZ21h
aWxfZGVmYXVsdCI+DQoNCsKgIMKgIMKgIMKgIGJtQXR0cmlidXRlcyDCoCDCoCDCoCDCoCDCoCDC
oDI8L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij7CoCDCoCDCoCDCoCDCoCBUcmFuc2Zl
ciBUeXBlIMKgIMKgIMKgIMKgIMKgIMKgQnVsazwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1
bHQiPsKgIMKgIMKgIMKgIMKgIFN5bmNoIFR5cGUgwqAgwqAgwqAgwqAgwqAgwqAgwqAgTm9uZTwv
ZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPsKgIMKgIMKgIMKgIMKgIFVzYWdlIFR5cGUg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgRGF0YTwvZGl2Pg0KDQo8ZGl2IGNsYXNzPSJnbWFpbF9kZWZh
dWx0Ij7CoCDCoCDCoCDCoCB3TWF4UGFja2V0U2l6ZSDCoCDCoCAweDAyMDAgwqAxeCA1MTIgYnl0
ZXM8L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij7CoCDCoCDCoCDCoCBiSW50ZXJ2YWwg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgMDwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPsKg
IMKgIMKgIEVuZHBvaW50IERlc2NyaXB0b3I6PC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVs
dCI+DQoNCsKgIMKgIMKgIMKgIGJMZW5ndGggwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgNzwvZGl2
PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPsKgIMKgIMKgIMKgIGJEZXNjcmlwdG9yVHlwZSDC
oCDCoCDCoCDCoCA1PC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+wqAgwqAgwqAgwqAg
YkVuZHBvaW50QWRkcmVzcyDCoCDCoCAweDgzIMKgRVAgMyBJTjwvZGl2PjxkaXYgY2xhc3M9Imdt
YWlsX2RlZmF1bHQiPsKgIMKgIMKgIMKgIGJtQXR0cmlidXRlcyDCoCDCoCDCoCDCoCDCoCDCoDI8
L2Rpdj4NCg0KPGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+wqAgwqAgwqAgwqAgwqAgVHJhbnNm
ZXIgVHlwZSDCoCDCoCDCoCDCoCDCoCDCoEJ1bGs8L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZh
dWx0Ij7CoCDCoCDCoCDCoCDCoCBTeW5jaCBUeXBlIMKgIMKgIMKgIMKgIMKgIMKgIMKgIE5vbmU8
L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij7CoCDCoCDCoCDCoCDCoCBVc2FnZSBUeXBl
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIERhdGE8L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0
Ij4NCg0KwqAgwqAgwqAgwqAgd01heFBhY2tldFNpemUgwqAgwqAgMHgwMTAwIMKgMXggMjU2IGJ5
dGVzPC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+wqAgwqAgwqAgwqAgYkludGVydmFs
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIDA8L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij7C
oCDCoCDCoCBFbmRwb2ludCBEZXNjcmlwdG9yOjwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1
bHQiPsKgIMKgIMKgIMKgIGJMZW5ndGggwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgNzwvZGl2Pg0K
DQo8ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij7CoCDCoCDCoCDCoCBiRGVzY3JpcHRvclR5cGUg
wqAgwqAgwqAgwqAgNTwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPsKgIMKgIMKgIMKg
IGJFbmRwb2ludEFkZHJlc3MgwqAgwqAgMHg4NCDCoEVQIDQgSU48L2Rpdj48ZGl2IGNsYXNzPSJn
bWFpbF9kZWZhdWx0Ij7CoCDCoCDCoCDCoCBibUF0dHJpYnV0ZXMgwqAgwqAgwqAgwqAgwqAgwqAz
PC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+DQoNCsKgIMKgIMKgIMKgIMKgIFRyYW5z
ZmVyIFR5cGUgwqAgwqAgwqAgwqAgwqAgwqBJbnRlcnJ1cHQ8L2Rpdj48ZGl2IGNsYXNzPSJnbWFp
bF9kZWZhdWx0Ij7CoCDCoCDCoCDCoCDCoCBTeW5jaCBUeXBlIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IE5vbmU8L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij7CoCDCoCDCoCDCoCDCoCBVc2Fn
ZSBUeXBlIMKgIMKgIMKgIMKgIMKgIMKgIMKgIERhdGE8L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9k
ZWZhdWx0Ij4NCg0KwqAgwqAgwqAgwqAgd01heFBhY2tldFNpemUgwqAgwqAgMHgwMDQwIMKgMXgg
NjQgYnl0ZXM8L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij7CoCDCoCDCoCDCoCBiSW50
ZXJ2YWwgwqAgwqAgwqAgwqAgwqAgwqAgwqAgNDwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1
bHQiPkRldmljZSBRdWFsaWZpZXIgKGZvciBvdGhlciBkZXZpY2Ugc3BlZWQpOjwvZGl2PjxkaXYg
Y2xhc3M9ImdtYWlsX2RlZmF1bHQiPg0KwqAgYkxlbmd0aCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oDEwPC9kaXY+DQo8ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij7CoCBiRGVzY3JpcHRvclR5cGUg
wqAgwqAgwqAgwqAgNjwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPsKgIGJjZFVTQiDC
oCDCoCDCoCDCoCDCoCDCoCDCoCAyLjAwPC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+
wqAgYkRldmljZUNsYXNzIMKgIMKgIMKgIMKgIMKgIMKgMCAoRGVmaW5lZCBhdCBJbnRlcmZhY2Ug
bGV2ZWwpPC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+DQoNCsKgIGJEZXZpY2VTdWJD
bGFzcyDCoCDCoCDCoCDCoCAwwqA8L2Rpdj48ZGl2IGNsYXNzPSJnbWFpbF9kZWZhdWx0Ij7CoCBi
RGV2aWNlUHJvdG9jb2wgwqAgwqAgwqAgwqAgMMKgPC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVm
YXVsdCI+wqAgYk1heFBhY2tldFNpemUwIMKgIMKgIMKgIMKgNjQ8L2Rpdj48ZGl2IGNsYXNzPSJn
bWFpbF9kZWZhdWx0Ij7CoCBiTnVtQ29uZmlndXJhdGlvbnMgwqAgwqAgwqAxPC9kaXY+PGRpdiBj
bGFzcz0iZ21haWxfZGVmYXVsdCI+DQoNCkRldmljZSBTdGF0dXM6IMKgIMKgIDB4MDAwMDwvZGl2
PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiPsKgIChCdXMgUG93ZXJlZCk8L2Rpdj48ZGl2Pjxi
cj48L2Rpdj48L2ZvbnQ+PC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCIgc3R5bGU9ImZv
bnQtZmFtaWx5OmFyaWFsLGhlbHZldGljYSxzYW5zLXNlcmlmO2ZvbnQtc2l6ZTpzbWFsbDtjb2xv
cjpyZ2IoNTEsNTEsNTEpIj4yLiBJbnRleCBXaXRoIEZNIFRWIFR1bmVyIC8gcmVicmFuZGVkID88
YnI+DQoNCjwvZGl2PjxkaXYgY2xhc3M9ImdtYWlsX2RlZmF1bHQiIHN0eWxlPSJmb250LWZhbWls
eTphcmlhbCxoZWx2ZXRpY2Esc2Fucy1zZXJpZjtmb250LXNpemU6c21hbGw7Y29sb3I6cmdiKDUx
LDUxLDUxKSI+PGRpdiBjbGFzcz0iZ21haWxfZGVmYXVsdCI+Q29heCBpbiBUViAvIEZNIC8gQ29t
cG9zaXRlIEFWIGluwqA8L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2PjxkaXY+QnVzIDAwMSBEZXZp
Y2UgMDMwOiBJRCAxOGVjOjMyODAgQXJrbWljcm8gVGVjaG5vbG9naWVzIEluYy7CoDwvZGl2Pg0K
DQo8ZGl2PkRldmljZSBEZXNjcmlwdG9yOjwvZGl2PjxkaXY+wqAgYkxlbmd0aCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoDE4PC9kaXY+PGRpdj7CoCBiRGVzY3JpcHRvclR5cGUgwqAgwqAgwqAgwqAg
MTwvZGl2PjxkaXY+wqAgYmNkVVNCIMKgIMKgIMKgIMKgIMKgIMKgIMKgIDIuMDA8L2Rpdj48ZGl2
PsKgIGJEZXZpY2VDbGFzcyDCoCDCoCDCoCDCoCDCoCDCoDAgKERlZmluZWQgYXQgSW50ZXJmYWNl
IGxldmVsKTwvZGl2PjxkaXY+wqAgYkRldmljZVN1YkNsYXNzIMKgIMKgIMKgIMKgIDDCoDwvZGl2
Pg0KDQo8ZGl2PsKgIGJEZXZpY2VQcm90b2NvbCDCoCDCoCDCoCDCoCAwwqA8L2Rpdj48ZGl2PsKg
IGJNYXhQYWNrZXRTaXplMCDCoCDCoCDCoCDCoDY0PC9kaXY+PGRpdj7CoCBpZFZlbmRvciDCoCDC
oCDCoCDCoCDCoCAweDE4ZWMgQXJrbWljcm8gVGVjaG5vbG9naWVzIEluYy48L2Rpdj48ZGl2PsKg
IGlkUHJvZHVjdCDCoCDCoCDCoCDCoCDCoDB4MzI4MMKgPC9kaXY+PGRpdj7CoCBiY2REZXZpY2Ug
wqAgwqAgwqAgwqAgwqAgwqAwLjAxPC9kaXY+PGRpdj4NCg0KwqAgaU1hbnVmYWN0dXJlciDCoCDC
oCDCoCDCoCDCoCAxIFVTQlRWQk9YPC9kaXY+PGRpdj7CoCBpUHJvZHVjdCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoDIgVVNCMzI4MERFVklDRTwvZGl2PjxkaXY+wqAgaVNlcmlhbCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCAwwqA8L2Rpdj48ZGl2PsKgIGJOdW1Db25maWd1cmF0aW9ucyDCoCDCoCDC
oDE8L2Rpdj48ZGl2PsKgIENvbmZpZ3VyYXRpb24gRGVzY3JpcHRvcjo8L2Rpdj48ZGl2PsKgIMKg
IGJMZW5ndGggwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgOTwvZGl2Pg0KDQo8ZGl2PsKgIMKgIGJE
ZXNjcmlwdG9yVHlwZSDCoCDCoCDCoCDCoCAyPC9kaXY+PGRpdj7CoCDCoCB3VG90YWxMZW5ndGgg
wqAgwqAgwqAgwqAgwqAgNjk8L2Rpdj48ZGl2PsKgIMKgIGJOdW1JbnRlcmZhY2VzIMKgIMKgIMKg
IMKgIMKgMTwvZGl2PjxkaXY+wqAgwqAgYkNvbmZpZ3VyYXRpb25WYWx1ZSDCoCDCoCAxPC9kaXY+
PGRpdj7CoCDCoCBpQ29uZmlndXJhdGlvbiDCoCDCoCDCoCDCoCDCoDDCoDwvZGl2PjxkaXY+wqAg
wqAgYm1BdHRyaWJ1dGVzIMKgIMKgIMKgIMKgIDB4ODA8L2Rpdj4NCg0KPGRpdj7CoCDCoCDCoCAo
QnVzIFBvd2VyZWQpPC9kaXY+PGRpdj7CoCDCoCBNYXhQb3dlciDCoCDCoCDCoCDCoCDCoCDCoCDC
oDUwMG1BPC9kaXY+PGRpdj7CoCDCoCBJbnRlcmZhY2UgRGVzY3JpcHRvcjo8L2Rpdj48ZGl2PsKg
IMKgIMKgIGJMZW5ndGggwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgOTwvZGl2PjxkaXY+wqAgwqAg
wqAgYkRlc2NyaXB0b3JUeXBlIMKgIMKgIMKgIMKgIDQ8L2Rpdj48ZGl2PsKgIMKgIMKgIGJJbnRl
cmZhY2VOdW1iZXIgwqAgwqAgwqAgwqAwPC9kaXY+DQoNCjxkaXY+wqAgwqAgwqAgYkFsdGVybmF0
ZVNldHRpbmcgwqAgwqAgwqAgMDwvZGl2PjxkaXY+wqAgwqAgwqAgYk51bUVuZHBvaW50cyDCoCDC
oCDCoCDCoCDCoCAyPC9kaXY+PGRpdj7CoCDCoCDCoCBiSW50ZXJmYWNlQ2xhc3MgwqAgwqAgwqAg
MjU1IFZlbmRvciBTcGVjaWZpYyBDbGFzczwvZGl2PjxkaXY+wqAgwqAgwqAgYkludGVyZmFjZVN1
YkNsYXNzIMKgIMKgIMKgMMKgPC9kaXY+PGRpdj7CoCDCoCDCoCBiSW50ZXJmYWNlUHJvdG9jb2wg
wqAgwqAyNTXCoDwvZGl2Pg0KDQo8ZGl2PsKgIMKgIMKgIGlJbnRlcmZhY2UgwqAgwqAgwqAgwqAg
wqAgwqAgwqAwwqA8L2Rpdj48ZGl2PsKgIMKgIMKgIEVuZHBvaW50IERlc2NyaXB0b3I6PC9kaXY+
PGRpdj7CoCDCoCDCoCDCoCBiTGVuZ3RoIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIDc8L2Rpdj48
ZGl2PsKgIMKgIMKgIMKgIGJEZXNjcmlwdG9yVHlwZSDCoCDCoCDCoCDCoCA1PC9kaXY+PGRpdj7C
oCDCoCDCoCDCoCBiRW5kcG9pbnRBZGRyZXNzIMKgIMKgIDB4ODEgwqBFUCAxIElOPC9kaXY+DQoN
CjxkaXY+wqAgwqAgwqAgwqAgYm1BdHRyaWJ1dGVzIMKgIMKgIMKgIMKgIMKgIMKgMzwvZGl2Pjxk
aXY+wqAgwqAgwqAgwqAgwqAgVHJhbnNmZXIgVHlwZSDCoCDCoCDCoCDCoCDCoCDCoEludGVycnVw
dDwvZGl2PjxkaXY+wqAgwqAgwqAgwqAgwqAgU3luY2ggVHlwZSDCoCDCoCDCoCDCoCDCoCDCoCDC
oCBOb25lPC9kaXY+PGRpdj7CoCDCoCDCoCDCoCDCoCBVc2FnZSBUeXBlIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIERhdGE8L2Rpdj48ZGl2PsKgIMKgIMKgIMKgIHdNYXhQYWNrZXRTaXplIMKgIMKgIDB4
MDA0MCDCoDF4IDY0IGJ5dGVzPC9kaXY+DQoNCjxkaXY+wqAgwqAgwqAgwqAgYkludGVydmFsIMKg
IMKgIMKgIMKgIMKgIMKgIDEwMDwvZGl2PjxkaXY+wqAgwqAgwqAgRW5kcG9pbnQgRGVzY3JpcHRv
cjo8L2Rpdj48ZGl2PsKgIMKgIMKgIMKgIGJMZW5ndGggwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
NzwvZGl2PjxkaXY+wqAgwqAgwqAgwqAgYkRlc2NyaXB0b3JUeXBlIMKgIMKgIMKgIMKgIDU8L2Rp
dj48ZGl2PsKgIMKgIMKgIMKgIGJFbmRwb2ludEFkZHJlc3MgwqAgwqAgMHgwMSDCoEVQIDEgT1VU
PC9kaXY+DQoNCjxkaXY+wqAgwqAgwqAgwqAgYm1BdHRyaWJ1dGVzIMKgIMKgIMKgIMKgIMKgIMKg
MzwvZGl2PjxkaXY+wqAgwqAgwqAgwqAgwqAgVHJhbnNmZXIgVHlwZSDCoCDCoCDCoCDCoCDCoCDC
oEludGVycnVwdDwvZGl2PjxkaXY+wqAgwqAgwqAgwqAgwqAgU3luY2ggVHlwZSDCoCDCoCDCoCDC
oCDCoCDCoCDCoCBOb25lPC9kaXY+PGRpdj7CoCDCoCDCoCDCoCDCoCBVc2FnZSBUeXBlIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIERhdGE8L2Rpdj48ZGl2PsKgIMKgIMKgIMKgIHdNYXhQYWNrZXRTaXpl
IMKgIMKgIDB4MDA0MCDCoDF4IDY0IGJ5dGVzPC9kaXY+DQoNCjxkaXY+wqAgwqAgwqAgwqAgYklu
dGVydmFsIMKgIMKgIMKgIMKgIMKgIMKgIDEwMDwvZGl2PjxkaXY+wqAgwqAgSW50ZXJmYWNlIERl
c2NyaXB0b3I6PC9kaXY+PGRpdj7CoCDCoCDCoCBiTGVuZ3RoIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIDk8L2Rpdj48ZGl2PsKgIMKgIMKgIGJEZXNjcmlwdG9yVHlwZSDCoCDCoCDCoCDCoCA0PC9k
aXY+PGRpdj7CoCDCoCDCoCBiSW50ZXJmYWNlTnVtYmVyIMKgIMKgIMKgIMKgMDwvZGl2PjxkaXY+
wqAgwqAgwqAgYkFsdGVybmF0ZVNldHRpbmcgwqAgwqAgwqAgMTwvZGl2Pg0KDQo8ZGl2PsKgIMKg
IMKgIGJOdW1FbmRwb2ludHMgwqAgwqAgwqAgwqAgwqAgNDwvZGl2PjxkaXY+wqAgwqAgwqAgYklu
dGVyZmFjZUNsYXNzIMKgIMKgIMKgIDI1NSBWZW5kb3IgU3BlY2lmaWMgQ2xhc3M8L2Rpdj48ZGl2
PsKgIMKgIMKgIGJJbnRlcmZhY2VTdWJDbGFzcyDCoCDCoCDCoDDCoDwvZGl2PjxkaXY+wqAgwqAg
wqAgYkludGVyZmFjZVByb3RvY29sIMKgIMKgMjU1wqA8L2Rpdj48ZGl2PsKgIMKgIMKgIGlJbnRl
cmZhY2UgwqAgwqAgwqAgwqAgwqAgwqAgwqAwwqA8L2Rpdj4NCg0KPGRpdj7CoCDCoCDCoCBFbmRw
b2ludCBEZXNjcmlwdG9yOjwvZGl2PjxkaXY+wqAgwqAgwqAgwqAgYkxlbmd0aCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCA3PC9kaXY+PGRpdj7CoCDCoCDCoCDCoCBiRGVzY3JpcHRvclR5cGUgwqAg
wqAgwqAgwqAgNTwvZGl2PjxkaXY+wqAgwqAgwqAgwqAgYkVuZHBvaW50QWRkcmVzcyDCoCDCoCAw
eDgxIMKgRVAgMSBJTjwvZGl2PjxkaXY+wqAgwqAgwqAgwqAgYm1BdHRyaWJ1dGVzIMKgIMKgIMKg
IMKgIMKgIMKgMzwvZGl2Pg0KDQo8ZGl2PsKgIMKgIMKgIMKgIMKgIFRyYW5zZmVyIFR5cGUgwqAg
wqAgwqAgwqAgwqAgwqBJbnRlcnJ1cHQ8L2Rpdj48ZGl2PsKgIMKgIMKgIMKgIMKgIFN5bmNoIFR5
cGUgwqAgwqAgwqAgwqAgwqAgwqAgwqAgTm9uZTwvZGl2PjxkaXY+wqAgwqAgwqAgwqAgwqAgVXNh
Z2UgVHlwZSDCoCDCoCDCoCDCoCDCoCDCoCDCoCBEYXRhPC9kaXY+PGRpdj7CoCDCoCDCoCDCoCB3
TWF4UGFja2V0U2l6ZSDCoCDCoCAweDAwNDAgwqAxeCA2NCBieXRlczwvZGl2PjxkaXY+wqAgwqAg
wqAgwqAgYkludGVydmFsIMKgIMKgIMKgIMKgIMKgIMKgIDEwMDwvZGl2Pg0KDQo8ZGl2PsKgIMKg
IMKgIEVuZHBvaW50IERlc2NyaXB0b3I6PC9kaXY+PGRpdj7CoCDCoCDCoCDCoCBiTGVuZ3RoIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIDc8L2Rpdj48ZGl2PsKgIMKgIMKgIMKgIGJEZXNjcmlwdG9y
VHlwZSDCoCDCoCDCoCDCoCA1PC9kaXY+PGRpdj7CoCDCoCDCoCDCoCBiRW5kcG9pbnRBZGRyZXNz
IMKgIMKgIDB4MDEgwqBFUCAxIE9VVDwvZGl2PjxkaXY+wqAgwqAgwqAgwqAgYm1BdHRyaWJ1dGVz
IMKgIMKgIMKgIMKgIMKgIMKgMzwvZGl2Pg0KDQo8ZGl2PsKgIMKgIMKgIMKgIMKgIFRyYW5zZmVy
IFR5cGUgwqAgwqAgwqAgwqAgwqAgwqBJbnRlcnJ1cHQ8L2Rpdj48ZGl2PsKgIMKgIMKgIMKgIMKg
IFN5bmNoIFR5cGUgwqAgwqAgwqAgwqAgwqAgwqAgwqAgTm9uZTwvZGl2PjxkaXY+wqAgwqAgwqAg
wqAgwqAgVXNhZ2UgVHlwZSDCoCDCoCDCoCDCoCDCoCDCoCDCoCBEYXRhPC9kaXY+PGRpdj7CoCDC
oCDCoCDCoCB3TWF4UGFja2V0U2l6ZSDCoCDCoCAweDAwNDAgwqAxeCA2NCBieXRlczwvZGl2Pjxk
aXY+wqAgwqAgwqAgwqAgYkludGVydmFsIMKgIMKgIMKgIMKgIMKgIMKgIDEwMDwvZGl2Pg0KDQo8
ZGl2PsKgIMKgIMKgIEVuZHBvaW50IERlc2NyaXB0b3I6PC9kaXY+PGRpdj7CoCDCoCDCoCDCoCBi
TGVuZ3RoIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIDc8L2Rpdj48ZGl2PsKgIMKgIMKgIMKgIGJE
ZXNjcmlwdG9yVHlwZSDCoCDCoCDCoCDCoCA1PC9kaXY+PGRpdj7CoCDCoCDCoCDCoCBiRW5kcG9p
bnRBZGRyZXNzIMKgIMKgIDB4ODIgwqBFUCAyIElOPC9kaXY+PGRpdj7CoCDCoCDCoCDCoCBibUF0
dHJpYnV0ZXMgwqAgwqAgwqAgwqAgwqAgwqAzPC9kaXY+DQoNCjxkaXY+wqAgwqAgwqAgwqAgwqAg
VHJhbnNmZXIgVHlwZSDCoCDCoCDCoCDCoCDCoCDCoEludGVycnVwdDwvZGl2PjxkaXY+wqAgwqAg
wqAgwqAgwqAgU3luY2ggVHlwZSDCoCDCoCDCoCDCoCDCoCDCoCDCoCBOb25lPC9kaXY+PGRpdj7C
oCDCoCDCoCDCoCDCoCBVc2FnZSBUeXBlIMKgIMKgIMKgIMKgIMKgIMKgIMKgIERhdGE8L2Rpdj48
ZGl2PsKgIMKgIMKgIMKgIHdNYXhQYWNrZXRTaXplIMKgIMKgIDB4MDA0MCDCoDF4IDY0IGJ5dGVz
PC9kaXY+PGRpdj7CoCDCoCDCoCDCoCBiSW50ZXJ2YWwgwqAgwqAgwqAgwqAgwqAgwqAgMTAwPC9k
aXY+DQoNCjxkaXY+wqAgwqAgwqAgRW5kcG9pbnQgRGVzY3JpcHRvcjo8L2Rpdj48ZGl2PsKgIMKg
IMKgIMKgIGJMZW5ndGggwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgNzwvZGl2PjxkaXY+wqAgwqAg
wqAgwqAgYkRlc2NyaXB0b3JUeXBlIMKgIMKgIMKgIMKgIDU8L2Rpdj48ZGl2PsKgIMKgIMKgIMKg
IGJFbmRwb2ludEFkZHJlc3MgwqAgwqAgMHg4MyDCoEVQIDMgSU48L2Rpdj48ZGl2PsKgIMKgIMKg
IMKgIGJtQXR0cmlidXRlcyDCoCDCoCDCoCDCoCDCoCAxMzwvZGl2Pg0KDQo8ZGl2PsKgIMKgIMKg
IMKgIMKgIFRyYW5zZmVyIFR5cGUgwqAgwqAgwqAgwqAgwqAgwqBJc29jaHJvbm91czwvZGl2Pjxk
aXY+wqAgwqAgwqAgwqAgwqAgU3luY2ggVHlwZSDCoCDCoCDCoCDCoCDCoCDCoCDCoCBTeW5jaHJv
bm91czwvZGl2PjxkaXY+wqAgwqAgwqAgwqAgwqAgVXNhZ2UgVHlwZSDCoCDCoCDCoCDCoCDCoCDC
oCDCoCBEYXRhPC9kaXY+PGRpdj7CoCDCoCDCoCDCoCB3TWF4UGFja2V0U2l6ZSDCoCDCoCAweDAz
ZmYgwqAxeCAxMDIzIGJ5dGVzPC9kaXY+DQoNCjxkaXY+wqAgwqAgwqAgwqAgYkludGVydmFsIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIDE8L2Rpdj48ZGl2PkRldmljZSBRdWFsaWZpZXIgKGZvciBvdGhl
ciBkZXZpY2Ugc3BlZWQpOjwvZGl2PjxkaXY+wqAgYkxlbmd0aCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoDEwPC9kaXY+PGRpdj7CoCBiRGVzY3JpcHRvclR5cGUgwqAgwqAgwqAgwqAgNjwvZGl2Pjxk
aXY+wqAgYmNkVVNCIMKgIMKgIMKgIMKgIMKgIMKgIMKgIDIuMDA8L2Rpdj48ZGl2PsKgIGJEZXZp
Y2VDbGFzcyDCoCDCoCDCoCDCoCDCoCDCoDAgKERlZmluZWQgYXQgSW50ZXJmYWNlIGxldmVsKTwv
ZGl2Pg0KDQo8ZGl2PsKgIGJEZXZpY2VTdWJDbGFzcyDCoCDCoCDCoCDCoCAwwqA8L2Rpdj48ZGl2
PsKgIGJEZXZpY2VQcm90b2NvbCDCoCDCoCDCoCDCoCAwwqA8L2Rpdj48ZGl2PsKgIGJNYXhQYWNr
ZXRTaXplMCDCoCDCoCDCoCDCoDY0PC9kaXY+PGRpdj7CoCBiTnVtQ29uZmlndXJhdGlvbnMgwqAg
wqAgwqAxPC9kaXY+PGRpdj5EZXZpY2UgU3RhdHVzOiDCoCDCoCAweDAwMDA8L2Rpdj48ZGl2PsKg
IChCdXMgUG93ZXJlZCk8L2Rpdj48L2Rpdj4NCg0KPGRpdj48YnI+PC9kaXY+PGRpdj48YnI+PC9k
aXY+PGRpdj5QbGVhc2UgZmVlbCBmcmVlIHRvIGNvbnRhY3QgbWUgYXQgPGEgaHJlZj0ibWFpbHRv
Om1heGljZUBnbWFpbC5jb20iPm1heGljZUBnbWFpbC5jb208L2E+IC48L2Rpdj48ZGl2Pjxicj48
L2Rpdj48ZGl2PktpbmQgUmVnYXJkcyw8L2Rpdj48ZGl2PlJvYmVydCBOZWRpeWFrYWxhcGFyYW1i
aWw8YnI+PC9kaXY+PGRpdj48YnI+PC9kaXY+DQoNCjxkaXY+PGJyPjwvZGl2PjxkaXY+PGJyPjwv
ZGl2PjwvZGl2Pg0KPC9kaXY+DQo=
--001a113518320081af04f3cc0140--


--===============1672632897==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1672632897==--
