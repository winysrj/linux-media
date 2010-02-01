Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f223.google.com ([209.85.218.223]:60434 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab0BAUSX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Feb 2010 15:18:23 -0500
Received: by bwz23 with SMTP id 23so21455bwz.21
        for <linux-media@vger.kernel.org>; Mon, 01 Feb 2010 12:18:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <21ce51251002011149u1139c57em1fd8ca2427a188f2@mail.gmail.com>
References: <4B60A983.7040405@gmail.com>
	 <21ce51251002011145g1def10b4w8e6d17557d958180@mail.gmail.com>
	 <21ce51251002011148h53629ad8vf161cdcf918a3fe8@mail.gmail.com>
	 <21ce51251002011149u1139c57em1fd8ca2427a188f2@mail.gmail.com>
Date: Mon, 1 Feb 2010 15:18:21 -0500
Message-ID: <829197381002011218p70e8d216qc25a5e8b81d291c3@mail.gmail.com>
Subject: Re: dmesg output with Pinnacle PCTV USB Stick
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Arnaud Boy <psykauze@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 1, 2010 at 2:49 PM, Arnaud Boy <psykauze@gmail.com> wrote:
> Hi!
>
> I've a card "PINNACLE PCTV HYBRID PRO (2)" with the PCI ID
> "0x2304:0x0226". This is work on analog mode but the "em28xx" module
> don't register dvb interface.
>
> I think the card could work if we uncomment the commented part in the
> section [EM2882_BOARD_PINNACLE_HYBRID_PRO] from the
> "/linux/drivers/media/video/em28xx/em28xx-cards.c" file and we add his
> reference card at the "/linux/drivers/media/video/em28xx/em28xx-dvb.c"
>
> You can(must?) explain me why we couldn't have this card work with your driver.

The 2304:0226 is the PCTV 330e.  The DVB side is not currently
supported do to issues with the drx-d driver.  Search the linux-media
archives for "330e" for the history of this issue.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
