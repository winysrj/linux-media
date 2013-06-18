Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:56132 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab3FRDpr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 23:45:47 -0400
Received: by mail-oa0-f43.google.com with SMTP id i7so4416362oag.2
        for <linux-media@vger.kernel.org>; Mon, 17 Jun 2013 20:45:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1371486876-30421-1-git-send-email-s.nawrocki@samsung.com>
References: <1371486876-30421-1-git-send-email-s.nawrocki@samsung.com>
Date: Tue, 18 Jun 2013 09:15:46 +0530
Message-ID: <CAK9yfHxpUPaKzrjCAX44rAB6pqOW2A2KD23A5SbwAWK+vJCbww@mail.gmail.com>
Subject: Re: [PATCH] Documentation: Update driver's directory in video4linux/fimc.txt
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

>
> -The machine code (plat-s5p and arch/arm/mach-*) must select following options
> +The machine code (arch/arm/plat-samsung and arch/arm/mach-*) must select
> +following options:

After the recent platform code cleanup the below entries are not found
in arch/arm/mach-* (checked in linux-next).

>
>  CONFIG_S5P_DEV_FIMC0       mandatory
>  CONFIG_S5P_DEV_FIMC1  \

-- 
With warm regards,
Sachin
