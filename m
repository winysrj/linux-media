Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.data-modul.de ([212.184.205.171]:41691 "HELO
	mailgw1.data-modul.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752041Ab2LLNbr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Dec 2012 08:31:47 -0500
From: "Fricke, Silvio" <SFricke@data-modul.com>
To: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	=?iso-8859-1?Q?Guitarte_P=E9rez=2C_Jes=FAs_Fernando?=
	<JGuitarte@data-modul.com>
Subject: request for linux driver for Analogix ANX9804/ANX9805
Date: Wed, 12 Dec 2012 13:20:46 +0000
Message-ID: <CB1254936A837D40B8C8611AEC83D691065C2388@MS-DM-M01.DATA-MODUL.com>
Content-Language: de-DE
Content-Type: text/plain; charset=US-ASCII
Content-ID: <1A5BE639E70894488868D66C8654BB35@DATA-MODUL.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

We have developed a prototype of an i.mx6 CPU-module connected to an ANALOGIX
AN9804 chip. This is a DisplayPort/HDMI-Transmitter [1]. This is a converter for simple rgb-signals
to DisplayPort and HDMI signals. The ANX is connected with the i.mx6 over i2c. Audio plays in this
context also a role.

The chip has these features:

- DisplayPort 1.1a with HDCP 1.3
- HDMI 1.3 with HDCP 1.2
- HDMI 1.2 and DVI 1.0 backward compatible

output:
- Dual Mode: DisplayPort or HDMI output
- 1/2/4 lane operation at up to HBR(2.7Gbps/lane) and RBR(1.62 Gbps/lane)
- DisplayPort mode Spread Spectrum Clock (SSC) support
- Support up to 2560X1600(WQXGA)@60Hz with 30bpp colour depth
- YCbCr to RGB conversion
- 4:4:4 and 4:2:2 data input formats
- 18/24/30/36 bits per pixel video support
- Embedded audio support
- HDCP encryption

input:
- 18-bit DVO/LVTTL flexible video input
- SDR and DDR data modes support
- Deep colour up to 36bpp in DDR support

audio input:
- S/PDIF audio mode including two-channel uncompressed L-PCM and multi-channel compressed DTS
  support
- 32,44.1,48,88.2,96,176.4 to 192KHz audio sampling rates support

others:
- Embedded HDCP key shared for DisplayPort, HDMI , and DVI modes
- Programmable output swing and pre-emphasis
- Support of upstream content protection protocol with embedded upstream keys
- Hot Plug and Unplug detection mechanism
- Built-in video pattern generator and audio tone generator for system self-test

I have checked it, and it does not exist any kind of linux driver for the ANX9804. My company
doesn't have currently the skills (and manpower) to bring this device to mainline kernel. Have
someone skills and courage to bring this hardware device to mainline kernel?
I will offer one iMX6 based development board for developing the device driver and after success of
the project, for the developer as gift to dominate the world.

[1] http://www.analogix.com/products/9805.html

best regards,
Silvio

-- 
-- S. Fricke --------------- jabber:silvio@conversation.port1024.net --
   Data Modul AG                            TEL:    +49-89-56017-  0
   Basic Development                        FAX:    +49-89-56017-119
   Linux - Development                       RG: HR-Muenchen B-85591
-- Landsberger Str. 322 D-80687 Muenchen - http://www.data-modul.com 