Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:43426 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751013AbdIKJRC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 05:17:02 -0400
Subject: Re: [PATCH 2/3] [media] s5p-mfc: Improve a size determination in
 s5p_mfc_alloc_memdev()
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
Message-id: <5b6fc74a-9927-cc1d-fd89-cd4578a14791@samsung.com>
Date: Mon, 11 Sep 2017 11:16:54 +0200
MIME-version: 1.0
In-reply-to: <003abb1f-4dc6-91ca-9d03-cae13dc4ff6f@users.sourceforge.net>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-language: en-GB
Content-transfer-encoding: 7bit
References: <482a6c92-a85e-0bcd-edf7-3c2f63ea74c5@users.sourceforge.net>
        <003abb1f-4dc6-91ca-9d03-cae13dc4ff6f@users.sourceforge.net>
        <CGME20170911091700epcas1p1bd85f95a6b776581ad4cd6f3108d09ba@epcas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/08/2017 10:52 PM, SF Markus Elfring wrote:
> Replace the specification of a data structure by a pointer dereference
> as the parameter for the operator "sizeof" to make the corresponding size
> determination a bit safer according to the Linux coding style convention.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring<elfring@users.sourceforge.net>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
