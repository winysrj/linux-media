Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:48363 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab3JRD4S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 23:56:18 -0400
Received: by mail-wi0-f181.google.com with SMTP id l12so352989wiv.2
        for <linux-media@vger.kernel.org>; Thu, 17 Oct 2013 20:56:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1382065635-27855-1-git-send-email-sachin.kamat@linaro.org>
References: <1382065635-27855-1-git-send-email-sachin.kamat@linaro.org>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Fri, 18 Oct 2013 09:25:57 +0530
Message-ID: <CA+V-a8vBtCq=S6gr0zT5Za8EZ5p2oJeWDL3f47ihaSATohq1dQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] [media] adv7343: Include linux/of.h header
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
