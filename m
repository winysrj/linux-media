Return-path: <linux-media-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.191]:15312 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbZKIRdi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 12:33:38 -0500
Received: by gv-out-0910.google.com with SMTP id r4so268941gve.37
        for <linux-media@vger.kernel.org>; Mon, 09 Nov 2009 09:33:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ad6681df0911090919i717a7ac3occdf8e260def2193@mail.gmail.com>
References: <ad6681df0911090313t17652362v2e92c465b60a92e4@mail.gmail.com>
	 <20091109144647.2f876934@pedra.chehab.org>
	 <ad6681df0911090919i717a7ac3occdf8e260def2193@mail.gmail.com>
Date: Mon, 9 Nov 2009 12:33:42 -0500
Message-ID: <829197380911090933y76e53e57o940520a0e7912092@mail.gmail.com>
Subject: Re: [XC3028] Terretec Cinergy T XS wrong firmware xc3028-v27.fw
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Valerio Bontempi <valerio.bontempi@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 9, 2009 at 12:19 PM, Valerio Bontempi
<valerio.bontempi@gmail.com> wrote:
> Hi All,
>
> first thank you for your quick support.
> I have already extracted and installed the xc3028-v27.fw firmware file
> following the instructions contained in
> http://www.linuxtv.org/wiki/index.php/Xceive_XC3028/XC2028#How_to_Obtain_the_Firmware
>
> but with no luck, the device is detected but the dvb device /dev/dvb
> is not created
>
> Attached you find the v4l-info output.
>
> I think that the extracted firmware is not the right one, since the
> device is detected correctly.
>
> Just two note:
> first: until kernel 2.6.31 I was able to use this device compiling
> em28xx-new source tree, but this driver version is no more compatible
> with last kernel versions.
> second: I tried to compile last v4l-dvb source code but the compilation failed.
>
> Is there a way to solve this problem?

Support for that particular device came after 2.6.31 went out, so it's
not in the stock 9.10 release.  In 9.10 the device was detected but
the driver did not create the DVB interface for that product.  It is
not a firmware problem.

The em28xx-new tree that Markus maintained is long deprecated.

The tree doesn't compile cleanly against Karmic due to a bug in their
packaging of the kernel headers.  To workaround it, open v4l/.config
and change the fedtv driver from "=m" to "=n".

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
