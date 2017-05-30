Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:52678 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750904AbdE3IaH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 May 2017 04:30:07 -0400
Subject: Re: [PATCH] [media] s5p-jpeg: fix recursive spinlock acquisition
To: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <c86b05d8-2278-5bf2-4836-75d57ad326fb@samsung.com>
Date: Tue, 30 May 2017 10:30:00 +0200
MIME-version: 1.0
In-reply-to: <f284a17b-2dee-a417-d361-0ecb4762b54c@gmail.com>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-transfer-encoding: 7bit
References: <20170425061943.717-1-acourbot@chromium.org>
        <14d0d257-a5c3-222e-137d-4991482c6fb4@gmail.com>
        <CAPBb6MV6YCARzwkvXoxtCFYuZkM1-TzR_BRY6xH1qpzs+vAEuQ@mail.gmail.com>
        <ad2fc73b-0709-f5d3-04c0-658974e2eb21@gmail.com>
        <CAPBb6MV+MTuYPFUxfgK6hkrXKXYUz-Jc6iPES9E3jQyQJ9gNCg@mail.gmail.com>
        <f284a17b-2dee-a417-d361-0ecb4762b54c@gmail.com>
        <CGME20170530083004epcas1p22ffe80b6a9442bcd3a6fb0b02381759f@epcas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 05/29/2017 09:08 PM, Jacek Anaszewski wrote:
> This patch seems to have lost somehow. Could you help merging it?

It's not lost, it has been on my todo queue. I have applied it now.

-- 
Thanks,
Sylwester
