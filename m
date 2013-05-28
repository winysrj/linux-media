Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:43882 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933515Ab3E1Ibc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 May 2013 04:31:32 -0400
Received: by mail-ob0-f175.google.com with SMTP id xn12so5402852obc.6
        for <linux-media@vger.kernel.org>; Tue, 28 May 2013 01:31:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1369725976-7828-2-git-send-email-a.hajda@samsung.com>
References: <1369725976-7828-1-git-send-email-a.hajda@samsung.com>
	<1369725976-7828-2-git-send-email-a.hajda@samsung.com>
Date: Tue, 28 May 2013 14:01:31 +0530
Message-ID: <CAK9yfHytCAvghurn8djWOKtf7MYsZbfjgu9yuBbmPPrC8tu4yA@mail.gmail.com>
Subject: Re: [PATCH 1/3] s5p-mfc: separate encoder parameters for h264 and mpeg4
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org,
	Jeongtae Park <jtp.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

On 28 May 2013 12:56, Andrzej Hajda <a.hajda@samsung.com> wrote:
> This patch fixes a bug which caused overwriting h264 codec
> parameters by mpeg4 parameters during V4L2 control setting.

Just curious, what was the use case that triggered this issue?

-- 
With warm regards,
Sachin
