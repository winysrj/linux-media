Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35813 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752175AbdLMODa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 09:03:30 -0500
To: mchehab@kernel.org, bhumirks@gmail.com, hans.verkuil@cisco.com,
        xyzzy@speakeasy.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] cx88: a possible sleep-in-atomic bug in snd_cx88_switch_put
Message-ID: <110cb3d4-656b-c5c7-53f7-c3851c56f22f@gmail.com>
Date: Wed, 13 Dec 2017 22:03:18 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver may sleep under a spinlock.
The function call path is:
snd_cx88_switch_put (acquire the spinlock)
   v4l2_ctrl_find
     mutex_lock --> may sleep

I do not find a good way to fix it, so I only report.
This possible bug is found by my static analysis tool (DSAC) and checked 
by my code review.


Thanks,
Jia-Ju Bai
