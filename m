Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:55906 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab0F0P4M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jun 2010 11:56:12 -0400
Message-ID: <4C277496.7050508@kolumbus.fi>
Date: Sun, 27 Jun 2010 18:56:06 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Oliver Endriss <o.endriss@gmx.de>,
	Jaroslav Klaus <jaroslav.klaus@gmail.com>
Subject: Re: TS discontinuity with TT S-2300
References: <1CF58597-201D-4448-A80C-55815811753E@gmail.com> <201006271437.01502@orion.escape-edv.de>
In-Reply-To: <201006271437.01502@orion.escape-edv.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

27.06.2010 15:37, Oliver Endriss wrote:
> Hi,
>
> On Sunday 27 June 2010 01:05:57 Jaroslav Klaus wrote:
>   
>> Hi,
>>
>> I'm loosing TS packets in my dual CAM premium TT S-2300 card (av7110+saa7146).
>>
>> I use dvblast to select 4 TV channels (~ 16 PIDs) from multiplex,
>> descramble them and stream them to network. Dvblast reports TS
>> discontinuity across all video PIDs only (no audio) usually every
>> 1-3 minutes ~80 packets. But sometimes it goes well for tens of
>> minutes (up to 1-2hours). Everything seems to be ok with 3 TV channels.
>>
>>     
> The full-featured cards are not able to deliver the full bandwidth of a
> transponder. It is a limitaion of the board design, not a firmware or
> driver issue.
>   
I noticed that saa7146 uses dvb_dmx_swfilter_packets().

I planned using of that function too for
Mantis 16K buffer delivery, but I found out that
hardware delivers sometimes additional bytes (corrupted partially lost
packets?)
between the full sized 204 byte packets:

Jun 26 16:20:37 koivu kernel: demux: skipped 49 bytes at position 3379
Jun 26 16:20:37 koivu kernel: demux: skipped 18 bytes at position 9868
Jun 26 16:20:37 koivu kernel: demux: skipped 30 bytes at position 10090
Jun 26 16:20:38 koivu kernel: demux: skipped 14 bytes at position 7208
Jun 26 16:20:38 koivu kernel: demux: skipped 114 bytes at position 7426

So dvb_dmx_swfilter(_204)() is needed to skip
these unwanted bytes. With simple usage of
dvb_dmx_swfilter_packets() the rest of the buffer
would have been lost. I wrote a faster version of these
functions, also for 188 sized packets today:
"Re: [PATCH] Avoid unnecessary data copying inside
dvb_dmx_swfilter_204() function"

CU
Marko


