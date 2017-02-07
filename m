Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:11397 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751526AbdBGM1d (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2017 07:27:33 -0500
Subject: Re: [PATCH] media: s5p-mfc: Fix initialization of internal structures
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
From: Andrzej Hajda <a.hajda@samsung.com>
Message-id: <299b7bdb-09b0-a5f8-9a7c-45d64c04865b@samsung.com>
Date: Tue, 07 Feb 2017 13:27:27 +0100
MIME-version: 1.0
In-reply-to: <1486130718-25998-1-git-send-email-m.szyprowski@samsung.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
References: <CGME20170203140530eucas1p17e9d0bbb29da881bae025e8e3bc7cbbb@eucas1p1.samsung.com>
 <1486130718-25998-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03.02.2017 15:05, Marek Szyprowski wrote:
> Initialize members of the internal device and context structures as early
> as possible to avoid access to uninitialized objects on initialization
> failures. If loading firmware or creating of the hardware instance fails,
> driver will access device or context queue in error handling path, which
> might not be initialized yet, what causes kernel panic. Fix this by moving
> initialization of all static members as early as possible.
>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>

Acked-by: Andrzej Hajda <a.hajda@samsung.com>

