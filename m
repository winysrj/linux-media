Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe05.c2i.net ([212.247.154.130]:33420 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750698Ab2JCTG5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Oct 2012 15:06:57 -0400
From: Hans Petter Selasky <hselasky@c2i.net>
To: Jose Alberto Reguero <jareguero@telefonica.net>
Subject: Re: [PATCH] Add toggle to the tt3650_rc_query function  of the ttusb2 driver
Date: Wed, 3 Oct 2012 21:08:19 +0200
Cc: linux-media@vger.kernel.org
References: <2504977.yNAtCnX8Pk@jar7.dominio> <201210022152.11115.hselasky@c2i.net> <201210032057.07711.hselasky@c2i.net>
In-Reply-To: <201210032057.07711.hselasky@c2i.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210032108.19904.hselasky@c2i.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 03 October 2012 20:57:07 Hans Petter Selasky wrote:
> On Tuesday 02 October 2012 21:52:11 Hans Petter Selasky wrote:
> > On Saturday 08 September 2012 19:08:22 Jose Alberto Reguero wrote:
> > > This patch add the toggle bit to the tt3650_rc_query function of the
> > > ttusb2 driver.
> > > 
> > > Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>
> > > 
> > > Jose Alberto
> > 
> > Hi,
> > 
> > This patch looks OK.
> 
> Hi,
> 
> > Regarding the TTUSB2 support, I see an issue where the IR polling
> > interference with the CAM access. If a IR poll request happens exactly
> > between a write/read CAM request, then that CAM request will fail. How
> > can this issue be solved without disabling the IR support entirely?
> 
> I checked the code and see that "dvb_usb_generic_rw()" will synchronize the
> requests, so this can't be the root cause. Currently I suspect the not
> brand new AMD based EHCI controller I'm using to connect my TTUSB adapter
> to be at fault. This is FreeBSD, not Linux. What I see when I dump all the
> transactions is that I have quite frequent timeouts on some of the I2C/CAM
> and IR commands going on the BULK endpoints. For example grepp'ed log
> extract looks like this:
> 
>  0000  55 3B 42 02 00 A0 01 DF  00 00 00 00 00 FB F5 81  |U;B.............|
>  0000  AA 3C 42 02 00 01 -- --  -- -- -- -- -- -- -- --  |.<B...          |
>  0000  55 3C 42 02 00 01 01 DF  00 00 00 00 00 FB F5 81  |U<B.............|
>  0000  AA 3D 42 02 00 01 -- --  -- -- -- -- -- -- -- --  |.=B...          |
> 18:46:16.972329 usbus1.3 DONE-BULK-
> EP=00000081,SPD=HIGH,NFR=0,SLEN=0,IVAL=0,ERR=TIMEOUT
>  0000  AA 3E 31 04 11 01 01 1A  -- -- -- -- -- -- -- --  |.>1.....        |
>  0000  55 3E 31 04 10 01 01 DF  00 00 00 00 00 FB F5 81  |U>1.............|
>  0000  AA 3D 42 02 00 01 -- --  -- -- -- -- -- -- -- --  |.=B...          |
>  0000  55 3D 42 02 00 01 01 DF  00 00 00 00 00 FB F5 81  |U=B.............|
>  0000  AA 40 41 01 01 -- -- --  -- -- -- -- -- -- -- --  |.@A..           |
> 
> I'm now trying some EHCI quirks, and will see what results I get later this
> week.
> 
> I can also say that VDR receives a ring buffer overflow at exactly the same
> time the USB BULK endpoint timeout happens ....
> 
> If this sounds familar to anyone, please let me know.
> 
> Thank you,
> 
> --HPS

More info if anyone cares to look at it:

vdr: [680141312] ERROR: can't write to CI adapter on device 0: Device not configured
vdr: [680142848] ERROR: 7 ring buffer overflows (1316 bytes dropped)
vdr: [680141312] CAM 1: module present
vdr: [680141312] CAM 1: module ready
vdr: [680141312] CAM 1: Conax Conditional Access, 01, 0B00, 0001
vdr: [680141312] CAM 1: doesn't reply to QUERY - only a single channel can be decrypted
vdr: [680141312] ERROR: can't write to CI adapter on device 0: Device not configured
vdr: [680142848] ERROR: 11 ring buffer overflows (2068 bytes dropped)
vdr: [680141312] CAM 1: module present
vdr: [680141312] CAM 1: module ready
vdr: [680141312] CAM 1: Conax Conditional Access, 01, 0B00, 0001
vdr: [680141312] CAM 1: doesn't reply to QUERY - only a single channel can be decrypted

Happens regularly, interrupts the stream and is very annoying :-)

--HPS

