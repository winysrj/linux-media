Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:32955 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757111AbcFHUkH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jun 2016 16:40:07 -0400
Received: by mail-oi0-f49.google.com with SMTP id k23so32234949oih.0
        for <linux-media@vger.kernel.org>; Wed, 08 Jun 2016 13:40:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAO4ydsQko_M--ZbSbfdZP1ne1t0u0C5hxNLE0EYmDHPXDZ+Rww@mail.gmail.com>
References: <CAO4ydsQko_M--ZbSbfdZP1ne1t0u0C5hxNLE0EYmDHPXDZ+Rww@mail.gmail.com>
Date: Wed, 8 Jun 2016 16:40:05 -0400
Message-ID: <CAGoCfiyuDfwaAPFmGa+zKGqs+T=h6LcTMb2siNF_22XPdoTJ0w@mail.gmail.com>
Subject: Re: Digital Devices CI adapter problem
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?UTF-8?B?TWFyY2luIEthxYJ1xbxh?= <marcin.kaluza@trioptimum.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jun 8, 2016 at 4:10 PM, Marcin Kałuża
<marcin.kaluza@trioptimum.com> wrote:
> Hello!
> I'm looking for someone who was able to successfully use Octopus Dual
> CI bridge by Digital Devices under Linux. We got it _almost_ working -
> we have a strange problem of the module dropping TS packets in sets of
> 30-33 packets rather randomly and this corrupts the whole stream.
>
> Their support ignored the ticket so far
> (http://support.digital-devices.eu/ticket.php?track=UG1-B42-NSGV&e=marcin.kaluza%40trioptimum.com&Refresh=51010)
> and we're slowly running out of options.
>
> We've tried rebuilding the module using streaming dma api
> (DDB_ALT_DMA), we changed the kernel (our 3.18.22 and 4.2.3 from FC
> 23), disabled smp, still the same.
>
> Strange things happen when I call read() to get data back from CI, if
> I use any other buffer size then their internal dma buffer (672*188),
> I sometimes get the data not in order I wrote them (we use test TS
> stream with a counter inside ts payload), and the strangest of all -
> if I use bigger buffer (i.e. 1000*188), read() always returns that
> value (188000), but actual amount of content in my read buffer vary
> greatly (although never exeeds their buffer size of 672*188) - we
> clear the read buffer before each read so we know how much data was
> actually read. That's probably a bug, but I have no idea how can this
> even happen (their code
> (https://github.com/DigitalDevices/dddvb/blob/master/ddbridge/ddbridge-core.c#L772)
> looks quite ok as for my not so great knowledge of linux kernel driver
> coding). Has anyone encountered similar problems? It looks like a race
> condition of some sort, but I was unable find/fix it.
>
> I'll be most grateful for any reply/suggestions/help...
> Martin

This mailing list generally isn't for vendors' out-of-kernel drivers.
If Digital Devices wants to not be responsive to users who bought
their products and wants the community to provide free tech support
for their devices, they should get their drivers merged upstream.  :-)

That said, the math in ddb_input_read() looks pretty wonky.  The fact
that it always returns count (i.e. the size of the buffer provided
from userland), without taking into account how much data is actually
in the ring buffer certainly looks wrong.  If there isn't enough data
available, it should return the amount of data that *is* available,
not the size of the buffer passed in from userland.

I would add some more logging to that routine and see what's going on.
You'll probably have to take some time to understand what the actual
buffer filling algorithm is supposed to be for that hardware in order
to figure out what's going wrong.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
