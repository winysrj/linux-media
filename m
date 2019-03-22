Return-Path: <SRS0=TC89=RZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E69BC43381
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 00:04:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5166B20830
	for <linux-media@archiver.kernel.org>; Fri, 22 Mar 2019 00:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfCVAEC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 20:04:02 -0400
Received: from mail-it1-f197.google.com ([209.85.166.197]:56503 "EHLO
        mail-it1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbfCVAEB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 20:04:01 -0400
Received: by mail-it1-f197.google.com with SMTP id f5so635545ita.6
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2019 17:04:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=aMmCqYqaoXJNPuNI30zhUuPbaEwdFM6TqCPG0NbQKRs=;
        b=CyZ3DqmDmX/6E9E8h2Jzztmp02Fku6B41KS/KXBej9Vrvr3KoyAr4FQf5glFFdRx/q
         aIXKI8Td/snr7sghZ8wOgzWrVR8eGH52tqnyEhJ8orkH4p76/9dKR7oPUWst6ZIGZuoC
         d/50Nz+hygkmpZsvwC5V/wnwBpcxuuq70qv0mMFRPtaJNyvWStM2+dioY2X6YGiyTQ9I
         3J+khTPF7FNndfKdYjUFbxDi8MipmXs/WkJqygiNyjlbx26IilUqTKYEaNUHvsWRvFkl
         sPQCO6TxiBJdfMaB+BRi0XgFgB60yyKj7IyWrJXW+dOWlm6Ts5UbWM+dok11xwE4Qf+T
         8bnQ==
X-Gm-Message-State: APjAAAUj1zMxfynL5zTLAmxAUkF5Vx3nT2cFxPV9+ltz26VHo3n7yDOB
        Mr7QNQVFmKXzl26HXENkbLUM0Rghh5ugvxTq8Sy4euK0FGOv
X-Google-Smtp-Source: APXvYqzlG4OOLIfA/+JzQNzIxmqInt1FZHjdHGY+Ez5t7ItYq4+AxHc9wZRFhpUlErwvflfSOxKnJY62ksU/zNPuaIYTO+4l4GlF
MIME-Version: 1.0
X-Received: by 2002:a24:f34f:: with SMTP id t15mr790649iti.88.1553213040971;
 Thu, 21 Mar 2019 17:04:00 -0700 (PDT)
Date:   Thu, 21 Mar 2019 17:04:00 -0700
In-Reply-To: <000000000000204051057963c4dc@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000915e8b0584a397a9@google.com>
Subject: Re: KASAN: use-after-free Write in __vb2_cleanup_fileio
From:   syzbot <syzbot+4e12d2d56f8ccc65c180@syzkaller.appspotmail.com>
To:     andy@greyhouse.net, davem@davemloft.net, hverkuil@xs4all.nl,
        j.vosburgh@gmail.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, maheshb@google.com,
        mchehab@kernel.org, netdev@vger.kernel.org,
        sakari.ailus@linux.intel.com, satendra.t@samsung.com,
        syzkaller-bugs@googlegroups.com, vfalico@gmail.com,
        viro@zeniv.linux.org.uk
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1232b037200000
start commit:   4493b81b bonding: initialize work-queues during creation o..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1132b037200000
console output: https://syzkaller.appspot.com/x/log.txt?x=1632b037200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=62118286bb772a24
dashboard link: https://syzkaller.appspot.com/bug?extid=4e12d2d56f8ccc65c180
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1346e183400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=117c2713400000

Reported-by: syzbot+4e12d2d56f8ccc65c180@syzkaller.appspotmail.com
Fixes: 4493b81bea24 ("bonding: initialize work-queues during creation of  
bond")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
