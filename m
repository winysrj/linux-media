Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.211.173]:48391 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab0BATtn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Feb 2010 14:49:43 -0500
Received: by ywh3 with SMTP id 3so1939380ywh.22
        for <linux-media@vger.kernel.org>; Mon, 01 Feb 2010 11:49:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <21ce51251002011148h53629ad8vf161cdcf918a3fe8@mail.gmail.com>
References: <4B60A983.7040405@gmail.com>
	 <21ce51251002011145g1def10b4w8e6d17557d958180@mail.gmail.com>
	 <21ce51251002011148h53629ad8vf161cdcf918a3fe8@mail.gmail.com>
Date: Mon, 1 Feb 2010 20:49:42 +0100
Message-ID: <21ce51251002011149u1139c57em1fd8ca2427a188f2@mail.gmail.com>
Subject: dmesg output with Pinnacle PCTV USB Stick
From: Arnaud Boy <psykauze@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I've a card "PINNACLE PCTV HYBRID PRO (2)" with the PCI ID
"0x2304:0x0226". This is work on analog mode but the "em28xx" module
don't register dvb interface.

I think the card could work if we uncomment the commented part in the
section [EM2882_BOARD_PINNACLE_HYBRID_PRO] from the
"/linux/drivers/media/video/em28xx/em28xx-cards.c" file and we add his
reference card at the "/linux/drivers/media/video/em28xx/em28xx-dvb.c"

You can(must?) explain me why we couldn't have this card work with your driver.

Sincerely yours.

PS.: Sorry for my bad english.
