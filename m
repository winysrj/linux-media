Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <tem4uk@gmail.com>) id 1Q3U6s-0003mo-Dn
	for linux-dvb@linuxtv.org; Sat, 26 Mar 2011 15:05:22 +0100
Received: from mail-iy0-f182.google.com ([209.85.210.182])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-3) with esmtps
	[TLSv1:RC4-SHA:128] for <linux-dvb@linuxtv.org>
	id 1Q3U6r-0007OB-Fm; Sat, 26 Mar 2011 15:04:58 +0100
Received: by iyj12 with SMTP id 12so2689280iyj.41
	for <linux-dvb@linuxtv.org>; Sat, 26 Mar 2011 07:04:55 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 26 Mar 2011 17:04:54 +0300
Message-ID: <BANLkTi==ug032HXM7hdVjGMd-sOj+0QdQw@mail.gmail.com>
From: Aleksandrov Artyom <tema@tem4uk.ru>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] YUAN STK7700D support (1164:3EDC)
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1488476137=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>

--===============1488476137==
Content-Type: multipart/alternative; boundary=001636e0b90beaa935049f6331a1

--001636e0b90beaa935049f6331a1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

I have Asus eeetop ET2010AGT with this card:

Bus 002 Device 002: ID 1164:3edc YUAN High-Tech Development Co., Ltd
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x1164 YUAN High-Tech Development Co., Ltd
  idProduct          0x3edc
  bcdDevice            1.00
  iManufacturer           1 YUANRD
  iProduct                2 STK7700D
  iSerial                 3 0000000001
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


I don`t find any info on wiki, so hope to find answer in maillist. It`s rea=
l
to make this card work?
I use 2.6.35-28 (ubuntu 10.10).

At now dvb_usb_dib0700 not find any card
~# dmesg | grep dvb
[    7.185061] usbcore: registered new interface driver dvb_usb_dib0700

=3D(

Thanks for answer!


-----
Best regards, Artyom
=D0=A1 =D1=83=D0=B2=D0=B0=D0=B6=D0=B5=D0=BD=D0=B8=D0=B5=D0=BC, =D0=90=D1=80=
=D1=82=D1=91=D0=BC.

--001636e0b90beaa935049f6331a1
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div><meta http-equiv=3D"content-type" content=3D"text/html; charset=3Dutf-=
8"><pre style=3D"font-family: &#39;Times New Roman&#39;; font-size: medium;=
 word-wrap: break-word; white-space: pre-wrap; ">Hello, </pre><pre style=3D=
"font-family: &#39;Times New Roman&#39;; font-size: medium; word-wrap: brea=
k-word; white-space: pre-wrap; ">
I have Asus eeetop ET2010AGT with this card:</pre><pre style=3D"word-wrap: =
break-word; "><font class=3D"Apple-style-span" size=3D"3"><span class=3D"Ap=
ple-style-span" style=3D"white-space: pre-wrap;">Bus 002 Device 002: ID 116=
4:3edc YUAN High-Tech Development Co., Ltd=20
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0=20
  bDeviceProtocol         0=20
  bMaxPacketSize0        64
  idVendor           0x1164 YUAN High-Tech Development Co., Ltd
  idProduct          0x3edc=20
  bcdDevice            1.00
  iManufacturer           1 YUANRD
  iProduct                2 STK7700D
  iSerial                 3 0000000001
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           46
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0=20
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
      bInterfaceSubClass      0=20
      bInterfaceProtocol      0=20
      iInterface              0=20
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
  bDeviceSubClass         0=20
  bDeviceProtocol         0=20
  bMaxPacketSize0        64
  bNumConfigurations      1
Device Status:     0x0000
  (Bus Powered)</span></font><span class=3D"Apple-style-span" style=3D"font=
-family: &#39;Times New Roman&#39;; white-space: pre-wrap; font-size: mediu=
m; ">
</span></pre><div style=3D"font-family: &#39;Times New Roman&#39;; font-siz=
e: medium; "><span class=3D"Apple-style-span" style=3D"font-family: arial; =
font-size: small; "><br></span></div><div style=3D"font-family: &#39;Times =
New Roman&#39;; font-size: medium; ">
<span class=3D"Apple-style-span" style=3D"font-family: arial; font-size: sm=
all; ">I don`t find any info on wiki, so hope to find answer in maillist. I=
t`s real to make this card work?</span></div><div style=3D"font-family: &#3=
9;Times New Roman&#39;; font-size: medium; ">
<span class=3D"Apple-style-span" style=3D"font-family: arial; font-size: sm=
all; ">I use=C2=A02.6.35-28 (ubuntu 10.10).</span></div><div style=3D"font-=
family: &#39;Times New Roman&#39;; font-size: medium; "><span class=3D"Appl=
e-style-span" style=3D"font-family: arial; font-size: small; "><br>
</span></div><div>At now=C2=A0dvb_usb_dib0700 not find any card=C2=A0<br><d=
iv>~# dmesg | grep dvb</div><div>[ =C2=A0 =C2=A07.185061] usbcore: register=
ed new interface driver dvb_usb_dib0700</div></div><div><br></div><div>=3D(=
</div><div><br></div>
<div>Thanks for answer!</div><div><br></div><div style=3D"font-family: &#39=
;Times New Roman&#39;; font-size: medium; "><span class=3D"Apple-style-span=
" style=3D"font-family: arial; font-size: small; "><br></span></div><div st=
yle=3D"font-family: &#39;Times New Roman&#39;; font-size: medium; ">
<span class=3D"Apple-style-span" style=3D"font-family: arial; font-size: sm=
all; ">-----</span></div><div style=3D"font-family: &#39;Times New Roman&#3=
9;; font-size: medium; "><span class=3D"Apple-style-span" style=3D"font-fam=
ily: arial; font-size: small; ">Best regards, Artyom</span></div>
</div>=D0=A1 =D1=83=D0=B2=D0=B0=D0=B6=D0=B5=D0=BD=D0=B8=D0=B5=D0=BC, =D0=90=
=D1=80=D1=82=D1=91=D0=BC.<br>

--001636e0b90beaa935049f6331a1--


--===============1488476137==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1488476137==--
