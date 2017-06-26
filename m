Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:34279 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751470AbdFZSlK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Jun 2017 14:41:10 -0400
Received: by mail-wr0-f182.google.com with SMTP id 77so148819535wrb.1
        for <linux-media@vger.kernel.org>; Mon, 26 Jun 2017 11:41:09 -0700 (PDT)
Date: Mon, 26 Jun 2017 20:41:05 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Ralph Metzler <rjkm@metzlerbros.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org, mchehab@kernel.org,
        liplianin@netup.ru, crope@iki.fi, jasmin@anw.at,
        Yasunari.Takiguchi@sony.com, tbird20d@gmail.com
Subject: Re: DD support improvements (was: Re: [PATCH v3 00/13]
 stv0367/ddbridge: support CTv6/FlexCT hardware)
Message-ID: <20170626204105.6397dcaa@audiostation.wuest.de>
In-Reply-To: <22864.55204.841821.456223@morden.metzler>
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
        <22864.55204.841821.456223@morden.metzler>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mon, 26 Jun 2017 11:45:08 +0200
schrieb Ralph Metzler <rjkm@metzlerbros.de>:

> Mauro Carvalho Chehab writes:
> 
>  > Would it be possible to change things at the dddvb tree to make
>  > it to use our coding style (for example, replacing CamelCase by the
>  > kernel_style), in order to minimize the amount of work to sync from
>  > your tree?  
> 
> Yes

Addmittedly, this might have been too quick, but I just couldn't
resist :) (thankfully, tools exist for such jobs).

Ralph, please have a look at
https://github.com/DigitalDevices/dddvb/pull/12 - if you're fine with the result, I will start a V2 series based on kernel_case naming.

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
