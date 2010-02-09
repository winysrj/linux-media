Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.juropnet.hu ([212.24.188.131]:40006 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030Ab0BIRcA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2010 12:32:00 -0500
Received: from kabelnet-193-82.juropnet.hu ([91.147.193.82])
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1NettP-0006Yk-Jb
	for linux-media@vger.kernel.org; Tue, 09 Feb 2010 18:29:20 +0100
Message-ID: <4B719CD0.6060804@mailbox.hu>
Date: Tue, 09 Feb 2010 18:35:12 +0100
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: DTV2000 H Plus issues
References: <4B3F6FE0.4040307@internode.on.net> <4B3F7B0D.4030601@mailbox.hu> <4B405381.9090407@internode.on.net> <4B421BCB.6050909@mailbox.hu> <4B4294FE.8000309@internode.on.net> <4B463AC6.2000901@mailbox.hu>
In-Reply-To: <4B463AC6.2000901@mailbox.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have an updated version now, with these changes:
  - the firmware file name can be specified with the "firmware_name"
    module parameter; it defaults to "xc4000.fw"
  - there is another new module parameter ("audio_std") for configuring
    the audio standard (NICAM, A2, etc.), and switching FM radio to
    using input 1 (i.e. cable TV instead of FM antenna). This is an
    integer value which can be the sum of:
      1: use NICAM/B or A2/B instead of NICAM/A or A2/A
      2: use A2 instead of NICAM or BTSC
      4: use SECAM K3 instead of K1
      8: in SECAM D/K mode, set the IF frequency and audio mode as for
         SECAM-L (this hack fixed the one SECAM channel I can receive)
     16: use FM radio input 1 instead of input 2
     32: mono TV audio (does not seem to work, so it is useless)
  - "struct xc4000_config" has a new member ("card_type") for specifying
    the card type
  - some code changes to allow for loading the new firmware files below
In addition to analog TV and FM radio, I have tested the IR as well, and
it apparently works. DVB-T is still untested, however.

There are two separate patches for v4l-dvb revision 28f5eca12bb0: the
first one adds the XC4000 driver, while the second one adds support for
the Leadtek WinFast DTV2000H Plus card in the CX88 driver.

http://www.sharemation.com/IstvanV/v4l/xc4000-28f5eca12bb0.patch
http://www.sharemation.com/IstvanV/v4l/cx88-dtv2000h+-28f5eca12bb0.patch

These new firmware files are more complete than the previous ones, but
are not compatible with the original driver. Both version 1.2 and 1.4
are available:

http://www.sharemation.com/IstvanV/v4l/xc4000-1.2.fw
http://www.sharemation.com/IstvanV/v4l/xc4000-1.4.fw

Note that the 1.4 firmware could have two different versions of DTV6,
which only differ in the audio mode register: 0x8002 (as in v1.2) vs.
0x8003. However, the above file includes only the latter one.

The following simple utility was used for creating the firmware files.
It can extract the firmware data from a Windows driver file (e.g.
hcw85bda.sys from Hauppauge, wfeaglxt.sys from Leadtek, etc.;
dvb7700all.sys from Pinnacle will not work, however), and supports both
v1.2 and v1.4 firmware. The tables at the beginning of the code are not
necessarily fully correct, though, and may need some fixing.

http://www.sharemation.com/IstvanV/v4l/xc4000fw.c

On 01/07/2010 08:49 PM, istvan_v@mailbox.hu wrote:

> On 01/05/2010 02:25 AM, Raena Lea-Shannon wrote:
> 
>> Thanks. Will try again later.
> 
> By the way, for those who would like to test it, here is a patch based
> on Devin Heitmueller's XC4000 driver and Mirek Slugen's older patch,
> that adds support for this card:
>   http://www.sharemation.com/IstvanV/v4l/dtv2000h+.patch
> It can be applied to this version of the v4l-dvb code:
>   http://linuxtv.org/hg/v4l-dvb/archive/75c97b2d1a2a.tar.bz2
> This is experimental code, so use it at your own risk. The analogue
> parts (TV and FM radio) basically work, although there are some minor
> issues to be fixed. Digital TV is not tested yet, but is theoretically
> implemented; reports on whether it actually works are welcome.
