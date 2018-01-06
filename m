Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:41508 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751613AbeAFMIT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 6 Jan 2018 07:08:19 -0500
Received: by mail-wr0-f177.google.com with SMTP id o7so3711727wro.8
        for <linux-media@vger.kernel.org>; Sat, 06 Jan 2018 04:08:19 -0800 (PST)
Date: Sat, 6 Jan 2018 13:08:12 +0100
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, mchehab@s-opensource.com
Cc: linux-media@vger.kernel.org, rjkm@metzlerbros.de
Subject: Re: [PATCH 0/2] Add FEC rates, S2X modulations and 64K transmission
Message-ID: <20180106130812.33e59792@lt530>
In-Reply-To: <20171221202321.30539-1-d.scheller.oss@gmail.com>
References: <20171221202321.30539-1-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Thu, 21 Dec 2017 21:23:19 +0100
schrieb Daniel Scheller <d.scheller.oss@gmail.com>:

> From: Daniel Scheller <d.scheller@gmx.net>
> 
> As the DVB API is bumped to 5.11 for the next cycle.
> 
> dddvb brings a few additional FEC rates (1/4 and 1/3), 64/128/256APSK
> modulations (DVB-S2X) and the 64K transmission mode. These two rather
> trivial patches bring them to mainline, and puts these missing bits
> into the stv0910's get_frontend() callback (FEC 1/4 and 1/3 are
> handled throughout the rest of the demod driver already).
> 
> Let's have these enums as a part of DVB core 5.11.
> 
> Daniel Scheller (2):
>   media: dvb_frontend: add FEC modes, S2X modulations and 64K
>     transmission
>   media: dvb-frontends/stv0910: report FEC 1/4 and 1/3 in
> get_frontend()
> 
>  Documentation/media/frontend.h.rst.exceptions |  6 ++++++
>  drivers/media/dvb-frontends/stv0910.c         |  2 +-
>  include/uapi/linux/dvb/frontend.h             | 13 +++++++++++++
>  3 files changed, 20 insertions(+), 1 deletion(-)

(Rather early) Ping - any chance these few constants/enums can make it
as part of DVB core 5.11?

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
