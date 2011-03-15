Return-path: <mchehab@pedra>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40428 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011Ab1COPT3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2011 11:19:29 -0400
Received: by vxi39 with SMTP id 39so653093vxi.19
        for <linux-media@vger.kernel.org>; Tue, 15 Mar 2011 08:19:28 -0700 (PDT)
MIME-Version: 1.0
From: Antoine Maillard <antoine.maillard@gmail.com>
Date: Tue, 15 Mar 2011 16:19:08 +0100
Message-ID: <AANLkTimTSE76vazXEM_UHYOh4qAnPa2OfhFXN9YxOoG+@mail.gmail.com>
Subject: Help with tuner/demux ST chips on i2c bus
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

I'm currently working on a Set Top Box which embeds two ST chips for
digital TV (stv6110b for the tuning and stv0900b for the demod). Since
those two chips are often used in retail PCI cards, the DVBAPI
includes drivers for these chips. Thus I'd like to know if I can use
those drivers just by enabling them in my .config or do I need to
write some glue to be able to talk with these chips ? (some kind of
abstraction layer, the same the PCI card drivers implement to expose
the chips to the userspace via /dev/dvb...).

Many thanks,

Antoine
