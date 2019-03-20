Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 829A3C4360F
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 20:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FE8521873
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 20:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfCTUfB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 16:35:01 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:34253 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbfCTUfB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 16:35:01 -0400
Received: by mail-io1-f69.google.com with SMTP id y13so3225078iol.1
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 13:35:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=JmLVF5snE2NyN7hOU1yFMUMgFKqoLudwJA/IgtiwKX4=;
        b=AQ7z1lW6I4khIT/BrdVyHfDH1+2gwkvdHipf5APqWChIpl+O3+6FfOJ5MNBvB8qAS3
         Vj5yrnf/YoWKsK1+qy15fWmNRpCnsF1udWFzzwjET8UlZLRlnRyiFqcd7gwUBpGv/gs7
         kzGnNmn+dQQJivw+zQUUxzavXCCAWB5fAZEGWWBssFZu+ddhZUSwWU8WYPj6EAkebm0r
         S4DtscHj8n8qKSxD5pFeFGncsrvdQ9gLOAycTtW73D1dr5cRqgDRgeUo3u8wlV3M2og/
         hUEKyTJyrXmMkqSL8IaSkgkmngjyWa50OjUg9j2LAm2CSJNFDb5S03hr+mwB+91+O63X
         Secw==
X-Gm-Message-State: APjAAAU59lgsgMxeA5JzvhdEK5SnEdBwfTxClAfjSwX2fVGAg1eVxPZq
        eXKZe8D5MYfaN2FPzW0WYaNiwP1wX0MuRkOfvT2inXlXaywB
X-Google-Smtp-Source: APXvYqw0cMwjeDljIAs1pj5QYCuuZfAcL8XbBmSJ95chswsZft4cVbAefhbc8z3zFJpn07YcUU+D6Vh1VJFN0w1k9tJPdafn/2IJ
MIME-Version: 1.0
X-Received: by 2002:a5d:9a0d:: with SMTP id s13mr5895129iol.26.1553114100801;
 Wed, 20 Mar 2019 13:35:00 -0700 (PDT)
Date:   Wed, 20 Mar 2019 13:35:00 -0700
In-Reply-To: <0000000000001c2b95057ad0935b@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000462a4105848c8e12@google.com>
Subject: Re: kernel BUG at arch/x86/mm/physaddr.c:LINE! (2)
From:   syzbot <syzbot+6c0effb5877f6b0344e2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, hverkuil@xs4all.nl, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        mchehab@kernel.org, mchehab@s-opensource.com, mkl@pengutronix.de,
        netdev@vger.kernel.org, socketcan@hartkopp.net,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

syzbot has bisected this bug to:

commit 6d469a202ee73196d0df76025af80bd6a379e658
Author: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Date:   Sun May 14 17:07:21 2017 +0000

     Merge tag 'v4.12-rc1' into patchwork

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12639fd7200000
start commit:   6d469a20 Merge tag 'v4.12-rc1' into patchwork
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=15639fd7200000
console output: https://syzkaller.appspot.com/x/log.txt?x=11639fd7200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d86f24333880b605
dashboard link: https://syzkaller.appspot.com/bug?extid=6c0effb5877f6b0344e2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1312062b400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=131bd093400000

Reported-by: syzbot+6c0effb5877f6b0344e2@syzkaller.appspotmail.com
Fixes: 6d469a20 ("Merge tag 'v4.12-rc1' into patchwork")
