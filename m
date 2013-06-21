Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:48621 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030336Ab3FUKCH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 06:02:07 -0400
Received: by mail-pa0-f41.google.com with SMTP id bj3so7617801pad.14
        for <linux-media@vger.kernel.org>; Fri, 21 Jun 2013 03:02:07 -0700 (PDT)
Date: Fri, 21 Jun 2013 19:01:57 +0900 (JST)
Message-Id: <20130621.190157.27985389.matsu@igel.co.jp>
To: vladimir.barinov@cogentembedded.com
Cc: sergei.shtylyov@cogentembedded.com, g.liakhovetski@gmx.de,
	mchehab@redhat.com, linux-media@vger.kernel.org,
	magnus.damm@gmail.com, linux-sh@vger.kernel.org,
	phil.edworthy@renesas.com
Subject: Re: [PATCH v6] V4L2: soc_camera: Renesas R-Car VIN driver
From: Katsuya MATSUBARA <matsu@igel.co.jp>
In-Reply-To: <51C41F66.1060300@cogentembedded.com>
References: <51C40974.600@cogentembedded.com>
	<20130621.180932.452518378.matsu@igel.co.jp>
	<51C41F66.1060300@cogentembedded.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Vladimir,

From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Date: Fri, 21 Jun 2013 13:39:50 +0400

(snip)
>> I have not seen such i2c errors during capturing and booting.
>> But I have seen that querystd() in the ml86v7667 driver often
>> returns V4L2_STD_UNKNOWN, although the corresponding function
>>   
> could you try Hans's fix:
> https://patchwork.kernel.org/patch/2640701/

The fix has been already applied in my environment.

Thanks,
---
Katsuya Matsubara / IGEL Co., Ltd
matsu@igel.co.jp
