Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:60534 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669AbZIJNjC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 09:39:02 -0400
Received: by bwz19 with SMTP id 19so89621bwz.37
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2009 06:39:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <18737.168.87.60.62.1252586475.squirrel@wm.feuersaenger.de>
References: <18737.168.87.60.62.1252586475.squirrel@wm.feuersaenger.de>
Date: Thu, 10 Sep 2009 09:39:03 -0400
Message-ID: <829197380909100639m52cbd9ao4892ed6194ffbd50@mail.gmail.com>
Subject: Re: Problems with Haupauge WinTV-HVR 900
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?Martin_Feuers=E4nger?= <m@feuersaenger.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/9/10 Martin Feuersänger <m@feuersaenger.de>:
> Hi list,
>
> I own the above TV USB stick (the 2040:6500 version, which is revision 1
> of the model)since a while now but didn't use it for several months (and
> kernel versions) now. It used to work in previous kernel versions.
>
> I guess that quite some things have changed in the kernel modules since
> last time I used the stick. From my previous usage I still had the
> xc3023_*.i2c.fw files hanging around in /lib/firmware but they seem
> obsolete now. So I followed the firmware extraction information (which was
> new to me) at http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028
> where it is claimed that the extracted firmware should "work with a large
> number of boards from different manufacturers."
>
> However, I seem to have problems. Right now I'm running
> 2.6.30-4.slh.2-sidux-686 kernel version (provided by the sidux team) and
> when plugging in the stick I get
>
> xc2028 0-0061: creating new instance
> xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
> i2c-adapter i2c-0: firmware: requesting xc3028-v27.fw
> xc2028 0-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028
> firmware,
> ver 2.7
> xc2028 0-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
> xc2028 0-0061: Loading firmware for type=MTS (4), id ffffffffffffffff.
> xc2028 0-0061: attaching existing instance
> xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
>
> (Full dmesg output can be seen at http://pastebin.com/f148257f6)
>
> When I try to do something with the stick I get error messages saying
> "Incorrect readback of firmware version."
>
> From googleing I found that other people with the same device for the
> type=MTS have a line with a different id, i.e.
>
> xc2028 0-0061: Loading firmware for type=MTS (4), id 000000000000b700.
>
> I hope that someone on this list can identify what problem I have/what I
> do wrong.
>
> Thanks in advance!
>
>  Martin

Hello Martin,

There was a regression with the HVR-900 that exhibited this behavior,
for which my fix was merged on July 15th.

Please update to the latest v4l-dvb code and that should address your
issue.  Instructions below:

http://linuxtv.org/repo

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
