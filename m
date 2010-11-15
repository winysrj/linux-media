Return-path: <mchehab@pedra>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:38641 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933403Ab0KORn5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 12:43:57 -0500
Message-ID: <4CE1715B.2070403@arcor.de>
Date: Mon, 15 Nov 2010 18:43:55 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Richard Zidlicky <rz@linux-m68k.org>
CC: Massis Sirapian <msirapian@free.fr>, linux-media@vger.kernel.org
Subject: Re: HVR900H : IR Remote Control
References: <4CDFF446.2000403@free.fr> <4CE0047D.8060401@arcor.de> <4CE03704.4070300@free.fr> <20101115091544.GA23490@linux-m68k.org>
In-Reply-To: <20101115091544.GA23490@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

  Am 15.11.2010 10:15, schrieb Richard Zidlicky:
> On Sun, Nov 14, 2010 at 08:22:44PM +0100, Massis Sirapian wrote:
>
>> Thanks Stefan. I've checked the /drivers/media/IR/keymaps of the kernel
>> source directory, but nothing seems to fit my remote, which is a
>> DSR-0012 : http://lirc.sourceforge.net/remotes/hauppauge/DSR-0112.jpg.
> FYI, this remote is identical to that shipped with (most?) Haupauge Ministicks
> and the codes reportedly match the rc-dib0700-rc5.c keymap. However I have not figured
> out how to make the userspace work with the new ir-code yet.
>
> Richard
With my terratec cinergy hybrid xe (equal yours hvr900h) I have this:

localhost:/usr/src/src/tm6000_alsa/utils/v4l-utils # ir-keytable
Found /sys/class/rc/rc0/ (/dev/input/event5) with:
         Driver tm6000, table rc-nec-terratec-cinergy-xs
         Supported protocols: NEC RC-5   Enabled protocols: NEC

I can change outside the keytable.

