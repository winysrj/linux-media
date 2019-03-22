Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 858A8C10F03
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 08:01:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53BD8204FD
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 08:01:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OlsRK8Hf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727633AbfCVIBB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 22 Mar 2019 04:01:01 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:34841 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727548AbfCVIBB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Mar 2019 04:01:01 -0400
Received: by mail-io1-f65.google.com with SMTP id p16so1019206iod.2
        for <linux-media@vger.kernel.org>; Fri, 22 Mar 2019 01:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9TrL7zc7AhFuZ4YHkL8qTuh2OarW08S6ZFrL3mlzc0Q=;
        b=OlsRK8Hf0Z7QzLhwsVqCPQrXDu9O57JKBuqBO9LiBHWf13fvUkF5EjLN2vj+Wz0Qst
         siU5+tVso0/6EplNcf6QEhN/vjGnuiat3AX5t32i4MdaILE0cY7bKavd9egsh1SF7Kpt
         VxNEEetdIW4E4biQc2H83JIcveu2cI7AdI0f5ZqnZy5oSHh7LfLSJxL6YaOB7vPnDNFd
         j+mrzsMuGFZ5q5Fw3c0zK/KEvNpU5Ox+T7sbugjxLnZfjuIYCtdCAliBiWZ7FVjSEn1C
         tx/c2cD52uUdvJRIo45DXQEbQPcxWvPYjX9E7Rt/JzbzkrIgW+lYNviXtrXnUrG2kVlN
         K84A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9TrL7zc7AhFuZ4YHkL8qTuh2OarW08S6ZFrL3mlzc0Q=;
        b=ZMw6pYNhtVx9UwDDCjRe5Citqv2ednFU18BWnzraHnxO5tSIQE47n4UcSwNapBNw3B
         Xv55SgzZL6jAqKyoxr5tg/eScKQCTXonBqe0HXgo4+Dl4rVUJj/xi7ZJQk6tcAyu7xki
         fudexGFlEZebmEyuTKk41N2B3mqJXWilfRAyfP8I3ZC/FO9UykyeyZFRXJ0joM0S+/yf
         4YiBneUvGL48S7t975gGvJcrMHGpsrvYONYQrCA9/9hMj1Yo4SQujzzpjWmlsR2mTYL/
         SKU0q+VYpxHhaaAYYJ4hE5n/CuyG8/A0Vvhp7MBj6d+eheIO5kE2JqcZfA13KorCffoe
         EGcA==
X-Gm-Message-State: APjAAAWpht7i2AGsLZRN27ml+QYw4sIc7UXkVElg43ChBw9FO3pz9opn
        O5zfRh0OWeYirtPp9bB2M2N5FfOWVMa2nGUM6ULXPg==
X-Google-Smtp-Source: APXvYqzRr5JBJcGhbyB+evQP9iT94CpLx3iI4L1dcQqgehjWAGFv+GBmVc8hhGikJuBqIeYWynluJCOfxtiP1Jf2zy4=
X-Received: by 2002:a6b:3709:: with SMTP id e9mr5079808ioa.282.1553241659838;
 Fri, 22 Mar 2019 01:00:59 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000080601805795ada2e@google.com> <000000000000e626290584a983c0@google.com>
In-Reply-To: <000000000000e626290584a983c0@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 22 Mar 2019 09:00:48 +0100
Message-ID: <CACT4Y+YVNA6aYe-Ai-ZnU+EhNSNAFhjvXPT0oA+i4rCFpQThcg@mail.gmail.com>
Subject: Re: INFO: task hung in vivid_stop_generating_vid_cap
To:     syzbot <syzbot+06283a66a648cd073885@syzkaller.appspotmail.com>,
        linux-can@vger.kernel.org
Cc:     andy@greyhouse.net, David Miller <davem@davemloft.net>,
        Hans Verkuil <hverkuil@xs4all.nl>, j.vosburgh@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        Mahesh Bandewar <maheshb@google.com>, mchehab@kernel.org,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        vfalico@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Mar 22, 2019 at 8:08 AM syzbot
<syzbot+06283a66a648cd073885@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this bug to:
>
> commit 4493b81bea24269df898339dee638d7c5cb2b2df
> Author: Mahesh Bandewar <maheshb@google.com>
> Date:   Wed Mar 8 18:55:54 2017 +0000
>
>      bonding: initialize work-queues during creation of bond

+linux-can

I think I will disable CONFIG_CAN before v4.12. It causes too many
false results for v4.12..v4.11 range. It always leads to a wrong
decision for first 3 steps, then no chances of correct bisection
anymore.

> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=176d1617200000
> start commit:   4493b81b bonding: initialize work-queues during creation o..
> git tree:       upstream
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=14ed1617200000
> console output: https://syzkaller.appspot.com/x/log.txt?x=10ed1617200000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=62118286bb772a24
> dashboard link: https://syzkaller.appspot.com/bug?extid=06283a66a648cd073885
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15701a33400000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=154c8e4d400000
>
> Reported-by: syzbot+06283a66a648cd073885@syzkaller.appspotmail.com
> Fixes: 4493b81bea24 ("bonding: initialize work-queues during creation of
> bond")
>
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
