Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36922 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaATJsi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jan 2014 04:48:38 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZP00MSB1WZH470@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 Jan 2014 09:48:35 +0000 (GMT)
Message-id: <52DCF0EC.2020003@samsung.com>
Date: Mon, 20 Jan 2014 10:48:28 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] s3c-camif: Remove use of deprecated
 V4L2_CTRL_FLAG_DISABLED.
References: <52DCEBED.2010603@xs4all.nl>
In-reply-to: <52DCEBED.2010603@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20/01/14 10:27, Hans Verkuil wrote:
> I came across this while checking the kernel use of V4L2_CTRL_FLAG_DISABLED.
> 
> This flag should not be used with the control framework. Instead, just don't
> add the control at all.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

