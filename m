Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f165.google.com ([209.85.217.165]:36700 "EHLO
	mail-gx0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbZCQCkF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 22:40:05 -0400
Received: by gxk9 with SMTP id 9so2479949gxk.13
        for <linux-media@vger.kernel.org>; Mon, 16 Mar 2009 19:40:02 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 16 Mar 2009 22:40:01 -0400
Message-ID: <d6a802e70903161940t2ce9d20aw46360de23d987d29@mail.gmail.com>
Subject: Strange card
From: Eduardo Kaftanski <ekaftan@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I bought today a card that was packaged as a PICO2000-compatible but I
can't get it to work... I read all the archives and wikis I could find
but the only one thread with the same card description but the recipe
won't work for me.

Here is the lspci... is this card supported?

01:0a.0 Multimedia video controller: Brooktree Corporation Unknown
device 016e (    rev 11)
        Flags: bus master, fast devsel, latency 32, IRQ 11
        Memory at d9fff000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2

01:0a.1 Multimedia controller: Brooktree Corporation Bt878 Audio
Capture (rev 11    )
        Flags: bus master, fast devsel, latency 32, IRQ 11
        Memory at d9ffe000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2


THanks.



-- 
---
Eduardo Kaftanski
ekaftan@gmail.com
eduardo@orsus.cl
