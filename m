Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f43.google.com ([209.85.212.43]:38519 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706Ab3FGK2W (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jun 2013 06:28:22 -0400
Received: by mail-vb0-f43.google.com with SMTP id e12so116401vbg.16
        for <linux-media@vger.kernel.org>; Fri, 07 Jun 2013 03:28:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK9yfHzi4Jdi9xO0eNuWe8U2303Qr+5erhN26P5ahfP0JvqTcw@mail.gmail.com>
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com>
	<1370005408-10853-7-git-send-email-arun.kk@samsung.com>
	<CAK9yfHzi4Jdi9xO0eNuWe8U2303Qr+5erhN26P5ahfP0JvqTcw@mail.gmail.com>
Date: Fri, 7 Jun 2013 15:58:21 +0530
Message-ID: <CALt3h78rY0OK9zXUxS17EKkegwBv88si014m2Lt310xNTFe+6Q@mail.gmail.com>
Subject: Re: [RFC v2 06/10] exynos5-fimc-is: Adds isp subdev
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

>> +       isp->refcount++;
>> +       return ret;
>
> You can directly return 0 here instead of creating a local variable
> 'ret' which is not used anywhere else.

Ok.

>> +
>
> nit: Please consider changing "Adds" to "Add" in the patch titles of
> this series during the next spin.
>

Ok will change like that.

Regards
Arun
