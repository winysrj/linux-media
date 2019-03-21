Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 421C7C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 01:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C7AF2184E
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 01:21:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbfCUBVC (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 21:21:02 -0400
Received: from mail-it1-f199.google.com ([209.85.166.199]:35945 "EHLO
        mail-it1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfCUBVB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 21:21:01 -0400
Received: by mail-it1-f199.google.com with SMTP id i4so1112076itb.1
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 18:21:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=LlTMmdoG7E6wZ4rWK7uh0Mls5qpshkbwaYodTMDIO0c=;
        b=QO7AxsQNEPoLMa+sJbzghh1AmPaYe/UosobZkKK2Qr9kVHBtqAUQ2M7ps2lMghQOZU
         lMPPH2YaC6Mq10IpAhXL/OgkIk6fK7mXX+N+4zko1WAPhto7EldZmHLhEkobhrzFS4kr
         WMlm+YrUCnoj75DpmGiPv575KfbGeKh/FSE2h+FEOO7gWlXPX3ziIkh2BI7XrszhpBy/
         e4XVyFT5tLqQxyxnpZptVzZdN7ZWnLxIetkQ5fSbXxGuJs5tFRO48W2eanct33HL8MIt
         TYmE/gZE20V7fraSUYbOTVkiSlWclrn6lrqQU0lQiZnjwidcrMm9CiSbKRXzzWttRPyV
         FWGA==
X-Gm-Message-State: APjAAAXlfGuFieZHZLPAVrDNDfcv4YZ3ggO/0b8yWBXW1yK9h3hoL67S
        XrwiM4sDj9vSV9PGuFK+Q3OUNZnT7MgvVIcGEkDLjFUcGdA1
X-Google-Smtp-Source: APXvYqxcVY0CRvgFLAgJTl8ubgj7AqjWomnlM5fnvxPCNXdlowNE3TQYXbjtpcmvXIx3eUaFNcvr2CAiwYQ0hMYDzPRWqO8A10vK
MIME-Version: 1.0
X-Received: by 2002:a24:e4a:: with SMTP id 71mr360124ite.0.1553131260157; Wed,
 20 Mar 2019 18:21:00 -0700 (PDT)
Date:   Wed, 20 Mar 2019 18:21:00 -0700
In-Reply-To: <000000000000aa8703057a7ea0bb@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000d28ac0584908d43@google.com>
Subject: Re: WARNING in dma_buf_vunmap
From:   syzbot <syzbot+a9317fe7ad261fc76b88@syzkaller.appspotmail.com>
To:     andy@greyhouse.net, davem@davemloft.net,
        dri-devel@lists.freedesktop.org, gregkh@linuxfoundation.org,
        j.vosburgh@gmail.com, linaro-mm-sig-owner@lists.linaro.org,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, maheshb@google.com,
        netdev@vger.kernel.org, sumit.semwal@linaro.org,
        syzkaller-bugs@googlegroups.com, vfalico@gmail.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

syzbot has bisected this bug to:

commit d5e73f7be850323ae3adbbe84ed37a38b0c31476
Author: Mahesh Bandewar <maheshb@google.com>
Date:   Wed Mar 8 18:55:51 2017 +0000

     bonding: restructure arp-monitor

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15e679f7200000
start commit:   d5e73f7b bonding: restructure arp-monitor
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=17e679f7200000
console output: https://syzkaller.appspot.com/x/log.txt?x=13e679f7200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4a0a89f12ca9b0f5
dashboard link: https://syzkaller.appspot.com/bug?extid=a9317fe7ad261fc76b88
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16f7b6f5400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=105a2783400000

Reported-by: syzbot+a9317fe7ad261fc76b88@syzkaller.appspotmail.com
Fixes: d5e73f7b ("bonding: restructure arp-monitor")
