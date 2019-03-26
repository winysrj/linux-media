Return-Path: <SRS0=7BPv=R5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD267C43381
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 15:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C64D20879
	for <linux-media@archiver.kernel.org>; Tue, 26 Mar 2019 15:10:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e07X++ET"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731810AbfCZPKr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 26 Mar 2019 11:10:47 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:33158 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728314AbfCZPKr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Mar 2019 11:10:47 -0400
Received: by mail-ed1-f65.google.com with SMTP id q3so11099467edg.0
        for <linux-media@vger.kernel.org>; Tue, 26 Mar 2019 08:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=N4Vd9BN2j932WxyWytszRjBw49iBm5N6JyEwBXF6F1o=;
        b=e07X++ETAhgPi0fwJDPG+04isJLrYPzVEo6tBff/ko7Bd0a5S+LLSFzRJZgElkmSmQ
         zWoFbZ3kek/VZeONWnGtmycDATI9oWg4w/KFIcSziwjacDTsyFXvBn8A9ssk8HUiblFR
         3QcOTKQTtxmYsronDa9e84J4yUYB4nFsJkjXw806I0wN2sIj8IuEyuwHSx46hgEzxqSC
         HVOo/Ai7K7T88Pazc7mRzqVsBpjRkOOhe1L19pUxSL0nm96QXtkn4Tjo/Vi+HEsFRLPM
         10GE+sxR7rmTCZfwHOV+Qjog+cl9t8NaZ2fAwmtzHSZlwxEGDKCk2enGid5sU4X1zcPC
         Y5RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=N4Vd9BN2j932WxyWytszRjBw49iBm5N6JyEwBXF6F1o=;
        b=LCmvvaorIlfDF2PMb0STRS83HdZuiFT6nfdE8ku4HhYYvWa1veN2GNVyYO3SbFVlOi
         Q6KZnB7z8sMuBaNcJXqbnERVdx46jl0wl1f7oCEM1zput0QsiAXc8L5UmUDXxY51AAZM
         tA1lnk1n/bC6u122TiAtGh4XjWtY5yexFDMqBnrOI28h5eu+rWRHmiZHc8HxY694zDqI
         vVLPpKbwUy6sqNJAZQfJHEns9/S3QJNg07Xq8EujfIaCcnMpeYcIIaCD5goSDQu86YEP
         Aidwm2TWTxUSxoUODIm/ZRHMZw/F2ddxKjvCsfljx6aKKgkP1t7ps7NYi8t+BpVjM80u
         jUDg==
X-Gm-Message-State: APjAAAXiOZ4umFTxV6D/3z8SXSRgO8QZlrwMx5rF0Y02HF2u+rNsNjiR
        I0MUarJstFqXXg5xVcryqxNYweKOSPnocrZ7AHY=
X-Google-Smtp-Source: APXvYqxQ+oYL1GEEIZMirGkqalT/4V3iMF2WvOvzlumZVdTMdNZadIe9wtQB65hhfwZGkw4fPSIJE//QcIPSwMUU8FU=
X-Received: by 2002:a50:9271:: with SMTP id j46mr20703132eda.184.1553613045616;
 Tue, 26 Mar 2019 08:10:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190315223425.hiq3qcjhjnirsizh@gofer.mess.org>
 <20190317065242.137cb095@coco.lan> <20190319164507.7f95af89@coco.lan>
 <a1f296ba-3c27-ed2c-3912-4edbeeb21eba@googlemail.com> <20190321094127.ysurm4u26zugmnmv@gofer.mess.org>
 <20190321083044.621f1922@coco.lan> <35ba4e81-fc2a-87ed-8da7-43cc4543de51@googlemail.com>
 <CANJnhGfRtEwAony5Z4rFMPcu58aF2k0G+9NSkMKsq_PhfmSNqw@mail.gmail.com>
 <20190325140838.71f88eac@coco.lan> <CANJnhGc_qx32nm7yZheC2ioHOij8QELbnwyJkZ83G9uYTxqwtA@mail.gmail.com>
 <20190326132643.r3svehoa764xagje@gofer.mess.org>
In-Reply-To: <20190326132643.r3svehoa764xagje@gofer.mess.org>
From:   Samuel CHEMLA <chemla.samuel@gmail.com>
Date:   Tue, 26 Mar 2019 16:10:33 +0100
Message-ID: <CANJnhGfgzrLZedeoCOq3L-MaEgjtHm1Bwn1cRPr54LvwZ=RBMQ@mail.gmail.com>
Subject: Re: [Bug report] dvbv5-zap crash dvb-tool ARMHF builds
To:     Sean Young <sean@mess.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Gregor Jasny <gjasny@googlemail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,


