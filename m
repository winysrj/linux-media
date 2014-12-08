Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:10917 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226AbaLHLE4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Dec 2014 06:04:56 -0500
Message-id: <548585C5.3000209@samsung.com>
Date: Mon, 08 Dec 2014 12:04:37 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v2 01/11] media: s3c-camif: use vb2_ops_wait_prepare/finish
 helper
References: <1417041754-8714-1-git-send-email-prabhakar.csengg@gmail.com>
 <1417041754-8714-2-git-send-email-prabhakar.csengg@gmail.com>
In-reply-to: <1417041754-8714-2-git-send-email-prabhakar.csengg@gmail.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/11/14 23:42, Lad, Prabhakar wrote:
> This patch drops driver specific wait_prepare() and
> wait_finish() callbacks from vb2_ops and instead uses
> the the helpers vb2_ops_wait_prepare/finish() provided
> by the vb2 core, the lock member of the queue needs
> to be initalized to a mutex so that vb2 helpers
> vb2_ops_wait_prepare/finish() can make use of it.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>


Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

-- 
Thanks,
Sylwester
