Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33524 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbdFUTvO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 15:51:14 -0400
Received: by mail-wr0-f193.google.com with SMTP id x23so29362187wrb.0
        for <linux-media@vger.kernel.org>; Wed, 21 Jun 2017 12:51:13 -0700 (PDT)
Date: Wed, 21 Jun 2017 21:51:07 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: crope@iki.fi
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, liplianin@netup.ru, rjkm@metzlerbros.de
Subject: Re: [PATCH v2 0/4] STV0367/DDB DVBv5 signal statistics
Message-ID: <20170621215107.4e70bbee@audiostation.wuest.de>
In-Reply-To: <20170621194544.16949-1-d.scheller.oss@gmail.com>
References: <20170621194544.16949-1-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Wed, 21 Jun 2017 21:45:40 +0200
schrieb Daniel Scheller <d.scheller.oss@gmail.com>:

> From: Daniel Scheller <d.scheller@gmx.net>
> 
> This series adds DVBv5 statistics support to the new DDB codepath of the
> stv0367 demodulator driver.
> 
> The changes utilise already existing functionality (in form of register
> readouts), but wraps the reads in separate functions so the existing
> relative scale reporting can be kept as-is, while adding the v5 stats
> in dB scale where appropriate.
> 
> From my own testing: Reported values look approx. the same as those
> reported by the cxd2841er driver for both -C and -T.
> 
> Changes from v1 to v2:
>  - INTLOG10X100() macro for QAM SNR calculation removed and replaced by
>    directly utilising intlog2 plus a div
>  - factored statistics collection into *_read_status()
>  - prevent a possible division by zero (though requires ridiculously good
>    SNR to trigger)
>  - _read_status() doesn't return -EINVAL anymore if no demod state is set,
>    prevents falsely reported errors from inquiries of userspace tools

Antti, FYI: statistics inquiry now lives in read_status(), didn't see any functional differences or problems due to this, so if your're comfortable with this, this variant works fine for me. Also, INTLOG10X100 is history, this even gave an improvement of two decimals of precision in dtv_property_cache, which will definitely work for everyone - we're still no scientific pro-measurement-gear. Readout of stats are still limited to FE_HAS_LOCK though, since, as explained, this is the only bit we'll receive at the moment.

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
