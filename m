Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9DEC43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 07:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BC5C2070B
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 07:35:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WBx0WEz+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730456AbfCZHf5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 03:35:57 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:40288 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbfCZHf5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 03:35:57 -0400
Received: by mail-ed1-f53.google.com with SMTP id h22so9820603edw.7
        for <linux-media@vger.kernel.org>; Tue, 26 Mar 2019 00:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=a13cjQtT4KdOdh+wwYFbupweZ7zB3qAbstR4DNnpXuE=;
        b=WBx0WEz+EoISKWIBxDm7rdALJ2S5Gg3OzEwBU3VXC+VZF3bXey2Xxn25BiyyGZd3Uz
         p/xxXOj7Ij41/aQIK8yNqnWE8X3ddL8gcUeAbkHsThKSzojv1fv4N1HWEzfNWKAZ9hLO
         w7BJW/ILio4rHT7sHGjNlC7wPertJIH0JetXjeYc0fM8PImuYWg8d3sWKxWDIqj/EIEX
         dx2IbBDVD8N9FkJH2/g+ZZfslkWgEJL57+3KBRy0u5GZahdgGtKFyuyz2Rjd1WcQtQg0
         8P8V3/w4CCfuB5J0EWtZsAYWccMsttgasZMVWjs24WBWrAkKnnEvZgh0uJnR7HxngSAa
         7qmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=a13cjQtT4KdOdh+wwYFbupweZ7zB3qAbstR4DNnpXuE=;
        b=VfiC3C2E/t2IPEjZjTGzmosG/XXsK2zgWvbZPFCQxe1DWD3bSaMPNz0SSUppuxRKgf
         1FEfwtBWS+zmYrUTqnXvaJw5/1py5fWiCDFWjFi/9rFgtgdQy9YtVNpggVtIflAqFBSM
         e463D9fFWmyz7GpPoWjarvXT0VzGnEbm00UgxS7MlHZAjplOgwVpYuSwa7tR+lCfSIHz
         W6W0IBQLEVWi+zVHHCPRrSTkAMGZz/Hn98otPlgvf2wOekEgENiyAxnZ2uK25cEJHULT
         OvYDduFzTgYkOA3LujeEmeEnfR44jNvb6x3eqn9/BH7nKyemnnGOFWxr2BrsF4FDPKqE
         IaKA==
X-Gm-Message-State: APjAAAX3VvXt4L9kbr0avauUzdlZUQ8ieMIfKGD1e5bLsjiAiAcGxlGW
        nhpqbttE/9/nAlZRbbMhrw9YnZ4XgHhgkYHb0so=
X-Google-Smtp-Source: APXvYqzDuyhOw3OIiTuKcEsVc/LAcjzQo2OZ2L2soMX51cERDEL4aAWgtjj0XB8tRzaQPqiale2xe5qXg8zxARNhskE=
X-Received: by 2002:a17:906:828f:: with SMTP id h15mr16865150ejx.170.1553585755862;
 Tue, 26 Mar 2019 00:35:55 -0700 (PDT)
MIME-Version: 1.0
References: <f4b69417-06c3-f9ab-2973-ae23d76088b8@gmail.com>
 <29bad771-843c-1dee-906c-6e9475aed7d8@gmail.com> <d291e164-993f-232a-f01b-0f8c17087004@googlemail.com>
 <20190315223425.hiq3qcjhjnirsizh@gofer.mess.org> <20190317065242.137cb095@coco.lan>
 <20190319164507.7f95af89@coco.lan> <a1f296ba-3c27-ed2c-3912-4edbeeb21eba@googlemail.com>
 <20190321094127.ysurm4u26zugmnmv@gofer.mess.org> <20190321083044.621f1922@coco.lan>
 <35ba4e81-fc2a-87ed-8da7-43cc4543de51@googlemail.com> <CANJnhGfRtEwAony5Z4rFMPcu58aF2k0G+9NSkMKsq_PhfmSNqw@mail.gmail.com>
 <20190325140838.71f88eac@coco.lan>
In-Reply-To: <20190325140838.71f88eac@coco.lan>
From:   Samuel CHEMLA <chemla.samuel@gmail.com>
Date:   Tue, 26 Mar 2019 08:35:44 +0100
Message-ID: <CANJnhGc_qx32nm7yZheC2ioHOij8QELbnwyJkZ83G9uYTxqwtA@mail.gmail.com>
Subject: Re: [Bug report] dvbv5-zap crash dvb-tool ARMHF builds
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Gregor Jasny <gjasny@googlemail.com>, Sean Young <sean@mess.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,


I am struggling with valgrind because it always complain with either :
    ASan runtime does not come first in initial library list; you
should either link runtime to your application or manually preload it
with LD_PRELOAD
    -> When I LD_PRELOAD, I'm getting a segfault, but I couldn't find
any core dump

or, if I link statically libasan with -static-libasan:
    Shadow memory range interleaves with an existing memory mapping.
ASan cannot proceed correctly. ABORTING.
    ASan shadow was supposed to be located in the
[0x00007fff7000-0x10007fff7fff] range.


I retested again on my raspberry zero W, and I confirm i cannot
reproduce the hang.
Your fix did work on that device.
I am testing with same OS (raspbian with latest updates, same kernel),
same configure options, same USB dongle... :-(
The only differences are CPU architecture (armv6 vs armv7), memory
constraints, and I was not using the same channels.conf, I'll fix that
today and re-check


Sam

On 25/03/2019 18:08, Mauro Carvalho Chehab wrote:

Em Mon, 25 Mar 2019 17:33:30 +0100
Samuel CHEMLA <chemla.samuel@gmail.com> escreveu:

Hi guys,

I'm afraid I'm coming with sad news.
I just tried both stable-1.12 and stable-1.16 on a raspberry pi 2, and
random hangs are back (see https://bugs.launchpad.net/raspbian/+bug/1819650
).
I previously test both branches on a raspberry zero and issues were gone
(same raspbian version).
There may be more memory issues somewhere...

Could you test it with valgrind?

Sam

Le jeu. 21 mars 2019 =C3=A0 20:59, Gregor Jasny <gjasny@googlemail.com> a =
=C3=A9crit :

Hello,

On 21.03.19 12:30, Mauro Carvalho Chehab wrote:

I went ahead and cherry-picked the relevant patches to -1.12, -1.14 and
-1.16, and tested both dvbv5-zap and dvbv5-scan with all versions. So,

we can

release a new minor version for all those stable branches.

After the patches, on my tests, I didn't get any memory leaks or
double-free issues.

I issues a new 1.12, 1.14, and 1.16 release.

Thanks,
Gregor



Thanks,
Mauro
