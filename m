Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E5EEC43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 17:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07C2F21874
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 17:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbfCURjB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 13:39:01 -0400
Received: from mail-it1-f200.google.com ([209.85.166.200]:42372 "EHLO
        mail-it1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728705AbfCURjB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 13:39:01 -0400
Received: by mail-it1-f200.google.com with SMTP id j127so2980696itj.7
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2019 10:39:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=EvagYsar2Kkc1zjuncQWprBpr0l0y5Xjvax9LXSFdA8=;
        b=AesBCHGJ5FhtOAvrRjFw/i4jRYYXJ4jBjrvnW/jGS4z8OxvSTX3SmTs2kyVo1BZXuo
         h5Krb34/FS3y+nQT+FnjR96oreRiyp9XP35jjaJwRvqA3N8rr1zjXei8iiZZ7BoMHvsI
         gHzBGfn9FhxbvaIvRqBEXNwzYnDtWeKHr1AJLvv3KqQthzSwt1uxRUeIXe1rhNLlEO5l
         aMcPZRVeKzvER5rf4d5Zn1PKJkKWHiXErcD0Xqbo4bxK5TuMxjkritZ7sc51395dCsci
         4gNvYuuR7iXSbKkS+ON475UlqhhtaXmhpKNkU0/VHgkGMnTiaHeqz3WgfZ3LaJvBgfiR
         FkBg==
X-Gm-Message-State: APjAAAWAejyIkIb64YG0Cluv6DbLQgNhTWjxzl5FRMF8wCLFdKyVEUrW
        j/nyHtHITRb3eOmgjNGcpPhsViWvx8IsrgXwfQwkfNhpvqWp
X-Google-Smtp-Source: APXvYqwGEkG50ftwcqAyo6aHxRCW80LFJfjGwntx2Y9ndgan1YT3uHyGiAffzbKSOY/vYdbDDO/N0dZVJcGSPX3Uaop7IceQZLX3
MIME-Version: 1.0
X-Received: by 2002:a6b:d913:: with SMTP id r19mr3827202ioc.76.1553189941049;
 Thu, 21 Mar 2019 10:39:01 -0700 (PDT)
Date:   Thu, 21 Mar 2019 10:39:01 -0700
In-Reply-To: <00000000000014008b057a598671@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b480bc05849e3623@google.com>
Subject: Re: general protection fault in vb2_mmap
From:   syzbot <syzbot+52e5bf0ebfa66092937a@syzkaller.appspotmail.com>
To:     kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, m.szyprowski@samsung.com,
        mchehab@kernel.org, pawel@osciak.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Bisection is inconclusive: the bug happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=160e9e6d200000
start commit:   [unknown
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=150e9e6d200000
console output: https://syzkaller.appspot.com/x/log.txt?x=110e9e6d200000
dashboard link: https://syzkaller.appspot.com/bug?extid=52e5bf0ebfa66092937a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c61b0b400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=109d545d400000

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
