Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0575C43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 07:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E03521900
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 07:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727430AbfCVHIB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Mar 2019 03:08:01 -0400
Received: from mail-it1-f200.google.com ([209.85.166.200]:51491 "EHLO
        mail-it1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfCVHIB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Mar 2019 03:08:01 -0400
Received: by mail-it1-f200.google.com with SMTP id e63so1400045ita.1
        for <linux-media@vger.kernel.org>; Fri, 22 Mar 2019 00:08:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=We/Sg27LqRj2nWSdbJg1A6SLyTwFCLM1xyYF+U7bC/g=;
        b=asPA+C8+OewF5W9j3ItkbTOqrDJje85JTVF8dGzttGy0W7ReX803fTDTGj0YSXFTdA
         od4Q1RNumD9pRFQ2HVapdpDC/XLGlOxhJQ5Rzg+6LGt83HmpEAKyu7Lg99fpCpAwcnp9
         RVyYcSOpfO/R/9YFmKt6Srj0sWw6wHkKE+1KVjahNa/olZEsVIIkR4FCMqfZHgVKfDuk
         PQixK+3oFZWe16wFzldZhf14j7zAZiuGagW3mxSb6Ure8bxmegUWROGLoOjXa5D23vrv
         nfBTekDG7FZB0ba2IOixjCgdPO8ZPA7qdJtFF8eedvSYPlFdvxWby+Y8x0sofX0rPdEZ
         jorA==
X-Gm-Message-State: APjAAAU7v3iyjE3+yRD+dBLoBbom7lokTZPv6uMHVZmq4sz4ua9NuRyH
        50BMs1/WCoC1skiHni/FTf56WFxypDIDurr+Y1UF0Vg7tjR/
X-Google-Smtp-Source: APXvYqy7Aky+F53NuKK5x5RtyI0ve6II5XMGbh2PGk4QjvMLoUnO1wr6ezUcLU4k6A+9z1PAAFkU6O0JTiM34h3c47R1BqElu7bH
MIME-Version: 1.0
X-Received: by 2002:a5e:da0b:: with SMTP id x11mr5537935ioj.200.1553238480789;
 Fri, 22 Mar 2019 00:08:00 -0700 (PDT)
Date:   Fri, 22 Mar 2019 00:08:00 -0700
In-Reply-To: <00000000000080601805795ada2e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e626290584a983c0@google.com>
Subject: Re: INFO: task hung in vivid_stop_generating_vid_cap
From:   syzbot <syzbot+06283a66a648cd073885@syzkaller.appspotmail.com>
To:     andy@greyhouse.net, davem@davemloft.net, hverkuil@xs4all.nl,
        j.vosburgh@gmail.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, maheshb@google.com,
        mchehab@kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, vfalico@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

syzbot has bisected this bug to:

commit 4493b81bea24269df898339dee638d7c5cb2b2df
Author: Mahesh Bandewar <maheshb@google.com>
Date:   Wed Mar 8 18:55:54 2017 +0000

     bonding: initialize work-queues during creation of bond

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=176d1617200000
start commit:   4493b81b bonding: initialize work-queues during creation o..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=14ed1617200000
console output: https://syzkaller.appspot.com/x/log.txt?x=10ed1617200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=62118286bb772a24
dashboard link: https://syzkaller.appspot.com/bug?extid=06283a66a648cd073885
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15701a33400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=154c8e4d400000

Reported-by: syzbot+06283a66a648cd073885@syzkaller.appspotmail.com
Fixes: 4493b81bea24 ("bonding: initialize work-queues during creation of  
bond")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
