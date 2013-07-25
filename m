Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:55356 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145Ab3GYU7D (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 16:59:03 -0400
Received: from [192.168.1.20] ([90.146.158.247]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0M09Ee-1UEuLJ12BY-00uIbE for
 <linux-media@vger.kernel.org>; Thu, 25 Jul 2013 22:59:01 +0200
Message-ID: <1374785938.2250.3.camel@nicisha>
Subject: Re: occasional problems with Technotrend TT-connect CT3650+CI -
 additional logs
From: Martin Maurer <martinmaurer@gmx.at>
To: linux-media@vger.kernel.org
Date: Thu, 25 Jul 2013 22:58:58 +0200
In-Reply-To: <1372535877.2338.14.camel@nicisha>
References: <1372535877.2338.14.camel@nicisha>
Content-Type: multipart/mixed; boundary="=-w5NNjM7NKtboilQxQod7"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-w5NNjM7NKtboilQxQod7
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

Hi,

I took some logs with debug flags enabled:
options dvb-usb debug=81
options dvb-usb-ttusb2 debug=1 debug_ci=1

After the "DVB CAM link initialization failed" I won't get more logs for
a few hours. At some time the TV card recovers without any intervention.

Do you have any ideas what is wrong here?

thanks,
Martin


On Sat, 2013-06-29 at 21:57 +0200, Martin Maurer wrote:
> Hi all,
> 
> I use the card CT3650 with the CI slot together with Mythtv (USB Card
> with integrated CI slot). Mostly this works fine, but every few
> recordings of encrypted programs fail. The logs hint that there is some
> problem with the CI initialization. Mythtv apparently doesn't correctly
> detect that the recording failed, as the recording remains marked as
> "Still recording" in the web-interface. The file size is 0 bytes.
> After such a recording fails it usually happens, that the next recording
> is fine again without any intervention by me.
> 
> I already replaced the USB cable by another one to rule this out. Don't
> want to replace the card unless I am sure that it is faulty.
> 
> Some data:
> I am using Ubuntu 12.04.2 LTS
> uname -a: Linux ashanta 3.5.0-26-generic #42~precise1-Ubuntu SMP Mon Mar
> 11 22:19:42 UTC 2013 i686 i686 i386 GNU/Linux
> 
> ---------------------------
> Today a recording failed at 10:06 AM:
> 
> Dmesg output: 
> [Sat Jun 29 09:56:50 2013] dvb_ca adapter 0: DVB CAM detected and
> initialised successfully
> [Sat Jun 29 10:02:15 2013] dvb_ca adapter 0: DVB CAM link initialisation
> failed :(
> [Sat Jun 29 10:56:47 2013] dvb_ca adapter 0: DVB CAM detected and
> initialised successfully
> 
> Mythtv output:
> see attachment
> 
> lsmod:
> see attachment
> ---------------------------
> 
> Other interesting dmesg messages:
> [Thu Jun 27 18:39:22 2013] dvb_ca adapter 0: CAM tried to send a buffer
> larger than the link buffer size (49087 > 128)!
> ...
> [Fri Jun 28 02:44:48 2013] dvb_ca adapter 0: Invalid PC card inserted :(
> ...
> [Sat Jun 29 11:13:01 2013] dvb_ca adapter 0: DVB CAM link initialisation
> failed :(
> ...
> 
> Anything I can do provide further data?
> In my opinion it would be interesting to discover such situations and
> automatically retry without the client programs (as mythtv) noticing it.
> 
> thanks,
> Martin


--=-w5NNjM7NKtboilQxQod7
Content-Disposition: attachment; filename="dmesg.txt"
Content-Type: text/plain; name="dmesg.txt"; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

[Thu Jul 25 20:13:36 2013] ttusb2: tt3650_ci_read_attribute_mem 00e6 -> 0 0x4f
[Thu Jul 25 20:13:36 2013] ttusb2: tt3650_ci_read_attribute_mem 00e8 -> 0 0x44
[Thu Jul 25 20:13:36 2013] ttusb2: tt3650_ci_read_attribute_mem 00ea -> 0 0x55
[Thu Jul 25 20:13:36 2013] ttusb2: tt3650_ci_read_attribute_mem 00ec -> 0 0x4c
[Thu Jul 25 20:13:36 2013] ttusb2: tt3650_ci_read_attribute_mem 00ee -> 0 0x45
[Thu Jul 25 20:13:36 2013] ttusb2: tt3650_ci_read_attribute_mem 00f0 -> 0 0x00
[Thu Jul 25 20:13:36 2013] ttusb2: tt3650_ci_read_attribute_mem 00f2 -> 0 0x14
[Thu Jul 25 20:13:36 2013] ttusb2: tt3650_ci_read_attribute_mem 00f4 -> 0 0x00
[Thu Jul 25 20:13:36 2013] ttusb2: tt3650_ci_read_attribute_mem 00f6 -> 0 0xff
[Thu Jul 25 20:13:36 2013] ttusb2: tt3650_ci_write_attribute_mem 0 0x01fe 0x0f
[Thu Jul 25 20:13:36 2013] ttusb2: tt3650_ci_read_attribute_mem 01fe -> 0 0x0f
[Thu Jul 25 20:13:36 2013] ttusb2: tt3650_ci_write_cam_control 0 0x01 0x08
[Thu Jul 25 20:13:36 2013] ttusb2: tt3650_ci_set_video_port 0 0
[Thu Jul 25 20:13:36 2013] ttusb2: tt3650_ci_slot_reset 0
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0000 -> 0 0x1d
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0002 -> 0 0x04
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0004 -> 0 0x00
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0006 -> 0 0xdb
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0008 -> 0 0x08
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 000a -> 0 0xff
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 000c -> 0 0x1c
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 000e -> 0 0x03
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0010 -> 0 0x00
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0012 -> 0 0x08
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0014 -> 0 0xff
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0016 -> 0 0x15
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0018 -> 0 0x15
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 001a -> 0 0x05
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 001c -> 0 0x00
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 001e -> 0 0x53
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0020 -> 0 0x43
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0022 -> 0 0x4d
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0024 -> 0 0x00
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0026 -> 0 0x44
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0028 -> 0 0x56
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 002a -> 0 0x42
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 002c -> 0 0x20
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 002e -> 0 0x43
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0030 -> 0 0x41
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0032 -> 0 0x20
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0034 -> 0 0x4d
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0036 -> 0 0x6f
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0038 -> 0 0x64
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 003a -> 0 0x75
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 003c -> 0 0x6c
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 003e -> 0 0x65
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0040 -> 0 0x00
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0042 -> 0 0xff
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0044 -> 0 0x20
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0046 -> 0 0x04
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0048 -> 0 0xff
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 004a -> 0 0xff
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 004c -> 0 0x01
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 004e -> 0 0x00
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0050 -> 0 0x1a
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0052 -> 0 0x15
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0054 -> 0 0x01
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0056 -> 0 0x0f
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0058 -> 0 0xfe
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 005a -> 0 0x01
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 005c -> 0 0x01
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 005e -> 0 0xc0
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0060 -> 0 0x0e
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0062 -> 0 0x41
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0064 -> 0 0x02
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0066 -> 0 0x44
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0068 -> 0 0x56
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 006a -> 0 0x42
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 006c -> 0 0x5f
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 006e -> 0 0x43
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0070 -> 0 0x49
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0072 -> 0 0x5f
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0074 -> 0 0x56
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0076 -> 0 0x31
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0078 -> 0 0x2e
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 007a -> 0 0x30
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 007c -> 0 0x30
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 007e -> 0 0x1b
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0080 -> 0 0x11
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0082 -> 0 0xc9
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0084 -> 0 0x41
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0086 -> 0 0x19
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0088 -> 0 0x37
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 008a -> 0 0x55
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 008c -> 0 0x4e
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 008e -> 0 0x5e
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0090 -> 0 0x1d
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0092 -> 0 0x56
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0094 -> 0 0xaa
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0096 -> 0 0x60
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 0098 -> 0 0x20
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 009a -> 0 0x03
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 009c -> 0 0x03
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 009e -> 0 0x50
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00a0 -> 0 0xff
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00a2 -> 0 0xff
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00a4 -> 0 0x1b
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00a6 -> 0 0x25
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00a8 -> 0 0xcf
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00aa -> 0 0x04
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00ac -> 0 0x09
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00ae -> 0 0x37
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00b0 -> 0 0x55
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00b2 -> 0 0x4d
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00b4 -> 0 0x5d
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00b6 -> 0 0x1d
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00b8 -> 0 0x56
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00ba -> 0 0x22
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00bc -> 0 0xc0
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00be -> 0 0x09
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00c0 -> 0 0x44
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00c2 -> 0 0x56
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00c4 -> 0 0x42
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00c6 -> 0 0x5f
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00c8 -> 0 0x48
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00ca -> 0 0x4f
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00cc -> 0 0x53
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00ce -> 0 0x54
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00d0 -> 0 0x00



[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00d2 -> 0 0xc1
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00d4 -> 0 0x0e
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00d6 -> 0 0x44
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00d8 -> 0 0x56
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00da -> 0 0x42
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00dc -> 0 0x5f
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00de -> 0 0x43
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00e0 -> 0 0x49
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00e2 -> 0 0x5f
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00e4 -> 0 0x4d
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00e6 -> 0 0x4f
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00e8 -> 0 0x44
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00ea -> 0 0x55
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00ec -> 0 0x4c
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00ee -> 0 0x45
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00f0 -> 0 0x00
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00f2 -> 0 0x14
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00f4 -> 0 0x00
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 00f6 -> 0 0xff
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_write_attribute_mem 0 0x01fe 0x0f
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_attribute_mem 01fe -> 0 0x0f
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_write_cam_control 0 0x01 0x08
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_cam_control 0x01 -> 0 0x00
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_cam_control 0x01 -> 0 0x40
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_write_cam_control 0 0x01 0x84
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_cam_control 0x01 -> 0 0xc0
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_cam_control 0x01 -> 0 0xc0
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_cam_control 0x03 -> 0 0x00
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_cam_control 0x02 -> 0 0x02
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_cam_control 0x00 -> 0 0x00
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_cam_control 0x00 -> 0 0x80
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_cam_control 0x01 -> 0 0x40
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_write_cam_control 0 0x01 0x80
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_write_cam_control 0 0x01 0x82
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_cam_control 0x01 -> 0 0x40
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_cam_control 0x01 -> 0 0x40
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_write_cam_control 0 0x01 0x81
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_cam_control 0x01 -> 0 0x40
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_write_cam_control 0 0x03 0x00
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_write_cam_control 0 0x02 0x02
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_write_cam_control 0 0x00 0x00
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_write_cam_control 0 0x00 0x80
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_read_cam_control 0x01 -> 0 0x02
[Thu Jul 25 20:13:38 2013] ttusb2: tt3650_ci_write_cam_control 0 0x01 0x80
[Thu Jul 25 20:13:38 2013] dvb_ca adapter 0: DVB CAM link initialisation failed :(

--=-w5NNjM7NKtboilQxQod7
Content-Disposition: attachment; filename="mythtv.log"
Content-Type: text/x-log; name="mythtv.log"; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit


Jul 25 20:10:16 ashanta mythbackend[2639]: I Metadata_1991 jobqueue.cpp:2151 (DoMetadataLookupThread) JobQueue: Metadata Lookup Start
ing for "Navy CIS" recorded from channel 1008 at 2013-07-25T18:56:00
Jul 25 20:10:16 ashanta mythbackend[2639]: I CoreContext mythdbcon.cpp:395 (PurgeIdleConnections) New DB connection, total: 13
Jul 25 20:10:18 ashanta mythbackend[2639]: I ProcessRequest mainserver.cpp:1360 (HandleAnnounce) MainServer::ANN Monitor
Jul 25 20:10:18 ashanta mythbackend[2639]: I ProcessRequest mainserver.cpp:1362 (HandleAnnounce) adding: ashanta as a client (events:
 0)
Jul 25 20:10:18 ashanta mythbackend[2639]: I ProcessRequest mainserver.cpp:1360 (HandleAnnounce) MainServer::ANN Monitor
Jul 25 20:10:18 ashanta mythbackend[2639]: I ProcessRequest mainserver.cpp:1362 (HandleAnnounce) adding: ashanta as a client (events:
 1)
Jul 25 20:10:28 ashanta mythbackend[2639]: I HouseKeeping housekeeper.cpp:225 (RunHouseKeeping) Running housekeeping thread
Jul 25 20:10:33 ashanta mythbackend[2639]: I Scheduler scheduler.cpp:2035 (HandleReschedule) Reschedule requested for id 0.
Jul 25 20:10:34 ashanta mythbackend[2639]: I Scheduler scheduler.cpp:2095 (HandleReschedule) Scheduled 52 items in 0.7 = 0.00 match +
 0.71 place
Jul 25 20:13:25 ashanta mythbackend[2639]: I TVRecEvent tv_rec.cpp:1544 (HandlePendingRecordings) TVRec(1): ASK_RECORDING 1 3 0 0
Jul 25 20:13:25 ashanta mythbackend[2639]: I TVRecEvent tv_rec.cpp:1544 (HandlePendingRecordings) TVRec(2): ASK_RECORDING 2 3 0 0
Jul 25 20:13:30 ashanta mythbackend[2639]: I TVRecEvent tv_rec.cpp:1030 (HandleStateChange) TVRec(1): Changing from RecordingOnly to 
None
Jul 25 20:13:30 ashanta mythbackend[2639]: E DVBRead dvbstreamhandler.cpp:214 (RunTS) DVBSH(/dev/dvb/adapter0/frontend0): Device EOF detected
Jul 25 20:13:30 ashanta mythbackend[2639]: I CoreContext scheduler.cpp:637 (UpdateRecStatus) Updating status for "Navy CIS" on cardid 1 (Recording => Recorded)
Jul 25 20:13:30 ashanta mythbackend[2639]: I PreviewGeneratorQueue mythdbcon.cpp:395 (PurgeIdleConnections) New DB connection, total: 12
Jul 25 20:13:30 ashanta mythbackend[2639]: I TVRecEvent recordinginfo.cpp:1113 (FinishedRecording) Finished recording Navy CIS: channel 1008
Jul 25 20:13:30 ashanta mythbackend[2639]: I ProcessRequest mainserver.cpp:1360 (HandleAnnounce) MainServer::ANN Monitor
Jul 25 20:13:30 ashanta mythbackend[2639]: I ProcessRequest mainserver.cpp:1362 (HandleAnnounce) adding: ashanta as a client (events: 0)
Jul 25 20:13:30 ashanta mythbackend[2639]: I ProcessRequest mainserver.cpp:1360 (HandleAnnounce) MainServer::ANN Monitor
Jul 25 20:13:30 ashanta mythbackend[2639]: I ProcessRequest mainserver.cpp:1362 (HandleAnnounce) adding: ashanta as a client (events: 1)
Jul 25 20:13:35 ashanta mythbackend[2639]: E DVBCam dvbdev/dvbci.cpp:479 (RecvTPDU) ERROR: CAM: Read failed: slot 0, tcid 1
Jul 25 20:13:35 ashanta mythbackend[2639]: I TVRecEvent tv_rec.cpp:1030 (HandleStateChange) TVRec(1): Changing from None to RecordingOnly
Jul 25 20:13:35 ashanta mythbackend[2639]: I TVRecEvent tv_rec.cpp:3503 (TuningCheckForHWChange) TVRec(1): HW Tuner: 1->1
Jul 25 20:13:39 ashanta mythbackend[2639]: N Scheduler autoexpire.cpp:263 (CalcParams) AutoExpire: CalcParams(): Max required Free Space: 3.0 GB w/freq: 14 min
Jul 25 20:13:39 ashanta mythbackend[2639]: I Scheduler scheduler.cpp:2514 (HandleRecordingStatusChange) Tuning recording: "Navy CIS":"Das trojanische Pferd": channel 1004 on cardid 1, sourceid 1
Jul 25 20:13:39 ashanta mythbackend[2639]: I Scheduler scheduler.cpp:2035 (HandleReschedule) Reschedule requested for id 0.
Jul 25 20:13:39 ashanta mythbackend[2639]: N DVBRead dtvsignalmonitor.cpp:354 (HandlePMT) DTVSM(/dev/dvb/adapter0/frontend0): PMT says program 20007 is encrypted
Jul 25 20:13:40 ashanta mythbackend[2639]: I Scheduler scheduler.cpp:2095 (HandleReschedule) Scheduled 51 items in 0.6 = 0.00 match + 0.60 place
Jul 25 20:13:43 ashanta mythbackend[2639]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x700 status: Encrypted
Jul 25 20:13:52 ashanta mythbackend[2639]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x6ff status: Encrypted
Jul 25 20:13:58 ashanta mythbackend[2639]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x6ff status: Unknown
Jul 25 20:14:03 ashanta mythbackend[2639]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x6ff status: Encrypted
Jul 25 20:14:04 ashanta mythbackend[2639]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x6ff status: Unknown
Jul 25 20:14:12 ashanta mythbackend[2639]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x6ff status: Encrypted
Jul 25 20:14:12 ashanta mythbackend[2639]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x6ff status: Unknown
Jul 25 20:14:15 ashanta mythbackend[2639]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x6ff status: Encrypted
Jul 25 20:14:18 ashanta mythbackend[2639]: I DVBRead mpeg/mpegstreamdata.cpp:1980 (ProcessEncryptedPacket) PID 0x6ff status: Unknown
Jul 25 20:14:21 ashanta mythbackend[2639]: I Commflag_1992 jobqueue.cpp:2276 (DoFlagCommercialsThread) JobQueue: Commercial Detection Starting for "Navy CIS" recorded from channel 1008 at 2013-07-25T18:56:00

--=-w5NNjM7NKtboilQxQod7--

