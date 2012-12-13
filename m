Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63085 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab2LMKvg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Dec 2012 05:51:36 -0500
Received: by mail-vb0-f46.google.com with SMTP id b13so1973356vby.19
        for <linux-media@vger.kernel.org>; Thu, 13 Dec 2012 02:51:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <016a01cdd912$a4243f10$ec6cbd30$%debski@samsung.com>
References: <1355311184-30029-1-git-send-email-k.debski@samsung.com>
	<CAK9yfHyNO8jhjtueR9eL=q-85AB_CN9Ok61LftBG8ufmZzJzbQ@mail.gmail.com>
	<016a01cdd912$a4243f10$ec6cbd30$%debski@samsung.com>
Date: Thu, 13 Dec 2012 16:21:35 +0530
Message-ID: <CALt3h7_q3EcrtWB9jr-0ST_QfY=7MD--mSJLmj7LFNf1-Lb4oQ@mail.gmail.com>
Subject: Re: [PATCH] s5p-mfc: Fix interrupt error handling routine
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Kamil Debski <k.debski@samsung.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
	LMML <linux-media@vger.kernel.org>, jtp.park@samsung.com,
	Arun Kumar K <arun.kk@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	posciak@google.com, Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

>
> No problem. First I would like to see this tested by Arun Kumar (he has
> Exynos 5) and Pawel Osciak (he did report the problem to me).
>

I tested this on Exynos5 with some error streams and found no issues.
If there is any specific error stream to test then please tell me.

Regards
Arun Kumar
