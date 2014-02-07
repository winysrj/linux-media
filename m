Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64175 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaBGCvr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Feb 2014 21:51:47 -0500
Received: by mail-vc0-f174.google.com with SMTP id im17so2151028vcb.19
        for <linux-media@vger.kernel.org>; Thu, 06 Feb 2014 18:51:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1391679907-17876-1-git-send-email-david.jedelsky@gmail.com>
References: <1391679907-17876-1-git-send-email-david.jedelsky@gmail.com>
Date: Fri, 7 Feb 2014 08:21:47 +0530
Message-ID: <CAHFNz9KKjjbuRFS=TZtB4e2FuC5-UMyVN-yTrAeRbVCqdmVkwg@mail.gmail.com>
Subject: Re: [PATCH] [media] stb0899: Fix DVB-S2 support for TechniSat SkyStar
 2 HD CI USB ID 14f7:0002
From: Manu Abraham <abraham.manu@gmail.com>
To: David Jedelsky <david.jedelsky@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,


On Thu, Feb 6, 2014 at 3:15 PM, David Jedelsky <david.jedelsky@gmail.com> wrote:
>
> My TechniSat SkyStar 2 HD CI USB ID 14f7:0002 wasn't tuning DVB-S2 channels.
> Investigation revealed that it doesn't read DVB-S2 registers out of stb0899.
> Comparison with usb trafic of the Windows driver showed the correct
> communication scheme. This patch implements it.
> The question is, whether the changed communication doesn't break other devices.
> But the read part of patched _stb0899_read_s2reg routine is now functinally
> same as (not changed) stb0899_read_regs which reads ordinrary DVB-S registers.
> Giving high chance that it should work correctly on other devices too.


The patch does not look correct. STB0899 has a well documented
I2C access method, which involves dummy reads, prior to any
other. Also, the S2 regs access are different from the standard
register access. That's the first part of the register access.

The second part,
According to 7914335A, the output buffer is not updated until a
new address is requested. The controller returns the same value
given in the first read operation. Thus the current code.

So, most likely, all your modified read_s2reg would be reading
incorrect data out of the registers that you requested; ie could
be likely reading a standard register, or could possibly be
returning data for some other read.

With the current code, Without any changes S2 access does work
correctly with most bridges. It's extremely strange such a change
can cause things to work for you. From what I can see, your
USB I2C interface has an incorrect or a bad implementation
(I have seen such weirdness with some I2C implementations),
which could be a likely explanation for your symptoms.

Generally, a bug with the USB host device firmware, or a bug with
USB-I2C driver is the most probable case.

Best Regards,

Manu
