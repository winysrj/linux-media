Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:33481 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752558AbdLQQAj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 11:00:39 -0500
Received: by mail-wm0-f52.google.com with SMTP id g130so4437117wme.0
        for <linux-media@vger.kernel.org>; Sun, 17 Dec 2017 08:00:39 -0800 (PST)
Date: Sun, 17 Dec 2017 17:00:36 +0100
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Subject: Re: [PATCH 0/8] ddbridge improvements and cleanups
Message-ID: <20171217170036.7dd3dac4@macbox>
In-Reply-To: <20171217154049.1125-1-d.scheller.oss@gmail.com>
References: <20171217154049.1125-1-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 17 Dec 2017 16:40:41 +0100
Daniel Scheller <d.scheller.oss@gmail.com> wrote:

> I verified this by simply removing tda18212.ko with this DD setup:

Sorry, I forgot to outline this: I also tested by removing stv0367.ko
and cxd2841er.ko of course, which resulted in partially working
hardware, either the cxd-based hardware or the stv-based one didn't
work, while everything else did. Unload worked cleanly, without leaving
any side effects.

All this worked without these patches before of course, but as they
touch the attach logic and make failure cleanup resources instantly
now, this required retesting.

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
