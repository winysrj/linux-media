Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:35514 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753955AbdCFOS0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Mar 2017 09:18:26 -0500
Subject: Re: [Patch v2 03/11] s5p-mfc: Use min scratch buffer size as provided
 by F/W
To: Smitha T Murthy <smitha.t@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, kamil@wypas.org, jtp.park@samsung.com,
        mchehab@kernel.org, pankaj.dubey@samsung.com, krzk@kernel.org,
        m.szyprowski@samsung.com, s.nawrocki@samsung.com
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <33a42a78-aaf8-5a57-c58c-62ebd37aa1ca@samsung.com>
Date: Mon, 06 Mar 2017 15:18:14 +0100
MIME-version: 1.0
In-reply-to: <1488532036-13044-4-git-send-email-smitha.t@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <1488532036-13044-1-git-send-email-smitha.t@samsung.com>
 <CGME20170303090440epcas5p33f1bea986f2f9c961c93af94df7ec565@epcas5p3.samsung.com>
 <1488532036-13044-4-git-send-email-smitha.t@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03.03.2017 10:07, Smitha T Murthy wrote:
> After MFC v8.0, mfc f/w lets the driver know how much scratch buffer
> size is required for decoder. If mfc f/w has the functionality,
> E_MIN_SCRATCH_BUFFER_SIZE, driver can know how much scratch buffer size
> is required for encoder too.
>
> Signed-off-by: Smitha T Murthy <smitha.t@samsung.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
--
Regards
Andrzej
