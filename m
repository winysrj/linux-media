Return-path: <linux-media-owner@vger.kernel.org>
Received: from imap.netup.ru ([77.72.80.14]:57292 "EHLO imap.netup.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751994AbdHBRgl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Aug 2017 13:36:41 -0400
Received: from mail-oi0-f46.google.com (mail-oi0-f46.google.com [209.85.218.46])
        by imap.netup.ru (Postfix) with ESMTPSA id 57BB28D103C
        for <linux-media@vger.kernel.org>; Wed,  2 Aug 2017 20:36:40 +0300 (MSK)
Received: by mail-oi0-f46.google.com with SMTP id x3so51313531oia.1
        for <linux-media@vger.kernel.org>; Wed, 02 Aug 2017 10:36:39 -0700 (PDT)
MIME-Version: 1.0
From: Abylay Ospan <aospan@netup.ru>
Date: Wed, 2 Aug 2017 13:36:18 -0400
Message-ID: <CAK3bHNUafQc_m7grP9DFTjgc3RKx5H8dCd7L4q0YvFhbGd_qvQ@mail.gmail.com>
Subject: =?UTF-8?Q?Universal_DTV_USB_receiver_=28=E2=80=9CJoker_TV=E2=80=9D=29?=
To: linux-media <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Everyone !

Some time ago I had announced my initiative about building truly
universal DTV receiver - =E2=80=9CJoker TV=E2=80=9D (supports DVB-S2/T2/C2,=
 ISDB-T,
ATSC, DTMB). Now I=E2=80=99m glad to post  an update.

It has been almost 10 months now but during this time, I have prepared
two hardware revisions of =E2=80=9CJoker TV=E2=80=9D with various fixes. I =
also wrote
software for FPGA and the host (for Linux/OSx/Windows). This was a lot
of work, but now I=E2=80=99m ready to share all of it with you. I have deci=
ded
to donate my work to the community and make this project an Open
Hardware and Open Software project. Here are some posts with
additional information:

https://jokersys.com/2017/07/06/schematic-pcb-share/ - hardware sharing
https://jokersys.com/2017/07/06/joker-tv-linuxosxwindows-drivers-apps/
- user-level driver&app description
https://jokersys.com/2017/07/06/joker-tv-fpga-verilogvhdl-code/ - FPGA
firmware description

And bonus for those who are interested in how the production is done
and how much it cost. Here is my post about this:

https://jokersys.com/2017/07/08/joker-tv-manufacturing/

Additionally, I have just placed the first batch order to the factory
and I=E2=80=99m anticipating the results which should be ready in about thr=
ee
(3) weeks. I will send freshly baked =E2=80=9CJoker TV=E2=80=9D gadgets to =
all
backers.

I=E2=80=99m planning to prepare new posts with internals about Joker TV=E2=
=80=99s
hardware and software. Here are some topics I=E2=80=99m planning to describ=
e:
 * USB part. ULPI PHY interface, FPGA USB-stack, Isochronous
transactions with TS data, etc;
 * RF part. Tuner and Demods, AGC, LNB, I&Q, etc
 * I2C and SPI buses
 * CI interface
Please let me know if you are interested in some topics listed above -
I will describe them in more detail next time.

I=E2=80=99m open to any comments, collaboration, discussions. Thanks !

--=20
Abylay Ospan
