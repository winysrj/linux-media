Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.list.priv.at ([87.230.15.114]:59234 "EHLO
	mail.list.priv.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759339Ab3BOBXN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Feb 2013 20:23:13 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.list.priv.at (Postfix) with ESMTP id CA8C04B0C02B
	for <linux-media@vger.kernel.org>; Fri, 15 Feb 2013 02:23:11 +0100 (CET)
Received: from mail.list.priv.at ([127.0.0.1])
	by localhost (mail.list.priv.at [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SCiFgFocKaCc for <linux-media@vger.kernel.org>;
	Fri, 15 Feb 2013 02:23:11 +0100 (CET)
Received: from [192.168.95.123] (pcd591124.netvigator.com [218.102.123.124])
	by mail.list.priv.at (Postfix) with ESMTPSA id AE6B54B0C02A
	for <linux-media@vger.kernel.org>; Fri, 15 Feb 2013 02:23:10 +0100 (CET)
Message-ID: <511D8DF9.7060508@list.priv.at>
Date: Fri, 15 Feb 2013 09:23:05 +0800
From: Alexander List <alex@list.priv.at>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: DMB-H USB Sticks: MagicPro ProHDTV Mini 2 USB
Content-Type: multipart/mixed;
 boundary="------------030107060701040409000705"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030107060701040409000705
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

frustrated that I couldn't watch the Chinese New Years' Fireworks on TVB
Jade using my RTL2832U based DVB-T stick in Hong Kong, I just bought a

MagicPro ProHDTV Mini 2

USB stick. Given that HK is now part of China (somehow), they decided to
follow the mainland DTV standard, so it's DTMB (DMB-T/H) over here.

The package says it only supports Windows, but I never believe the
packaging, and I believe in Linux hackers :)

lsusb -v says:

Bus 001 Device 008: ID 1b80:d39f Afatech

This looks *very* similar to the RTL2832U, in fact dmesg says it's a
Realtek chip:

[58773.739843] usb 1-1.1: new high-speed USB device number 8 using ehci_hcd
[58773.835657] usb 1-1.1: New USB device found, idVendor=1b80,
idProduct=d39f
[58773.835665] usb 1-1.1: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[58773.835670] usb 1-1.1: Product: usbtv
[58773.835673] usb 1-1.1: Manufacturer: realtek

Full lsusb -v output is attached.

I checked here but it's not listed, but other (PCIe) devices from the
same manufacturer are:

http://linuxtv.org/wiki/index.php/DMB-T/H_PCIe_Cards

I'm more than willing to get this thing supported under Linux - just let
me know what I can do to help.

I have

a) the stick
b) the Windows driver/software CD (soon as an ISO)

What I can provide is

a) help getting more info on the hardware (taking it apart etc.)
b) provide remote access to a box with the stick plugged in if necessary
c) test new code / patches

Cheers

Alex

--------------030107060701040409000705
Content-Type: text/plain; charset=UTF-8;
 name="lsusb.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="lsusb.txt"

