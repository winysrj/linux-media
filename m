Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:48824 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab3JRD5P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 23:57:15 -0400
Received: by mail-wi0-f182.google.com with SMTP id ez12so348983wid.15
        for <linux-media@vger.kernel.org>; Thu, 17 Oct 2013 20:57:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1382065635-27855-5-git-send-email-sachin.kamat@linaro.org>
References: <1382065635-27855-1-git-send-email-sachin.kamat@linaro.org> <1382065635-27855-5-git-send-email-sachin.kamat@linaro.org>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 18 Oct 2013 09:26:54 +0530
Message-ID: <CA+V-a8uZSbKP=vHGvLBjPBAEs3HbEa=Y-QiT=fdccuyZ=9PRQw@mail.gmail.com>
Subject: Re: [PATCH 5/6] [media] tvp7002: Include linux/of.h header
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
