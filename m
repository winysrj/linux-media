Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9456C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 15:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 970CE218A5
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 15:55:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfCUPzB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:55:01 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:46958 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727823AbfCUPzA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 11:55:00 -0400
Received: by mail-io1-f70.google.com with SMTP id k5so5464820ioh.13
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2019 08:55:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=7gbEWpXyndZlflaw+JjlVst73NWxLTxudfqepEyKVPw=;
        b=EiaZ43CYC3yxEB2PtUtwKtYSKFJi4dBGhSLMi0PlWmNyLa81//PgEHSzMNWjV1vsQT
         al7lEpSnHKj9tuY/TpPz8eKsVe3Djn6ymQLs4+AlGgr348q6nyAlUNKkX0Tm4r4A2qLo
         X30JHcBFL00QU1/syTRF0e8LaalTWNPgkxYu+48LBCyBYqz1RxEYkrh+yo18jT2RAZet
         KB20cw84e4rmmMHc67kJ2EwriWLXt0lFbRpPZ3i5VCAaJIgJNSxhu451ezdad0FEYp8f
         TX1qwlKCyUqGJNYDXqmBPzaWmk9pPDqD2gB9L6H8AZVODhsMGeRJhfZk3q6gH26FkDSf
         5R4A==
X-Gm-Message-State: APjAAAWFKNRJ0nQOle/DXNUPQRkhc3WlQ+DjnFZXThwTld99DvPyYx6t
        3akXc+uK7kaks31+Kh78PpPKbfN8wS6rgJ5G0otoFAzGESLK
X-Google-Smtp-Source: APXvYqyntVODvycB46+J+TTAh0RmKsnjVe1CuiYBpG2g4cduDsMtyKnrzQJJK5VTff1o/m8kTdIVrRXtayMqYrpXNOwQ9AWWOvIl
MIME-Version: 1.0
X-Received: by 2002:a24:640c:: with SMTP id t12mr132619itc.97.1553183700185;
 Thu, 21 Mar 2019 08:55:00 -0700 (PDT)
Date:   Thu, 21 Mar 2019 08:55:00 -0700
In-Reply-To: <00000000000069922505797781b0@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b87c6405849cc2d6@google.com>
Subject: Re: WARNING in vb2_core_reqbufs
From:   syzbot <syzbot+f9966a25169b6d66d61f@syzkaller.appspotmail.com>
To:     dafna3@gmail.com, hans.verkuil@cisco.com, hverkuil-cisco@xs4all.nl,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, m.szyprowski@samsung.com,
        mchehab+samsung@kernel.org, mchehab@kernel.org, pawel@osciak.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

syzbot has bisected this bug to:

commit 3b15f68e19c28a76d175f61943a8c23224afce93
Author: Dafna Hirschfeld <dafna3@gmail.com>
Date:   Mon Jan 21 11:46:18 2019 +0000

     media: vicodec: Add support for resolution change event.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1662bfbd200000
start commit:   3b15f68e media: vicodec: Add support for resolution change..
git tree:       linux-next
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1562bfbd200000
console output: https://syzkaller.appspot.com/x/log.txt?x=1162bfbd200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a2b2e9c0bc43c14d
dashboard link: https://syzkaller.appspot.com/bug?extid=f9966a25169b6d66d61f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1342c7a0c00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15a241c4c00000

Reported-by: syzbot+f9966a25169b6d66d61f@syzkaller.appspotmail.com
Fixes: 3b15f68e19c2 ("media: vicodec: Add support for resolution change  
event.")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
