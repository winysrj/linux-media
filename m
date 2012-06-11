Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:47794 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab2FKE12 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 00:27:28 -0400
Received: by vcbf11 with SMTP id f11so1879456vcb.19
        for <linux-media@vger.kernel.org>; Sun, 10 Jun 2012 21:27:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FC290EC.3010509@gmail.com>
References: <1338045114-2477-1-git-send-email-sachin.kamat@linaro.org>
	<4FC290EC.3010509@gmail.com>
Date: Mon, 11 Jun 2012 09:57:27 +0530
Message-ID: <CAK9yfHw=3VhvWVTKBTS1qCd7U9MKU7Zk5rxP9cXNytoApuxWPg@mail.gmail.com>
Subject: Re: [PATCH 1/1] [media] s5p-fimc: Add missing static storage class
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	mchehab@infradead.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28/05/2012, Sylwester Nawrocki <snjw23@gmail.com> wrote:
> On 05/26/2012 05:11 PM, Sachin Kamat wrote:
>> Fixes the following sparse warnings:
>
> Hi Sachin. Thanks, in case somebody else applies this patch
> before I do:
> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>

Thanks Sylwester.

> I would just change the summary line to:
> "s5p-fimc: Add missing static storage class specifiers" when
> applying this patch.

Ok.

>
> --
> Regards,
> Sylwester
>


-- 
With warm regards,
Sachin
