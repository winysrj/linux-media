Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:33875 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbZFTWIs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Jun 2009 18:08:48 -0400
Received: by bwz9 with SMTP id 9so2396184bwz.37
        for <linux-media@vger.kernel.org>; Sat, 20 Jun 2009 15:08:50 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 20 Jun 2009 18:08:50 -0400
Message-ID: <3833b9400906201508w14f15b96i41e0963186a0a2cb@mail.gmail.com>
Subject: cx23885, new hardware revision found
From: Michael Kutyna <mkutyna@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, I just purchased a Dvico FusionHDTV7 Dual Express and intend on
using it with MythTV.  Unfortunately, the dvb-apps aren't working with
it just yet and I think I've narrowed down why.

I've used mercurial to get the latest v4l-dvb source, compiled and
installed the modules.  I downloaded the firmware from Steven Toth's
website, extracted and installed it.  This all seems to run fine.

Running scan against the us-ATSC-center-frequencies file returns no
channels and running femon -a 0 returns the following output:

status S     | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |

After examining dmesg output, I noticed the following bit:

cx23885_dev_checkrevision() New hardware revision found 0x0
cx23885_dev_checkrevision() Hardware revision unknown 0x0
cx23885[0]/0: found at 0000:02:00.0, rev: 4, irq: 17, latency: 0,
mmio: 0xfd800000
cx23885 0000:02:00.0: setting latency timer to 64

I'm pretty sure that is the problem but I don't know how to fix it.  I
also tried using mercurial to get the v4l tree from
http://linuxtv.org/hg/~stoth/v4l-dvb/ with the same results as above.

Thanks in advance for any assistance you can offer.

mkutyna
