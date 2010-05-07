Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43928 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab0EGLwG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 May 2010 07:52:06 -0400
Received: by wyg36 with SMTP id 36so724856wyg.19
        for <linux-media@vger.kernel.org>; Fri, 07 May 2010 04:52:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <r2u156a113e1005062314yc9c974bcm8399cfa9251816e1@mail.gmail.com>
References: <y2n2256c86e1005061726n72921cb9r28d81df677f7b5e8@mail.gmail.com>
	 <r2u156a113e1005062314yc9c974bcm8399cfa9251816e1@mail.gmail.com>
Date: Fri, 7 May 2010 15:52:02 +0400
Message-ID: <x2x2256c86e1005070452gb2e26af6w50df82169619c432@mail.gmail.com>
Subject: Re: [em28xx] No sound in Leadtek WinFast TV USB II (not Deluxe)
From: Vladimir <volch5@gmail.com>
To: Magnus Alm <magnus.alm@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/5/7 Magnus Alm <magnus.alm@gmail.com>:
>
> Hi, the main problem (I think) is that your box doesn't support audio
> over usb. So when you use the "card=28" option, it doesn't turn on the
> audio output connector. Your box has a Em2800 chip, where the "Deluxe"
> version uses a Em2820.
>
> I'll take a look at the code when I comes home, maybe I can figure
> something out. Your box is supposed to be supported but maybe some
> regression in the codes has happend.
>
> /Magnus
>

Hi, afaik there are two (minimal) revisions of Leadtek WinFast TV USB
II - one with Em2800 and some LG tuner and one with Em2820 with
Phillips FM1216ME/I H3.
$lsusb
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 003: ID 0a81:0101 Chesen Electronics Corp. Keyboard
Bus 002 Device 002: ID 0458:0038 KYE Systems Corp. (Mouse Systems)
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 005: ID eb1a:2820 eMPIA Technology, Inc.  <---- my
Leadtek WinFast TV USB II
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

My box doesn't support usb audio but it is with Em2820 chip, doesn't
it? I can attach lsusb -v if needed
