Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:17406 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932294AbeCLQfb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Mar 2018 12:35:31 -0400
Subject: Re: [GIT PULL] HEVC V4L2 controls and s5p-mfc update
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Smitha T Murthy <smitha.t@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <75dc8545-6411-db8a-c69b-5ac8961b9db1@samsung.com>
Date: Mon, 12 Mar 2018 17:35:16 +0100
MIME-version: 1.0
In-reply-to: <a0d2557e-d451-8cec-a700-e403a5da8919@xs4all.nl>
Content-type: text/plain; charset="utf-8"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <CGME20180312154404epcas2p1fa0c2d98b4534a2dea6536f0063ec5b3@epcas2p1.samsung.com>
        <68f7ba13-0bf5-627b-139f-9efb1c33a467@samsung.com>
        <a0d2557e-d451-8cec-a700-e403a5da8919@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 03/12/2018 05:19 PM, Hans Verkuil wrote:
> Does this include this __v4l2_ctrl_modify_range() request:
> 
> https://patchwork.kernel.org/patch/10196605/
> 
> I haven't seen anything for that. I'd like to see that implemented before this
> is merged, otherwise this typically will never happen.

Not yet, I assumed it will come afterwards.
I will write the patch myself until end of this week, unless Smitha submits 
it earlier.

-- 
Regards,
Sylwester
