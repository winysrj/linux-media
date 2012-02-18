Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52883 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab2BRRQV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Feb 2012 12:16:21 -0500
Received: by vbjk17 with SMTP id k17so2862746vbj.19
        for <linux-media@vger.kernel.org>; Sat, 18 Feb 2012 09:16:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120218170440.GA13834@brain.nahmias.net>
References: <20120218170440.GA13834@brain.nahmias.net>
Date: Sat, 18 Feb 2012 12:16:19 -0500
Message-ID: <CAGoCfiwSVbCQYaR2UknKGg8E+vTq59e0eoRwf8fbOG67VFpboQ@mail.gmail.com>
Subject: Re: HVR-2250 remote
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Joe Nahmias <joe@nahmias.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Feb 18, 2012 at 12:04 PM, Joe Nahmias <joe@nahmias.net> wrote:
> Hello,
>
> I have a Hauppauge WinTV HVR 2250 card, which is working great for video
> using the saa7164 kernel driver.  I was wondering if the remote control
> that comes with it is supported under lirc.  I'm running Debian wheezy
> with kernel 3.2.0 and lirc 0.9.0-pre1.
>
> Thanks in advance for any help,
> --Joe

No, it is not supported.  Steven never got around to writing the
saa7164 driver support for IR.

Just spend $20 and buy yourself an MCEUSB kit.  It will probably work
better anyway (and is much easier to install than most of the IR
drivers that are for chipsets bundled with the tuners).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
