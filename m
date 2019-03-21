Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3FD7C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 17:39:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB30B21874
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 17:39:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728710AbfCURjP (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 13:39:15 -0400
Received: from mail-it1-f200.google.com ([209.85.166.200]:43392 "EHLO
        mail-it1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728712AbfCURjC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 13:39:02 -0400
Received: by mail-it1-f200.google.com with SMTP id w200so2976605itc.8
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2019 10:39:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ltum6L1yStqaszX+G3ATCwsEMnljdk7XwCw4LQxUuso=;
        b=KH/QBOcqRwYQua5zvl/nY32g0z9I+rYEbJgwN+U8PvfSarFSOPdtms/i8zbsP6uilW
         If+/aWkjW0l4oTuShXwhhBpriwhGliB0Vv3nwevC3njQssyzlX9dSl7vLRZGqqOh3i8v
         n7rCjHlop9c/nhLYLUm/Ztum+Z93N375MTS9sZqrPb3L8dJx7GfftOKG3Xr0RVmAxN/M
         ah1PIOCIi3B2v7+Tzpg0ZgoM26BvKmKUWx4CLw24oQ8yptFzEJVLKJQFsPRAM9Sktkou
         U+KLJ2/MxGBHTTY12keu8e4ZQkH6Zavt61kMcdmDdygUdtPDbpJ9iC0d8lrxowZJhb+k
         YDrg==
X-Gm-Message-State: APjAAAUMIyj/Hwusg9kJsO1T/8eC1d4yOsxqWdse4iRwHVVvlsQWIri1
        rpyukQ7dAdOgzWX/L6eTiiy9cticfmtr3njyiRNnDPS4sIGE
X-Google-Smtp-Source: APXvYqwmWXGhIPxuo2dx4extPBJ7l9tAksm0/QEkCzNO94Y6Oga2FGi+fbiune3/sMrwpq9tWEUrL4tMPZpal6LsUhEvlZ7JgQiO
MIME-Version: 1.0
X-Received: by 2002:a02:6610:: with SMTP id k16mr3733083jac.40.1553189941229;
 Thu, 21 Mar 2019 10:39:01 -0700 (PDT)
Date:   Thu, 21 Mar 2019 10:39:01 -0700
In-Reply-To: <00000000000057e614057a9abcd3@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b73f7005849e3600@google.com>
Subject: Re: KASAN: null-ptr-deref Read in refcount_sub_and_test_checked (2)
From:   syzbot <syzbot+0468b73bdbb243217224@syzkaller.appspotmail.com>
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

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13b0323b200000
start commit:   [unknown
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1070323b200000
console output: https://syzkaller.appspot.com/x/log.txt?x=17b0323b200000
dashboard link: https://syzkaller.appspot.com/bug?extid=0468b73bdbb243217224
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16d20893400000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=118f5a2b400000

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
