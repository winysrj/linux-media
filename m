Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:57273 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751210AbdGHAIq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Jul 2017 20:08:46 -0400
Subject: Re: [PATCH v2 00/10] STV0910/STV6111 drivers, ddbridge CineS2 V7
 support
To: Daniel Scheller <d.scheller.oss@gmail.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rjkm@metzlerbros.de
References: <20170630205106.1268-1-d.scheller.oss@gmail.com>
From: "Jasmin J." <jasmin@anw.at>
Message-ID: <e8a0857d-3076-9bcd-043c-8cd4a7b4e368@anw.at>
Date: Sat, 8 Jul 2017 02:08:35 +0200
MIME-Version: 1.0
In-Reply-To: <20170630205106.1268-1-d.scheller.oss@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

> This series adds drivers for the ST STV0910 DVB-S/S2 demodulator ICs and
> the ST STV6111 DVB-S/S2 tuners, and utilises them to enable ddbridge to
> support the current line of Digital Devices DVB-S/S2 hardware (e.g. Cine
> S2 V7/V7A adapters, DuoFlex S2 V4 addon modules and maybe more, with
> similar components).
I have a DuoFlex S2 V4 card and a Cine S2 V6. I did a rough test only and I
checked the signal statistics, also.

I am using VDR 2.3.8 and Kernel 3.13.0 on an Ubuntu system.

On the DuoFlex S2 V4 (STV0910) the stats were a little high, I guess. At least
VDR showed a too big value. I am using two cables from the same LNB. This needs
to be fixed by Ralph M. in the upstream driver from DD.

DuoFlex S2 V4 (STV0910):
# dvb-fe-tool -m -a 4
Sperre (0x1f) Signal= -31,59dBm S/R= 14,50dB preBER= 0
Sperre (0x1f) Signal= -33,11dBm S/R= 14,40dB preBER= 0

Cine S2 V6 (STV090x):
# dvb-fe-tool -m -a 1
Sperre (0x1f) Signal= 75,00% S/R= 27,40% postBER= 0
Sperre (0x1f) Signal= 75,00% S/R= 27,20% postBER= 0
Sperre (0x1f) Signal= 75,00% S/R= 27,40% postBER= 0

Also from me a "tested by" for this particular set of patches.

BR,
   Jasmin
