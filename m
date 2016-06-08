Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:35504 "EHLO
	mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152AbcFHUK6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2016 16:10:58 -0400
Received: by mail-vk0-f43.google.com with SMTP id d127so27003318vkh.2
        for <linux-media@vger.kernel.org>; Wed, 08 Jun 2016 13:10:58 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?TWFyY2luIEthxYJ1xbxh?= <marcin.kaluza@trioptimum.com>
Date: Wed, 8 Jun 2016 22:10:18 +0200
Message-ID: <CAO4ydsQko_M--ZbSbfdZP1ne1t0u0C5hxNLE0EYmDHPXDZ+Rww@mail.gmail.com>
Subject: Digital Devices CI adapter problem
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!
I'm looking for someone who was able to successfully use Octopus Dual
CI bridge by Digital Devices under Linux. We got it _almost_ working -
we have a strange problem of the module dropping TS packets in sets of
30-33 packets rather randomly and this corrupts the whole stream.

Their support ignored the ticket so far
(http://support.digital-devices.eu/ticket.php?track=UG1-B42-NSGV&e=marcin.kaluza%40trioptimum.com&Refresh=51010)
and we're slowly running out of options.

We've tried rebuilding the module using streaming dma api
(DDB_ALT_DMA), we changed the kernel (our 3.18.22 and 4.2.3 from FC
23), disabled smp, still the same.

Strange things happen when I call read() to get data back from CI, if
I use any other buffer size then their internal dma buffer (672*188),
I sometimes get the data not in order I wrote them (we use test TS
stream with a counter inside ts payload), and the strangest of all -
if I use bigger buffer (i.e. 1000*188), read() always returns that
value (188000), but actual amount of content in my read buffer vary
greatly (although never exeeds their buffer size of 672*188) - we
clear the read buffer before each read so we know how much data was
actually read. That's probably a bug, but I have no idea how can this
even happen (their code
(https://github.com/DigitalDevices/dddvb/blob/master/ddbridge/ddbridge-core.c#L772)
looks quite ok as for my not so great knowledge of linux kernel driver
coding). Has anyone encountered similar problems? It looks like a race
condition of some sort, but I was unable find/fix it.

I'll be most grateful for any reply/suggestions/help...
Martin
