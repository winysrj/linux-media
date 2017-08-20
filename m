Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:38721 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752721AbdHTLPn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 07:15:43 -0400
Received: by mail-wr0-f193.google.com with SMTP id k10so344194wre.5
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 04:15:43 -0700 (PDT)
Date: Sun, 20 Aug 2017 13:15:35 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, d_spingler@gmx.de, rjkm@metzlerbros.de
Subject: Re: [PATCH 0/4] MxL5xx demodulator-tuner driver, DD MaxS8 support
Message-ID: <20170820131535.1c462292@audiostation.wuest.de>
In-Reply-To: <20170709194246.10334-1-d.scheller.oss@gmail.com>
References: <20170709194246.10334-1-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Sun,  9 Jul 2017 21:42:42 +0200
schrieb Daniel Scheller <d.scheller.oss@gmail.com>:

> Hard-dependency on the STV0910/STV6111 driver+DD support series and
> the DD driver bump.
> 
> This adds a driver for the MaxLinear MxL5xx tuner-demodulator series
> (a DVB-S/S2/DSS demodulator-tuner combo frontend) as being found on
> Digital Devices MaxS8 4/8 tunerport cards.

The stv0910/6111 dependency is fulfilled already, but the DD driver
bump is still required. So, ddbridge-0.9.29-v4 as of [1] needs to go in
first. After that, this series works "standalone".

Since in the DD bump series the -irq.c split has been removed, patch #2
may conflict in the Makefile (ddbridge-irq.c is gone).

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
