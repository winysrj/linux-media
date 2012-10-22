Return-path: <linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.72)
	(envelope-from <wender.reis@gmail.com>) id 1TQJ3g-0000EL-DQ
	for linux-dvb@linuxtv.org; Mon, 22 Oct 2012 16:32:48 +0200
Received: from mail-oa0-f54.google.com ([209.85.219.54])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-2) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1TQJ3f-0002kQ-J9; Mon, 22 Oct 2012 16:32:48 +0200
Received: by mail-oa0-f54.google.com with SMTP id n9so2509810oag.41
	for <linux-dvb@linuxtv.org>; Mon, 22 Oct 2012 07:32:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMqjYaUwU=PvFn+TZp6_cenn7tBtSpEQBhu1d-rBjcDy_yLpZg@mail.gmail.com>
References: <CAMqjYaUwU=PvFn+TZp6_cenn7tBtSpEQBhu1d-rBjcDy_yLpZg@mail.gmail.com>
Date: Mon, 22 Oct 2012 11:32:45 -0300
Message-ID: <CAMqjYaVwXGXP7re9rMpYAzRA4kNdpdEB+NSD6+sxOxHV7zzoPA@mail.gmail.com>
From: Wender Reis <wender.reis@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] ISDB-T Siano Not Supported
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0291674494=="
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=linuxtv.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0291674494==
Content-Type: multipart/alternative; boundary=e89a8ff253fe18c8da04cca6bad3

--e89a8ff253fe18c8da04cca6bad3
Content-Type: text/plain; charset=ISO-8859-1

Hi guys, I've got one new isdb-t usb full-seg dongle, with siano driver but
I can't make it work with v4linux.
I've installed last version of v4l but it still doesn't load any driver.
lsusb gives me:

----------------------------------------------------------------------------------------------------
Bus 001 Device 005: ID 187f:0600 Siano Mobile Silicon
Couldn't open device, some information will be missing
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x187f Siano Mobile Silicon
  idProduct          0x0600
  bcdDevice            0.08
  iManufacturer           1
  iProduct                2
  iSerial                 0
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           32
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass    255 Vendor Specific Subclass
      bInterfaceProtocol    255 Vendor Specific Protocol
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
------------------------------------------------------------------------------------------------------------

As we can see the hardware is 187f:0600 and not 187f:0201 like other siano
isdb-t. In my windows 7 64bits the driver calls one file named sdbt_rio.inp
instead of common dvb_nova_12mhz**.inp

Typing dmesg it doesn't recognize the driver, it shows:
"usb 1-2: new high-speed USB device number 5 using ehci_hcd"

I have driver files like sdbt_rio.inp to send if its needed. I don't know
what else to do, I guess I tried a lot of things but this stick is somehow
different than any other tutorial I saw in internet to isdb-t. My hope is
in the fact that the dongle is SMS1xxx.

Thanks,
Wender Reis

--e89a8ff253fe18c8da04cca6bad3
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: base64

