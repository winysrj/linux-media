Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from an-out-0708.google.com ([209.85.132.249])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <bslima19@gmail.com>) id 1MbyAG-0005oJ-Tf
	for linux-dvb@linuxtv.org; Fri, 14 Aug 2009 16:53:57 +0200
Received: by an-out-0708.google.com with SMTP id d40so628400and.41
	for <linux-dvb@linuxtv.org>; Fri, 14 Aug 2009 07:53:51 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 14 Aug 2009 11:53:51 -0300
Message-ID: <64e6eabb0908140753i1e3aaebaq23526ee3f3d89dab@mail.gmail.com>
From: Bruno Seabra Lima <bslima@telemidia.puc-rio.br>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Help for developing a driver for a usb ISDB-T
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0735769218=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0735769218==
Content-Type: multipart/alternative; boundary=0016e6470fa0708d7504711b3836

--0016e6470fa0708d7504711b3836
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,
I'm a master student in brazil. My work is related to digital tv and i wann=
a
help developer a driver for a USB card ISBD-T.
I already seen the DVB API 5.1 that has a support for ISBD-T. I just wanna
know a minimal guideline of the things i have to do.
Things like Do i have to make a new frontend ? How do i use the new
parameters for ISDB-T ?
I open the device and found a very curious thing:

We have two chips, the first one is:
DIB8076MC (STK807x), i guess this is the tuner.
the second one is:
0700C, i guess this is the usb bridge.
For what i saw from the linuxtv wiki, the 0700C is support by others
drivers.
I search the DiBCOM site and found that the DIB8076MC is pin-to-pin
compatible with the 7070p (that is support by other drivers).

Below i have the lsusb -v.

Bus 001 Device 003: ID 1554:5010 Prolink Microsystems Corp.
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x1554 Prolink Microsystems Corp.
  idProduct          0x5010
  bcdDevice            1.00
  iManufacturer           1 DiBcom
  iProduct                2 STK807X
  iSerial                 3 016
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
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
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
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
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0200  1x 512 bytes
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


Thanks in  advance for any help.

--=20
Bruno Seabra Mendon=C3=A7a Lima
--------------
Bacharel em Ci=C3=AAncia da Computa=C3=A7=C3=A3o - UFMA
Mestrando da PUC-Rio
Pesquisador Laborat=C3=B3rio Telemidia (PUC-Rio)
-------------
www.bslima.com

--0016e6470fa0708d7504711b3836
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

