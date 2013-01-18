Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:9316 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab3ARJsv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jan 2013 04:48:51 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGT001J0F8PV420@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 18 Jan 2013 09:48:48 +0000 (GMT)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MGT002NGF9C1J30@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 18 Jan 2013 09:48:48 +0000 (GMT)
Message-id: <50F91A7F.8010502@samsung.com>
Date: Fri, 18 Jan 2013 10:48:47 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: arun.kk@samsung.com
Cc: Kamil Debski <k.debski@samsung.com>,
	SUNIL JOSHI <joshi@samsung.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Wrong patch applied to media-tree
References: <7510586.84171358500177683.JavaMail.weblogic@epv6ml01>
In-reply-to: <7510586.84171358500177683.JavaMail.weblogic@epv6ml01>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On 01/18/2013 10:09 AM, Arun Kumar K wrote:
> Hi Sylwester,
> 
> The patch -- "[media] s5p-mfc: Add device tree support"
> which is applied to media-tree staging v3.9 is an older one.
> I had sent an updated patch to the mailing list --
> https://patchwork.kernel.org/patch/1692181/
> This is the one which Kamil acked.

Sorry for this oversight. Indeed this patch has even 'accepted'
state in the patchwork: http://patchwork.linuxtv.org/patch/15333 :/

> With the old patch, a kernel warning will come every time
> memory allocation is done due to missing device_initialize() call.
> Can this be corrected now?

Now when the patch is in Mauro's tree we can only fix it by applying
an incremental patch. Can you prepare it and send to LMML ? I would
then include it in my second pull request for v3.9.

Thanks,
Sylwester

-- 
Sylwester Nawrocki
Samsung Poland R&D Center
