Return-path: <linux-media-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.191]:62327 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab0AMPol (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2010 10:44:41 -0500
Received: by gv-out-0910.google.com with SMTP id r4so189483gve.37
        for <linux-media@vger.kernel.org>; Wed, 13 Jan 2010 07:44:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B4D852F.4030506@skynet.be>
References: <4B4CE912.1000906@von-eitzen.de>
	 <829197381001121344l3ad94bdajdd4eb0345b895f2b@mail.gmail.com>
	 <4B4D852F.4030506@skynet.be>
Date: Wed, 13 Jan 2010 10:44:39 -0500
Message-ID: <829197381001130744m24da5ea3xe1cb5135237b1127@mail.gmail.com>
Subject: Re: VL4-DVB compilation issue not covered by Daily Automated
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: xof <xof@skynet.be>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jan 13, 2010 at 3:32 AM, xof <xof@skynet.be> wrote:
> Are you sure? (it is an Ubuntu-only issue)
>
> I can see several
>> #include <asm/asm.h>
> in the v4l tree that compile fine on Ubuntu
> but only linux/drivers/media/dvb/firewire/firedtv-1394.c contains
>> #include <asm.h>
> and doesn't compile.
>
> Unfortunately the asm.h asm/asm.h is not the only issue with
> firedtv-1394.c (on Ubuntu/Karmic Koala?).
> The /drivers/ieee1394/*.h seem to be in the linux-sources tree and not
> in the linux-headers one (?)
>
> Everywhere I look, I read "don't bother, just disable firedtv-1394.c"
> until they fix it.

I think perhaps you meant to write "dma.h" and not "asm.h".

All of the missing includes in the error log (including "dma.h") are
for files that are found in the iee1394 source directory, which are
not provided in the Ubuntu linux-headers package.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
