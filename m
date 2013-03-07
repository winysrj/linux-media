Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:29414 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab3CGKvZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 05:51:25 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MJA00L1DE1ALC70@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 07 Mar 2013 10:51:23 +0000 (GMT)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MJA00LDRE5NQT30@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 07 Mar 2013 10:51:23 +0000 (GMT)
Message-id: <5138712A.2070404@samsung.com>
Date: Thu, 07 Mar 2013 11:51:22 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arun Kumar K <arunkk.samsung@gmail.com>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>, jtp.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH] [media] s5p-mfc: Fix encoder control 15 issue
References: <1362575757-22839-1-git-send-email-arun.kk@samsung.com>
 <5137BEBF.7060608@gmail.com>
 <CALt3h79+TGKL3DYgHGEhNgg+ZeQBhw=8ivX7eQrkPFyBc=bMQA@mail.gmail.com>
In-reply-to: <CALt3h79+TGKL3DYgHGEhNgg+ZeQBhw=8ivX7eQrkPFyBc=bMQA@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/07/2013 05:23 AM, Arun Kumar K wrote:
>> Do you mean this problem was not observed in 3.8 kernel and something
>> has changed in the v4l2 core so it fails in 3.9-rc now ? Or is it
>> related to some change in the driver itself ?
> 
> I saw this problem in 3.9rc1 and also in 3.8 stable.
> But I havent seen this in media-tree v3.9 staging branch.
> I didnt dig in much into what changed in v4l2 framework for this to happen now.

Thanks Arun. This is strange though, I haven't observe the problem
in 3.8. The issue seems to be related to

commit 88e85861b4f77ae29495ee05574c98dd0c6c3037
[media] v4l2-ctrl: Add helper function for the controls range update

which appeared in 3.9-rc1 only.

Regards,
Sylwester
