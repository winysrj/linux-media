Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35051 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752769AbdHTMOU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Aug 2017 08:14:20 -0400
Received: by mail-wr0-f196.google.com with SMTP id p8so10479689wrf.2
        for <linux-media@vger.kernel.org>; Sun, 20 Aug 2017 05:14:19 -0700 (PDT)
Date: Sun, 20 Aug 2017 14:14:17 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: rjkm@metzlerbros.de, linux-media@vger.kernel.org,
        mchehab@kernel.org, jasmin@anw.at
Subject: Re: [PATCH] [media] ddbridge: add IOCTLs
Message-ID: <20170820141417.29648a72@audiostation.wuest.de>
In-Reply-To: <20170820141126.17b24bf1@audiostation.wuest.de>
References: <20170820110855.7127-1-d.scheller.oss@gmail.com>
        <20170820085356.0aa87e66@vento.lan>
        <20170820141126.17b24bf1@audiostation.wuest.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Sun, 20 Aug 2017 14:11:26 +0200
schrieb Daniel Scheller <d.scheller.oss@gmail.com>:

> > Anyway, I applied today the ddbridge patches we had. I solved a few
> > conflicts while merging some things, so I'd appreciate if you could
> > check if everything is ok. If not, please send patches :-)  
> 
> Wohoooo! Thanks very much, especially for the mxl5xx! Looks like 4.14
> will be a hell of a kernel for all DD card owners! :)
> 
> Will check if something's wrong now (saw you missed the stv0910
> constify patch from Colin King) and shove out patches _today_ if
> neccessary.

Addendum: media_build will need updates, will take care of that aswell.

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
