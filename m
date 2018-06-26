Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:42175 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751852AbeFZVVx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Jun 2018 17:21:53 -0400
Received: by mail-qt0-f182.google.com with SMTP id y31-v6so16531768qty.9
        for <linux-media@vger.kernel.org>; Tue, 26 Jun 2018 14:21:52 -0700 (PDT)
Subject: Re: V4L2_CID_USER_MAX217X_BASE == V4L2_CID_USER_IMX_BASE
To: Helmut Grohne <h.grohne@intenta.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
References: <20180622075151.g24iiqfcg5pwbr73@laureti-dev>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <0b2e6f14-3297-fc53-5af0-2494ac6c925f@gmail.com>
Date: Tue, 26 Jun 2018 14:21:48 -0700
MIME-Version: 1.0
In-Reply-To: <20180622075151.g24iiqfcg5pwbr73@laureti-dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Helmut,


On 06/22/2018 12:51 AM, Helmut Grohne wrote:
> Hi,
>
> I found it strange that the macros V4L2_CID_USER_MAX217X_BASE and
> V4L2_CID_USER_IMX_BASE have equal value even though each of them state
> that they reserved a range. Those reservations look conflicting to me.

Yes, they conflict.

> The macro V4L2_CID_USER_MAX217X_BASE came first,

No, imx came first. e1302912 ("media: Add i.MX media core driver")
is dated June 10, 2017. 8d67ae25 ("media: v4l2-ctrls: Reserve controls for
MAX217X") is dated two days later.

>   and
> V4L2_CID_USER_IMX_BASE was introduced in e130291212df ("media: Add i.MX
> media core driver") with the conflicting assignment (not a merge error).
> The authors of that patch mostly make up the recipient list.

There were 8 revisions of the imx-media driver posted. In all of
those postings, V4L2_CID_USER_MAX217X_BASE did not exist yet.
So it looks like 8d67ae25 was merged at the same time as e1302912
but the conflict went unnoticed.

Steve
