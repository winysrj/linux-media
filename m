Return-path: <linux-media-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:37359 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755535AbcITRMQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Sep 2016 13:12:16 -0400
Date: Tue, 20 Sep 2016 20:10:15 +0300
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: andrey.utkin@corp.bluecherry.net, chall@corp.bluecherry.net,
        artem.rusanov@gmail.com, maintainers@bluecherrydvr.com
Subject: tw5864 - call to hardware owners
Message-ID: <20160920171015.hnmf4y5qwmqhzpdw@acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I would love to hear from anybody who owns any sample of PCIE board with
TW5864 chip.

It is possible to buy from here
http://www.provideo.com.tw/Products.htm?link=web/DVR%20Card_Hardward.htm
I guess there are more companies selling boards with it.

So there is a driver, "tw5864", submitted and accepted upstream,
currently in linux-next, I guess it will get into Linux v4.9.
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/drivers/media/pci/tw5864

Then there is a pile of sources from vendor, obfuscated and bloated, not
very human-readable, but that is what our painful development started
with:
http://lizard.bluecherry.net/~autkin/tw5864/TW-3XX_Linux.rar

TW5864 datasheet from manufacturer:
http://lizard.bluecherry.net/~autkin/tw5864/tw5864b1-ds.pdf

Recently a developer from another company contacted us, reporting that
our driver doesn't work well on samples they had, and sharing quite
different driver sources from their vendor, which work fine. Those
sources were also obfuscated, but much less, and they have successfully
deobfuscated by them. Link to the code:
https://github.com/bluecherrydvr/linux/tree/master/drivers/media/pci/Isil5864

This second driver is interesting because on some samples it really
works well, despite the upstreamed driver gives worse picture. I cannot
work on that productively because my hardware sample is not affected.
That's why some communication with other owners would be useful.

Oh and of course Intersil (current owner of Techwell labs) technical
support is useless, just stating that development team was dismissed
several years ago.

(By the way, if anybody is aware of different PCI Express boards with
both analog input decoders and video compression encoders, except
solo6x10, which are easy to buy and to run on Linux, please let us
know).
