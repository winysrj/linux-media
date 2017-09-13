Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:26124 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbdIMMax (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 08:30:53 -0400
Subject: Re: [PATCH] s5p-cec: add NACK detection support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <8fb0163d-1d55-8cbd-46ed-53ab4f1bc7ba@samsung.com>
Date: Wed, 13 Sep 2017 14:30:47 +0200
MIME-version: 1.0
In-reply-to: <6ab242a3-ce49-ff45-4fb1-545911d4330f@xs4all.nl>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <CGME20170831165619epcas5p14a276a7c0ac7a75f9385783580928728@epcas5p1.samsung.com>
        <6ab242a3-ce49-ff45-4fb1-545911d4330f@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/31/2017 06:56 PM, Hans Verkuil wrote:
> The s5p-cec driver returned CEC_TX_STATUS_ERROR for the NACK condition.
> 
> Some digging into the datasheet uncovered the S5P_CEC_TX_STAT1 register where
> bit 0 indicates if the transmit was nacked or not.
> 
> Use this to return the correct CEC_TX_STATUS_NACK status to userspace.
> 
> This was the only driver that couldn't tell a NACK from another error, and
> that was very unusual. And a potential problem for applications as well.
> 
> Tested with my Odroid-U3.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
