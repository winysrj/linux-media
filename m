Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:47053 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab3G0WUz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Jul 2013 18:20:55 -0400
Received: by mail-la0-f51.google.com with SMTP id fp13so3067571lab.24
        for <linux-media@vger.kernel.org>; Sat, 27 Jul 2013 15:20:53 -0700 (PDT)
Message-ID: <51F447C0.9030901@cogentembedded.com>
Date: Sun, 28 Jul 2013 02:20:48 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: mchehab@samsung.com, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl
CC: matsu@igel.co.jp, linux-sh@vger.kernel.org,
	vladimir.barinov@cogentembedded.com
Subject: Re: [PATCH] ml86v7667: override default field interlace order
References: <201307152312.22371.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201307152312.22371.sergei.shtylyov@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 15.07.2013 23:12, I wrote:

> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

> ML86V7667 always transmits top field first for both PAL and  NTSC -- that makes
> application incorrectly  treat interlaced  fields when relying on the standard.
> Hence we must set V4L2_FIELD_INTERLACED_TB format explicitly.

> Reported-by: Katsuya MATSUBARA <matsu@igel.co.jp>
> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> [Sergei: added a comment.]
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

> ---
> This patch is against the 'media_tree.git' repo.

    I forgot to mention that it was against the 'fixes' branch, and we 
intended it as a fix (I'm seeing this patch committed to the 'master' branch).

WBR, Sergei