SGksPGJyPkkmIzM5O20gYSBtYXN0ZXIgc3R1ZGVudCBpbiBicmF6aWwuIE15IHdvcmsgaXMgcmVs
YXRlZCB0byBkaWdpdGFsIHR2IGFuZCBpIHdhbm5hIGhlbHAgZGV2ZWxvcGVyIGEgZHJpdmVyIGZv
ciBhIFVTQiBjYXJkIElTQkQtVC48YnI+SSBhbHJlYWR5IHNlZW4gdGhlIERWQiBBUEkgNS4xIHRo
YXQgaGFzIGEgc3VwcG9ydCBmb3IgSVNCRC1ULiBJIGp1c3Qgd2FubmEga25vdyBhIG1pbmltYWwg
Z3VpZGVsaW5lIG9mIHRoZSB0aGluZ3MgaSBoYXZlIHRvIGRvLjxicj4KCgpUaGluZ3MgbGlrZSBE
byBpIGhhdmUgdG8gbWFrZSBhIG5ldyBmcm9udGVuZCA/IEhvdyBkbyBpIHVzZSB0aGUgbmV3IHBh
cmFtZXRlcnMgZm9yIElTREItVCA/PGJyPkkgb3BlbiB0aGUgZGV2aWNlIGFuZCBmb3VuZCBhIHZl
cnkgY3VyaW91cyB0aGluZzo8YnI+PGJyPldlIGhhdmUgdHdvIGNoaXBzLCB0aGUgZmlyc3Qgb25l
IGlzOjxicj5ESUI4MDc2TUMgKFNUSzgwN3gpLCBpIGd1ZXNzIHRoaXMgaXMgdGhlIHR1bmVyLjxi
cj4KCgp0aGUgc2Vjb25kIG9uZSBpczo8YnI+MDcwMEMsIGkgZ3Vlc3MgdGhpcyBpcyB0aGUgdXNi
IGJyaWRnZS48YnI+Rm9yIHdoYXQgaSBzYXcgZnJvbSB0aGUgbGludXh0diB3aWtpLCB0aGUgMDcw
MEMgaXMgc3VwcG9ydCBieSBvdGhlcnMgZHJpdmVycy48YnI+SQpzZWFyY2ggdGhlIERpQkNPTSBz
aXRlIGFuZCBmb3VuZCB0aGF0IHRoZSBESUI4MDc2TUMgaXMgcGluLXRvLXBpbgpjb21wYXRpYmxl
IHdpdGggdGhlIDcwNzBwICh0aGF0IGlzIHN1cHBvcnQgYnkgb3RoZXIgZHJpdmVycykuPGJyPgo8
YnI+QmVsb3cgaSBoYXZlIHRoZSBsc3VzYiAtdi4gPGJyPjxicj5CdXMgMDAxIERldmljZSAwMDM6
IElEIDE1NTQ6NTAxMCBQcm9saW5rIE1pY3Jvc3lzdGVtcyBDb3JwLiA8YnI+RGV2aWNlIERlc2Ny
aXB0b3I6PGJyPsKgIGJMZW5ndGjCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMTg8YnI+
wqAgYkRlc2NyaXB0b3JUeXBlwqDCoMKgwqDCoMKgwqDCoCAxPGJyPsKgIGJjZFVTQsKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgMi4wMDxicj7CoCBiRGV2aWNlQ2xhc3PCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIDAgKERlZmluZWQgYXQgSW50ZXJmYWNlIGxldmVsKTxicj4KCgrCoCBiRGV2aWNl
U3ViQ2xhc3PCoMKgwqDCoMKgwqDCoMKgIDAgPGJyPsKgIGJEZXZpY2VQcm90b2NvbMKgwqDCoMKg
wqDCoMKgwqAgMCA8YnI+wqAgYk1heFBhY2tldFNpemUwwqDCoMKgwqDCoMKgwqAgNjQ8YnI+wqAg
aWRWZW5kb3LCoMKgwqDCoMKgwqDCoMKgwqDCoCAweDE1NTQgUHJvbGluayBNaWNyb3N5c3RlbXMg
Q29ycC48YnI+wqAgaWRQcm9kdWN0wqDCoMKgwqDCoMKgwqDCoMKgIDB4NTAxMCA8YnI+wqAgYmNk
RGV2aWNlwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAxLjAwPGJyPsKgIGlNYW51ZmFjdHVyZXLCoMKg
wqDCoMKgwqDCoMKgwqDCoCAxIERpQmNvbTxicj4KCgrCoCBpUHJvZHVjdMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCAyIFNUSzgwN1g8YnI+wqAgaVNlcmlhbMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIDMgMDE2PGJyPsKgIGJOdW1Db25maWd1cmF0aW9uc8KgwqDCoMKgwqAg
MTxicj7CoCBDb25maWd1cmF0aW9uIERlc2NyaXB0b3I6PGJyPsKgwqDCoCBiTGVuZ3RowqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgOTxicj7CoMKgwqAgYkRlc2NyaXB0b3JUeXBlwqDC
oMKgwqDCoMKgwqDCoCAyPGJyPsKgwqDCoCB3VG90YWxMZW5ndGjCoMKgwqDCoMKgwqDCoMKgwqDC
oCA0Njxicj4KCgrCoMKgwqAgYk51bUludGVyZmFjZXPCoMKgwqDCoMKgwqDCoMKgwqAgMTxicj7C
oMKgwqAgYkNvbmZpZ3VyYXRpb25WYWx1ZcKgwqDCoMKgIDE8YnI+wqDCoMKgIGlDb25maWd1cmF0
aW9uwqDCoMKgwqDCoMKgwqDCoMKgIDAgPGJyPsKgwqDCoCBibUF0dHJpYnV0ZXPCoMKgwqDCoMKg
wqDCoMKgIDB4YTA8YnI+wqDCoMKgwqDCoCAoQnVzIFBvd2VyZWQpPGJyPsKgwqDCoMKgwqAgUmVt
b3RlIFdha2V1cDxicj7CoMKgwqAgTWF4UG93ZXLCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA1
MDBtQTxicj7CoMKgwqAgSW50ZXJmYWNlIERlc2NyaXB0b3I6PGJyPgoKCsKgwqDCoMKgwqAgYkxl
bmd0aMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDk8YnI+wqDCoMKgwqDCoCBiRGVz
Y3JpcHRvclR5cGXCoMKgwqDCoMKgwqDCoMKgIDQ8YnI+wqDCoMKgwqDCoCBiSW50ZXJmYWNlTnVt
YmVywqDCoMKgwqDCoMKgwqAgMDxicj7CoMKgwqDCoMKgIGJBbHRlcm5hdGVTZXR0aW5nwqDCoMKg
wqDCoMKgIDA8YnI+wqDCoMKgwqDCoCBiTnVtRW5kcG9pbnRzwqDCoMKgwqDCoMKgwqDCoMKgwqAg
NDxicj7CoMKgwqDCoMKgIGJJbnRlcmZhY2VDbGFzc8KgwqDCoMKgwqDCoCAyNTUgVmVuZG9yIFNw
ZWNpZmljIENsYXNzPGJyPgoKCsKgwqDCoMKgwqAgYkludGVyZmFjZVN1YkNsYXNzwqDCoMKgwqDC
oCAwIDxicj7CoMKgwqDCoMKgIGJJbnRlcmZhY2VQcm90b2NvbMKgwqDCoMKgwqAgMCA8YnI+wqDC
oMKgwqDCoCBpSW50ZXJmYWNlwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMCA8YnI+wqDCoMKg
wqDCoCBFbmRwb2ludCBEZXNjcmlwdG9yOjxicj7CoMKgwqDCoMKgwqDCoCBiTGVuZ3RowqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgNzxicj7CoMKgwqDCoMKgwqDCoCBiRGVzY3JpcHRv
clR5cGXCoMKgwqDCoMKgwqDCoMKgIDU8YnI+wqDCoMKgwqDCoMKgwqAgYkVuZHBvaW50QWRkcmVz
c8KgwqDCoMKgIDB4MDHCoCBFUCAxIE9VVDxicj4KCgrCoMKgwqDCoMKgwqDCoCBibUF0dHJpYnV0
ZXPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDI8YnI+wqDCoMKgwqDCoMKgwqDCoMKgIFRyYW5zZmVy
IFR5cGXCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEJ1bGs8YnI+wqDCoMKgwqDCoMKgwqDCoMKgIFN5
bmNoIFR5cGXCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIE5vbmU8YnI+wqDCoMKgwqDCoMKg
wqDCoMKgIFVzYWdlIFR5cGXCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIERhdGE8YnI+wqDC
oMKgwqDCoMKgwqAgd01heFBhY2tldFNpemXCoMKgwqDCoCAweDAyMDDCoCAxeCA1MTIgYnl0ZXM8
YnI+wqDCoMKgwqDCoMKgwqAgYkludGVydmFswqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAx
PGJyPgoKCsKgwqDCoMKgwqAgRW5kcG9pbnQgRGVzY3JpcHRvcjo8YnI+wqDCoMKgwqDCoMKgwqAg
Ykxlbmd0aMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDc8YnI+wqDCoMKgwqDCoMKg
wqAgYkRlc2NyaXB0b3JUeXBlwqDCoMKgwqDCoMKgwqDCoCA1PGJyPsKgwqDCoMKgwqDCoMKgIGJF
bmRwb2ludEFkZHJlc3PCoMKgwqDCoCAweDgxwqAgRVAgMSBJTjxicj7CoMKgwqDCoMKgwqDCoCBi
bUF0dHJpYnV0ZXPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDI8YnI+wqDCoMKgwqDCoMKgwqDCoMKg
IFRyYW5zZmVyIFR5cGXCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEJ1bGs8YnI+CgoKwqDCoMKgwqDC
oMKgwqDCoMKgIFN5bmNoIFR5cGXCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIE5vbmU8YnI+
wqDCoMKgwqDCoMKgwqDCoMKgIFVzYWdlIFR5cGXCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IERhdGE8YnI+wqDCoMKgwqDCoMKgwqAgd01heFBhY2tldFNpemXCoMKgwqDCoCAweDAyMDDCoCAx
eCA1MTIgYnl0ZXM8YnI+wqDCoMKgwqDCoMKgwqAgYkludGVydmFswqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCAxPGJyPsKgwqDCoMKgwqAgRW5kcG9pbnQgRGVzY3JpcHRvcjo8YnI+wqDCoMKg
wqDCoMKgwqAgYkxlbmd0aMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDc8YnI+CgoK
wqDCoMKgwqDCoMKgwqAgYkRlc2NyaXB0b3JUeXBlwqDCoMKgwqDCoMKgwqDCoCA1PGJyPsKgwqDC
oMKgwqDCoMKgIGJFbmRwb2ludEFkZHJlc3PCoMKgwqDCoCAweDgywqAgRVAgMiBJTjxicj7CoMKg
wqDCoMKgwqDCoCBibUF0dHJpYnV0ZXPCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDI8YnI+wqDCoMKg
wqDCoMKgwqDCoMKgIFRyYW5zZmVyIFR5cGXCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEJ1bGs8YnI+
wqDCoMKgwqDCoMKgwqDCoMKgIFN5bmNoIFR5cGXCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IE5vbmU8YnI+wqDCoMKgwqDCoMKgwqDCoMKgIFVzYWdlIFR5cGXCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIERhdGE8YnI+CgoKwqDCoMKgwqDCoMKgwqAgd01heFBhY2tldFNpemXCoMKgwqDC
oCAweDAyMDDCoCAxeCA1MTIgYnl0ZXM8YnI+wqDCoMKgwqDCoMKgwqAgYkludGVydmFswqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAxPGJyPsKgwqDCoMKgwqAgRW5kcG9pbnQgRGVzY3JpcHRv
cjo8YnI+wqDCoMKgwqDCoMKgwqAgYkxlbmd0aMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIDc8YnI+wqDCoMKgwqDCoMKgwqAgYkRlc2NyaXB0b3JUeXBlwqDCoMKgwqDCoMKgwqDCoCA1
PGJyPsKgwqDCoMKgwqDCoMKgIGJFbmRwb2ludEFkZHJlc3PCoMKgwqDCoCAweDgzwqAgRVAgMyBJ
Tjxicj4KCgrCoMKgwqDCoMKgwqDCoCBibUF0dHJpYnV0ZXPCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
IDI8YnI+wqDCoMKgwqDCoMKgwqDCoMKgIFRyYW5zZmVyIFR5cGXCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIEJ1bGs8YnI+wqDCoMKgwqDCoMKgwqDCoMKgIFN5bmNoIFR5cGXCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIE5vbmU8YnI+wqDCoMKgwqDCoMKgwqDCoMKgIFVzYWdlIFR5cGXCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIERhdGE8YnI+wqDCoMKgwqDCoMKgwqAgd01heFBhY2tldFNp
emXCoMKgwqDCoCAweDAyMDDCoCAxeCA1MTIgYnl0ZXM8YnI+wqDCoMKgwqDCoMKgwqAgYkludGVy
dmFswqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAxPGJyPgoKCkRldmljZSBRdWFsaWZpZXIg
KGZvciBvdGhlciBkZXZpY2Ugc3BlZWQpOjxicj7CoCBiTGVuZ3RowqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIDEwPGJyPsKgIGJEZXNjcmlwdG9yVHlwZcKgwqDCoMKgwqDCoMKgwqAgNjxi
cj7CoCBiY2RVU0LCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDIuMDA8YnI+wqAgYkRldmlj
ZUNsYXNzwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAwIChEZWZpbmVkIGF0IEludGVyZmFjZSBsZXZl
bCk8YnI+wqAgYkRldmljZVN1YkNsYXNzwqDCoMKgwqDCoMKgwqDCoCAwIDxicj4KCgrCoCBiRGV2
aWNlUHJvdG9jb2zCoMKgwqDCoMKgwqDCoMKgIDAgPGJyPsKgIGJNYXhQYWNrZXRTaXplMMKgwqDC
oMKgwqDCoMKgIDY0PGJyPsKgIGJOdW1Db25maWd1cmF0aW9uc8KgwqDCoMKgwqAgMTxicj5EZXZp
Y2UgU3RhdHVzOsKgwqDCoMKgIDB4MDAwMDxicj7CoCAoQnVzIFBvd2VyZWQpPGJyPjxicj48YnI+
VGhhbmtzIGluwqAgYWR2YW5jZSBmb3IgYW55IGhlbHAuPGJyIGNsZWFyPSJhbGwiPjxicj4tLSA8
YnI+QnJ1bm8gU2VhYnJhIE1lbmRvbsOnYSBMaW1hPGJyPgotLS0tLS0tLS0tLS0tLTxicj5CYWNo
YXJlbCBlbSBDacOqbmNpYSBkYSBDb21wdXRhw6fDo28gLSBVRk1BPGJyPk1lc3RyYW5kbyBkYSBQ
VUMtUmlvPGJyPlBlc3F1aXNhZG9yIExhYm9yYXTDs3JpbyBUZWxlbWlkaWEgKFBVQy1SaW8pPGJy
Pi0tLS0tLS0tLS0tLS08YnI+PGEgaHJlZj0iaHR0cDovL3d3dy5ic2xpbWEuY29tIj53d3cuYnNs
aW1hLmNvbTwvYT48YnI+Cg==
--0016e6470fa0708d7504711b3836--


--===============0735769218==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0735769218==--
