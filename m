Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f43.google.com ([209.85.212.43]:58208 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab3CGEXn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 23:23:43 -0500
Received: by mail-vb0-f43.google.com with SMTP id fs19so18132vbb.16
        for <linux-media@vger.kernel.org>; Wed, 06 Mar 2013 20:23:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5137BEBF.7060608@gmail.com>
References: <1362575757-22839-1-git-send-email-arun.kk@samsung.com>
	<5137BEBF.7060608@gmail.com>
Date: Thu, 7 Mar 2013 09:53:42 +0530
Message-ID: <CALt3h79+TGKL3DYgHGEhNgg+ZeQBhw=8ivX7eQrkPFyBc=bMQA@mail.gmail.com>
Subject: Re: [PATCH] [media] s5p-mfc: Fix encoder control 15 issue
From: Arun Kumar K <arunkk.samsung@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Arun Kumar K <arun.kk@samsung.com>,
	LMML <linux-media@vger.kernel.org>,
	Kamil Debski <k.debski@samsung.com>, jtp.park@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

> Do you mean this problem was not observed in 3.8 kernel and something
> has changed in the v4l2 core so it fails in 3.9-rc now ? Or is it
> related to some change in the driver itself ?

I saw this problem in 3.9rc1 and also in 3.8 stable.
But I havent seen this in media-tree v3.9 staging branch.
I didnt dig in much into what changed in v4l2 framework for this to happen now.

Regards
Arun