QnVzIDAwMSBEZXZpY2UgMDA4OiBJRCAxYjgwOmQzOWYgQWZhdGVjaCAKRGV2aWNlIERlc2Ny
aXB0b3I6CiAgYkxlbmd0aCAgICAgICAgICAgICAgICAxOAogIGJEZXNjcmlwdG9yVHlwZSAg
ICAgICAgIDEKICBiY2RVU0IgICAgICAgICAgICAgICAyLjAwCiAgYkRldmljZUNsYXNzICAg
ICAgICAgICAgMCAoRGVmaW5lZCBhdCBJbnRlcmZhY2UgbGV2ZWwpCiAgYkRldmljZVN1YkNs
YXNzICAgICAgICAgMCAKICBiRGV2aWNlUHJvdG9jb2wgICAgICAgICAwIAogIGJNYXhQYWNr
ZXRTaXplMCAgICAgICAgNjQKICBpZFZlbmRvciAgICAgICAgICAgMHgxYjgwIEFmYXRlY2gK
ICBpZFByb2R1Y3QgICAgICAgICAgMHhkMzlmIAogIGJjZERldmljZSAgICAgICAgICAgIDEu
MDAKICBpTWFudWZhY3R1cmVyICAgICAgICAgICAxIAogIGlQcm9kdWN0ICAgICAgICAgICAg
ICAgIDIgCiAgaVNlcmlhbCAgICAgICAgICAgICAgICAgMCAKICBiTnVtQ29uZmlndXJhdGlv
bnMgICAgICAxCiAgQ29uZmlndXJhdGlvbiBEZXNjcmlwdG9yOgogICAgYkxlbmd0aCAgICAg
ICAgICAgICAgICAgOQogICAgYkRlc2NyaXB0b3JUeXBlICAgICAgICAgMgogICAgd1RvdGFs
TGVuZ3RoICAgICAgICAgICAzOQogICAgYk51bUludGVyZmFjZXMgICAgICAgICAgMQogICAg
YkNvbmZpZ3VyYXRpb25WYWx1ZSAgICAgMQogICAgaUNvbmZpZ3VyYXRpb24gICAgICAgICAg
NCAKICAgIGJtQXR0cmlidXRlcyAgICAgICAgIDB4ODAKICAgICAgKEJ1cyBQb3dlcmVkKQog
ICAgTWF4UG93ZXIgICAgICAgICAgICAgIDUwMG1BCiAgICBJbnRlcmZhY2UgRGVzY3JpcHRv
cjoKICAgICAgYkxlbmd0aCAgICAgICAgICAgICAgICAgOQogICAgICBiRGVzY3JpcHRvclR5
cGUgICAgICAgICA0CiAgICAgIGJJbnRlcmZhY2VOdW1iZXIgICAgICAgIDAKICAgICAgYkFs
dGVybmF0ZVNldHRpbmcgICAgICAgMAogICAgICBiTnVtRW5kcG9pbnRzICAgICAgICAgICAz
CiAgICAgIGJJbnRlcmZhY2VDbGFzcyAgICAgICAyNTUgVmVuZG9yIFNwZWNpZmljIENsYXNz
CiAgICAgIGJJbnRlcmZhY2VTdWJDbGFzcyAgICAyNTUgVmVuZG9yIFNwZWNpZmljIFN1YmNs
YXNzCiAgICAgIGJJbnRlcmZhY2VQcm90b2NvbCAgICAyNTUgVmVuZG9yIFNwZWNpZmljIFBy
b3RvY29sCiAgICAgIGlJbnRlcmZhY2UgICAgICAgICAgICAgIDUgCiAgICAgIEVuZHBvaW50
IERlc2NyaXB0b3I6CiAgICAgICAgYkxlbmd0aCAgICAgICAgICAgICAgICAgNwogICAgICAg
IGJEZXNjcmlwdG9yVHlwZSAgICAgICAgIDUKICAgICAgICBiRW5kcG9pbnRBZGRyZXNzICAg
ICAweDgxICBFUCAxIElOCiAgICAgICAgYm1BdHRyaWJ1dGVzICAgICAgICAgICAgMgogICAg
ICAgICAgVHJhbnNmZXIgVHlwZSAgICAgICAgICAgIEJ1bGsKICAgICAgICAgIFN5bmNoIFR5
cGUgICAgICAgICAgICAgICBOb25lCiAgICAgICAgICBVc2FnZSBUeXBlICAgICAgICAgICAg
ICAgRGF0YQogICAgICAgIHdNYXhQYWNrZXRTaXplICAgICAweDAyMDAgIDF4IDUxMiBieXRl
cwogICAgICAgIGJJbnRlcnZhbCAgICAgICAgICAgICAgIDAKICAgICAgRW5kcG9pbnQgRGVz
Y3JpcHRvcjoKICAgICAgICBiTGVuZ3RoICAgICAgICAgICAgICAgICA3CiAgICAgICAgYkRl
c2NyaXB0b3JUeXBlICAgICAgICAgNQogICAgICAgIGJFbmRwb2ludEFkZHJlc3MgICAgIDB4
ODIgIEVQIDIgSU4KICAgICAgICBibUF0dHJpYnV0ZXMgICAgICAgICAgICAyCiAgICAgICAg
ICBUcmFuc2ZlciBUeXBlICAgICAgICAgICAgQnVsawogICAgICAgICAgU3luY2ggVHlwZSAg
ICAgICAgICAgICAgIE5vbmUKICAgICAgICAgIFVzYWdlIFR5cGUgICAgICAgICAgICAgICBE
YXRhCiAgICAgICAgd01heFBhY2tldFNpemUgICAgIDB4MDIwMCAgMXggNTEyIGJ5dGVzCiAg
ICAgICAgYkludGVydmFsICAgICAgICAgICAgICAgMAogICAgICBFbmRwb2ludCBEZXNjcmlw
dG9yOgogICAgICAgIGJMZW5ndGggICAgICAgICAgICAgICAgIDcKICAgICAgICBiRGVzY3Jp
cHRvclR5cGUgICAgICAgICA1CiAgICAgICAgYkVuZHBvaW50QWRkcmVzcyAgICAgMHg4MyAg
RVAgMyBJTgogICAgICAgIGJtQXR0cmlidXRlcyAgICAgICAgICAgIDIKICAgICAgICAgIFRy
YW5zZmVyIFR5cGUgICAgICAgICAgICBCdWxrCiAgICAgICAgICBTeW5jaCBUeXBlICAgICAg
ICAgICAgICAgTm9uZQogICAgICAgICAgVXNhZ2UgVHlwZSAgICAgICAgICAgICAgIERhdGEK
ICAgICAgICB3TWF4UGFja2V0U2l6ZSAgICAgMHgwMjAwICAxeCA1MTIgYnl0ZXMKICAgICAg
ICBiSW50ZXJ2YWwgICAgICAgICAgICAgICAwCgogICAgICAgICAgCgo=
--------------030107060701040409000705--