> Earlier you said "random hangs are back". When this happens, does the who=
le
> device become unresponsive or just dvbv5-zap?
The device completely freeze, you can't even switch numlock on/off.
I said "the issue is back", it is because I **thought** it was gone.
To be more precise:
- on raspberry zero W, the issue is gone since Mauro's patch
(https://git.linuxtv.org/v4l-utils.git/commit/?id=3D22b06353227e04695b1b0a9=
622b896b948adba89)
- on raspberry 2, the issue, it is still there and the patch has no
effect (the issue was and is still there)

> Since this issue is "back",
> I wouldn't be surprised this is unrelated to the fixes in 1.12.7 and 1.16=
.4.
The issue doesn't appear anymore on raspberry zero W since Mauro's commit.
So it did improve on that platform.

> It would be useful to see the output from dmesg (best thing would be afte=
r
> the issue occurs).
You can't, device is frozen.
Logs are not flushed to disk, and journalctl -f freeze before showing anyth=
ing

> Also what dvb hardware are you using?
I reproduced it with different two tuners: rtl2832U from RTL-SDR.COM
and a TerraTec Cinergy T Stick+


You can found all the details here:
https://bugs.launchpad.net/raspbian/+bug/1819650


Sam


Le mar. 26 mars 2019 =C3=A0 14:26, Sean Young <sean@mess.org> a =C3=A9crit =
:
>
> Hi Sam,
>
> On Tue, Mar 26, 2019 at 08:35:44AM +0100, Samuel CHEMLA wrote:
> > Hi,
> >
> >
> > I am struggling with valgrind because it always complain with either :
> >     ASan runtime does not come first in initial library list; you
> > should either link runtime to your application or manually preload it
> > with LD_PRELOAD
> >     -> When I LD_PRELOAD, I'm getting a segfault, but I couldn't find
> > any core dump
> >
> > or, if I link statically libasan with -static-libasan:
> >     Shadow memory range interleaves with an existing memory mapping.
> > ASan cannot proceed correctly. ABORTING.
> >     ASan shadow was supposed to be located in the
> > [0x00007fff7000-0x10007fff7fff] range.
> >
> >
> > I retested again on my raspberry zero W, and I confirm i cannot
> > reproduce the hang.
> > Your fix did work on that device.
> > I am testing with same OS (raspbian with latest updates, same kernel),
> > same configure options, same USB dongle... :-(
> > The only differences are CPU architecture (armv6 vs armv7), memory
> > constraints, and I was not using the same channels.conf, I'll fix that
> > today and re-check
>
> Earlier you said "random hangs are back". When this happens, does the who=
le
> device become unresponsive or just dvbv5-zap? Since this issue is "back",
> I wouldn't be surprised this is unrelated to the fixes in 1.12.7 and 1.16=
.4.
>
> It would be useful to see the output from dmesg (best thing would be afte=
r
> the issue occurs).
>
> Also what dvb hardware are you using?
>
> Thanks,
>
> san
>
> >
> >
> > Sam
> >
> > On 25/03/2019 18:08, Mauro Carvalho Chehab wrote:
> >
> > Em Mon, 25 Mar 2019 17:33:30 +0100
> > Samuel CHEMLA <chemla.samuel@gmail.com> escreveu:
> >
> > Hi guys,
> >
> > I'm afraid I'm coming with sad news.
> > I just tried both stable-1.12 and stable-1.16 on a raspberry pi 2, and
> > random hangs are back (see https://bugs.launchpad.net/raspbian/+bug/181=
9650
> > ).
> > I previously test both branches on a raspberry zero and issues were gon=
e
> > (same raspbian version).
> > There may be more memory issues somewhere...
> >
> > Could you test it with valgrind?
> >
> > Sam
> >
> > Le jeu. 21 mars 2019 =C5=95 20:59, Gregor Jasny <gjasny@googlemail.com>=
 a =C3=A9crit :
> >
> > Hello,
> >
> > On 21.03.19 12:30, Mauro Carvalho Chehab wrote:
> >
> > I went ahead and cherry-picked the relevant patches to -1.12, -1.14 and
> > -1.16, and tested both dvbv5-zap and dvbv5-scan with all versions. So,
> >
> > we can
> >
> > release a new minor version for all those stable branches.
> >
> > After the patches, on my tests, I didn't get any memory leaks or
> > double-free issues.
> >
> > I issues a new 1.12, 1.14, and 1.16 release.
> >
> > Thanks,
> > Gregor
> >
> >
> >
> > Thanks,
> > Mauro
