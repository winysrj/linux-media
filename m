Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:36495 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751392AbdFZPnM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 11:43:12 -0400
Received: by mail-wr0-f169.google.com with SMTP id c11so146657607wrc.3
        for <linux-media@vger.kernel.org>; Mon, 26 Jun 2017 08:43:11 -0700 (PDT)
Date: Mon, 26 Jun 2017 17:43:08 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Ralph Metzler <rjkm@metzlerbros.de>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        liplianin@netup.ru, crope@iki.fi, "Jasmin J." <jasmin@anw.at>,
        "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>,
        "tbird20d@gmail.com" <tbird20d@gmail.com>
Subject: Re: DD support improvements (was: Re: [PATCH v3 00/13]
 stv0367/ddbridge: support CTv6/FlexCT hardware)
Message-ID: <20170626174308.15005f62@audiostation.wuest.de>
In-Reply-To: <20170626061920.2f0aa781@vento.lan>
References: <20170329164313.14636-1-d.scheller.oss@gmail.com>
        <20170412212327.5b75be19@macbox>
        <20170507174212.2e45ab71@audiostation.wuest.de>
        <20170528234537.3bed2dde@macbox>
        <20170619221821.022fc473@macbox>
        <20170620093645.6f72fd1a@vento.lan>
        <20170620204121.4cff42d1@macbox>
        <20170620161043.1e6a1364@vento.lan>
        <20170621225712.426d3a17@audiostation.wuest.de>
        <22860.14367.464168.657791@morden.metzler>
        <20170624135001.5bcafb64@vento.lan>
        <20170625195259.1623ef71@audiostation.wuest.de>
        <20170626061920.2f0aa781@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mon, 26 Jun 2017 06:19:20 -0300
schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> Yes, config flags work, but please don't use a config flag like this:
> 
> 	if (initflags & TDA18212_INIT_DDSTV) 
> 
> The flags should identify the required functionality, not if the
> caller is ddbridge driver. On a quick look at your patch, I suspect
> that it would need two flags, like:
> 
> 	TDA18212_FLAG_SLEEP - with would enable sleep/wakeup/standby
> 	TDA18212_FLAG_CALIBRATION - with would enable calibration

Yes, of course. Actually, this was just some (early) random attempt at
fixing something which turned out unrelated and even doesn't apply as is
anymore. But that patch might be a start to get this done.

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
