Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:38473 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbZCSU1m (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2009 16:27:42 -0400
Received: by ewy24 with SMTP id 24so638197ewy.13
        for <linux-media@vger.kernel.org>; Thu, 19 Mar 2009 13:27:39 -0700 (PDT)
Date: Thu, 19 Mar 2009 21:27:19 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Benjamin Zores <benjamin.zores@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] add new frequency table for Strasbourg, France
In-Reply-To: <49C00954.6050200@gmail.com>
Message-ID: <alpine.DEB.2.00.0903192057270.26404@ybpnyubfg.ybpnyqbznva>
References: <49BBEFC3.5070901@gmail.com> <alpine.DEB.2.00.0903160803030.4176@ybpnyubfg.ybpnyqbznva> <49BE9B50.5050506@gmail.com> <49BEB20A.1030209@gmx.de> <alpine.DEB.2.00.0903170237550.4176@ybpnyubfg.ybpnyqbznva> <49C00954.6050200@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(sorry for not answering sooner, I got distracted by good weather
and the need to replenish my reserve of beer, depleted during the
long wintry weather)

On Tue, 17 Mar 2009, Benjamin Zores wrote:

> > Anyway, to the original poster, Benjamin, can you make a short
> > recording of, oh, say, ten seconds, of just PID 16 of only the
> > five or six french muxen which you receive, and somehow deliver

> Here it goes.
> See attachment.

Thanks -- except, um, somehow the attachments got mangled in the
process of being MIMEd.  It seems your mailer (Thunderbird) has
chosen to tag the files as something like text/xemacs (similar,
I can't remember exactly what) and performed some strange 
irreversible conversion of much of the binary data into character
0x3f, which breaks `dvbsnoop'.

I attempted to convert those characters to the padding used to
fill out the 188-byte Transport Stream packet, but it still was
not enough, as that's not the only character that got mangled.

Here's your ARD multiplex (722MHz) dumped after my conversion:

from file: /tmp/hexrev
------------------------------------------------------------
  0000:  47 40 10 17 00 40 ff 52  30 38 ff 00 00 ff 05 40   G@...@.R08.....@
  0010:  03 41 52 44 ff 40 38 01  21 14 ff 3a 5a 0b 04 35   .ARD.@8.!..:Z..5
  0020:  45 40 1f 41 3b ff ff ff  ff 41 0c 00 ff 01 00 02   E@.A;....A......
  0030:  01 00 03 01 00 06 01 62  1d ff 03 ff ff 40 04 1c   .......b.....@..
  0040:  ff 40 04 4d ff 40 04 66  19 40 04 7e ff 40 04 ff   .@.M.@.f.@.~.@..
  0050:  ff 40 04 ff 57 40 29 ff  74 08 ff ff ff ff ff ff   .@..W@).t.......
[...]

And here's how it should have looked (the sequential number is
different, but the others should be similar or identical):

from file: /tmp/ard-fs-DVB_T-17.Mar.2009-04h-NIT.ts
------------------------------------------------------------
  0000:  47 40 10 1e 00 40 f0 52  30 38 d7 00 00 f0 05 40   G@...@.R08.....@
  0010:  03 41 52 44 f0 40 38 01  21 14 f0 3a 5a 0b 04 35   .ARD.@8.!..:Z..5
  0020:  45 40 1f 41 3b ff ff ff  ff 41 0c 00 e0 01 00 02   E@.A;....A......
  0030:  01 00 03 01 00 06 01 62  1d ff 03 df d2 40 04 1c   .......b.....@..
  0040:  db 40 04 4d af 40 04 66  19 40 04 7e 83 40 04 8a   .@.M.@.f.@.~.@..
  0050:  b8 40 04 af 57 40 29 df  74 08 ff ff ff ff ff ff   .@..W@).t.......


It appears anything above 0x80 (decimal 128, or with high-bit
set) is converted by Chunderbird to the 0x3f -- that is, any
non-US-ASCII value gets mangled.


So I'll ask, can you send the files again, but first make them
ASCII-safe, either by `uuencode' or `xxd' or some base64
encoder, before attaching them?  And send them directly to me,
no need to bother the whole list with them.  (Or if you have
access to a different mailer which will attach the files as
simple octet-stream, that will work with no need to pre-encode)


One more question, can you receive anything at 858MHz, channel
69?  I have this listed in the frequency allocations from several
sources for Strasbourg.  If not, I may be able to check myself
in the next month or so, if I remember...

Thanks!
barry bouwsma
