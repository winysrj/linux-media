Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C77EC43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 22:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2250B2075E
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 22:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbfCVWp1 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Mar 2019 18:45:27 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:47405 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728239AbfCVWpB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Mar 2019 18:45:01 -0400
Received: by mail-io1-f71.google.com with SMTP id b199so2953325iof.14
        for <linux-media@vger.kernel.org>; Fri, 22 Mar 2019 15:45:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=zCALCNEO7NtFKxHfvEoBHzJUygt2XBFs5Dg/oqssbps=;
        b=FFkvGOPWq43uyU+oIn8NiMOB25HXh/SJt1olOfMlaAKqfsGyeA/dmC35kG399qstQi
         gVpMDmmu8F5mdfWlzrc95Bgf6qVHu1w2VzTfvjWDUBuginGacVv6N/EqKJGUu1du/tRa
         VgiBOZoZhYEn+Pgy/wPJM/vLWnkefXfuP3cFKJoU3LOTbi0VaUncKDY3yWaVJhCw89iG
         3QXCrJUAu+zAJwztFxnyRCNfqAb8MI5RRzUMd9WJCZhygTutk/NCopf7Xi2er2lNq6jl
         nGsZ7ky6gzqADCMU86OlTowZId3mFqHKoaJr9mUmbwlKZFY1jSvQ5yY9gxRfJ01coqeV
         D2Pg==
X-Gm-Message-State: APjAAAU89d20R3fHZCIEQoXkHwwetZK3bmTHH9yVGREyuRfbvuplLP7i
        aW1YtNwFw1qkLJ9YsxavpudUdfhZjBW+SuC1V6qtm/lzpDQH
X-Google-Smtp-Source: APXvYqxlMHnEBpoHifDJpAyMFP2NLWonn97WJtkDeK1UM0im4KbDRyJkDObbN/BJfI9PK42gT6QHAX3y5Rr0EmcNS0ZY6CFOruj/
MIME-Version: 1.0
X-Received: by 2002:a6b:6218:: with SMTP id f24mr7986054iog.229.1553294700965;
 Fri, 22 Mar 2019 15:45:00 -0700 (PDT)
Date:   Fri, 22 Mar 2019 15:45:00 -0700
In-Reply-To: <00000000000080601805795ada2e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e1f98d0584b69aa6@google.com>
Subject: Re: INFO: task hung in vivid_stop_generating_vid_cap
From:   syzbot <syzbot+06283a66a648cd073885@syzkaller.appspotmail.com>
To:     andy@greyhouse.net, davem@davemloft.net, dvyukov@google.com,
        hans.verkuil@cisco.com, helen.koike@collabora.com,
        hverkuil@xs4all.nl, j.vosburgh@gmail.com,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, maheshb@google.com,
        mchehab@kernel.org, mchehab@s-opensource.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        vfalico@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

syzbot has bisected this bug to:

commit f2fe89061d79706eca5c47e4efdc09bbc171e74a
Author: Helen Koike <helen.koike@collabora.com>
Date:   Fri Apr 7 17:55:19 2017 +0000

     [media] vimc: Virtual Media Controller core, capture and sensor

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12ea247d200000
start commit:   9f51ae62 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=11ea247d200000
console output: https://syzkaller.appspot.com/x/log.txt?x=16ea247d200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=62118286bb772a24
dashboard link: https://syzkaller.appspot.com/bug?extid=06283a66a648cd073885
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15701a33400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=154c8e4d400000

Reported-by: syzbot+06283a66a648cd073885@syzkaller.appspotmail.com
Fixes: f2fe89061d79 ("[media] vimc: Virtual Media Controller core, capture  
and sensor")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
