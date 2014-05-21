Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:52697 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaEUJwD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 May 2014 05:52:03 -0400
Received: by mail-ob0-f172.google.com with SMTP id wp18so1883400obc.3
        for <linux-media@vger.kernel.org>; Wed, 21 May 2014 02:52:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400664571-13746-1-git-send-email-arun.kk@samsung.com>
References: <1400664571-13746-1-git-send-email-arun.kk@samsung.com>
Date: Wed, 21 May 2014 15:22:02 +0530
Message-ID: <CAK9yfHz=4g3XP0STD7GGrDwHR-bx4nJkte1nydDHjQEt5UWEpA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Support for multiple MFC FW sub-versions
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Arun Kumar K <arun.kk@samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Pawel Osciak <posciak@chromium.org>,
	Kiran Avnd <avnd.kiran@samsung.com>,
	Tomasz Figa <t.figa@samsung.com>,
	Arun Kumar <arunkk.samsung@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21 May 2014 14:59, Arun Kumar K <arun.kk@samsung.com> wrote:
> This patchset is for supporting multple firmware sub-versions
> for MFC. Newer firmwares come with changed interfaces and fixes
> without any change in the fw version number.
> So this implementation is as per Tomasz Figa's suggestion [1].
> [1] http://permalink.gmane.org/gmane.linux.kernel.samsung-soc/31735
>
> Changes from v1
> - Addressed nits pointed by Sachin on PATCH 2/3

Thanks Arun.

Series looks good.
Reviewed-by: Sachin Kamat <sachin.kamat@linaro.org>

-- 
With warm regards,
Sachin
