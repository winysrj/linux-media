Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5.clear.net.nz ([203.97.33.68]:42068 "EHLO
        smtp5.clear.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750818AbdGAEf1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 1 Jul 2017 00:35:27 -0400
Received: from mxin1-orange.clear.net.nz
 (lb1-srcnat.clear.net.nz [203.97.32.236])
 by smtp5.clear.net.nz (CLEAR Net Mail)
 with ESMTP id <0OSE009KQ9BZHB00@smtp5.clear.net.nz> for
 linux-media@vger.kernel.org; Sat, 01 Jul 2017 16:19:17 +1200 (NZST)
Date: Sat, 01 Jul 2017 16:19:16 +1200
From: Richard Scobie <r.scobie@clear.net.nz>
Subject: Re: [PATCH v2 00/10] STV0910/STV6111 drivers,
 ddbridge CineS2 V7 support
In-reply-to: <20170630205106.1268-1-d.scheller.oss@gmail.com>
To: Daniel Scheller <d.scheller.oss@gmail.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rjkm@metzlerbros.de, jasmin@anw.at
Message-id: <3be374d3-b8c5-1e72-9add-9b2813a919bd@clear.net.nz>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <20170630205106.1268-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Daniel Scheller wrote:
> From: Daniel Scheller <d.scheller@gmx.net>
>
> For Linux 4.14.
>
> This series adds drivers for the ST STV0910 DVB-S/S2 demodulator ICs and
> the ST STV6111 DVB-S/S2 tuners, and utilises them to enable ddbridge to
> support the current line of Digital Devices DVB-S/S2 hardware (e.g. Cine
> S2 V7/V7A adapters, DuoFlex S2 V4 addon modules and maybe more, with
> similar components).

-snip

Just posting to offer a "tested by", for this particular set of patches.

I have successfully been running a DD Cine S2 V7A alongside a TT S2 6400 
since late March, working with Daniel to iron out minor problems during 
the development of this set.

Testing has been done on a dedicated PVR system based on VDR 2.3.X, with 
kernels 4.10 and 4.12, for 3-4 hours daily without issue. Multistream 
support works fine and STR/CNR stats seem realistic.

Many thanks to Daniel and the reviewers.

Regards,

Richard
