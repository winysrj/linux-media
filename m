Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:18928 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752531AbdGJIlO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Jul 2017 04:41:14 -0400
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <22883.15775.467965.425483@morden.metzler>
Date: Mon, 10 Jul 2017 10:41:03 +0200
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, jasmin@anw.at, d_spingler@gmx.de,
        rjkm@metzlerbros.de
Subject: [PATCH 1/4] [media] dvb-frontends: MaxLinear MxL5xx DVB-S/S2 tuner-demodulator driver
In-Reply-To: <20170709194246.10334-2-d.scheller.oss@gmail.com>
References: <20170709194246.10334-1-d.scheller.oss@gmail.com>
        <20170709194246.10334-2-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Daniel Scheller writes:
 > From: Daniel Scheller <d.scheller@gmx.net>
 > 
 > This adds the frontend driver for the MaxLinear MxL5xx family of tuner-
 > demodulators, as used on Digital Devices MaxS4/8 four/eight-tuner cards.
 > 
 > The driver was picked from the dddvb vendor driver package and - judging
 > solely from the diff - has undergone a 100% rework:
 > 
 >  - Silly #define's used to pass multiple values to functions were
 >    expanded. This resulted in macro/register names not being usable
 >    anymore for such occurences, but makes the code WAY more read-,
 >    understand- and maintainable.

OK, but why did you also replace all kinds of register value defines
with numerical values? This makes the driver much less comprehensible.
