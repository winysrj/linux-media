Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:29186 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab3CGKtK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 05:49:10 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MJA00L1DE1ALC70@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 07 Mar 2013 10:49:07 +0000 (GMT)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MJA00HEHE1VCG40@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 07 Mar 2013 10:49:07 +0000 (GMT)
Message-id: <513870A2.7090209@samsung.com>
Date: Thu, 07 Mar 2013 11:49:06 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Shaik Ameer Basha <shaik.samsung@gmail.com>
Cc: Arun Kumar K <arun.kk@samsung.com>, linux-media@vger.kernel.org,
	k.debski@samsung.com, jtp.park@samsung.com, s.nawrocki@samsung.com
Subject: Re: [PATCH] [media] s5p-mfc: Fix encoder control 15 issue
References: <1362575757-22839-1-git-send-email-arun.kk@samsung.com>
 <5137BEBF.7060608@gmail.com>
 <CAOD6ATpeNvnAsTL+j17d3W-SZr0gXAk07AsXqo+HWW50N7V1_g@mail.gmail.com>
In-reply-to: <CAOD6ATpeNvnAsTL+j17d3W-SZr0gXAk07AsXqo+HWW50N7V1_g@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/07/2013 03:20 AM, Shaik Ameer Basha wrote:
> v4l2_ctrl_new() uses check_range() for control range checking (which
> is added newly).
> This function expects 'step' value for V4L2_CTRL_TYPE_BOOLEAN type control.
> If 'step' value doesn't match to '1', it returns -ERANGE error.
> 
> Its a change in v4l2 core.

Yes, I suspected the issue appeared after recent change

commit 88e85861b4f77ae29495ee05574c98dd0c6c3037
[media] v4l2-ctrl: Add helper function for the controls range update

Then it is related to to 3.9-rc1+ kernels only. I have verified it on
3.8 based kernel and there is no issue with drivers that do not
initialize step value for boolean type controls properly. It only
appears after the above commit is applied.

I've picked your fixup patches into v3.9-fixes branch and will try
to send them out this week, together with other patches from our side.


Regards,
Sylwester
