Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:42673 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751013AbdIKJOm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 05:14:42 -0400
Subject: Re: [PATCH 1/3] [media] s5p-mfc: Delete an error message for a
 failed memory allocation in s5p_mfc_probe()
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        Andrzej Hajda <a.hajda@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <ccf6b04a-6e8a-231c-f456-0b37ba350acc@samsung.com>
Date: Mon, 11 Sep 2017 11:14:33 +0200
MIME-version: 1.0
In-reply-to: <ff8f7dcd-c3e8-2a12-c0db-997b514f5d94@users.sourceforge.net>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <482a6c92-a85e-0bcd-edf7-3c2f63ea74c5@users.sourceforge.net>
        <ff8f7dcd-c3e8-2a12-c0db-997b514f5d94@users.sourceforge.net>
        <CGME20170911091439epcas1p3f8b62f55cae4255d250b1fe990fbf1ff@epcas1p3.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/08/2017 10:51 PM, SF Markus Elfring wrote:
> Omit an extra message for a memory allocation failure in this function.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring<elfring@users.sourceforge.net>

Could you make the commit summary shorter, to keep it below 70
characters [1]? With that changed feel free to add

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--
Regards,
Sylwester

[1] Documentation/process/submitting-patches.rst
