Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:50706 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbaIUR2o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 13:28:44 -0400
Received: from [192.168.1.21] ([79.215.138.24]) by mail.gmx.com (mrgmx101)
 with ESMTPSA (Nemesis) id 0MOBOi-1XQHIV0zo4-005bJX for
 <linux-media@vger.kernel.org>; Sun, 21 Sep 2014 19:28:43 +0200
Message-ID: <541F0AC7.4010004@gmx.net>
Date: Sun, 21 Sep 2014 19:28:39 +0200
From: JPT <j-p-t@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Running Technisat DVB-S2 on ARM-NAS
References: <541EE016.9030504@gmx.net> <541EE2EB.4000802@iki.fi> <541EEA74.2000909@gmx.net> <541EEEAB.10106@iki.fi>
In-Reply-To: <541EEEAB.10106@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> If I didn't remember wrong, that means allocated buffers are 8 * 32 *
> 2048 = 524288 bytes. It sounds rather big for my taste. Probably even
> wrong. IIRC USB2.0 frames are 1024 and there could be 1-3 frames. You
> could use lsusb with all verbosity levels to see if it is
> 1024/2048/3072. And set value according to that info.

lsusb tells:
    Interface Descriptor:
      Endpoint Descriptor:
        wMaxPacketSize     0x0200  1x 512 bytes
      Endpoint Descriptor:
        wMaxPacketSize     0x0200  1x 512 bytes
      Endpoint Descriptor:
        wMaxPacketSize     0x0200  1x 512 bytes
    Interface Descriptor:
      Endpoint Descriptor:
        wMaxPacketSize     0x0c00  2x 1024 bytes
      Endpoint Descriptor:
        wMaxPacketSize     0x0200  1x 512 bytes
      Endpoint Descriptor:
        wMaxPacketSize     0x0200  1x 512 bytes


But I haven't got any clue about the meaning.
Ask me a question about any bit in the tcp/ip packages, but don't ask me
about USB ;)
Where can I get technical details that are, well... readable without
studing for weeks?

btw, it's attached to a FT1009 USB3.0 SuperSpeed chip.

> So I would recommend
> .count = 6,
> .framesperurb = 8,
> .framesize = 1024,
> 
> Use some testing with error and trial to find out smallest working
> buffers, then add some 20% extra for that.

I set to 8x8x2048 (because max package size is 2x1024)
but w_scan doesn't find any transponder.

What should happen if buffers are too small?

Tommorrow I'll swap the sat cable just to make sure this isn't the cause.

thanks,

Jan
