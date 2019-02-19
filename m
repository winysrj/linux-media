Return-Path: <SRS0=RQn6=Q2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C88C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 14:46:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E58F92146E
	for <linux-media@archiver.kernel.org>; Tue, 19 Feb 2019 14:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfBSOqd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Feb 2019 09:46:33 -0500
Received: from tnsp.org ([94.237.36.134]:36454 "EHLO pet8032.tnsp.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726388AbfBSOqd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Feb 2019 09:46:33 -0500
Received: by pet8032.tnsp.org (Postfix, from userid 1000)
        id 3C16C19690B; Tue, 19 Feb 2019 16:46:31 +0200 (EET)
Received: from localhost (localhost [127.0.0.1])
        by pet8032.tnsp.org (Postfix) with ESMTP id 3A49719690A;
        Tue, 19 Feb 2019 16:46:31 +0200 (EET)
Date:   Tue, 19 Feb 2019 16:46:31 +0200 (EET)
From:   =?ISO-8859-15?Q?Matti_H=E4m=E4l=E4inen?= <ccr@tnsp.org>
To:     Hans Verkuil <hverkuil@xs4all.nl>
cc:     linux-media@vger.kernel.org
Subject: Re: [BUG] Regression caused by "media: gspca: convert to vb2"
In-Reply-To: <2e3e8d88-5d7d-c6d6-9fb7-7b5670ed44ef@xs4all.nl>
Message-ID: <alpine.DEB.2.20.1902191431390.29258@tnsp.org>
References: <alpine.DEB.2.20.1902190711130.21189@tnsp.org> <2e3e8d88-5d7d-c6d6-9fb7-7b5670ed44ef@xs4all.nl>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="-312572380-965880199-1550579835=:29258"
Content-ID: <alpine.DEB.2.20.1902191643480.29258@tnsp.org>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---312572380-965880199-1550579835=:29258
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.20.1902191643481.29258@tnsp.org>

On Tue, 19 Feb 2019, Hans Verkuil wrote:

> Hi Matti,
>
> On 2/19/19 6:30 AM, Matti Hämäläinen wrote:
>>
>> Hello!
>>
>> Last week while testing some webcams that use gspca-based v4l2 drivers, I
>> noticed that the driver was spewing some errors in klog whenever the
>> program using them issued VIDIOC_STREAMOFF ioctl. This seems to be a
>> regression caused by commit 1f5965c4dfd7665f2914a1f1095dcc6020656b04
>> "media: gspca: convert to vb2" in the mainline kernel.

[...]
>
> Which kernel version are you using?
>
> I got other, similar reports as well and I plan to look at it next week.

Hi Hans,

Sorry, forgot to mention that. First I noticed it on a vanilla 4.20.8 
kernel, but bisected to the mentioned commit in Linus' mainline tree, 
which was merged in some 4.18-rc. 4.17.x and earlier without the 
change work fine.

I just tested with git://linuxtv.org/media_tree.git of today 
(5.0.0-rc7-test-00312-gb3c786566d8f), and the problems persist.
Actually I got my other PC to hard lockup, too, when disconnecting the 
camera while capture was on.


-- 
] ccr/TNSP ^ pWp  ::  ccr@tnsp.org  ::  https://tnsp.org/~ccr/
] https://tnsp.org/hg/ -- https://www.openhub.net/accounts/ccr
] PGP key: 7BED 62DE 898D D1A4 FC4A  F392 B705 E735 307B AAE3
---312572380-965880199-1550579835=:29258--
