Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mu-out-0910.google.com ([209.85.134.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <albert.comerma@gmail.com>) id 1JkFWR-00063B-2G
	for linux-dvb@linuxtv.org; Fri, 11 Apr 2008 11:26:16 +0200
Received: by mu-out-0910.google.com with SMTP id w8so387897mue.1
	for <linux-dvb@linuxtv.org>; Fri, 11 Apr 2008 02:26:02 -0700 (PDT)
Message-ID: <ea4209750804110226u18388307m48c629fe69b20d99@mail.gmail.com>
Date: Fri, 11 Apr 2008 11:26:01 +0200
From: "Albert Comerma" <albert.comerma@gmail.com>
To: "Jernej Tonejc" <tonejc@math.wisc.edu>
In-Reply-To: <Pine.LNX.4.64.0804102256540.3892@garbadale.math.wisc.edu>
MIME-Version: 1.0
References: <Pine.LNX.4.64.0804102256540.3892@garbadale.math.wisc.edu>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Pinnacle PCTV HD pro USB stick 801e
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0021757865=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0021757865==
Content-Type: multipart/alternative;
	boundary="----=_Part_26890_1673306.1207905961839"

------=_Part_26890_1673306.1207905961839
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

For the chips you list it seems to be an hybrid card, with a dibcom bridge.
In this case, what's more easy is to make dvb-t working (dib0700 + xc5000)
as you have tried. But there's no frontend which uses xc5000, so a new one
must be specified. In theory xc5000 is supported.... I hope this helps.

Albert

2008/4/11 Jernej Tonejc <tonejc@math.wisc.edu>:

> Hi,
>
> I was wondering if anyone is working on enabling this device under linux.
> I took it apart and it contains the following chips:
>
> DIBcom 0700C-XCCXa-G
> USB 2.0 D3LTK.1
> 0804-0100-C
> -----------------
> SAMSUNG
> S5H1411X01-Y0
> NOTKRSUI H0801
> -----------------
> XCeive
> XC5000AQ
> BK66326.1
> 0802MYE3
> -----------------
> Cirrus
> 5340CZZ
> 0748
> -----------------
> CONEXANT
> CX25843-24Z
> 71035657
> 0742 KOREA
> -----------------
>
> It seems that all parts should be more or less supported. I played around
> with the code and managed to get the IR receiver to work, however the
> frontend and tuner do not get attached no matter what kind of combination
> I try. The firmware for DiBcom chip  gets loaded successfully. Output in
> dmesg:
> dvb-usb: downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
> dib0700: firmware started successfully.
> ...
> input: IR-receiver inside an USB DVB receiver as
> /devices/pci0000:00/0000:00:1d.7/usb7/7-2/input/input20
>
> The output of lsusb -v is
>
> Bus 007 Device 023: ID 2304:023a Pinnacle Systems, Inc. [hex]
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   idVendor           0x2304 Pinnacle Systems, Inc. [hex]
>   idProduct          0x023a
>   bcdDevice            1.00
>   iManufacturer           1 YUANRD
>   iProduct                2 PCTV 801e
>   iSerial                 3 01004E0F9F
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength           46
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0xa0
>       (Bus Powered)
>       Remote Wakeup
>     MaxPower              500mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           4
>       bInterfaceClass       255 Vendor Specific Class
>       bInterfaceSubClass      0
>       bInterfaceProtocol      0
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x01  EP 1 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               1
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0200  1x 512 bytes
>         bInterval               1
> Device Qualifier (for other device speed):
>   bLength                10
>   bDescriptorType         6
>   bcdUSB               2.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0        64
>   bNumConfigurations      1
> Device Status:     0x0000
>   (Bus Powered)
>
>
> Thanks,
>
>   Jernej
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

------=_Part_26890_1673306.1207905961839
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

For the chips you list it seems to be an hybrid card, with a dibcom bridge. In this case, what&#39;s more easy is to make dvb-t working (dib0700 + xc5000)&nbsp; as you have tried. But there&#39;s no frontend which uses xc5000, so a new one must be specified. In theory xc5000 is supported.... I hope this helps.<br>

<br>Albert<br><br><div class="gmail_quote">2008/4/11 Jernej Tonejc &lt;<a href="mailto:tonejc@math.wisc.edu" target="_blank">tonejc@math.wisc.edu</a>&gt;:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">

Hi,<br>
<br>
I was wondering if anyone is working on enabling this device under linux.<br>
I took it apart and it contains the following chips:<br>
<br>
DIBcom 0700C-XCCXa-G<br>
USB 2.0 D3LTK.1<br>
0804-0100-C<br>
-----------------<br>
SAMSUNG<br>
S5H1411X01-Y0<br>
NOTKRSUI H0801<br>
-----------------<br>
XCeive<br>
XC5000AQ<br>
BK66326.1<br>
0802MYE3<br>
-----------------<br>
Cirrus<br>
5340CZZ<br>
0748<br>
-----------------<br>
CONEXANT<br>
CX25843-24Z<br>
71035657<br>
0742 KOREA<br>
-----------------<br>
<br>
It seems that all parts should be more or less supported. I played around<br>
with the code and managed to get the IR receiver to work, however the<br>
frontend and tuner do not get attached no matter what kind of combination<br>
I try. The firmware for DiBcom chip &nbsp;gets loaded successfully. Output in<br>
dmesg:<br>
dvb-usb: downloading firmware from file &#39;dvb-usb-dib0700-1.10.fw&#39;<br>
dib0700: firmware started successfully.<br>
...<br>
input: IR-receiver inside an USB DVB receiver as<br>
/devices/pci0000:00/0000:00:1d.7/usb7/7-2/input/input20<br>
<br>
The output of lsusb -v is<br>
<br>
Bus 007 Device 023: ID 2304:023a Pinnacle Systems, Inc. [hex]<br>
Device Descriptor:<br>
 &nbsp; bLength &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;18<br>
 &nbsp; bDescriptorType &nbsp; &nbsp; &nbsp; &nbsp; 1<br>
 &nbsp; bcdUSB &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 2.00<br>
 &nbsp; bDeviceClass &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0 (Defined at Interface level)<br>
 &nbsp; bDeviceSubClass &nbsp; &nbsp; &nbsp; &nbsp; 0<br>
 &nbsp; bDeviceProtocol &nbsp; &nbsp; &nbsp; &nbsp; 0<br>
 &nbsp; bMaxPacketSize0 &nbsp; &nbsp; &nbsp; &nbsp;64<br>
 &nbsp; idVendor &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 0x2304 Pinnacle Systems, Inc. [hex]<br>
 &nbsp; idProduct &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0x023a<br>
 &nbsp; bcdDevice &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;1.00<br>
 &nbsp; iManufacturer &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1 YUANRD<br>
 &nbsp; iProduct &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;2 PCTV 801e<br>
 &nbsp; iSerial &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 3 01004E0F9F<br>
 &nbsp; bNumConfigurations &nbsp; &nbsp; &nbsp;1<br>
 &nbsp; Configuration Descriptor:<br>
 &nbsp; &nbsp; bLength &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 9<br>
 &nbsp; &nbsp; bDescriptorType &nbsp; &nbsp; &nbsp; &nbsp; 2<br>
 &nbsp; &nbsp; wTotalLength &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 46<br>
 &nbsp; &nbsp; bNumInterfaces &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;1<br>
 &nbsp; &nbsp; bConfigurationValue &nbsp; &nbsp; 1<br>
 &nbsp; &nbsp; iConfiguration &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0<br>
 &nbsp; &nbsp; bmAttributes &nbsp; &nbsp; &nbsp; &nbsp; 0xa0<br>
 &nbsp; &nbsp; &nbsp; (Bus Powered)<br>
 &nbsp; &nbsp; &nbsp; Remote Wakeup<br>
 &nbsp; &nbsp; MaxPower &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;500mA<br>
 &nbsp; &nbsp; Interface Descriptor:<br>
 &nbsp; &nbsp; &nbsp; bLength &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 9<br>
 &nbsp; &nbsp; &nbsp; bDescriptorType &nbsp; &nbsp; &nbsp; &nbsp; 4<br>
 &nbsp; &nbsp; &nbsp; bInterfaceNumber &nbsp; &nbsp; &nbsp; &nbsp;0<br>
 &nbsp; &nbsp; &nbsp; bAlternateSetting &nbsp; &nbsp; &nbsp; 0<br>
 &nbsp; &nbsp; &nbsp; bNumEndpoints &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 4<br>
 &nbsp; &nbsp; &nbsp; bInterfaceClass &nbsp; &nbsp; &nbsp; 255 Vendor Specific Class<br>
 &nbsp; &nbsp; &nbsp; bInterfaceSubClass &nbsp; &nbsp; &nbsp;0<br>
 &nbsp; &nbsp; &nbsp; bInterfaceProtocol &nbsp; &nbsp; &nbsp;0<br>
 &nbsp; &nbsp; &nbsp; iInterface &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0<br>
 &nbsp; &nbsp; &nbsp; Endpoint Descriptor:<br>
 &nbsp; &nbsp; &nbsp; &nbsp; bLength &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 7<br>
 &nbsp; &nbsp; &nbsp; &nbsp; bDescriptorType &nbsp; &nbsp; &nbsp; &nbsp; 5<br>
 &nbsp; &nbsp; &nbsp; &nbsp; bEndpointAddress &nbsp; &nbsp; 0x01 &nbsp;EP 1 OUT<br>
 &nbsp; &nbsp; &nbsp; &nbsp; bmAttributes &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;2<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Transfer Type &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Bulk<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Synch Type &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; None<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Usage Type &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Data<br>
 &nbsp; &nbsp; &nbsp; &nbsp; wMaxPacketSize &nbsp; &nbsp; 0x0200 &nbsp;1x 512 bytes<br>
 &nbsp; &nbsp; &nbsp; &nbsp; bInterval &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1<br>
 &nbsp; &nbsp; &nbsp; Endpoint Descriptor:<br>
 &nbsp; &nbsp; &nbsp; &nbsp; bLength &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 7<br>
 &nbsp; &nbsp; &nbsp; &nbsp; bDescriptorType &nbsp; &nbsp; &nbsp; &nbsp; 5<br>
 &nbsp; &nbsp; &nbsp; &nbsp; bEndpointAddress &nbsp; &nbsp; 0x81 &nbsp;EP 1 IN<br>
 &nbsp; &nbsp; &nbsp; &nbsp; bmAttributes &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;2<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Transfer Type &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Bulk<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Synch Type &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; None<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Usage Type &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Data<br>
 &nbsp; &nbsp; &nbsp; &nbsp; wMaxPacketSize &nbsp; &nbsp; 0x0200 &nbsp;1x 512 bytes<br>
 &nbsp; &nbsp; &nbsp; &nbsp; bInterval &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1<br>
 &nbsp; &nbsp; &nbsp; Endpoint Descriptor:<br>
 &nbsp; &nbsp; &nbsp; &nbsp; bLength &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 7<br>
 &nbsp; &nbsp; &nbsp; &nbsp; bDescriptorType &nbsp; &nbsp; &nbsp; &nbsp; 5<br>
 &nbsp; &nbsp; &nbsp; &nbsp; bEndpointAddress &nbsp; &nbsp; 0x82 &nbsp;EP 2 IN<br>
 &nbsp; &nbsp; &nbsp; &nbsp; bmAttributes &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;2<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Transfer Type &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Bulk<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Synch Type &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; None<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Usage Type &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Data<br>
 &nbsp; &nbsp; &nbsp; &nbsp; wMaxPacketSize &nbsp; &nbsp; 0x0200 &nbsp;1x 512 bytes<br>
 &nbsp; &nbsp; &nbsp; &nbsp; bInterval &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1<br>
 &nbsp; &nbsp; &nbsp; Endpoint Descriptor:<br>
 &nbsp; &nbsp; &nbsp; &nbsp; bLength &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 7<br>
 &nbsp; &nbsp; &nbsp; &nbsp; bDescriptorType &nbsp; &nbsp; &nbsp; &nbsp; 5<br>
 &nbsp; &nbsp; &nbsp; &nbsp; bEndpointAddress &nbsp; &nbsp; 0x83 &nbsp;EP 3 IN<br>
 &nbsp; &nbsp; &nbsp; &nbsp; bmAttributes &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;2<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Transfer Type &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Bulk<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Synch Type &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; None<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Usage Type &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; Data<br>
 &nbsp; &nbsp; &nbsp; &nbsp; wMaxPacketSize &nbsp; &nbsp; 0x0200 &nbsp;1x 512 bytes<br>
 &nbsp; &nbsp; &nbsp; &nbsp; bInterval &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 1<br>
Device Qualifier (for other device speed):<br>
 &nbsp; bLength &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;10<br>
 &nbsp; bDescriptorType &nbsp; &nbsp; &nbsp; &nbsp; 6<br>
 &nbsp; bcdUSB &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 2.00<br>
 &nbsp; bDeviceClass &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;0 (Defined at Interface level)<br>
 &nbsp; bDeviceSubClass &nbsp; &nbsp; &nbsp; &nbsp; 0<br>
 &nbsp; bDeviceProtocol &nbsp; &nbsp; &nbsp; &nbsp; 0<br>
 &nbsp; bMaxPacketSize0 &nbsp; &nbsp; &nbsp; &nbsp;64<br>
 &nbsp; bNumConfigurations &nbsp; &nbsp; &nbsp;1<br>
Device Status: &nbsp; &nbsp; 0x0000<br>
 &nbsp; (Bus Powered)<br>
<br>
<br>
Thanks,<br>
<br>
 &nbsp; Jernej<br>
<br>
_______________________________________________<br>
linux-dvb mailing list<br>
<a href="mailto:linux-dvb@linuxtv.org" target="_blank">linux-dvb@linuxtv.org</a><br>
<a href="http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" target="_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br>
</blockquote></div><br>

------=_Part_26890_1673306.1207905961839--


--===============0021757865==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0021757865==--
