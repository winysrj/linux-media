Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:41526 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751134AbdDJIee (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Apr 2017 04:34:34 -0400
Subject: Re: [PATCH 09/12] [media] s5p-mfc: use setup_timer
To: Geliang Tang <geliangtang@gmail.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>,
        Jeongtae Park <jtp.park@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <aa3f052e-c4c5-158f-79cb-d4e26b8e4f10@samsung.com>
Date: Mon, 10 Apr 2017 10:33:59 +0200
MIME-version: 1.0
In-reply-to: <f35bda17a884852135983ab4128976b9c220a768.1490953290.git.geliangtang@gmail.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
References: <77c0fb26d214e023a99afc948c71d6edd9284205.1490953290.git.geliangtang@gmail.com>
 <f35bda17a884852135983ab4128976b9c220a768.1490953290.git.geliangtang@gmail.com>
 <CGME20170410083414epcas5p401f39ae110afbae34e0f2c6b53bd86a3@epcas5p4.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/09/2017 03:34 AM, Geliang Tang wrote:
> Use setup_timer() instead of init_timer() to simplify the code.
>
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

Applied, thanks.
