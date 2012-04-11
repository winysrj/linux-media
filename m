Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54574 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758176Ab2DKLpp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Apr 2012 07:45:45 -0400
Message-ID: <4F856EE1.6070805@redhat.com>
Date: Wed, 11 Apr 2012 08:45:37 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jannis <jannis-lists@kripserver.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] Add support for TechniSat SkyStar S2 / CX24120-13Z frontend
References: <4F7BF437.4090206@kripserver.net>
In-Reply-To: <4F7BF437.4090206@kripserver.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jannis,

Em 04-04-2012 04:11, Jannis escreveu:
> Hi all,
> 
> some (longer) time ago, I posted to this list concerning the
> CX24120-frontend
> (http://www.spinics.net/lists/linux-media/msg33717.html). By now I
> modified the patch to work with linux-3.4-r1 (after the DVB-interface
> changes):
> 
> [    2.434181] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV
> receiver chip loaded successfully
> [    2.434240] flexcop-pci: will use the HW PID filter.
> [    2.434242] flexcop-pci: card revision 2
> [    2.438105] DVB: registering new adapter (FlexCop Digital TV device)
> [    2.440018] b2c2-flexcop: MAC address = 00:08:c9:e0:87:57
> [    2.440024] CX24120: cx24120_attach: -> Conexant cx24120/cx24118 -
> DVBS/S2 Satellite demod/tuner
> [    2.440025] CX24120: cx24120_attach: -> Driver version: 'SVT - 0.0.4a
>        03.04.2012'
> [    2.440149] CX24120: cx24120_attach: -> Demod CX24120 rev. 0x07 detected.
> [    2.440150] CX24120: cx24120_attach: -> Conexant cx24120/cx24118 -
> DVBS/S2 Satellite demod/tuner ATTACHED.
> [    2.440440] b2c2-flexcop: ISL6421 successfully attached.
> [    2.440440] b2c2-flexcop: found 'Conexant CX24120/CX24118' .
> [    2.440442] DVB: registering adapter 0 frontend 0 (Conexant
> CX24120/CX24118)...
> [    2.440648] b2c2-flexcop: initialization of 'Sky2PC/SkyStar S2
> DVB-S/S2 rev 3.3' at the 'PCI' bus controlled by a 'FlexCopIIb' complete
> 
> As stated in the original message, the patch is not written by me, the
> author is Sergey Tyurin, I just modified it so it keeps working with
> current kernels. Since I don't know an appropiate location for
> publishing this, I thought this is best sent upstream.

If the patch was made by Sergey, you should add, at the beginning of the
body of the email, a like like:

From: Sergey Tyurin <his@email>


and add your comments like:

[jannis-lists@kripserver.net: patch ported to the current DVB kernel ABI]

You should also add your Signed-off-by:. It is also highly recommended
that you would get Sergey's Signed-off-by on it.

Please see LinuxTV developer wiki pages, in order to check the proper ways
to submit the patch upstream.

In particular, please check the patch using scripts/checkpatch.pl. This
tool checks the patch CodingStyle. It also checks a few trivial mistakes.

It currently doesn't like this code very much:

ERROR: Missing Signed-off-by: line(s)

total: 515 errors, 394 warnings, 1522 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

As you're not the author of the original driver, the better procedure is
to submit Sergey's driver as-is (but without the Kconfig/Makefile changes,
in order to avoid it to break compilation), then a patch fixing it to the
current ABI from you, and patch/patch series from you fixing the CodingStyle 
issues.

Btw, scripts/Lindent in general solves most of those issues (although it
is not a perfect tool).

> This patch was tested with some channels (SDTV, HDTV and audio only
> (radio)) from Astra-19.2E in Europe.
> 
> If you have any comments abouth things that stop the patch from going
> upstream, please feel free to tell me and I'll see if I can change them.

I just did a quick look on it, as it is harder to analyze a code with a
different CodingStyle.

There are too many EXPORT_SYMBOL() there, several of them for static functions.
That's wrong. Only non-static functions used by other modules should use
EXPORT_SYMBOL. Probably, the only function that requires it is cx24120_attach().

Anyway, I'll do a deeper review after you fix the pointed issues.
> 
> Best regards,
> 	Jannis Achstetter

Regards,
Mauro
