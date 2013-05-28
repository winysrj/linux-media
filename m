Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36368 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933699Ab3E1JLn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 May 2013 05:11:43 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MNI00B1V46XVEC0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 28 May 2013 10:11:41 +0100 (BST)
Message-id: <51A474CA.4040303@samsung.com>
Date: Tue, 28 May 2013 11:11:38 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org,
	Jeongtae Park <jtp.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 1/3] s5p-mfc: separate encoder parameters for h264 and mpeg4
References: <1369725976-7828-1-git-send-email-a.hajda@samsung.com>
 <1369725976-7828-2-git-send-email-a.hajda@samsung.com>
 <CAK9yfHytCAvghurn8djWOKtf7MYsZbfjgu9yuBbmPPrC8tu4yA@mail.gmail.com>
In-reply-to: <CAK9yfHytCAvghurn8djWOKtf7MYsZbfjgu9yuBbmPPrC8tu4yA@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/28/2013 10:31 AM, Sachin Kamat wrote:
> Hi Andrzej,
>
> On 28 May 2013 12:56, Andrzej Hajda <a.hajda@samsung.com> wrote:
>> This patch fixes a bug which caused overwriting h264 codec
>> parameters by mpeg4 parameters during V4L2 control setting.
> Just curious, what was the use case that triggered this issue?
>
For example it was not possible to set h264 profile and level -
they were overwritten by "struct s5p_mfc_mpeg4_enc_params" fields.

In general all 'union' fields of s5p_mfc_h264_enc_params were
overwritten by
s5p_mfc_mpeg4_enc_params and vice versa, the control which was set later
was 'the winner'.
Furthermore during stream start v4l2_ctrl_handler_setup was called so
all controls
were refreshed, so the final winners order was determined by controls
definition order.

Regards
Andrzej





