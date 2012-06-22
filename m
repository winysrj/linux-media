Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:54666 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab2FVQXR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 12:23:17 -0400
Received: by gglu4 with SMTP id u4so1679740ggl.19
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2012 09:23:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALF0-+ViQTmGnAS19kOCZPZAj0ZYZX4Ef-+J7A=k1J2OFhFuVg@mail.gmail.com>
References: <CACK0K0gXr08aNe3gKkWXmKkZ+JA0RBcWtq35aFfNaSqCCWMM1Q@mail.gmail.com>
	<CALF0-+ViQTmGnAS19kOCZPZAj0ZYZX4Ef-+J7A=k1J2OFhFuVg@mail.gmail.com>
Date: Fri, 22 Jun 2012 13:23:16 -0300
Message-ID: <CALF0-+XoKmw0fe_vpOs-BEZXDZThA5WuNw8CRjohLJojZ2O4Dw@mail.gmail.com>
Subject: Fwd: stk1160 linux driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Gianluca Bergamo <gianluca.bergamo@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gianluca,

Forwarded to linux-media, since it could be interesting
and/or might get some extra help.

Please, keep linux-media in Cc when you reply.

Ezequiel.

---------- Forwarded message ----------
From: Ezequiel Garcia <elezegarcia@gmail.com>
Date: Fri, Jun 22, 2012 at 1:19 PM
Subject: Re: stk1160 linux driver
To: Gianluca Bergamo <gianluca.bergamo@gmail.com>


Hi!

On Fri, Jun 22, 2012 at 9:00 AM, Gianluca Bergamo
<gianluca.bergamo@gmail.com> wrote:
> Dear Ezequiel,
>
> I've found your driver implementation for stk1160 grabber card:
> http://patchwork.linuxtv.org/patch/11575/
>
> I've patched my kernel 3.0.8 and it compiles without problems.
> I've compiled it NOT as a module but directly built in in the kernel.
>
> Now when I insert my grabber card I see only the USB level messages:
>
> [   83.638497] usb 1-1: new high speed USB device number 2 using usb20_otg
> [   83.849347] usb 1-1: New USB device found, idVendor=05e1, idProduct=0408
> [   83.856077] usb 1-1: New USB device strings: Mfr=1, Product=2,
> SerialNumber=0
> [   83.863258] usb 1-1: Product: USB 2.0 Video Capture Controller
> [   83.869634] usb 1-1: Manufacturer: Syntek Semiconductor
>
> VID and PID are ok.
>
> What am I doing wrong?
>

Glad to see someone is using the driver :-)

Why are you compiling it built-in instead of module?
I can't try it right now, but tomorrow I'll compile built-in myself
with 3.0.8 and let you now.

Anyway, send me full dmesg.

Thanks,
Ezequiel.
