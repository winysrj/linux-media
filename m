Return-path: <mchehab@pedra>
Received: from mail-bw0-f52.google.com ([209.85.214.52]:63315 "EHLO
	mail-bw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab1EVOkG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 May 2011 10:40:06 -0400
Received: by bwj24 with SMTP id 24so6184489bwj.11
        for <linux-media@vger.kernel.org>; Sun, 22 May 2011 07:40:04 -0700 (PDT)
Date: Sun, 22 May 2011 16:40:54 +0200 (CEST)
From: Martin Vidovic <xtronom@gmail.com>
To: linux-media@vger.kernel.org
cc: Ralph Metzler <rjkm@metzlerbros.de>
Subject: octopus-ci PowerCAM issue
Message-ID: <alpine.LNX.2.00.1105221534560.16386@mvdev.cyberevil.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

There seems to be a problem with PowerCAM_HD V2.0.3 in combination with 
Octopus CI-Module.

Linux: 2.6.35.12
Driver: http://linuxtv.org/hg/~endriss/ngene-octopus-test/rev/1d1b7ad5ac76

Command Interface works OK, but "something strange" happens with Transport 
Stream Interface. Other CAMs (Irdeto, Viaccess, and AlphaCrypt) don't 
manifest this problem. All also works well without CAM.

The problem is like this:

(1) I write 672 TS packets to SEC. All packets have PID 0x80, and only 
    adaptation field with private data. Private data starts with a 32 bit 
    counter which is incremented for each TS packet. The rest of private 
    data is padded with 0x55.

(2) 672 TS packets are read from SEC. Packet header is verified, counter 
    is checked for discontinuities, and all padding bytes are compared 
    with 0x55.

So, with all other CAMs this works as expected, but with PowerCAM it works 
like this (4 consecutive TS packets are displayed):

(1) write:

47 00 80 20 b7 02 b5 00 00 02 3d 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55

47 00 80 20 b7 02 b5 00 00 02 3e 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55

47 00 80 20 b7 02 b5 00 00 02 3f 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55

47 00 80 20 b7 02 b5 00 00 02 40 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55

(2) read:

47 00 80 b7 02 b5 00 00 03 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 47 80 60 b7 b5 00 00 03 15 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55

47 00 60 b7 02 b5 00 00 16 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 47 00 80 60 02 b5 00 00 03 17 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55

47 00 60 b7 02 00 00 03 18 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 47 00 80 60 02 b5 00 03 19 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55

47 00 80 60 b7 02 00 00 03 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55
55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 47 80 60 b7 02 b5 00 03 1b 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55 55

In most cases (maybe all), I need to make two writes of 672 packets to be 
able to read 672 packets back. This is not the case with other CAMs.

Two identical PowerCAM modules had been tested, both work the same. Both 
modules work fine with TT S2-3200 and S-1500 cards.

Any help greatly appreciated.

Best regards,
Martin Vidovic
