Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:61838 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbZG2AoJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2009 20:44:09 -0400
Received: by gxk9 with SMTP id 9so758897gxk.13
        for <linux-media@vger.kernel.org>; Tue, 28 Jul 2009 17:44:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A6F8AA5.3040900@iol.it>
References: <4A6F8AA5.3040900@iol.it>
Date: Tue, 28 Jul 2009 20:44:09 -0400
Message-ID: <829197380907281744o5c3a7eb7rd0d2cb8c53cd646f@mail.gmail.com>
Subject: Re: Terratec Cinergy HibridT XS
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: efa@iol.it
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 28, 2009 at 7:32 PM, Valerio Messina<efa@iol.it> wrote:
> hi all,
>
> I own a Terratec Cinergy HibridT XS
> with lsusb ID:
> Bus 001 Device 007:
> ID 0ccd:0042 TerraTec Electronic GmbH Cinergy Hybrid T XS
>
> With past kernel and a patch as suggested here:
> http://www.linuxtv.org/wiki/index.php/TerraTec
> that link to:
> http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_Hybrid_T_USB_XS
> that link to:
> http://mcentral.de/wiki/index.php5/Main_Page
> and some troubles for Ubuntu kernel that I solved here:
> https://bugs.launchpad.net/bugs/322732
> worked well for a year or more.
>
> With last Ubuntu 9.04, kernel 2.6.28-13 seems have native support for the
> tuner, but from dmesg a file is missing: xc3028-v27.fw
> (maybe manage I2C for IR?)
> I found it on a web site, copied in /lib/firmware
> and now Kaffeine work, but ... no more IR remote command work.
>
> More bad now:
> http://mcentral.de/wiki/index.php5/Installation_Guide
> sell TV tuner, and do not support anymore the Terratec tuner, the source
> repository is disappeared, and install instruction is a commercial.
>
>
> Any chanches?
>
> thanks in advace,
> Valerio

That device, including full support for the IR, is now supported in
the mainline v4l-dvb tree (and will appear in kernel 2.6.31).  Just
follow the directions here to get the code:

http://linuxtv.org/repo

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
