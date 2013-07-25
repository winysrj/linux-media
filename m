Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33861 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab3GYHde (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 03:33:34 -0400
Received: by mail-pa0-f48.google.com with SMTP id kp13so434532pab.21
        for <linux-media@vger.kernel.org>; Thu, 25 Jul 2013 00:33:33 -0700 (PDT)
Date: Thu, 25 Jul 2013 16:32:56 +0900 (JST)
Message-Id: <20130725.163256.373541261.matsu@igel.co.jp>
To: sergei.shtylyov@cogentembedded.com
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl, linux-sh@vger.kernel.org,
	vladimir.barinov@cogentembedded.com
Subject: Re: [PATCH] ml86v7667: override default field interlace order
From: Katsuya MATSUBARA <matsu@igel.co.jp>
In-Reply-To: <201307152312.22371.sergei.shtylyov@cogentembedded.com>
References: <201307152312.22371.sergei.shtylyov@cogentembedded.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


 Hi Vladimir,

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: [PATCH] ml86v7667: override default field interlace order
Date: Mon, 15 Jul 2013 23:12:21 +0400

> From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> 
> ML86V7667 always transmits top field first for both PAL and  NTSC -- that makes
> application incorrectly  treat interlaced  fields when relying on the standard.
> Hence we must set V4L2_FIELD_INTERLACED_TB format explicitly.
> 
> Reported-by: Katsuya MATSUBARA <matsu@igel.co.jp>
> Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
> [Sergei: added a comment.]
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
(snip)

I made sure that it works well on the Renesas BOCK-W board.

Tested-by: Katsuya MATSUBARA <matsu@igel.co.jp>

---
Katsuya Matsubara / IGEL Co., Ltd
matsu@igel.co.jp
