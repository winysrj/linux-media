Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:65503 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab3JRD5z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 23:57:55 -0400
Received: by mail-we0-f182.google.com with SMTP id t61so3205557wes.13
        for <linux-media@vger.kernel.org>; Thu, 17 Oct 2013 20:57:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1382065635-27855-4-git-send-email-sachin.kamat@linaro.org>
References: <1382065635-27855-1-git-send-email-sachin.kamat@linaro.org> <1382065635-27855-4-git-send-email-sachin.kamat@linaro.org>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 18 Oct 2013 09:27:33 +0530
Message-ID: <CA+V-a8u1dOJfDxzeNzVmSme1oOPaXSx2Dh-zJnQLv5BPEj0VFA@mail.gmail.com>
Subject: Re: [PATCH 4/6] [media] tvp514x: Include linux/of.h header
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 18, 2013 at 8:37 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> 'of_match_ptr' is defined in linux/of.h. Include it explicitly to
> avoid build breakage in the future.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regrads,
--Prabhakar Lad