SGkgZ3V5cywgSSYjMzk7dmUgZ290IG9uZSBuZXcgaXNkYi10IHVzYiBmdWxsLXNlZyBkb25nbGUs
IHdpdGggc2lhbm8gZHJpdmVyIGJ1dCBJIGNhbiYjMzk7dCBtYWtlIGl0IHdvcmsgd2l0aCB2NGxp
bnV4Ljxicj48ZGl2IGNsYXNzPSJnbWFpbF9xdW90ZSI+SSYjMzk7dmUgaW5zdGFsbGVkIGxhc3Qg
dmVyc2lvbiBvZiB2NGwgYnV0IGl0IHN0aWxsIGRvZXNuJiMzOTt0IGxvYWQgYW55IGRyaXZlci4g
bHN1c2IgZ2l2ZXMgbWU6PGJyPgo8YnI+LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLTxicj4KQnVzIDAwMSBEZXZpY2UgMDA1OiBJRCAxODdmOjA2MDAgU2lhbm8gTW9i
aWxlIFNpbGljb24gPGJyPkNvdWxkbiYjMzk7dCBvcGVuIGRldmljZSwgc29tZSBpbmZvcm1hdGlv
biB3aWxsIGJlIG1pc3Npbmc8YnI+RGV2aWNlIERlc2NyaXB0b3I6PGJyPqAgYkxlbmd0aKCgoKCg
oKCgoKCgoKCgoCAxODxicj6gIGJEZXNjcmlwdG9yVHlwZaCgoKCgoKCgIDE8YnI+oCBiY2RVU0Kg
oKCgoKCgoKCgoKCgoCAyLjAwPGJyPgoKoCBiRGV2aWNlQ2xhc3OgoKCgoKCgoKCgoCAwIChEZWZp
bmVkIGF0IEludGVyZmFjZSBsZXZlbCk8YnI+oCBiRGV2aWNlU3ViQ2xhc3OgoKCgoKCgoCAwIDxi
cj6gIGJEZXZpY2VQcm90b2NvbKCgoKCgoKCgIDAgPGJyPqAgYk1heFBhY2tldFNpemUwoKCgoKCg
oCA2NDxicj6gIGlkVmVuZG9yoKCgoKCgoKCgoCAweDE4N2YgU2lhbm8gTW9iaWxlIFNpbGljb248
YnI+oCBpZFByb2R1Y3SgoKCgoKCgoKAgMHgwNjAwIDxicj4KCqAgYmNkRGV2aWNloKCgoKCgoKCg
oKAgMC4wODxicj6gIGlNYW51ZmFjdHVyZXKgoKCgoKCgoKCgIDEgPGJyPqAgaVByb2R1Y3SgoKCg
oKCgoKCgoKCgoKAgMiA8YnI+oCBpU2VyaWFsoKCgoKCgoKCgoKCgoKCgoCAwIDxicj6gIGJOdW1D
b25maWd1cmF0aW9uc6CgoKCgIDE8YnI+oCBDb25maWd1cmF0aW9uIERlc2NyaXB0b3I6PGJyPqCg
oCBiTGVuZ3RooKCgoKCgoKCgoKCgoKCgoCA5PGJyPgoKoKCgIGJEZXNjcmlwdG9yVHlwZaCgoKCg
oKCgIDI8YnI+oKCgIHdUb3RhbExlbmd0aKCgoKCgoKCgoKAgMzI8YnI+oKCgIGJOdW1JbnRlcmZh
Y2VzoKCgoKCgoKCgIDE8YnI+oKCgIGJDb25maWd1cmF0aW9uVmFsdWWgoKCgIDE8YnI+oKCgIGlD
b25maWd1cmF0aW9uoKCgoKCgoKCgIDAgPGJyPqCgoCBibUF0dHJpYnV0ZXOgoKCgoKCgoCAweDgw
PGJyPqCgoKCgIChCdXMgUG93ZXJlZCk8YnI+CgqgoKAgTWF4UG93ZXKgoKCgoKCgoKCgoKCgIDEw
MG1BPGJyPqCgoCBJbnRlcmZhY2UgRGVzY3JpcHRvcjo8YnI+oKCgoKAgYkxlbmd0aKCgoKCgoKCg
oKCgoKCgoKAgOTxicj6goKCgoCBiRGVzY3JpcHRvclR5cGWgoKCgoKCgoCA0PGJyPqCgoKCgIGJJ
bnRlcmZhY2VOdW1iZXKgoKCgoKCgIDA8YnI+oKCgoKAgYkFsdGVybmF0ZVNldHRpbmegoKCgoKAg
MDxicj6goKCgoCBiTnVtRW5kcG9pbnRzoKCgoKCgoKCgoCAyPGJyPgoKoKCgoKAgYkludGVyZmFj
ZUNsYXNzoKCgoKCgIDI1NSBWZW5kb3IgU3BlY2lmaWMgQ2xhc3M8YnI+oKCgoKAgYkludGVyZmFj
ZVN1YkNsYXNzoKCgIDI1NSBWZW5kb3IgU3BlY2lmaWMgU3ViY2xhc3M8YnI+oKCgoKAgYkludGVy
ZmFjZVByb3RvY29soKCgIDI1NSBWZW5kb3IgU3BlY2lmaWMgUHJvdG9jb2w8YnI+oKCgoKAgaUlu
dGVyZmFjZaCgoKCgoKCgoKCgoKAgMCA8YnI+oKCgoKAgRW5kcG9pbnQgRGVzY3JpcHRvcjo8YnI+
CgqgoKCgoKCgIGJMZW5ndGigoKCgoKCgoKCgoKCgoKCgIDc8YnI+oKCgoKCgoCBiRGVzY3JpcHRv
clR5cGWgoKCgoKCgoCA1PGJyPqCgoKCgoKAgYkVuZHBvaW50QWRkcmVzc6CgoKAgMHg4MaAgRVAg
MSBJTjxicj6goKCgoKCgIGJtQXR0cmlidXRlc6CgoKCgoKCgoKCgIDI8YnI+oKCgoKCgoKCgIFRy
YW5zZmVyIFR5cGWgoKCgoKCgoKCgoCBCdWxrPGJyPqCgoKCgoKCgoCBTeW5jaCBUeXBloKCgoKCg
oKCgoKCgoKAgTm9uZTxicj4KCqCgoKCgoKCgoCBVc2FnZSBUeXBloKCgoKCgoKCgoKCgoKAgRGF0
YTxicj6goKCgoKCgIHdNYXhQYWNrZXRTaXploKCgoCAweDAyMDCgIDF4IDUxMiBieXRlczxicj6g
oKCgoKCgIGJJbnRlcnZhbKCgoKCgoKCgoKCgoKCgIDA8YnI+oKCgoKAgRW5kcG9pbnQgRGVzY3Jp
cHRvcjo8YnI+oKCgoKCgoCBiTGVuZ3RooKCgoKCgoKCgoKCgoKCgoCA3PGJyPqCgoKCgoKAgYkRl
c2NyaXB0b3JUeXBloKCgoKCgoKAgNTxicj4KCqCgoKCgoKAgYkVuZHBvaW50QWRkcmVzc6CgoKAg
MHgwMqAgRVAgMiBPVVQ8YnI+oKCgoKCgoCBibUF0dHJpYnV0ZXOgoKCgoKCgoKCgoCAyPGJyPqCg
oKCgoKCgoCBUcmFuc2ZlciBUeXBloKCgoKCgoKCgoKAgQnVsazxicj6goKCgoKCgoKAgU3luY2gg
VHlwZaCgoKCgoKCgoKCgoKCgIE5vbmU8YnI+oKCgoKCgoKCgIFVzYWdlIFR5cGWgoKCgoKCgoKCg
oKCgoCBEYXRhPGJyPqCgoKCgoKAgd01heFBhY2tldFNpemWgoKCgIDB4MDIwMKAgMXggNTEyIGJ5
dGVzPGJyPgoKoKCgoKCgoCBiSW50ZXJ2YWygoKCgoKCgoKCgoKCgoCAwPGJyPi0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLTxicj48YnI+QXMgd2UgY2Fu
IHNlZSB0aGUgaGFyZHdhcmUgaXMgMTg3ZjowNjAwIGFuZCBub3QgMTg3ZjowMjAxIGxpa2Ugb3Ro
ZXIgc2lhbm8gaXNkYi10LiBJbiBteSB3aW5kb3dzIDcgNjRiaXRzIHRoZSBkcml2ZXIgY2FsbHMg
b25lIGZpbGUgbmFtZWQgc2RidF9yaW8uaW5wIGluc3RlYWQgb2YgY29tbW9uIDxzcGFuPmR2Yl9u
b3ZhXzEybWh6PGVtPjwvZW0+PC9zcGFuPi5pbnA8YnI+Cgo8YnI+VHlwaW5nIGRtZXNnIGl0IGRv
ZXNuJiMzOTt0IHJlY29nbml6ZSB0aGUgZHJpdmVyLCBpdCBzaG93czo8YnI+JnF1b3Q7dXNiIDEt
MjogbmV3IGhpZ2gtc3BlZWQgVVNCIGRldmljZSBudW1iZXIgNSB1c2luZyBlaGNpX2hjZCZxdW90
Ozxicj6gPGJyPkkgaGF2ZSBkcml2ZXIgZmlsZXMgbGlrZSBzZGJ0X3Jpby5pbnAgdG8gc2VuZCBp
ZiBpdHMgbmVlZGVkLiBJIGRvbiYjMzk7dCBrbm93IHdoYXQgZWxzZSB0byBkbywgSSBndWVzcyBJ
IHRyaWVkIGEgbG90IG9mIHRoaW5ncyBidXQgdGhpcyBzdGljayBpcyBzb21laG93IGRpZmZlcmVu
dCB0aGFuIGFueSBvdGhlciB0dXRvcmlhbCBJIHNhdyBpbiBpbnRlcm5ldCB0byBpc2RiLXQuIE15
IGhvcGUgaXMgaW4gdGhlIGZhY3QgdGhhdCB0aGUgZG9uZ2xlIGlzIFNNUzF4eHguPGJyPgoKPGJy
PlRoYW5rcyw8YnI+V2VuZGVyIFJlaXM8YnI+PC9kaXY+Cg==
--e89a8ff253fe18c8da04cca6bad3--


--===============0291674494==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0291674494==--
